class Api::V1::BrandsController < ApplicationController
  before_action :authenticate_user, :except => :index
  before_action :check_admin_privileges, :except => :index
  before_action :set_brand, :except => [:index, :create]

  def index
    brands = Brand.all

    render json: BrandSerializer.new(brands).serializable_hash.to_json, status: :ok
  end

  def create
    brand = Brand.new(brand_params)

    if brand.save
      render json: BrandSerializer.new(brand).serializable_hash.to_json, status: :created
    else
      render json: { errors: brand.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @brand.update(brand_params)
      render json: BrandSerializer.new(@brand).serializable_hash.to_json, status: :ok
    else
      render json: { errors: @brand.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @brand.destroy
    render json: BrandSerializer.new(@brand).serializable_hash.to_json, status: :accepted
  end

  private

  def brand_params
    params.require(:brand).permit(:name)
  end

  def set_brand
    @brand = Brand.find(params[:id])
  end

end