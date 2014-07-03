require 'spec_helper'
require 'digest/sha1'

describe Trip do

  context 'creation' do

    context 'without data' do

      it 'raise an exception' do
        lambda { Trip.create! }.should raise_exception ActiveRecord::RecordInvalid
      end

    end

    context 'with data' do

      before(:each) do
        @data = 'foo'
        @trip = Trip.create!(data: @data)
      end

      context 'with new data' do

        it 'creates a uuid from the data' do
          @trip.uuid.should == UUIDTools::UUID.md5_create(UUIDTools::UUID_DNS_NAMESPACE, @data.to_json).raw
        end

      end

      context 'with existing data' do

        it 'raise an exception' do
          lambda { Trip.create!(data: @data) }.should raise_exception ActiveRecord::RecordNotUnique
        end

      end

    end

  end

end
