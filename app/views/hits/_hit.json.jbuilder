json.extract! hit, :id, :hit_type, :location, :language, :encoding, :title, :color_depth, :screen_res, :viewport, :tracking_id, :client_id, :site_id, :created_at, :updated_at
json.url hit_url(hit, format: :json)
