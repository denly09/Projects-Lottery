class Users::MesController < ApplicationController

  def index
    @orders = Order.where(user: current_user) if params[:filter_by] == 'orders'
    @lotteries = Bet.where(user: current_user) if params[:filter_by] == 'lotteries'
    @winners = Winner.where(user: current_user) if params[:filter_by] == 'winners'
    @invitations = User.where(parent: current_user) if params[:filter_by] == 'invitations'
  end
end
