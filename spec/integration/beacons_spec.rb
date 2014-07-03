require 'spec_helper'

describe BeaconsController do

  before(:each) do
    @expected_beacon_json_schema = {
      'type' => 'object',
      'additionalProperties' => false,
      'properties' => {
        'uuid' => {'type' => 'string', 'pattern' => '^[0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12}$'},
        'data' => {}
      }
    }
    @expected_beacons_json_schema = {
      'type' => 'array',
      'items' => @expected_beacon_json_schema
    }
  end

  describe 'create new beacon' do

    context 'without data' do

      it 'fails and return a bad request status' do
        post('/beacons')
        response.status.should == 400
      end

    end

    context 'with badly formatted data' do

      before(:each) do
        @data = '{"foo":"bar'
      end

      it 'fails and return a bad request status' do
        post('/beacons', {
          data: @data
        })
        response.status.should == 400
      end
    end

    context 'with data' do

      before(:each) do
        @data = FactoryGirl.attributes_for(:beacon)[:data].to_json
      end

      context 'with existing data' do

        before(:each) do
          FactoryGirl.create(:beacon)
        end

        it 'fails and return a resource conflict status' do
          post('/beacons', {
            data: @data
          })
          response.status.should == 409
        end

      end

      context 'with new data' do

        it 'is succesful and return a hashed version of the data' do
          post('/beacons', {
            data: @data
          })
          response.status.should == 201
          json_parsed_body_response = JSON.parse(response.body)
          JSON::Schema.validate(json_parsed_body_response, @expected_beacon_json_schema)
        end

      end

    end

  end

  describe 'retrieve beacons' do

    before(:each) do
      FactoryGirl.create(:beacon, :data => {foo: 'bar'})
      FactoryGirl.create(:beacon, :data => {foo: 'baz'})
      FactoryGirl.create(:beacon, :data => {bar: 'baz'})
    end

    it 'returns a collection of beacons' do
      get('/beacons')
      response.status.should == 200
      json_parsed_body_response = JSON.parse(response.body)
      JSON::Schema.validate(json_parsed_body_response, @expected_beacons_json_schema)
    end

  end

end
