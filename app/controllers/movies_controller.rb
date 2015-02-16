class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def get_ratings()
    @ratings = params[:ratings]
    @ratings_checked = {} 
    # if we have ratings selected, get them and set the others as unselected
    if !@ratings.nil?
      session[:original_ratings] = @ratings
      puts "**** original ratings = ", @ratings
      @ratings = @ratings.keys()
      session[:ratings] = @ratings
    else
      @ratings = @all_ratings
      if session[:ratings].nil?
        session[:ratings] = @ratings
      else
        @ratings = session[:ratings]
        # params[:ratings] = session[:original_ratings]
        @redirect_hash[:ratings] = session[:original_ratings]
        # @redirect = true
      end
    end

    @all_ratings.each do |r|
      if (!@ratings.include? r)
        @ratings_checked[r] = false
      else
        @ratings_checked[r] = true
      end
    end
    session[:ratings_checked] = @ratings_checked
  end

  def index
    @all_ratings = Movie.uniq.pluck(:rating)
    @redirect = false
    @redirect_hash = {}
    get_ratings()

    if (!params[:sort_by].nil?)
      session[:sort_var] = params[:sort_by]
    else
      # params[:sort_by] = session[:sort_var]
      @redirect_hash[:sort_by] = session[:sort_var]
      if (!session[:sort_var].nil?)
        @redirect = true
      end
    end

    # session.clear

    puts "**** ratings checked = ", @ratings_checked
    puts "**** params = ", params
    puts "**** session = ", session
    puts "**** ratings = ", @ratings
    puts "**** session[:ratings] = ", session[:ratings]
    # session.clear
    # session[:ratings] = nil
    # session[:ratings_checked] = nil
    # session[:sort_var] = nil

    if(!session[:sort_var].nil?)
      # @movies = Movie.find(:all, :conditions => ["rating IN (?)", ratings], :order => sort_var)
      @sort_var = session[:sort_var]
      @movies = Movie.find(:all, :conditions => ["rating IN (?)", session[:ratings]], :order => session[:sort_var])
    else
      @sort_var = nil
      # @movies = Movie.find(:all, :conditions => ["rating IN (?)", ratings])
      @movies = Movie.find(:all, :conditions => ["rating IN (?)", session[:ratings]])
    end

    if (@redirect)
      flash.keep
      redirect_to movies_path(@redirect_hash)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
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
    redirect_to movies_path
  end

end