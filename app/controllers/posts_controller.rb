class PostsController < ApplicationController
  before_action :is_admin , except: [:index, :list, :search, :show]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :set_objects, only: [:index, :list, :search]
  after_action :view_count, only: [:show]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.scp_published.scp_ordered_new.includes(:user, :blog_category, :tags).references(:user, :blog_category, :tags).page params[:page]
  end

  def list

    @posts = Post.scp_published.includes(:user, :blog_category).references(:user, :blog_category)

    if not params[:qlink].nil?
      if params[:qlink] == "new"
        @PageTitle = "Yeni Eklenenler"
        @posts = @posts.scp_ordered_new
      elsif params[:qlink] == "max_comment"
        @PageTitle = "En Çok Yorum Alanlar"
        @posts = @posts.scp_ordered_comments
      elsif params[:qlink] == "draft"
        @PageTitle = "Yayınlanmamış Yazılar"
        @posts = @posts.unscope(:where).scp_draft.scp_ordered_new
      else
        @PageTitle = "Yeni Eklenenler"
        @posts = @posts.scp_ordered_new
      end
    elsif not params[:cat].nil?
        @posts = @posts.scp_category?(params[:cat]).scp_ordered_new
        @PageTitle = BlogCategory.find(params[:cat]).name + " Kategorisindeki Yazılar"
    elsif not params[:po].nil?
        @posts = @posts.scp_user?(params[:po]).scp_ordered_new
        @PageTitle = User.find(params[:po]).name + " Yazıları"
    elsif not params[:tag].nil?
        @posts = @posts.scp_tag?(params[:tag]).scp_ordered_new
        @PageTitle = params[:tag] + " Etiketli Yazılar"
    else
      @PageTitle = "Yeni Eklenenler"
      @posts = @posts.scp_ordered_new
    end

    @posts = @posts.page params[:page]

    render :index

  end

  def search

    @PageTitle = "Arama Sonuçları"
    @posts = Post.scp_published.includes(:user, :blog_category).references(:user, :blog_category)

    if  !params[:p_content].nil? && params[:p_content] != ""
      @posts = @posts.scp_content?("%" + params[:p_content] + "%")
    end

    if  !params[:category].nil? && params[:category] != ""
      @posts = @posts.scp_category?(params[:category])
    end

    @posts = @posts.page params[:page]

    render :index

  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post_comments = @post.comments.includes(:user).references(:user)
#    @favorite = @post.favorites.where(user_id: session[:userid]).first

#    if @post.tags.size > 0
#      @post_books = Book.includes(:bookPrints).references(:bookPrints).scp_book_name_in?(@post.tags.pluck(:tag))
#      @post_writers = Writer.scp_name_in?(@post.tags.pluck(:tag))
#      @post_characters = Character.scp_name_in?(@post.tags.pluck(:tag))

#      @post.tags.each do |tag|
#        @post_books = @post_books.scp_book_name?(tag.tag)
#      end
#    end
#    @character_books = @character.books.includes(:bookPrints).references(:bookPrints)

  end

  # GET /posts/new
  def new
    @post = Post.new
    @post.user_id = current_user.id
    @post.comment_count = 0
    @post.view_count = 0
    @tags = ""
  end

  # GET /posts/1/edit
  def edit
    @tags = @post.tags.pluck(:tag)*","
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)


    respond_to do |format|
      if @post.save

        new_tags = params[:tags].split(',')

        new_tags.each do |stag|
          @post.tags.create(tag: stag)
        end

        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update

    old_tags = @post.tags.pluck(:tag)
    new_tags = params[:tags].split(',')

    #logger.debug old_tags
    #logger.debug new_tags
    #logger.debug (old_tags - new_tags)
    #logger.debug (new_tags - old_tags)

    (old_tags - new_tags).each do |stag|
      @post.tags.where(tag: stag).first.destroy
    end

    (new_tags - old_tags).each do |stag|
      @post.tags.create(tag: stag)
    end

    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_objects

      @postOwnerMenuList = Post.scp_postOwner_menu
      @catMenuList = BlogCategory.scp_category_menu

    end

    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:user_id, :blog_category_id, :title, :content, :status, :comment_count, :view_count, :img)
    end

    def view_count
      @post.increment(:view_count)
      @post.save
    end

end
