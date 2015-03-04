class Meme < ActiveRecord::Base
  has_attached_file :img,
    :styles => {
    :thumb => "100x100#",
    :medium => "300x200#" }
  validates_attachment_content_type :img, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_img
  before_validation { self.img.clear if self.delete_img == '1' }

  has_many :meme_slugs
  has_many :generated_memes
end
