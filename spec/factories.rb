FactoryGirl.define do
  factory :bank_account, aliases: [:account] do
    sequence(:username) { |n| "OH#{n}" }
    factory :credior_account do
      sequence(:username) { |n| "CR#{n}" }
    end  
  end

  factory :transaction do
    bank_account
    amount 100
    trait :d do
      state 0
      association :bank_account, factory: :bank_account
      association :creditor, factory: :credior_account
    end
    trait :w do
      state 1
      association :bank_account, factory: :bank_account
      association :creditor, factory: :credior_account
    end
  end
end
