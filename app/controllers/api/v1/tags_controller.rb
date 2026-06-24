module Api
  module V1
    class TagsController < BaseController
      resource_description do
        short "Tags"
        description "Retrieve tags available for inbox classification."
        formats [ "json" ]
      end

      api :GET, "/v1/tags", "List all tags"
      def index
        render json: Tag.order(:name).map { |tag| serialize(tag) }
      end

      private

      def serialize(tag)
        {
          id: tag.id,
          name: tag.name,
          color: tag.color,
          created_at: tag.created_at,
          updated_at: tag.updated_at
        }
      end
    end
  end
end
