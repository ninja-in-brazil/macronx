class Inbox < ApplicationRecord
  attr_accessor :payload_text, :metadata_text

  before_validation :set_default_name
  before_validation :parse_json_fields

  private

  # TODO: replace with LLM-generated name derived from payload/summary
  def set_default_name
    self.name = "inbox-#{SecureRandom.hex(4)}" if name.blank?
  end

  def parse_json_fields
    self.payload  = JSON.parse(payload_text)  if payload_text.present?
    self.metadata = JSON.parse(metadata_text) if metadata_text.present?
  rescue JSON::ParserError => e
    errors.add(:base, "Invalid JSON: #{e.message}")
    throw :abort
  end
end
