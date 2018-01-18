class ProductsController < ApplicationController
    
    #展示所有产品 
    def show
        @product = Product.find(params[:id])
    end
end
