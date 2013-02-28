require 'factory_girl'

FactoryGirl.define do

  factory :assignment, class:Engrade::Assignment do
    clid "101"
    assnid "1"
  end

end
