class GeneratedMeme < ActiveRecord::Base
	belongs_to :user
	belongs_to :meme

	has_many :meme_views

	def self.search(search)
		condition = "%#{search.upcase}%"
		where("top like ? OR bottom like ?", condition, condition)
	end
end
