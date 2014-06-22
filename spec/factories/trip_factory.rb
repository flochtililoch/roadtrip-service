FactoryGirl.define do

  factory :trip, class: Trip do
    data  { {foo: 'bar'} }
  end

end
