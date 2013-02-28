require 'factory_girl'

FactoryGirl.define do

  factory :classroom, class:Engrade::Classroom do
    clid "101"
  end

  factory :bad_classroom, class:Engrade::Classroom do
    clid "123456"
  end

end
