class ReviewsController < ApplicationController
  def show
    review = Review.find(params[:id])
    render Views::Reviews::Show.new(review:)
  end

  def create
    @review = Review.new(review_params)
    @review.place_id = params[:place_id]
    @review.user_id = current_user.id
    Time.zone = "Japan"
    @review.time = Time.now
    @review.save
    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def review_params
    params.require(:review).permit(:text, :rating)
  end
end
