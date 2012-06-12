class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.my_all_rate
    if params[:order_by] == nil
      @movies = if !params[:ratings].nil? then Movie.where(:rating => params[:ratings].keys) else Movie.all end
    else
      rate  = ""
      if !params[:ratings].nil? then
        params[:ratings].each do |x|
         rate += "'"+x[0]+"',"
        end
      end
      @movies = if !params[:ratings].nil? then Movie.find_by_sql(["SELECT * FROM movies WHERE movies.rating IN ","(",rate[0,rate.length-1],")"," ORDER BY ",params[:order_by]].join ) else Movie.all(:order=>params[:order_by]) end
    end
    session.merge!(params)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_params = {}
    [:ratings, :order_by].each do |session_key|
        redirect_params.merge!({ session_key => session[session_key]  }) unless session[session_key].nil?
    end
    redirect_to movies_path(redirect_params)

  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_params = {}
    [:ratings, :order_by].each do |session_key|
        redirect_params.merge!({ session_key => session[session_key]  }) unless session[session_key].nil?
    end
    redirect_to movies_path(redirect_params)

  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_params = {}
    [:ratings, :order_by].each do |session_key|
        redirect_params.merge!({ session_key => session[session_key]  }) unless session[session_key].nil?
    end
    redirect_to movies_path(redirect_params)

  end

end
