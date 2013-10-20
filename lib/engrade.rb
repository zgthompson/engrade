require 'rest_client'
require 'json'
require_relative 'engrade/version'
require_relative 'engrade/exceptions'
require_relative 'engrade/return_types'
require_relative 'engrade/browser'

module Engrade

  ###########################
  # VARIABLES AND CONSTANTS #
  ###########################
  
  @default_params = { :api => 'json' }
  @browser = Engrade::Browser.new

  def self.base_uri; 'https://api.engrade.com/api/' end 

  ###########################
  # GETTERS AND (RE)SETTERS #
  ###########################

  # default_params are included in all post requests
  def self.default_params; @default_params end


  # browser is used to extend the engrade api to allow for the removal of
  # assignment comments
  def self.browser; @browser end
  

  def self.reset!
    @default_params = { :api => 'json' }
  end


  def self.set_ses(ses)
    @default_params.store :ses, ses
  end

  ######################
  # CORE FUNCTIONALITY #
  ######################
  
  # .post merges the default_params with query, a hash of input fields,
  # and posts them to the api
  # Example: 
  # Engrade.post({:apitask => 'login', :usr => 'myusername', :pwd => 'secret'})
  def self.post(query={})
    response = RestClient.post base_uri, query.merge(@default_params)
    raise InvalidKey, 'Invalid apikey' if response.match("Invalid apikey")
    raise MissingTask, 'No apitask specified' if response.match("No apitask specified")
    raise InvalidTask, 'Invalid apitask' if response.match("Invalid apitask")
    raise InvalidSession, 'Not logged in' if response.match("Not logged in")
    response
  end


  def self.set_apikey(key)
    @default_params.store :apikey, key
  end


  # .login posts a valid username and password to the api, and stores the
  # responding session token in default_params
  def self.login(u, p)
    response = post :apitask => 'login', :usr => u, :pwd => p
    raise InvalidLogin, 'Invalid username/password' if response.
      match(/Invalid (username|password)/)
    @browser.login u, p
    @default_params.store :ses, JSON(response)['values']['ses']
  end

  
  # .classes returns an array of active Classroom objects(data structure to represent
  # classes). when no argument is given, all classes are returned. the classes
  # can be filtered by calling with the :only or :except option.
  def self.classes(options={})
    classes = teacher_classes
    classes.select! { |item| item.folder == 3 }
    filter classes, options
  end


  # .assignments returns an array(of Assignment objects) of every assignment
  # from the input classes. the classes parameter can be the class id, a
  # Classroom object, an array of class ids, or an array of Classroom objects.
  # assignments can be filtered by calling with the additional :only or :except
  # option.
  def self.assignments(classes, options={})
    filter all_assignments(classes), options
  end



  # .delete! takes in an array of Assignment object, or a single Assignment
  # object and deletes those assignments from the Engrade webpage. it also
  # removes the comments from those assignments before deleting, because of
  # a bug in the Engrade system where comments from deleted assignments
  # reappear when assignment ids are recycled.
  def self.delete!(assignments)
    assignments = array(assignments)
    assignments.each do |assn|
      @browser.remove_comments assn.clid, assn.assnid
      post :apitask => 'assignment-edit', :clid => assn.clid, :assnid => assn.assnid, :delete => '1'
    end
  end

  ##################
  # HELPER METHODS #
  ##################

  def self.filter(array=[], options={})
    var = :name if array.first.instance_of? Classroom
    var = :title if array.first.instance_of? Assignment
    array.select! { |item| item.send(var).match options[:only]} if options[:only]
    array.reject! { |item| item.send(var).match options[:except]} if options[:except]
    array
  end

  def self.all_assignments(classes)
    assignments = []
    clid_array(classes).each do |clid|
      (Engrade.gradebook :clid => clid).
        map { |assn| assignments << Assignment.new(assn) }
    end
    assignments
  end

  def self.teacher_classes(query={})
    class_hash = JSON(post :apitask => 'teacher-classes')['classes']
    class_hash.map { |cl| Classroom.new(cl) }
  end


  def self.gradebook(query={})
    response = post({ :apitask => 'gradebook' }.merge query)
    raise InvalidClassId, 'Invalid class' if response.
      match("You are not authorized to view this class")
    JSON(response)['assignments']
  end


  def self.array(input)
    input = input.instance_of?(Array) ? input : [input]
  end


  def self.clid_array(classes)
    classes =  array(classes)
    classes.map! { |cl| cl.clid } if classes.first.instance_of? Classroom 
    classes
  end

end

