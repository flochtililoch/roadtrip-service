class TripsController < ApplicationController

  def create
    trip = Trip.create!(data: params[:data])
    render json: build_trip_response(trip), status: 201
  end

  private

  def build_trip_response(trip)
    {
      uuid: trip.uuid_hexdigest
    }
  end

end
