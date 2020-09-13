class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  def title_header
    Movie.order('title')
  end
  
  def release_date_header
    Movie.order("release_date")
  end
    
  protect_from_forgery with: :exception
end
