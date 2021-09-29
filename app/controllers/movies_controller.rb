class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      # session persists only as long as page is open?
      # session.clear
      session[:sortCol] = params[:sortCol] || session[:sortCol] || nil                  # params else session else nothing,
      if !['title', 'release_date', nil].include?(session[:sortCol])                    # make sure input matches allowed values. 
        session[:sortCol] = nil
      end
      
      @movies = session[:sortCol].blank? ? Movie.all : Movie.all.order("LOWER(#{session[:sortCol]})") # if no sortCol then all movies else order movies.
      @all_ratings = Movie.get_ratings
      session[:ratings] = params[:ratings] || session[:ratings] || @all_ratings           # params else session else all
      @movies = @movies.with_ratings(session[:ratings])                                   # get movie ratings. (all or some never none)
      
      if session[:ratings] != params[:ratings] || session[:sortCol] != params[:sortCol]   # fill in params from session if not exist
        flash.keep
        redirect_to movies_path(sortCol: session[:sortCol], ratings: session[:ratings])
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
  
    private
    # Making "internal" methods private is not required, but is a common practice.
    # This helps make clear which methods respond to requests, and which ones do not.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
  end