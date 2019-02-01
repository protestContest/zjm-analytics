class Hit < ApplicationRecord
  belongs_to :site

  validates_format_of :tracking_id, :with => Site.tracking_id_regex
  validate :tracking_id_valid

  private

    def tracking_id_valid
      site_data = Site.parse_tracking_id self.tracking_id
      if self.site.id != site_data[:site_id]
        errors.add(:tracking_id)
      end

      if self.site.user.id != site_data[:user_id]
        errors.add(:tracking_id)
      end
    end
end
