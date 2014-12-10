FactoryGirl.define do
  factory :fund do
    sequence(:name) { |n| "Fund Name #{n}" }
    sequence(:display_name) { |n| "Name #{n}" }
    active true
    active_from { Date.today - 1 }
  end

  factory :batch do
    name "Week Ending: " + Date.today.to_s
    opening_date Date.today
    deposit_date Date.today + 1.week
    amount 5000.00
    status 'Open'
    batch_type 'Manual'
  end
end
