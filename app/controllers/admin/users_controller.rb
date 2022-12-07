class Admin::UsersController < AdminController
  before_action :authenticate_user!, except: :index
  def index
    @users = User.client
  end
end
