class ProfilesController < ApplicationController
  before_action :get_user
  before_action :authorize_user!, except: :show

  def show
  end

  def edit
  end

  def update
    result = @profile.update(profile_params)
    if result
      flash[:notice] = "Profile updated successfully"
    else
      flash[:alert] = "Profile failed to update"
    end
    redirect_to root_path
  end

  private

  def profile_params
    params.require(:profile).permit(:about, :email, :photo)
  end

  def get_user
    @profile = Profile.includes(:user).find(params[:id])
  end

  def authorize_user!
    redirect_to root_path if @profile.user != current_user
  end
end
