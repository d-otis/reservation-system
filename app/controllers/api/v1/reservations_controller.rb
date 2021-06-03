class Api::V1::ReservationsController < ApplicationController
  before_action :set_reservation, :except => :index
  before_action :authenticate_user

  def show
    render :json => ReservationSerializer.new(@reservation).serializable_hash.to_json
  end

  def index
    @reservations = Reservation.where(:user => @user)
    render :json => ReservationSerializer.new(@reservations).serializable_hash.to_json, status: :ok
  end

  def create
  end

  def update
  end

  def destroy
  end

  private

  def set_reservation
    @reservation = Reservation.find(params[:id])
  end
end
