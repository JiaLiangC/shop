class Admin::CouponsController < Admin::BaseController


	def index
		@coupons = Coupon.all();
	end

	def new
 		@coupon = Coupon.new
	end

	def create
		batch_num = Coupon.generate_batch_num

		@coupon = Coupon.new(coupon_params)
		@coupon.status = Coupon::CouponTypes::StatusInitial
		  
		# all single category
		case coupon_params[:range_type]
		when Coupon::CouponTypes::RangeTypeSingle 
			product = Product.find(coupon_params[:source_id])
			@coupon.source = product 
		when Coupon::CouponTypes::RangeTypeAll
			category = Category.find(coupon_params[:source_id])
			@coupon.source = category 
		end

		attributes = @coupon.attributes.except!("id", "created_at", "updated_at")
		CouponWorker.perform_async(batch_num, attributes, coupon_params[:amount])
		redirect_to admin_coupons_path
	end

	def edit

	end

	def update

	end

	def destroy

	end


	private

		def  coupon_params
			params.require(:coupon).permit(:amount, :name, :range_type, :source_id, :limit, :limit_val, :property, :start_date, :end_date,:days)
		end


end