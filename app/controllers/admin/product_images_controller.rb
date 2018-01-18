class Admin::ProductImagesController < Admin::BaseController
    
    def index
        @product = Product.find(params[:product_id])
    end

    def new
    end

    def create
    end

    def edit
    end

    def update
    end

    def destroy
        @image = Image.find(params[:id])
        @image.destroy
        redirect_to :back
    end

    private
        def permitted_params
        end
end