require 'rails_helper'

RSpec.describe Tags::ImportFromYaml do
  let(:path) { Rails.root.join('tmp/tags_import_spec.yml') }

  after do
    File.delete(path) if File.exist?(path)
  end

  it 'creates missing tags from a tags root' do
    File.write(path, <<~YAML)
      tags:
        - name: Urgent
          color: bg-red-100 text-red-700
        - Backlog
    YAML

    result = described_class.new(path).call

    expect(result.created.map(&:name)).to contain_exactly('Urgent', 'Backlog')
    expect(Tag.find_by(name: 'Urgent').color).to eq('bg-red-100 text-red-700')
  end

  it 'creates missing tags from a top-level list' do
    File.write(path, <<~YAML)
      - Bug
      - name: Feature
        color: bg-blue-100 text-blue-700
    YAML

    described_class.new(path).call

    expect(Tag.pluck(:name)).to contain_exactly('Bug', 'Feature')
  end

  it 'skips existing tags case-insensitively without updating them' do
    existing = create(:tag, name: 'urgent', color: 'bg-gray-100 text-gray-700')
    File.write(path, <<~YAML)
      tags:
        - name: URGENT
          color: bg-red-100 text-red-700
        - name: New
    YAML

    result = described_class.new(path).call

    expect(result.skipped).to eq([ 'URGENT' ])
    expect(result.created.map(&:name)).to eq([ 'New' ])
    expect(existing.reload.color).to eq('bg-gray-100 text-gray-700')
  end
end
