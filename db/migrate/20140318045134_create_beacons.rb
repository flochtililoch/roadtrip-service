class CreateBeacons < ActiveRecord::Migration
  def change
    create_table :beacons do |t|
      t.column :uuid, 'BINARY(16)', null: false
      t.binary :data, limit: 10.megabyte, null: false
      t.timestamps
    end
    add_index :beacons, :uuid, unique: true, length: 16
  end
end
