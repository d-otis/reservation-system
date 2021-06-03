class Api::V1::ItemsController < ApplicationController
  before_action :authenticate_user

  def index
    @items = Item.all

    render json: ItemSerializer.new(@items).serializable_hash.to_json, status: :ok
  end
end