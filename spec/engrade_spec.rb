require_relative 'spec_helper'

describe Engrade do

  after :each do
    Engrade.reset!
  end

  it "should have base_uri set to engrade api endpoint" do
    Engrade.base_uri.should eql 'https://api.engrade.com/api/'
  end


  describe ".default_params" do
    
    it "should be a Hash" do
      Engrade.default_params.should be_an_instance_of Hash
    end

    it "should have :api set to json" do
      Engrade.default_params[:api].should eql 'json'
    end

  end

  describe ".set_apikey" do

    it "should set :apikey in default_params" do
      Engrade.set_apikey 'test'
      Engrade.default_params[:apikey].should eql 'test'
    end

  end

  describe ".set_ses" do

    it "should set :ses in default_params" do
      Engrade.set_ses 'test'
      Engrade.default_params[:ses].should eql 'test'
    end

  end

  describe ".reset!" do

    it "should reset default_params to original value" do
      orig = Engrade.default_params.dup
      Engrade.set_apikey "12345"
      Engrade.reset!
      Engrade.default_params.should eql orig
    end

  end

  describe ".post" do

    before :each do
      Engrade.set_apikey ENV['ENG_API']
    end

    it "should call RestClient.post with query and default_params" do
      response = build :login
      RestClient.should_receive(:post).with(Engrade.base_uri, response[:payload]).
        and_return response[:body]
      Engrade.post response[:query]
    end

    context "with valid call" do

      it "should return the result of RestClient.post" do
        response = build :login
        RestClient.stub(:post).and_return response[:body]
        Engrade.post(response[:query]).should eql response[:body]
      end

    end

    context "when not logged in" do

      it "should raise an InvalidSession error" do
        RestClient.stub(:post).and_return build(:bad_ses)[:body]
        expect { Engrade.post :apitask => 'teacher-classes' }.
          to raise_error Engrade::InvalidSession
      end

    end

    context "with bad apikey" do

      it "should raise an InvalidKey error" do
        Engrade.set_apikey 'badapi'
        RestClient.stub(:post).and_return build(:bad_api)[:body]
        expect { Engrade.post }.to raise_error Engrade::InvalidKey
      end

    end

    context "with no apitask specified" do

      it "should raise a MissingTask error" do
        RestClient.stub(:post).and_return build(:no_task)[:body]
        expect { Engrade.post }.to raise_error Engrade::MissingTask
      end

    end

    context "with invalid apitask specified" do

      it "should raise an InvalidTask error" do
        RestClient.stub(:post).and_return build(:bad_task)[:body]
        expect { Engrade.post :apitask => 'badtask' }.
          to raise_error Engrade::InvalidTask
      end
    
    end

  end

  describe ".login" do

    before :each do
      Engrade.browser.stub :login
    end

    it "should call .post with query Hash" do
      response = build :login
      Engrade.should_receive(:post).with(response[:query]).
        and_return response[:body]
      Engrade.login ENV['ENG_USER'], ENV['ENG_PASS']
    end

    context "with valid credentials" do

      before :each do
        @response = build(:login)
        Engrade.stub(:post).and_return @response[:body]
      end

      it "should return the session id" do
        Engrade.login(ENV['ENG_USER'], ENV['ENG_PASS']).
          should eql @response[:json]['values']['ses']
      end

      it "should set :ses in the default params" do
        ses = Engrade.login ENV['ENG_USER'], ENV['ENG_PASS']
        Engrade.default_params[:ses].should eql ses
      end

    end

    context "with invalid username" do

      it "should raise InvalidLogin error" do
        Engrade.stub(:post).and_return build(:login_baduser)[:body]
        expect { Engrade.login 'baduser', 'anypass' }.to raise_error Engrade::InvalidLogin
      end

    end

    context "with invalid password" do
      
      it "should raise InvalidLogin error" do
        Engrade.stub(:post).and_return build(:login_badpass)[:body]
        expect { Engrade.login ENV['ENG_USER'], 'badpass' }.to raise_error Engrade::InvalidLogin
      end

    end

  end

  describe ".classes" do

    before :each do
      Engrade.stub(:post).and_return build(:teacher_classes)[:body]
    end

    describe "return value" do

      it "should be an Array" do
        Engrade.classes.should be_an_instance_of Array
      end

      it "should contain Classroom objects" do
        Engrade.classes.first.should be_an_instance_of Engrade::Classroom
      end

      it "should only include classes that match the :only parameter" do
        Engrade.classes(:only => "Sem1").each do |cl|
          cl.name.should match "Sem1"
        end
      end

      it "should not include classes that match the :except paramter" do
        Engrade.classes(:except => "Sem1").each do |cl|
          cl.name.should_not match "Sem1"
        end
      end

    end

  end

  describe ".assignments" do

    before :each do
      @response = build :gradebook
      Engrade.stub(:gradebook).and_return @response[:assignments]
    end

    it "should take a class id as input" do
      expect { Engrade.assignments((build :classroom).clid) }.to_not raise_error
    end

    it "should take a classroom object as input" do
      expect { Engrade.assignments(build :classroom) }.to_not raise_error
    end

    it "should take an array of classroom objects as input" do
      expect { Engrade.assignments [build(:classroom), build(:classroom)] }.
        to_not raise_error
    end

    it "should take an array of clids as input" do
      expect { Engrade.assignments [(build :classroom).clid, (build :classroom).clid] }.
        to_not raise_error
    end

    it "should call .gradebook for each class from input array" do
      classes = [build(:classroom), build(:classroom)]
      Engrade.should_receive(:gradebook).exactly(2).times
      Engrade.assignments classes
    end


    it "should call .gradebook with the appropriate query" do
      Engrade.should_receive(:gradebook).with @response[:public_query]
      Engrade.assignments build(:classroom)
    end


    describe "return value" do

      before :each do
        @class = build :classroom
      end

      it "should be an Array" do
        Engrade.assignments(@class).should be_an_instance_of Array
      end

      it "should contain Assignment objects" do
        Engrade.assignments(@class).first.
          should be_an_instance_of Engrade::Assignment
      end

      it "should contain assigments from all input classes" do
        Engrade.assignments(@class).size.
          should be < Engrade.assignments([@class, @class]).size
      end
      
      it "should only include assignments that match the :only parameter" do
        Engrade.assignments(@class, :only => "Pop Quiz").each do |assn|
          assn.title.should match "Pop Quiz"
        end
      end

      it "should not include assignments that match the :except paramter" do
        Engrade.assignments(@class, :except => "Pop Quiz").each do |assn|
          assn.title.should_not match "Pop Quiz"
        end
      end

    end

  end

  describe ".delete" do

    before :each do
      Engrade.set_ses ENV['ENG_SES']
      Engrade.stub :post
      Engrade.browser.stub :remove_comments
    end

    it "should accept an array of Assignments as input" do
      assignments = [build(:assignment), build(:assignment)]
      expect { Engrade.delete assignments }.to_not raise_error
    end

    it "should accept a single Assignment as input" do
      assignment = build :assignment
      expect { Engrade.delete assignment }.to_not raise_error
    end

    it "should remove comments of every assignment" do
      assignments = [build(:assignment), build(:assignment)]
      Engrade.browser.should_receive(:remove_comments).exactly(2).times
      Engrade.delete assignments
    end

    it "should call .post with proper query" do
      Engrade.should_receive(:post).with build(:delete)[:query]
      Engrade.delete [build(:assignment)]
    end
    

  end

end
