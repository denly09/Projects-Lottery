class HomeController < ApplicationController

  def index
    @user = User.client
  end

end
