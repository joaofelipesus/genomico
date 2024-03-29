FactoryBot.define do
  factory :qubit_report do
    subsample { create(:subsample) }
    concentration { Faker::Number.decimal(l_digits: 3) }
  end
end
