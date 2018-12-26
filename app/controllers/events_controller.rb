class EventsController < ApplicationController
  before_action :is_admin , except: [:index, :list, :search, :show]
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :set_objects, only: [:index, :list, :search]
  after_action :view_count, only: [:show]

  # GET /posts
  # GET /posts.json
  def index
    @events = Event.scp_published.scp_ordered_new.includes(:user, :event_category, :tags).references(:user, :event_category, :tags).page params[:page]
  end

  def list

    @events = Event.scp_published.includes(:user, :event_category).references(:user, :event_category)

    if not params[:qlink].nil?
      if params[:qlink] == "current"
        @PageTitle = "Güncel Etkinlikler"
        @events = @events.scp_current_events.scp_ordered_new
      elsif params[:qlink] == "old"
        @PageTitle = "Geçmiş Etkinlikler"
        @events = @events.scp_old_events.scp_ordered_new
      else
        @PageTitle = "Tüm Etkinlikler"
        @events = @events.scp_ordered_new
      end
    elsif not params[:cat].nil?
        @events = @events.scp_category?(params[:cat]).scp_ordered_new
        @PageTitle = EventCategory.find(params[:cat]).name + " Kategorisindeki Etkinlikler"
    elsif not params[:po].nil?
        @events = @events.scp_user?(params[:po]).scp_ordered_new
        @PageTitle = User.find(params[:po]).name + " Etkinlikleri"
    elsif not params[:tag].nil?
        @events = @events.scp_tag?(params[:tag]).scp_ordered_new
        @PageTitle = params[:tag] + " Etiketli Etkinlikler"
    else
      @PageTitle = "Yeni Eklenenler"
      @events = @events.scp_ordered_new
    end

    @events = @events.page params[:page]

    render :index

  end

  def search

    @PageTitle = "Arama Sonuçları"
    @events = Event.scp_published.includes(:user, :event_category).references(:user, :event_category)

    if  !params[:p_content].nil? && params[:p_content] != ""
      @events = @events.scp_content?("%" + params[:p_content] + "%")
    end

    if  !params[:category].nil? && params[:category] != ""
      @events = @events.scp_category?(params[:category])
    end

    @events = @events.page params[:page]

    render :index

  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @event_comments = @event.comments.includes(:user).references(:user)

  end

  # GET /posts/new
  def new
    @event = Event.new
    @event.user_id = current_user.id
    @event.comment_count = 0
    @event.view_count = 0
    @tags = ""
  end

  # GET /posts/1/edit
  def edit
    @tags = @event.tags.pluck(:tag)*","
  end

  # POST /posts
  # POST /posts.json
  def create
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save

        new_tags = params[:tags].split(',')

        new_tags.each do |stag|
          @event.tags.create(tag: stag)
        end

        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update

    old_tags = @event.tags.pluck(:tag)
    new_tags = params[:tags].split(',')

    #logger.debug old_tags
    #logger.debug new_tags
    #logger.debug (old_tags - new_tags)
    #logger.debug (new_tags - old_tags)

    (old_tags - new_tags).each do |stag|
      @event.tags.where(tag: stag).first.destroy
    end

    (new_tags - old_tags).each do |stag|
      @event.tags.create(tag: stag)
    end

    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_objects

      @eventOwnerMenuList = Event.scp_postOwner_menu
      @catMenuList = EventCategory.scp_category_menu

    end

    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:user_id, :event_category_id, :event_type_id, :title, :content, :status, :comment_count, :view_count, :start_date, :end_date, :event_time, :img)
    end

    def view_count
      @event.increment(:view_count)
      @event.save
    end

end
