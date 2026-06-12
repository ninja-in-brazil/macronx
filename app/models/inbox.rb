class Inbox < ApplicationRecord
  attr_accessor :payload_text, :metadata_text

  before_validation :parse_json_fields

  private

  def parse_json_fields
    self.payload  = JSON.parse(payload_text)  if payload_text.present?
    self.metadata = JSON.parse(metadata_text) if metadata_text.present?
  rescue JSON::ParserError => e
    errors.add(:base, "Invalid JSON: #{e.message}")
    throw :abort
  end
end
