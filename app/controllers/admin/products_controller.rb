class Admin::ProductsController < Admin::BaseController
        
    def index
        @products = Product.all
    end

    def new
        @product = Product.new
    end

    def create
        @product = Product.new(product_params)
        if @product.save
            flash[:success] = " 创建成功"
            redirect_to admin_products_path
        else
            flash.now[:danger] = @product.errors.first
            render :new
        end
    end

    def edit
        @product = Product.find(params[:id])
    end

    def update
        @product = Product.find(params[:id])

        if @product.update_attributes(product_params)
            flash[:success] = "更新成功"
            redirect_to admin_products_path
        else
            flash[:info] = "更新失败"
            redirect_to :back
        end
    end

    def destroy
        @product = Product.find(params[:id])
        @product.destroy
        flash[:info] = "删除成功"
        redirect_to admin_products_path
    end

    private
        def product_params
            params.require(:product).permit(:category_id, :title, :price, :amount, :msrp, :description, :status)
        end

end