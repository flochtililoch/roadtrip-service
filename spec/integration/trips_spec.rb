require 'spec_helper'

describe TripsController do

  before(:each) do
    @expected_trip_json_schema = {
      'type' => 'object',
      'additionalProperties' => false,
      'properties' => {
        'uuid' => {'type' => 'string', 'pattern' => '^[0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12}$'},
        'data' => {}
      }
    }
    @expected_trips_json_schema = {
      'type' => 'array',
      'items' => @expected_trip_json_schema
    }
  end

  describe 'create new trip' do

    context 'without data' do

      it 'fails and return a bad request status' do
        post('/trips')
        response.status.should == 400
      end

    end

    context 'with badly formatted data' do

      before(:each) do
        @data = '{"foo":"bar'
      end

      it 'fails and return a bad request status' do
        post('/trips', {
          data: @data
        })
        response.status.should == 400
      end
    end

    context 'with data' do

      before(:each) do
        @data = FactoryGirl.attributes_for(:trip)[:data].to_json
      end

      context 'with existing data' do

        before(:each) do
          FactoryGirl.create(:trip)
        end

        it 'fails and return a resource conflict status' do
          post('/trips', {
            data: @data
          })
          response.status.should == 409
        end

      end

      context 'with new data' do

        it 'is succesful and return a hashed version of the data' do
          post('/trips', {
            data: @data
          })
          response.status.should == 201
          json_parsed_body_response = JSON.parse(response.body)
          JSON::Schema.validate(json_parsed_body_response, @expected_trip_json_schema)
        end

      end

    end

  end

  describe 'retrieve trips' do

    before(:each) do
      FactoryGirl.create(:trip, :data => {foo: 'bar'})
      FactoryGirl.create(:trip, :data => {foo: 'baz'})
      FactoryGirl.create(:trip, :data => {bar: 'baz'})
    end

    it 'returns a collection of trips' do
      get('/trips')
      response.status.should == 200
      json_parsed_body_response = JSON.parse(response.body)
      JSON::Schema.validate(json_parsed_body_response, @expected_trips_json_schema)
    end

  end

end
