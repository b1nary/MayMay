class HomeController < ApplicationController
  def index
  end
  def top_users
  end

  def remove_meme
    meme = GeneratedMeme.find(params[:meme].to_i)
    if !meme.user.nil? and meme.user.id != current_user.id
      flash[:error] = "This is not your MayMay, why remove it?"
      redirect_to '/no'
    else
      meme.delete()
      meme.save()
      flash[:notice] = "Meme removed from our database."
      redirect_to :root
    end
  end

  def user
    usr = params[:username]
    @user = User.where(:name => usr).first

    @limit = 50
    @limit = params[:limit] if params[:limit]

    @image_count = @limit

    @page = 0
    @offset = 0
    if params[:page] and params[:page].to_i.is_a? Integer
      @page = (params[:page].to_i - 1)
      @page = 0 if @page < 0
      @offset = @page * @image_count
    end

    @sort = :created_at
    @sort = :views if params['sort'] == 'most_popular'

    @search = nil
    @search = params[:search] if params[:search]

    if @search
      @maymays = GeneratedMeme.where(:user_id => @user.id).search(@search).order(@sort => :desc, :created_at => :desc).limit(@image_count).offset(@offset)
    else
      @maymays = GeneratedMeme.where(:user_id => @user.id).order(@sort => :desc, :created_at => :desc).limit(@image_count).offset(@offset)
    end

    if !@user.nil?
      @memecount = @user.generated_memes.count
      if File.extname(request.url.split('?').first) == ".json"
        user = {
          :username => @user.name,
          :points => @user.points,
          :uploads => @user.generated_memes.size,
          :registered_since => @user.created_at.to_s,
          :sort_by => @sort,
          :rendered => Time.now.to_s,
          :memes => []
        }
        @maymays.each do |meme|
          user[:memes] << ApplicationHelper.build_meme_hash(meme)
        end
        render :json => user.to_json
      end

    else
      redirect_to '/404?user_not_found'
    end
  end

  def generator
  	@is_meme = false
    @is_rand = false
  	if params[:meme]
      @meme_slug = MemeSlug.where(:slug => params[:meme].downcase)
      if @meme_slug.size > 0
        @is_meme = true
        @meme = @meme_slug.first.meme
        @meme_slugs = MemeSlug.where(:meme_id => @meme.id)
        @main_slug = @meme_slugs.order(main: :desc).first
      end
    else
      @is_rand = true
      @is_meme = true
      @meme = Meme.offset(rand(Meme.count)).first
      @meme_slugs = MemeSlug.where(:meme_id => @meme.id)
      @main_slug = @meme_slugs.order(main: :desc).first
    end
  end
end
