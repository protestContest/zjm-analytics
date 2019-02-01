class Site < ApplicationRecord
  belongs_to :user
  has_many :hits

  validates :name, presence: true

  validates_uniqueness_of :name, scope: :user_id

  def tracking_id
    user_id = self.user.id.to_s.rjust(6, "0")
    "ZA-#{user_id}-#{self.id}"
  end

  def self.tracking_id_regex
    return /\AZA-([[:digit:]]{6})-([[:digit:]]+)\z/
  end

  def self.parse_tracking_id tracking_id
    matches = tracking_id.match(self.tracking_id_regex)
    if matches
      return {
        user_id: matches[1].to_i,
        site_id: matches[2].to_i
      }
    else
      return nil
    end
  end
end
