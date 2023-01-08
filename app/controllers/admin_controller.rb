class AdminController < ApplicationController
  before_action :authenticate_admin!

  def index
    render Views::Admin::Index.new
  end
end
