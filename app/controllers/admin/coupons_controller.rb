class Admin::CouponsController < Admin::BaseController



	def index

	end

	def new
 		@coupon = Coupon.new
	end

	def create
		binding.pry
		# all single category
		if coupon_params[:type] == "single" 
		end

		#时间类型 
		if coupon_params[:time_limit] == "absolute"
		end

		@coupon = Coupon.new(coupon_params)



	end

	def edit

	end

	def update

	end

	def destroy

	end


	private

		def  coupon_params
			params.require(:coupon).permit(:amount, :type, :source_id, :limit, :limit_val, :property, :start_date, :end_date,:days)
		end


end