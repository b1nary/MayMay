class MemeController < ApplicationController
  def view_image

    @meme = GeneratedMeme.find(ApplicationHelper.id10(params[:hex]))
    @url = ApplicationHelper.build_url(@meme)
    @short_url = ApplicationHelper.build_short_url(@meme)

    @my_image = false
    @my_image = true if (user_signed_in? and @meme.user and current_user.id == @meme.user.id) or (@meme.created_at >= 2.days.ago.utc and Digest::MD5.hexdigest(request.remote_ip) == @meme.user_hash)

    if File.extname(request.url) == ".json"
      render :json => ApplicationHelper.build_meme_hash(@meme).to_json
    end
  end

  def list
    @limit = 50
    @limit = params[:limit].to_i if params[:limit]
    @limit = 100 if @limit > 100

    @page = 0
    @offset = 0
    if params[:page] and params[:page].to_i.is_a? Integer
      @page = (params[:page].to_i)
      @page = 0 if @page < 0
      @offset = @page * @limit
    end

    @sort = :views_day
    @sort = :views 			  if params["sort"] == "views"
    @sort = :views_day 		if params["sort"] == "views_day"
    @sort = :views_week 	if params["sort"] == "views_week"
    @sort = :views_month 	if params["sort"] == "views_month"
    @sort = :created_at 	if params["sort"] == "newest"


    @search = nil
    @search = params[:q] if params[:q]
    @meme = nil
    @meme = params[:meme] if params[:meme]

    if @search and @meme
      slug = MemeSlug.where(:slug => @meme).first
      @maymays = GeneratedMeme.search(@search).where(:meme_id => slug.meme.id).order(@sort => :desc, :created_at => :desc)
    elsif @search
      @maymays = GeneratedMeme.search(@search).order(@sort => :desc, :created_at => :desc)
    elsif @meme
      slug = MemeSlug.where(:slug => @meme).first
      @maymays = GeneratedMeme.where(:meme_id => slug.meme.id).order(@sort => :desc, :created_at => :desc)
    else
      @maymays = GeneratedMeme.order(@sort => :desc, :created_at => :desc)
    end

    # hm? pagination
    @maymay_count = @maymays.count
    @max_pages = (@maymay_count / @limit)

    @maymays = @maymays.limit(@limit).offset(@offset)

    if File.extname(request.url.split('?').first) == ".json"
      memes = {
        :sort_by => @sort,
        :rendered => Time.now.to_s,
        :memes => []
      }
      @maymays.each do |meme|
        memes[:memes] << ApplicationHelper.build_meme_hash(meme)
      end
      render :json => memes.to_json
    end
  end
end
