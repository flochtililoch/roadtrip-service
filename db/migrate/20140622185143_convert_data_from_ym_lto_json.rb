class ConvertDataFromYmLtoJson < ActiveRecord::Migration
  def up
    Beacon.all.each do |beacon|
      beacon.data2 = JSON.parse(beacon.data)
      beacon.save!
    end
  end

  def down
  end
end
