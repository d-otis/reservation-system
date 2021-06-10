class Api::V1::ReservationsController < ApplicationController
  before_action :set_reservation, :except => [:index, :create]
  before_action :authenticate_user
  before_action :check_ownership, :only => [:update, :destroy]

  def show
    render :json => ReservationSerializer.new(@reservation).serializable_hash.to_json
  end

  def index
    @reservations = Reservation.where(:user => @user)
    render :json => ReservationSerializer.new(@reservations).serializable_hash.to_json, status: :ok
  end

  def create
    reservation = Reservation.new(reservation_params.merge(:user => @user))

    if reservation.save
      render json: ReservationSerializer.new(reservation).serializable_hash.to_json, status: :created
    else
      render json: { errors: reservation.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @reservation.update(reservation_params)
      render json: ReservationSerializer.new(@reservation).serializable_hash.to_json, status: :ok
    else
      render json: { errors: @reservation.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
  end

  private

  def set_reservation
    @reservation = Reservation.find(params[:id])
  end

  def reservation_params
    params.require(:reservation).permit(:start_time, :end_time, :note, :user_id, :item_ids => [])
  end

  def check_ownership
    render json: { errors: ["Insufficient privileges."] }, status: :forbidden unless @user.is_admin? || @reservation.user == @user
  end
end
