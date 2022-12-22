class Admin::OrdersController < AdminController
  before_action :set_order, only: [:pay, :cancel]

  def index
    @orders = Order.includes(:user, :offer).all
    @orders = @orders.where(serial_number: params[:serial_number]) if params[:serial_number].present?
    @orders = @orders.where(user: { email: params[:user_email] }) if params[:user_email].present?
    @orders = @orders.where(state: params[:state]) if params[:state].present?
    @orders = @orders.where(genre: params[:genre]) if params[:genre].present?
    @orders = @orders.where(offer: {name: params[:name] }) if params[:name].present?
  end

  def pay
    if @order.may_pay?
      @order.pay!
      flash[:notice] = "Successfully Paid"
      redirect_to admin_orders_path
    else
      flash[:alert] = "Unsuccessful Paid Transaction!"
      redirect_to admin_orders_path
    end
  end

  def cancel
    if @order.may_cancel?
      @order.cancel!
      flash[:notice] = "Successfully Cancelled"
      redirect_to admin_orders_path
    else
      flash[:alert] = "Unsuccessful Cancelled Transaction!"
    end
    end

    private

    def set_order
      @order = Order.find(params[:order_id])
    end
end
