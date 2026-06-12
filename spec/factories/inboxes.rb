FactoryBot.define do
  factory :inbox do
    name { 'Test Inbox' }
    summary { 'A test inbox summary' }
    source { 'test_source' }
    payload { {} }
    metadata { {} }
  end
end
