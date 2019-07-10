FactoryBot.define do
  factory :contact do
    sequence(:first_name) { |index| "joe-#{index}" }
    sequence(:last_name) { |index| "doe-#{index}" } 
    cell_phone { '151201200' }
    zip_code { '1540' }

    factory :contact_with_activities do
      after(:create) do |contact|
        create_list(:activity,  rand(1..3), contact: contact)
      end
    end
  end
end
