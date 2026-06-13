class InboxesController < ApplicationController
  before_action :set_inbox, only: %i[show edit update destroy process_modal mark_processed archive]

  def index
    @counts = {
      unprocessed: Inbox.unprocessed.count,
      processed: Inbox.processed_items.count,
      archived: Inbox.archived.count
    }

    @inboxes = case params[:filter]
               when 'processed' then Inbox.processed_items
               when 'archived'  then Inbox.archived
               else                  Inbox.unprocessed
               end.order(created_at: :desc)
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
      redirect_to @inbox, notice: 'Inbox was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    populate_json_text_fields
  end

  def update
    if @inbox.update(inbox_params)
      redirect_to @inbox, notice: 'Inbox was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @inbox.destroy
    redirect_to inboxes_path, notice: 'Inbox was successfully deleted.'
  end

  def process_modal
    @workflows = Workflow.order(:name)
    render :process
  end

  def mark_processed
    if @inbox.update(processed: true, workflow_id: params.dig(:inbox, :workflow_id))
      redirect_to inboxes_path, notice: 'Inbox item successfully processed.'
    else
      @workflows = Workflow.order(:name)
      render :process, status: :unprocessable_entity
    end
  end

  def archive
    @inbox.update(archived: true)
    redirect_to inboxes_path, notice: 'Inbox item archived.'
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
