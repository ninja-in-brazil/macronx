class Avo::Resources::User < Avo::BaseResource
  self.title = :email
  self.search = {
    query: -> { query.ransack(email_cont: q).result(distinct: false) }
  }

  def fields
    field :id, as: :id
    field :email, as: :text, sortable: true
    field :admin, as: :boolean, sortable: true
    field :created_at, as: :date_time, sortable: true
    field :updated_at, as: :date_time, sortable: true, hide_on: :index
  end
end
