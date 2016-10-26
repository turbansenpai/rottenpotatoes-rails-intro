class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    @all_ratings = Movie.ratings
    
    session[:ratings] = params[:ratings] unless params[:ratings].nil?
    session[:direction] = params[:direction] unless params[:direction].nil?
    session[:sort] = params[:sort] unless params[:sort].nil?
    
    @ratings = session[:ratings] || @all_ratings    
    sort = session[:sort]
    direction = session[:direction]
    
    case sort
    when 'title'
		@titleClass = "hilite"
		@movies = Movie.find_all_by_rating(@ratings.keys, order: sort + ' ' + direction)
	when 'release_date'
		@releaseClass = "hilite"
		@movies = Movie.find_all_by_rating(@ratings.keys, order: sort + ' ' + direction)
	else
		@movies = Movie.find_all_by_rating(@ratings.keys)
	end
	if params[:ratings] != session[:ratings] and params[:direction] != session[:direction] and params[:sort] != session[:sort]
		redirect_to (movies_path(:ratings => session[:ratings], :direction => session[:direction], :sort => session[:sort]))
	end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path(:sort => session[:sort], :direction => session[:direction], :ratings => session[:ratings])
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path(:sort => session[:sort], :direction => session[:direction], :ratings => session[:ratings])
  end

end