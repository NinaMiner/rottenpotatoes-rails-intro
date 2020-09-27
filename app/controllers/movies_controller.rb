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
    #identify the components and pointers
    sort= params[:sort]  || session[:sort]
    #restructure highlight and sort to maintain integrity for the session instead of the page index
    case sort
    when 'title'
      ordering, @title_header = {:title => :asc}, 'hilite'
    when 'release_date'
      ordering, @date_header = {:release_date => :asc}, 'hilite'
    end
    @all_ratings = Movie.all_ratings
    #create a tag to define the selections to keep 
    @selected_ratings = params[:ratings] || session[:ratings] || {}
    
    #To keep the function of the sort, create an if, elseif, else loop for ratings
   if @slected_ratings == {}
     @selected_ratings = Hash[@all_ratings.map {|rating| [rating, rating]}]
   end
    #Turned in attempt 1
    #  @ratings = params[:ratings].keys #IDs each rating for the seleced
   #   session[:filtered_rating] = @ratings #specifies the filtered rating based on the selection
    #  session[params[:sort]]
    #contional for the session using specified hashes including the first selection
   # elsif session[:filtered_rating]
    #  query = Hash.new #once a rating has been selected generate a new query for that rating
    
    if params[:sort] != session[:sort] or params[:ratings] != session[:ratings]
      session[:sort] = sort
      session[:ratings] = @selected_ratings
      redirect_to :sort => sort, :ratings => @selected_ratings and return
    end
    #  session[:filtered_rating].each do |rating| #for each rating slected save the selections to the current sesssion
    #    query['ratings['+ rating +']']=1 #for multiple selections
    #  end
    #  query['sort'] = params[:sort] if params[:sort] #sorts the params idetified-- both ratings, title, and release data
    #  session[:filtered_rating] = nil #dont forget nil!
    #  session[params[:sort]]
    #  flash.keep #this keeps the selections for the session
    #  redirect_to movies_path(query) #sends the selections to the movies_path
    #final condition for all ratings being default
   # else
    #  @ratings = @all_ratings
   # end
    #@movies.where!(rating: @ratings)
    @movies = Movie.where(rating: @selected_ratings.keys).order(ordering)
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
