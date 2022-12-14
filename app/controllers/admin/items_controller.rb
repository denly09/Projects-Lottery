class Admin::ItemsController < AdminController
  # before_action :authenticate_user!, except: :index
  before_action :set_item, only: [:edit, :update, :destroy]
  before_action :set_event, only: [:start, :pause, :end, :cancel]

  def index
    @items = Item.includes(:categories).all
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      flash[:notice] = 'Successfully saved'
      redirect_to admin_items_path
    else
      render :new
    end
  end

  def edit ;end

  def update
    if @item.update(item_params)
      redirect_to admin_items_path
    else
      render :edit
    end
  end

  def destroy
     @item.destroy
     if @item.deleted_at
       flash[:notice] = "Successfully Deleted"
     else
       flash[:alert] = "The item cannot be delete"
      redirect_to admin_items_path
    end
  end

  def start
    # render json: params
    if @item.may_start?
      @item.start!
      flash[:notice] = "Do you want to start?"
      redirect_to admin_items_path
    else
    flash[:notice] = "You cannot start"
    redirect_to admin_items_path
    end
  end

  def pause
    if @item.may_pause?
      @item.pause!
      flash[:notice] = "Would you like pause?"
    else
      flash[:notice] = "You cannot pause"
      redirect_to admin_items_path
    end
  end

  def end
    if @item.may_end?
      @item.end!
      flash[:notice] = "Would you like to end?"
    else
      flash[:notice] = "You cannot end"
      redirect_to admin_items_path
    end
  end

  def cancel
    if @item.may_cancel?
      @item.cancel!
      flash[:notice] = "Would you like to cancel?"
    else
      flash[:notice] = "You cannot cancel"
      redirect_to admin_items_path
    end
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def set_event
    @item = Item.find(params[:item_id])
  end

  def item_params
    params.require(:item).permit( :image, :name, :quantity, :minimum_bets, :state,
                                  :batch_count, :online_at, :offline_at, :start_at, :status, category_ids: [])
  end
end
