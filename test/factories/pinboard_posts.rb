# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :pinboard_post do
    href "MyString"
    description "MyString"
    extended "MyText"
    tag "MyString"
    time "2013-08-06 19:47:59"
    replace false
    shared false
    toread false
  end
end
