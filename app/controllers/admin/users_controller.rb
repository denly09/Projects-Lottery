class Admin::UsersController < AdminController

  def index
    @users = User.all
  end

  def check_admin
    raise ActionController::RoutingError.new('Not Found') unless current_admin_user
  end
end
