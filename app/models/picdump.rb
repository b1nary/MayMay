class Picdump < ActiveRecord::Base
  belongs_to :picdump_category
  has_many :picdump_images
end
