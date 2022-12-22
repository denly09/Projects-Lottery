class Users::ShopController < ApplicationController
  before_action :authenticate_user!, only:  :create

  def index
    @offers = Offer.active
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    @offer = Offer.active.find(params[:order][:offer_id])
    @order.user = current_user
    @order.amount = @offer.amount
    @order.coin = @offer.coin
    @order.genre = :deposit
    @order.state = :submitted
    if @order.save
      flash[:notice] = "Successfully Order"
    else
      flash[:alert] = "Unsuccessful Order"
    end
  end

  private

  def order_params
    params.require(:shop).permit(:offer_id)
  end


end
