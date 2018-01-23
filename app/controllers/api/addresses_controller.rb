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
		user_address = UserAddress.find(params[:id])
		user_address.delete
	end

	def set_default
		@address = UserAddress.find(params[:id])
    	default_addr = current_user.user_addresses.where(defaults: true).first
     	default_addr.update_attributes(defaults: false)  if default_addr
    	@address.update_attributes(defaults: true)
	end

	private
    def address_params
        params.require(:user_address).permit(:address, :mobile, :zipcode, :contact_name,:user_id)
    end

end