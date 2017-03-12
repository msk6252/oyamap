class Map < ActiveRecord::Base
	mount_uploader :image, ImageUploader
	reverse_geocoded_by :latitude, :longitude
	after_validation :reverse_geocode
end
