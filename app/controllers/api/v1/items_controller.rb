class Api::V1::ItemsController < ApplicationController
  before_action :authenticate_user, :except => :index
  before_action :check_admin_privileges, :except => :index

  def index
    @items = Item.all

    render json: ItemSerializer.new(@items).serializable_hash.to_json, status: :ok
  end

  def create
    item = Item.new(item_params)

    if item.save
      render json: ItemSerializer.new(item).serializable_hash.to_json, status: :created
    else
      render json: { errors: item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :serial_number, :brand_id)
  end
end