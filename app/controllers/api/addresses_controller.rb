class Api::AddressesController < Api::BaseController

	def index
		@user_addresses =  current_user.user_addresses
	end

	def create
		user_address = UserAddress.new(address_params)
		user_address.save
		@user_addresses = current_user.user_addresses

	end

	def destroy
		
	end


	private
    def address_params
        params.require(:user_address).permit(:address, :mobile, :zipcode, :contact_name,:user_id)
    end

end