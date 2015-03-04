class ImageController < ApplicationController
  INTERLINE_SPACING_RATIO = 100
  WATERMARK_OPACITY = 0.2
  WATERMARK_PERC_SIZE = 4
  NOT_COUNT_VIEW_AGENT = [
    "visionutils", "ggpht.com GoogleImageProxy", "facebookexternalhit",
    "redditbot", "Google-HTTP-Java-Client", "Yahoo! Slurp",
    "MetaURI API", "+/web/snippet/", "Googlebot", "bingbot",
    "Googlebot-Image"
  ]

  def check
    top = (params[:top] || '').upcase.gsub('_',' ')
    bottom = (params[:bottom] || '').upcase.gsub('_',' ')

    if params[:meme].downcase != "s"
      meme_slug = MemeSlug.where(:slug => params[:meme].downcase)
      if meme_slug.nil? or meme_slug.size < 1
        redirect_to '/404'
      end
    end

    if params[:meme].downcase == "s"
      gen_meme = GeneratedMeme.where(:id => ApplicationHelper.id10(params[:top]).to_i).first
      meme = gen_meme.meme
      top = (gen_meme.top.chomp || '').upcase.gsub('_',' ')
      bottom = (gen_meme.bottom.chomp || '').upcase.gsub('_',' ')
    else
      meme = meme_slug.first.meme
    end

    if !meme.nil?
      main_slug = MemeSlug.where(:meme_id => meme.id).order(main: :desc).first

      ff = ApplicationHelper.sanitize_filename(top) || ''
      ff += "-" if !bottom.nil? and bottom != ""
      ff += ApplicationHelper.sanitize_filename(bottom) || ''
      filename = "#{main_slug.slug}-#{ff}.#{meme.img_content_type.split("/").last}".downcase

      if File.exists? "#{Rails.root}/public/gen/#{filename}"
        self.show meme, filename
      else
        exists = GeneratedMeme.where(:top => top, :bottom => bottom, :meme_id => meme.id)
        if exists.size > 0
          self.gen top, bottom, meme, main_slug, filename, true, exists
        else
          self.gen top, bottom, meme, main_slug, filename, false, exists
        end
      end
    else
      redirect_to '/404'
    end
  end

  def show meme, filename
    gen_meme = GeneratedMeme.where(:filename => filename).first
    meme_view = MemeView.where(:generated_meme_id => gen_meme.id, :user_hash => Digest::MD5.hexdigest(request.remote_ip))

    # Ignore bots for views
    count_view = true
    agent = request.env['HTTP_USER_AGENT']
    NOT_COUNT_VIEW_AGENT.each do |nc|
      if agent.include? nc
        count_view = false
        break
      end
    end

    if meme_view.size < 1 and count_view
      MemeView.create!(
        user_hash: Digest::MD5.hexdigest(request.remote_ip),
        generated_meme_id: gen_meme.id
      )
      gen_meme.views += 1
      gen_meme.views_day += 1
      gen_meme.views_week += 1
      gen_meme.views_month += 1
      gen_meme.save

      owner = gen_meme.user
      if owner and (!user_signed_in? or owner.id != current_user.id)
        owner.points += 1
        owner.points = 0 if owner.points < 0 or owner.points.nil?
        owner.save
      end
    end

    if File.extname(request.url) == ".json"
      render :json => build_json(gen_meme, "cache").to_json
    else
      send_file "#{Rails.root}/public/gen/#{filename}",
        type: meme.img_content_type,
        disposition: "inline",
        filename: filename
    end
  end

  def gen top, bottom, meme, main_slug, filename, exists, exists_elem
    begin
      canvas = Magick::ImageList.new(meme.img.path)
      image = canvas.first

      draw = Magick::Draw.new
      draw.font = "#{Rails.root}/public/fonts/Impact.ttf"
      draw.font_weight = Magick::BoldWeight

      pointsize = image.columns / 7.0
      stroke_width = pointsize / 30.0
      x_position = image.columns / 2
      y_position = image.rows * 0.15

      unless top.empty?
        scale, text = scale_text(top)
        text = "%2" if text == ""
        bottom_draw = draw.dup
        bottom_draw.annotate(canvas, 0, 0, 0, 0, text) do # 0 0 0 20
          self.interline_spacing = -(pointsize / INTERLINE_SPACING_RATIO) * scale
          self.stroke_antialias(true)
          self.stroke = "black"
          self.fill = "white"
          self.gravity = Magick::NorthGravity
          self.stroke_width = stroke_width * scale
          self.pointsize = pointsize * scale
        end
      end

      unless bottom.empty?
        scale, text = scale_text(bottom)
        text = "%2" if text == ""
        bottom_draw = draw.dup
        bottom_draw.annotate(canvas, 0, 0, 0, 0, text) do
          self.interline_spacing = -(pointsize / INTERLINE_SPACING_RATIO) * scale
          self.stroke_antialias(true)
          self.stroke = "black"
          self.fill = "white"
          self.gravity = Magick::SouthGravity
          self.stroke_width = stroke_width * scale
          self.pointsize = pointsize * scale
        end
      end


      @@logo ||= Magick::Image.read("#{Rails.root}/public/images/logo_small.png").first
      @@logo.alpha(Magick::ActivateAlphaChannel)

      if @@logo.rows > (canvas.rows/100*WATERMARK_PERC_SIZE)
        shrink_logo = (canvas.rows/100*WATERMARK_PERC_SIZE).to_f/@@logo.rows.to_f
        logo = @@logo.scale(shrink_logo)
      end

      white_canvas = Magick::Image.new(logo.columns, logo.rows) { self.background_color = "none" }
      white_canvas.alpha(Magick::ActivateAlphaChannel)
      white_canvas.opacity = Magick::QuantumRange - (Magick::QuantumRange * WATERMARK_OPACITY)

      logo_opacity = logo.composite(white_canvas, Magick::SouthWestGravity, 0, 0, Magick::DstInCompositeOp)
      logo_opacity.alpha(Magick::ActivateAlphaChannel)

      canvas = canvas.composite(logo_opacity, Magick::SouthWestGravity, 10, 5, Magick::OverCompositeOp)

      full_path = "#{Rails.root}/public/gen/#{filename}"

      canvas.write(full_path)

      canvas_medium = canvas.resize_to_fit(500, nil)
      canvas_medium.write("#{Rails.root}/public/gen/medium___#{filename}")
      canvas_small = canvas.resize_to_fit(180, nil)
      canvas_small.write("#{Rails.root}/public/gen/small___#{filename}")

      if !exists
        new_maymay = {
          top: top,
          bottom: bottom,
          meme_id: meme.id,
          img_hash: Digest::SHA1.hexdigest(filename),
          filename: filename,
          views: 1,
          views_day: 1,
          views_week: 1,
          views_month: 1
        }
        if user_signed_in?
          new_maymay[:user_id] = current_user.id
        else
          new_maymay[:user_hash] = Digest::MD5.hexdigest(request.remote_ip)
        end

        gen_maymay = GeneratedMeme.create!(new_maymay)
        MemeView.create!(
          user_hash: Digest::MD5.hexdigest(request.remote_ip),
          generated_meme_id: gen_maymay.id
        )
      else
        gen_maymay = exists_elem.first
      end

      if File.extname(request.url) == ".json"
        render :json => build_json(gen_maymay, "new").to_json
      else
        send_file full_path,
          type: meme.img_content_type,
          disposition: "inline",
          filename: filename
      end
    rescue Exception => e
      Rails.logger.info "Generation error #{e.message}\n#{e.backtrace}"
      puts e.message
      puts e.backtrace
      redirect_to '/500'
    end
  end

  def build_json meme, status
    usr = "anyanon"
    usr = meme.user.name if !meme.user.nil?
    {
      :id => ApplicationHelper.id32(meme.id),
      :meme => meme.meme.title,
      :top_text => meme.top.downcase,
      :bottom_text => meme.bottom.downcase,
      :url => ApplicationHelper.build_url(meme),
      :short_url => ApplicationHelper.build_short_url(meme),
      :view_url => ApplicationHelper.build_view_url(meme),
      :creator => usr,
      :status => status
    }
  end

  private

  def word_wrap(txt, col = 80)
    txt.gsub(/(.{1,#{col + 4}})(\s+|\Z)/, "\\1\n")
  end

  def scale_text(text)
    text = text.dup
    if text.length < 10
      scale = 1.0
    elsif text.length < 24
      text = word_wrap(text, 10)
      scale = 0.70
    elsif text.length < 48
      text = word_wrap(text, 15)
      scale = 0.5
    else
      text = word_wrap(text, 20)
      scale = 0.4
    end
    [scale, text.strip]
  end
end
