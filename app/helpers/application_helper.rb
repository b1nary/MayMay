module ApplicationHelper
  def self.sanitize_filename(filename)
    filename.gsub(/[^0-9A-z.\-]/, '_')
  end

  def self.urlencode_filename(filename)
    Rack::Utils.escape(filename)
  end

  def self.id32 num
    Base58.encode(num)
  end

  def self.id10 num
    Base58.decode(num)
  end

  def self.build_url meme
    slug = MemeSlug.where(:meme_id => meme.meme.id).order(:main => :desc).first.slug
    top = meme.top
    bottom = meme.bottom
    uri = "#{Rails.configuration.schema}#{Rails.configuration.app_domain}/#{slug}"
    if top != ""
      uri += "/#{urlencode_filename(top.downcase)}"
    else
      uri += "/_"
    end
    uri += "/#{urlencode_filename(bottom.downcase)}" if bottom != ""
    uri += ".jpg"
    uri
  end

  def self.number_format num
    num = "0" if num.nil?
    num = "#{(num/1_000_000_000).round(2)}b" if num.is_a? Integer and num > 1_000_000_000
    num = "#{(num/1_000_000).round(2)}m" if num.is_a? Integer and num > 1_000_000
    num = "#{(num/1_000).round(2)}k" if num.is_a? Integer and num > 1_000
    return num
  end

  def self.build_short_url meme
    "#{Rails.configuration.schema}#{Rails.configuration.app_domain}/s/#{ApplicationHelper.id32(meme.id)}.jpg"
  end

  def self.build_view_url meme
    "#{Rails.configuration.schema}#{Rails.configuration.app_domain}/info/#{ApplicationHelper.id32(meme.id)}"
  end

  def self.get_meme_slug meme
    MemeSlug.where(:meme_id => meme.meme.id).order(:main).first.slug
  end

  def self.url
    "#{Rails.configuration.schema}#{Rails.configuration.app_domain}"
  end

  def self.build_meme_hash meme
    creator = "anyanon"
    creator = meme.user.name if meme.user_id
    {
      :creator => creator,
      :meme => meme.meme.title,
      #:meme_slug => ApplicationHelper.get_meme_slug(@meme),
      :created => meme.created_at.to_s,
      :top_text => meme.top.downcase,
      :bottom_text => meme.bottom.downcase,
      :url => self.build_url(meme),
      :short_url => self.build_short_url(meme),
      :views => {
        :today => meme.views_day,
        :week => meme.views_week,
        :month => meme.views_month,
        :all => meme.views
      }
    }
  end

  def self.build_parameter params, arr
    addextra = ""
    arr.each do |ar|
      if params[ar[:param]]
        if addextra == ""
          addextra += "?"
        else
          addextra += "&"
        end
        addextra += "#{ar[:uri]}=#{params[ar[:param]]}"
      end
    end
    addextra
  end
end
