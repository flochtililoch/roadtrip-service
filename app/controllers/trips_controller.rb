class TripsController < ApplicationController

  def create
    trip = Trip.create!(data: JSON.parse(params[:data]))
    render json: build_trip_response(trip), status: 201
  end

  def index
    trips = Trip.all()
    render json: build_trips_response(trips), status: 200
  end

  private

  def build_trip_response(trip)
    {
      uuid: trip.uuid_hexdigest,
      data: trip.data
    }
  end

  def build_trips_response(trips)
    trips.map { |trip|
      build_trip_response(trip)
    }
  end

end
