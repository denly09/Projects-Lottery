class Users::AddressesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_address, only: [:edit, :update, :destroy]

  def index
    @addresses = current_user.addresses.includes(:user, :region, :province, :city_municipality, :barangay)
  end

  def new
    @address = Address.new
  end

  def create
    @address = Address.new(add_params)
    @address.user = current_user
    if @address.save
      redirect_to users_addresses_path
    else
      render :new
    end
  end

  def edit ;end

  def update
    if @address.update(add_params)
      redirect_to users_addresses_path
    else
      render :edit
    end
  end

  def destroy
    if @address.destroy
      redirect_to users_addresses_path
    end
  end

  private

  def add_params
    params.require(:address).permit(:genre, :name, :street_address, :phone_number, :remark, :is_default, :address_region_id, :address_province_id, :address_city_municipality_id, :address_barangay_id)
  end

  def set_address
    @address = Address.find(params[:id])
  end
end
