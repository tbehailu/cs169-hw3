class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.uniq.pluck(:rating)
    sort_var = params[:sort_by] 
    @ratings_checked = {}  
    @all_ratings.each do |rating|
      @ratings_checked[rating] = true
    end
    ratings = params[:ratings]

    # if (!sort_var.nil?)
    #   @movies = Movie.order(sort_var)
    # else
    #   @movies = Movie.all
    # end
    if !ratings.nil?
      ratings = ratings.keys()
      @all_ratings.each do |r|
        if (!ratings.include? r)
          @ratings_checked[r] = false
        end
      end
    else
      ratings = @all_ratings
    end
    print "*** ratings checked = ", @ratings_checked
    if(!sort_var.nil?)
      @movies = Movie.find(:all, :conditions => ["rating IN (?)", ratings], :order => sort_var)
    else
      @movies = Movie.find(:all, :conditions => ["rating IN (?)", ratings])
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