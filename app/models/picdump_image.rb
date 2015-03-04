class PicdumpImage < ActiveRecord::Base
    attr_accessor :img_url # to handle external URL upload

    has_attached_file :img,
      :styles => {
        :medium => "300x300>",
        :thumb => "100x100>"
      },
      :default_url => "/images/picdump/missing.png"
    validates_attachment_content_type :img,
      :content_type => /\Aimage\/.*\Z/

    belongs_to :picdump
    belongs_to :picdump_category
end
