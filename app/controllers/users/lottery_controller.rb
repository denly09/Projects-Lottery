class Users::LotteryController < ApplicationController

  def index
    @items = Item.where(status: :active, state: :starting)
    @items = @items.includes(:categories).where(categories: { name: params[:category] }) if params[:category]
    @categories = Category.all
  end
  end