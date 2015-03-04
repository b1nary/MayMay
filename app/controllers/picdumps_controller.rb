class PicdumpsController < ApplicationController
  def index
    @_category = params[:category]
    @title = "MayMay Picdumps"
    if @_category
      @category = PicdumpCategory.where(:slug => @_category)
      if @category.size > 0
        @title = "#{@category.first.title} Picdumps"
      end
    end
  end

  def view
  end
end
