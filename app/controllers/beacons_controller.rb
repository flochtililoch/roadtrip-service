class BeaconsController < ApplicationController

  def create
    beacon = Beacon.create!(data: JSON.parse(params[:data]))
    render json: build_beacon_response(beacon), status: 201
  end

  def index
    beacons = Beacon.all()
    render json: build_beacons_response(beacons), status: 200
  end

  private

  def build_beacon_response(beacon)
    {
      uuid: beacon.uuid_hexdigest,
      data: beacon.data
    }
  end

  def build_beacons_response(beacons)
    beacons.map { |beacon|
      build_beacon_response(beacon)
    }
  end

end
