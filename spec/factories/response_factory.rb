require 'factory_girl'

FactoryGirl.define do
  
  factory :login, class:Hash do
    body "{\"fields\":\"usr pwd remember go\",\"success\":true,\"values\":{\"usr\":\"zgthompson\",\"pwd\":\"secretpass\",\"remember\":null,\"go\":null,\"ses\":\"9426016804785795792n8k42bbalb40m8e58j4n0faa98d03o0958kfmn98019pa\"},\"time\":1363650224}" 
    json { JSON(body) }
    query { { :usr => ENV['ENG_USER'], :pwd => ENV['ENG_PASS'], :apitask => 'login' } }
    payload { { :api => 'json', :apikey => ENV['ENG_API'] }.merge query }

    initialize_with { attributes }
  end

  factory :login_baduser, class:Hash do
    body "{\"fields\":\"usr pwd remember go\",\"success\":false,\"values\":{\"usr\":\"baduser\",\"pwd\":\"anypass\",\"remember\":null,\"go\":null},\"errors\":{\"usr\":\"Invalid username\"},\"time\":1363653753}"
    json { JSON(body) }
    query { { :usr => 'baduser', :pwd => 'anypass', :apitask => 'login' } }
    payload { { :api => 'json', :apikey => ENV['ENG_API'] }.merge query }
    
    initialize_with { attributes }
  end

  factory :login_badpass, class:Hash do
    body "{\"fields\":\"usr pwd remember go\",\"success\":false,\"values\":{\"usr\":\"zgthompson\",\"pwd\":\"badpass\",\"remember\":null,\"go\":null},\"errors\":{\"pwd\":\"Invalid password\"},\"time\":1363654455}" 
    json { JSON(body) }
    query { { :usr => 'zgthompson', :pwd => 'badpass', :apitask => 'login' } }
    payload { { :api => 'json', :apikey => ENV['ENG_API'] }.merge query }
    
    initialize_with { attributes }
  end

  factory :bad_api, class:Hash do
    body "Invalid apikey, please contact Engrade to receive your API key.badapi" 
    query { {} }
    payload { { :api => 'json', :apikey => 'badapi' } }
    
    initialize_with  { attributes }
  end

  factory :teacher_classes, class:Hash do
    body "{\"success\":true,\"classes\":[{\"superid\":\"1000008059883\",\"subid\":\"101\",\"supertype\":\"teacher\",\"subtype\":\"class\",\"auth\":6,\"joined\":1361653042,\"role\":\"Teacher\",\"clid\":\"101\",\"created\":1361653042,\"folder\":3,\"syr\":\"2013-2014\",\"gp\":1,\"gscale\":9,\"weighted\":0,\"showper\":1,\"stusort\":1,\"assnsort\":1,\"round\":1,\"stuview\":1,\"stumail\":0,\"gradelevel\":7,\"subject\":5,\"bb\":0,\"teachmail\":1,\"priteach\":\"1000008059883\",\"name\":\"Biology\",\"code\":null,\"stucount\":6,\"average\":68.3,\"missing\":0,\"failing\":1,\"registered\":0,\"acount\":1,\"stdset\":0,\"updated\":1362535927},{\"superid\":\"1000008059883\",\"subid\":\"5000006291841\",\"supertype\":\"teacher\",\"subtype\":\"class\",\"auth\":6,\"joined\":1363580907,\"role\":\"Teacher\",\"clid\":\"5000006291841\",\"created\":1363580907,\"folder\":3,\"syr\":\"2013-2014\",\"gp\":1,\"gscale\":9,\"weighted\":0,\"showper\":1,\"stusort\":1,\"assnsort\":1,\"round\":1,\"stuview\":1,\"stumail\":0,\"gradelevel\":99,\"subject\":99,\"bb\":0,\"teachmail\":1,\"priteach\":\"1000008059883\",\"name\":\"Chemistry - Sem1\",\"code\":null,\"stucount\":2,\"average\":0,\"missing\":0,\"failing\":0,\"registered\":0,\"acount\":0,\"stdset\":0,\"updated\":1363580917},{\"superid\":\"1000008059883\",\"subid\":\"5000006291845\",\"supertype\":\"teacher\",\"subtype\":\"class\",\"auth\":6,\"joined\":1363580934,\"role\":\"Teacher\",\"clid\":\"5000006291845\",\"created\":1363580934,\"folder\":3,\"syr\":\"2013-2014\",\"gp\":1,\"gscale\":9,\"weighted\":0,\"showper\":1,\"stusort\":1,\"assnsort\":1,\"round\":1,\"stuview\":1,\"stumail\":0,\"gradelevel\":99,\"subject\":99,\"bb\":0,\"teachmail\":1,\"priteach\":\"1000008059883\",\"name\":\"Math - Sem2\",\"code\":null,\"stucount\":2,\"average\":0,\"missing\":0,\"failing\":0,\"registered\":0,\"acount\":0,\"stdset\":0,\"updated\":1363580941}],\"time\":1363655149}"
    json { JSON(body) }
    classes { json['classes'] }
    helper_query { { :apitask => 'teacher-classes' } }
    payload { { :api => 'json', :apikey => ENV['ENG_API'], :ses => ENV['ENG_SES'] }.merge helper_query }

    initialize_with { attributes }
  end

  factory :bad_ses, class:Hash do
    body "{\"success\":false,\"errors\":{\"system\":\"Not logged in\"},\"time\":1363655473}"
    query { { :apitask => 'teacher-classes' } }
    payload { { :api => 'json', :apikey => ENV['ENG_API'] }.merge query } 
    initialize_with { attributes }
  end

  factory :no_task, class:Hash do
    body "No apitask specified"
    query { {} }
    payload { { :api => 'json', :apikey => ENV['ENG_API'] } }
    initialize_with { attributes }
  end

  factory :bad_task, class:Hash do
    body "Invalid apitask"
    query { { :apitask => 'badtask' } }
    payload { { :api => 'json', :apikey => ENV['ENG_API'] }.merge query }
    initialize_with { attributes }
  end

  factory :gradebook, class:Hash do
    body "{\"clid\":\"101\",\"created\":1361653042,\"folder\":3,\"syr\":\"2013-2014\",\"gp\":1,\"gscale\":9,\"weighted\":0,\"showper\":1,\"stusort\":1,\"assnsort\":1,\"round\":1,\"stuview\":1,\"stumail\":0,\"gradelevel\":7,\"subject\":5,\"bb\":0,\"teachmail\":1,\"priteach\":\"1000008059883\",\"name\":\"Biology\",\"code\":null,\"stucount\":6,\"average\":69.3,\"missing\":0,\"failing\":1,\"registered\":0,\"acount\":2,\"stdset\":0,\"updated\":1363837018,\"cgs\":[{\"num\":1,\"low\":90,\"grade\":\"A\"},{\"num\":2,\"low\":80,\"grade\":\"B\"},{\"num\":3,\"low\":70,\"grade\":\"C\"},{\"num\":4,\"low\":60,\"grade\":\"D\"},{\"num\":5,\"low\":0,\"grade\":\"F\"}],\"cat\":[{\"num\":1,\"name\":\"Assignments\",\"weight\":null,\"dls\":0}],\"assignments\":[{\"clid\":\"101\",\"assnid\":2,\"created\":1363837018,\"creator\":\"1000008059883\",\"type\":1,\"cat\":1,\"cal\":1,\"bb\":1,\"turnin\":0,\"lastreplier\":0,\"lastreply\":0,\"replies\":0,\"attachments\":0,\"due\":20130320,\"points\":2,\"title\":\"Quiz\",\"gb\":1,\"showstu\":1,\"rubric\":0,\"itemid\":null,\"name\":\"Zachary Thompson\",\"usr\":\"zgthompson\",\"pic\":0},{\"clid\":\"101\",\"assnid\":1,\"created\":1362534970,\"creator\":\"1000008059883\",\"type\":1,\"cat\":1,\"cal\":1,\"bb\":1,\"turnin\":0,\"lastreplier\":0,\"lastreply\":0,\"replies\":0,\"attachments\":0,\"due\":20130305,\"points\":10,\"title\":\"Pop Quiz\",\"gb\":1,\"showstu\":1,\"rubric\":0,\"itemid\":null,\"name\":\"Zachary Thompson\",\"usr\":\"zgthompson\",\"pic\":0}],\"students\":[{\"stuid\":95956,\"num\":1,\"first\":\"George\",\"last\":\"Washington\",\"grade\":\"F\",\"percent\":17,\"missing\":0,\"acount\":2,\"status\":3},{\"stuid\":17406,\"num\":2,\"first\":\"John\",\"last\":\"Adams\",\"grade\":\"B\",\"percent\":83,\"missing\":0,\"acount\":2,\"status\":3},{\"stuid\":12345,\"num\":3,\"first\":\"Bob\",\"last\":\"Barker\",\"grade\":\"B\",\"percent\":83,\"missing\":0,\"acount\":2,\"status\":3},{\"stuid\":13371,\"num\":4,\"first\":\"Mary\",\"last\":\"Popper\",\"grade\":\"B\",\"percent\":83,\"missing\":0,\"acount\":2,\"status\":3},{\"stuid\":12567,\"num\":5,\"first\":\"Mark\",\"last\":\"Zuck\",\"grade\":\"C\",\"percent\":75,\"missing\":0,\"acount\":2,\"status\":3},{\"stuid\":44245,\"num\":6,\"first\":\"Frank\",\"last\":\"Cull\",\"grade\":\"C\",\"percent\":75,\"missing\":0,\"acount\":2,\"status\":3}],\"scores\":[{\"assnid\":1,\"stuid\":12345,\"score\":8},{\"assnid\":1,\"stuid\":12567,\"score\":8},{\"assnid\":1,\"stuid\":13371,\"score\":8},{\"assnid\":1,\"stuid\":17406,\"score\":8},{\"assnid\":1,\"stuid\":44245,\"score\":8},{\"assnid\":1,\"stuid\":95956,\"score\":1},{\"assnid\":2,\"stuid\":12345,\"score\":2},{\"assnid\":2,\"stuid\":12567,\"score\":1},{\"assnid\":2,\"stuid\":13371,\"score\":2},{\"assnid\":2,\"stuid\":17406,\"score\":2},{\"assnid\":2,\"stuid\":44245,\"score\":1},{\"assnid\":2,\"stuid\":95956,\"score\":1}],\"success\":true,\"time\":1363840611}"
    json { JSON(body) }
    assignments { json['assignments'] }
    public_query { { :clid => '101' } }
    helper_query { { :apitask => 'gradebook', :clid => '101' } }
    payload { { :api => 'json', :apikey => ENV['ENG_API'], :ses => ENV['ENG_SES'] }.merge helper_query }
    initialize_with { attributes }
  end

  factory :bad_class, class:Hash do
    body "{\"success\":false,\"errors\":{\"system\":\"You are not authorized to view this class\"},\"time\":1363843636}"
    query { { :apitask => 'gradebook', :clid => '123456' } }
    payload { { :api => 'json', :apikey => ENV['ENG_API'], :ses => ENV['ENG_SES'] }.merge query }
    initialize_with { attributes }
  end

  factory :delete, class:Hash do
    query { { :apitask => 'assignment-edit', :delete => '1',
      :clid => '101', :assnid => '1' } }

    initialize_with { attributes }
  end

end
    
