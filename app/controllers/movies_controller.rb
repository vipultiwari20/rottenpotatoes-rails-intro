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
    @sorting_variable = params[:sorting_field]
    @movies = Movie.order(@sorting_variable)
    @all_ratings = Movie.get_ratings
    redirect = false
    if params[:commit] =='Refresh' and params[:ratings].nil?
      redirect = true
      @ratings_selected = session[:ratings]
      session[:ratings] = nil
    elsif (params).key?(:ratings)
	    @ratings_selected = params[:ratings]
      session[:ratings] = params[:ratings]
    elsif session[:ratings]
	    @ratings_selected = session[:ratings]
	    redirect = true
    end
    
    if (params).key?(:sorting_field)
	    @sorting_variable = params[:sorting_field]
      session[:sorting_field] = @sorting_variable
    elsif session[:sorting_field]
	    @sorting_variable = session[:sorting_field]
	    redirect = true
    end
    
    if redirect 
      flash.keep
      redirect_to(:action=>'index', :sorting_field=>@sorting_variable, :ratings=>@ratings_selected)
    end
    
    if @sorting_variable and @ratings_selected
       @movies = Movie.where(:rating=>@ratings_selected.keys).order(@sorting_variable)
    elsif @sorting_variable
      @movies = Movie.all.order(@sorting_variable)
      @ratings_selected = Hash.new(@all_ratings)
    elsif @ratings_selected
      @movies = Movie.where(:rating=>@ratings_selected.keys)
    else 
      @movies = Movie.all
      @ratings_selected = Hash.new(@all_ratings)
    end
  end

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
