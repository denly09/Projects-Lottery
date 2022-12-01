class Admin::HomeController < AdminController
  def index
    @users = User.all
  end
end
