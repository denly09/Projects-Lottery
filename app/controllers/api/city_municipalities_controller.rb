class Api::CityMunicipalitiesController < ApplicationController
  def index
    province = Address::Province.find_by_id(params[:province_id])
    if province
      city_municipalities = province.city_municipalities
      render json: city_municipalities, each_serializer: CityMunicipalitySerializer
    end
  end
end
