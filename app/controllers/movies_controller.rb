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
    
    if (params[:ratings].nil? && params[:sort].nil? && (!session[:ratings].nil? || !session[:sort].nil?))
      flash.keep
      redirect_to movies_path :sort => session[:sort], :ratings => session[:ratings]
    end
    
    if params[:ratings].present? && params[:ratings].is_a?(Hash)
      session[:ratings] = params[:ratings]
    end
    
    if params[:sort].present?
      session[:sort] = params[:sort]
    end
  
    @all_ratings = Movie.ratings
    
    @sort_column = session[:sort]
    
    @selected_ratings = session[:ratings]
    
    unless @selected_ratings
      @selected_ratings = @all_ratings
    end
    
    if (!session[:sort].nil? && !session[:ratings].nil?)
      @movies = Movie.where(:rating => @selected_ratings.keys).order(@sort_column)
    elsif (session[:ratings].nil?)
      @movies = Movie.order(@sort_column)
    elsif (session[:sort].nil?)
      @movies =  Movie.where(:rating => @selected_ratings.keys)
    else
      @movies = Movie.all
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
