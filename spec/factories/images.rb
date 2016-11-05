FactoryGirl.define do
  factory :image do
    photo File.new(Rails.root.join('spec/fixtures/elon.jpeg'))
  end
end
