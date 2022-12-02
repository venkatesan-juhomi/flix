class LikesController < ApplicationController
  before_action :require_signin

  def create
    @movie = Movie.find(params[:movie_id])
    @movie.likes.new(user: current_user)
    @movie.save
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:movie_id])
    @like = Like.find_by(movie: @movie, user: current_user)
    @like.destroy
    redirect_to movie_path(@movie)
  end
end
