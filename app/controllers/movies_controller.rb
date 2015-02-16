class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end


  def get_checked_ratings()
    # mark all ratings as selected
    @ratings_checked = {}  
    @all_ratings.each do |rating|
      @ratings_checked[rating] = true
    end
    return @ratings_checked
  end

  def get_ratings()
    @ratings = params[:ratings]
    @ratings_checked = {} 
    # if we have ratings selected, get them and set the others as unselected
    if !@ratings.nil?
      @ratings = @ratings.keys()
      session[:ratings] = @ratings
      @all_ratings.each do |r|
        if (!@ratings.include? r)
          @ratings_checked[r] = false
        else
          @ratings_checked[r] = true
        end
      end
      session[:ratings_checked] = @ratings_checked
    else
      @ratings = @all_ratings
    end
    return @ratings
  end

  def index
    @all_ratings = Movie.uniq.pluck(:rating)
    # get_checked_ratings()
    get_ratings()

    session[:sort_var] = (params[:sort_by] != nil ? params[:sort_by] : session[:sort_var])
    # session[:ratings_checked] = (session[:ratings_checked] == nil ? @ratings_checked : session[:ratings_checked])
    # session[:ratings] = (@ratings.nil? != nil ? @ratings : session[:ratings])

    # sort_var = params[:sort_by] 
    

    puts "*** ratings checked = ", @ratings_checked
    puts "*** params = ", params
    puts "**** session = ", session
    puts "***** ratings = ", @ratings
    puts "******** session[:ratings] = ", session[:ratings]
    # session.clear
    # session[:ratings] = nil
    # session[:ratings_checked] = nil
    # session[:sort_var] = nil

    if(!session[:sort_var].nil?)
      # @movies = Movie.find(:all, :conditions => ["rating IN (?)", ratings], :order => sort_var)
      @movies = Movie.find(:all, :conditions => ["rating IN (?)", session[:ratings]], :order => session[:sort_var])
    else
      # @movies = Movie.find(:all, :conditions => ["rating IN (?)", ratings])
      @movies = Movie.find(:all, :conditions => ["rating IN (?)", session[:ratings]])
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