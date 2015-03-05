# encoding: utf-8 

namespace :cron do
  desc "Daily cron job"
  task daily: :environment do
    last = JSON.parse(File.read(Rails.root+"config/cron.json", :encoding => "UTF-8"))
    GeneratedMeme.update_all( "views_day = 0" )
    if last["week"] != Date.today.cweek
      last["week"] = Date.today.cweek
      GeneratedMeme.update_all( "views_week = 0" )
      File.open(Rails.root+"config/cron.json", "w", :encoding => "UTF-8") do |f|
        f.write( last.to_json )
      end
    end

    if last["month"] != Date.today.month
      last["month"] = Date.today.month
      GeneratedMeme.update_all( "views_month = 0" )
      File.open(Rails.root+"config/cron.json", "w", :encoding => "UTF-8") do |f|
        f.write( last.to_json )
      end
    end
  end

  desc "Hourly cron job"
  task hourly: :environment do
    MemeView.destroy_all(['updated_at < ?', 6.hours.ago])
  end

  desc "Social post cron job"
  task social: :environment do
    require 'mandrill'

    if rand(10) < 3
      mandrill = Mandrill::API.new 'szbLIY9tRHQYRRtD0AWp6g'

      puts "yay (social)"
      social = JSON.parse(File.read(Rails.root+"config/social.json", :encoding => "UTF-8"))

      new_meme = nil
      memes = GeneratedMeme.order(:views_day => :desc, :views_week => :desc, :views_month => :desc, :views => :desc).limit(20)
      memes.each do |meme|
        (new_meme = meme; break) if !social.include? meme.id
      end

      if !new_meme.nil?
        social << new_meme.id
        File.open(Rails.root+"config/social.json", "w", :encoding => "UTF-8") do |f|
          f.write(social.to_json)
        end

        title = new_meme.top.downcase
        title = new_meme.bottom.downcase if title == "" or title == " "

        message = {
         :subject=> ApplicationHelper.build_view_url(new_meme),
         :from_name=> "MayMay",
         :text=> title,
         :to=>[
           {
             :email=> "trigger@recipe.ifttt.com",
             :name=> "IFTTT"
           }
         ],
         :from_email=>"info@maymay.in"
        }
        sending = mandrill.messages.send message
      end

    end
  end
end
