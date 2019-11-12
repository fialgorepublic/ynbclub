class ConversationsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :replies]
  before_action :set_conversation, only: [:show, :edit, :update, :destroy, :reply, :conversation_reply, :replies]

  # GET /conversations
  # GET /conversations.json
  def index
    conversations  = Conversation.includes(:replies).post_conversations
    conversations  = conversations.sort_by_type(params[:sort_type]) if params[:sort_type].present?
    @conversations = conversations.paginate(page: params[:page])
    @next_page     = @conversations.next_page

    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /conversations/1
  # GET /conversations/1.json
  def show
    @related_posts = @conversation.three_related_posts
    @replies = @conversation.replies.paginate(page: params[:page])
  end

  # GET /conversations/new
  def new
    @conversation = Conversation.new
  end

  # GET /conversations/1/edit
  def edit
  end

  # POST /conversations
  # POST /conversations.json
  def create
    @conversation = current_user.conversations.new(conversation_params)

    respond_to do |format|
      if @conversation.save
        format.html { redirect_to @conversation, notice: 'Conversation was successfully created.' }
        format.json { render :show, status: :created, location: @conversation }
      else
        format.html { render :new }
        format.json { render json: @conversation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /conversations/1
  # PATCH/PUT /conversations/1.json
  def update
    respond_to do |format|
      if @conversation.update(conversation_params)
        format.html { redirect_to @conversation, notice: 'Conversation was successfully updated.' }
        format.json { render :show, status: :ok, location: @conversation }
      else
        format.html { render :edit }
        format.json { render json: @conversation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /conversations/1
  # DELETE /conversations/1.json
  def destroy
    @conversation.destroy
    respond_to do |format|
      format.html { redirect_to conversations_url, notice: 'Conversation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def search
    @conversations = Conversation.post_conversations.filter_by_subject(params[:conversation_subject])
  end

  def banner
    @page.update(conversation_banner: params[:page][:conversation_banner])
    redirect_to conversations_path
  end

  def reply
    @reply = @conversation.replies.new
  end

  def conversation_reply
    reply = @conversation.replies.create(conversation_params.merge(user: current_user))
    if reply
      redirect_to @conversation, notice: 'Posted your reply successfully.'
    else
      render :reply
    end
  end

  def replies
    @replies   = @conversation.replies.paginate(page: params[:page])
    @next_page = @replies.next_page
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_conversation
      @conversation = Conversation.includes(:user, :group, :replies).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def conversation_params
      params.require(:conversation).permit(:subject, :body, :group_id, tags: [])
    end
end
