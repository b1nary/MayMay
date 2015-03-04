class PicdumpCategory < ActiveRecord::Base
  has_attached_file :header,
    :styles => {
      :medium => "300x300>",
      :thumb => "100x100>"
    },
    :default_url => "/images/picdump/header.png"
  validates_attachment_content_type :header,
    :content_type => /\Aimage\/.*\Z/

  has_many :picdumps
  has_many :picdump_images
end
