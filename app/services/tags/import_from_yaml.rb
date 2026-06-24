module Tags
  class ImportFromYaml
    Result = Struct.new(:created, :skipped, keyword_init: true)

    def initialize(path)
      @path = Pathname.new(path.to_s)
    end

    def call
      raise ArgumentError, "YAML file path is required" if path.to_s.blank?
      raise Errno::ENOENT, path.to_s unless path.file?

      entries.each_with_object(Result.new(created: [], skipped: [])) do |attributes, result|
        name = attributes[:name].to_s.strip
        next if name.blank?

        if existing_names.include?(name.downcase)
          result.skipped << name
          next
        end

        tag = Tag.create!(name: name, color: attributes[:color].presence)
        existing_names.add(tag.name.downcase)
        result.created << tag
      end
    end

    private

    attr_reader :path

    def entries
      raw_tags.map { |entry| normalize_entry(entry) }
    end

    def raw_tags
      parsed = YAML.safe_load_file(path, permitted_classes: [], aliases: false) || []
      parsed = parsed["tags"] || parsed[:tags] if parsed.is_a?(Hash)

      Array(parsed)
    end

    def normalize_entry(entry)
      case entry
      when String
        { name: entry }
      when Hash
        entry.symbolize_keys.slice(:name, :color)
      else
        {}
      end
    end

    def existing_names
      @existing_names ||= Tag.pluck(:name).map(&:downcase).to_set
    end
  end
end
