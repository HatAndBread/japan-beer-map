class Admin::PlaceUpdatesController < ApplicationController
  before_action :authenticate_admin!
  before_action :place_update, only: [:show, :destroy, :update]

  def show
    render Views::Admin::PlaceUpdates::Show.new(update: @place_update)
  end

  def update
  end

  def merge
    update = PlaceUpdate.find(params[:place_update_id])
    update.merge_with_place
    flash[:notice] = "Merged the update with the place."
    redirect_to admin_path
  end

  def destroy
    @place_update.destroy!
    flash[:notice] = "Place update dismissed."
    redirect_to admin_path
  end

  private

  def place_update
    @place_update = PlaceUpdate.find(params[:id])
  end
end
