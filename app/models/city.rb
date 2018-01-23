class City < ApplicationRecord


	# class method
	scope :cities, ->{where(level: 2)}



	def province
		City.where(level:1, id: self.parent_id).first
	end

	def city
		City.where(level:2, id: self.parent_id).first
	end

	def cities
		City.where(level:2, parent_id: self.id)
	end

	def counties
		City.where(level:3, parent_id: self.id)
	end

	def county
		City.where(level:3, id: self.parent_id).first
	end

	def towns
		City.where(level:4, parent_id: self.id)
	end



end
