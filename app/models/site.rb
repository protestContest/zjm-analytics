class Site < ApplicationRecord
  belongs_to :user
  has_many :hits

  validates :name, presence: true

  validates_uniqueness_of :name, scope: :user_id

  def tracking_id
    user_id = self.user.id.to_s.rjust(6, "0")
    "ZA-#{user_id}-#{self.id}"
  end

  def hits_by_day
    query = <<-SQL
      SELECT d.day, count(hits.id) as num_hits
      FROM (SELECT date_trunc('day', (current_date - offs)) AS day
            FROM generate_series(0, 30, 1) AS offs
           ) d LEFT OUTER JOIN
           hits
           ON d.Day = date_trunc('day', hits.created_at) AND hits.site_id = #{self.id}
      GROUP BY d.day order by d.day;
    SQL

    return self.hits.find_by_sql(query)
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
