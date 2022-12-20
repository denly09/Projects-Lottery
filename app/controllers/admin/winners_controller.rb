class Admin::WinnersController < AdminController
  before_action :winner_params, only: [:submit, :pay, :ship, :deliver, :publish, :remove_publish]

  def index
    @winners = Winner.includes(:user, :item, :bet).all
    @winner = @winners.where(bet: params[:serial_number]) if params[:serial_number].present?
    @bets = @bets.where(user: { email: params[:user_email] }) if params[:user_email].present?
    @bets = @bets.where(state: params[:state]) if params[:state].present?
  end

  def submit
    @winner.submit!
    flash[:notice] = "Submitted"
    redirect_to admin_winners_path
  end

  def pay
    @winner.pay!
    flash[:notice] = "Successfully paid"
    redirect_to admin_winners_path
  end

  def ship
    @winner.ship!
    flash[:notice] = "Is ready to ship"
    redirect_to admin_winners_path
  end

  def deliver
    @winner.deliver!
    flash[:notice] = "The prize is ready to deliver"
    redirect_to admin_winners_path
  end

  def publish
    @winner.publish!
    flash[:notice] = "Published"
    redirect_to admin_winners_path
  end

  def remove_publish
    @winner.remove_publish!
    flash[:notice] = "Remove the publish"
    redirect_to admin_winners_path
  end

  private

  def winner_params
    @winner = Winner.find(params[:winner_id])

  end
end
