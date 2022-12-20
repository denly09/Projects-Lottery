class Users::LotteryController < ApplicationController
  before_action :authenticate_user!, except: :index
  before_action :set_item, only: :show

  def index
    @items = Item.where(status: :active, state: :starting)
    @items = @items.includes(:categories).where(categories: { name: params[:category] }) if params[:category]
    @categories = Category.all
  end

  def show
    @bet = Bet.new
    @user_bet = @item.bets.where(user: current_user, batch_count: @item.batch_count, item: @item)
  end

  def create
    @count_bet = params[:bet][:coins].to_i
    params[:bet][:coins] = 1
    @count_bet.times {
      @bet = Bet.new(bet_params)
      @bet.user = current_user
      @bet.item = Item.find(params[:item_id])
      @bet.batch_count = @bet.item.batch_count
      @bet.save!
    }
    flash[:notice] = 'Successfully Bet!'
    redirect_to users_lottery_path(@bet.item)
  end

  private

  def bet_params
    params.require(:bet).permit(:item_id, :coins)
  end

  def set_item
    @item = Item.find(params[:id])
  end
end