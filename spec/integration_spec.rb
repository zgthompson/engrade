require_relative 'spec_helper'

describe Engrade do

  it "should allow me to delete all my assignments" do
    Engrade.set_apikey ENV['ENG_API']

    VCR.use_cassette('login') { Engrade.login ENV['ENG_USER'], ENV['ENG_PASS'] }

    VCR.use_cassette('classes') { @classes = Engrade.classes }

    VCR.use_cassette('assignments') { @assignments = Engrade.assignments @classes }

    VCR.use_cassette('delete') { Engrade.delete @assignments }

    VCR.use_cassette('result') { @result = Engrade.assignments @classes }

    @result.should be_empty
  end

end
    
