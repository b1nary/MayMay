class ErrorsController < ApplicationController
  def e404
  	render :status => 404
  end

  def e422
  	render :status => 422
  end

  def e500
  	render :status => 500
  end
end
