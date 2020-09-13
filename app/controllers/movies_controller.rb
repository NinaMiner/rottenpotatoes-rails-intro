class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @sort= params[:sort]
    @all_ratings = Movie.ratings
    @movies = Movie.all.order(@sort)
    
    #To keep the function of the sort, create an if, elseif, else loop for ratings
    if params[:ratings]
      #use keys for each rating instead of identifying them through a hash
      @ratings = params[:ratings].keys
      session[:filtered_rating] = @ratings
    #contional for the session using specified hashes
    elsif session[:filtered_rating]
      query = Hash.new #new has for each selection of keys
      session[:filtered_rating].each do |rating|
        query['ratings['+ rating +']']=1
      end #sort for the selected ratings 
      query['sort'] = params[:sort] if params[:sort]
      session[:filtered_rating] = nil #DONT FORGET NIL
      flash.keep
      redirect_to movies_path(query)
    #final condition for all ratings
    else
      @ratings = @all_ratings
    end
    #apply the loop to the selected rating!!  
    @movies.where!(rating: @ratings)
    
  end
  #Attempt 1: 
  #def title_header
  #  Movie.order('title')
  #end
  #def release_date_header
  #  Movie.order("release_date")
  #end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
