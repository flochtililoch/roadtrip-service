class Trip < ActiveRecord::Base

  attr_accessible :data, :uuid
  before_create :digest_data
  serialize :data
  validates_presence_of :data
  validates_uniqueness_of :uuid

  def uuid_hexdigest
    UUIDTools::UUID.parse_raw(self.uuid).to_s
  end

  private

  def digest_data
    self.uuid = UUIDTools::UUID.md5_create(UUIDTools::UUID_DNS_NAMESPACE, self.data).raw
  end

end
