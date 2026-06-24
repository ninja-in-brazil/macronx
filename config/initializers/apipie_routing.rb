# apipie-rails 1.5.0 passes route options as a hash to `get`, which Rails 8.1+
# deprecates. Remove this patch when upgrading past the fix in
# https://github.com/Apipie/apipie-rails/pull/962
module Apipie
  module Routing
    module MapperExtensions
      def apipie(options = {})
        namespace "apipie", path: Apipie.configuration.doc_base_url do
          get "apipie_checksum", to: "apipies#apipie_checksum", format: "json"
          constraints(version: %r{[^/]+}, resource: %r{[^/]+}, method: %r{[^/]+}) do
            get_args = options.reverse_merge("(:version)/(:resource)/(:method)" => "apipies#index", as: :apipie)
            get(**get_args)
          end
        end
      end
    end
  end
end
