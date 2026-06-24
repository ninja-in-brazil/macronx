namespace :tags do
  desc "Import tags from a YAML file. Usage: bin/rails tags:import FILE=config/tags.yml"
  task import: :environment do
    file = ENV["FILE"] || ENV["TAGS_FILE"]
    result = Tags::ImportFromYaml.new(file).call

    puts "Created #{result.created.size} tags."
    puts "Skipped #{result.skipped.size} existing tags."
  end
end
