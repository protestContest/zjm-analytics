class Site < ApplicationRecord
  belongs_to :account
  has_many :hits, dependent: :destroy

  validates :name, presence: true

  validates_uniqueness_of :name, scope: :account_id

  def tracking_id
    account_id = self.account.id.to_s.rjust(6, "0")
    "ZA-#{account_id}-#{self.id}"
  end

  def hits_by_day
    query = <<-SQL
      SELECT d.day, count(distinct hits.client_id) as num_hits
      FROM (SELECT date_trunc('day', (current_date - offs)) AS day
            FROM generate_series(0, 29) AS offs
           ) d LEFT OUTER JOIN
           hits
           ON d.Day = date_trunc('day', hits.created_at) AND hits.site_id = #{self.id}
      GROUP BY d.day order by d.day;
    SQL

    return self.hits.find_by_sql(query)
  end

  def hits_by_week
    query = <<-SQL
      SELECT d.week, count(distinct hits.client_id) as num_hits
      FROM (SELECT date_trunc('week', (current_date - (7*offs))) AS week
            FROM generate_series(0, 11) AS offs
           ) d LEFT OUTER JOIN
           hits
           ON d.week = date_trunc('week', hits.created_at) AND hits.site_id = #{self.id}
      GROUP BY d.week order by d.week;
    SQL

    return self.hits.find_by_sql(query)
  end

  def hits_by_month
    query = <<-SQL
      SELECT d.month, count(distinct hits.client_id) as num_hits
      FROM (SELECT date_trunc('month', (current_date - (30*offs))) AS month
            FROM generate_series(0, 11) AS offs
           ) d LEFT OUTER JOIN
           hits
           ON d.month = date_trunc('month', hits.created_at) AND hits.site_id = #{self.id}
      GROUP BY d.month order by d.month;
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
        account_id: matches[1].to_i,
        site_id: matches[2].to_i
      }
    else
      return nil
    end
  end
end
