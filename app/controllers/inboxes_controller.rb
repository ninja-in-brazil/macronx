class InboxesController < ApplicationController
  before_action :set_inbox, only: %i[show edit update destroy]

  def index
    @inboxes = Inbox.order(created_at: :desc)
  end

  def show
  end

  def new
    @inbox = Inbox.new(payload: {}, metadata: {})
    populate_json_text_fields
  end

  def create
    @inbox = Inbox.new(inbox_params)

    if @inbox.save
      redirect_to @inbox, notice: "Inbox was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    populate_json_text_fields
  end

  def update
    if @inbox.update(inbox_params)
      redirect_to @inbox, notice: "Inbox was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @inbox.destroy
    redirect_to inboxes_path, notice: "Inbox was successfully deleted."
  end

  private

  def set_inbox
    @inbox = Inbox.find(params[:id])
  end

  def populate_json_text_fields
    @inbox.payload_text  = JSON.pretty_generate(@inbox.payload  || {})
    @inbox.metadata_text = JSON.pretty_generate(@inbox.metadata || {})
  end

  def inbox_params
    params.require(:inbox).permit(:name, :source, :summary, :payload_text, :metadata_text)
  end
end
