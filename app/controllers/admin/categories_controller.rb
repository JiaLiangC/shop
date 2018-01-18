class Admin::CategoriesController < Admin::BaseController

    def index
      if params[:id].present?
        @category = Category.find(params[:id])
        @categories = @category.children.paginate(page: params[:page], per_page: 20)
      else
        @categories = Category.roots.paginate(page: params[:page], per_page: 20)
      end
    end

    def new
        @category = Category.new
    end

    def create
        @category  = Category.new(category_params)
        if @category.save
            flash[:success] = "创建成功"
            redirect_to admin_categories_path
        else
            render :new
        end
    end

    def edit
        @category = Category.find(params[:id])
    end

    def update
        @category = Category.find(params[:id])
        if @category && @category.update_attributes(category_params)
            flash[:success] = "更新成功"
            redirect_to admin_categories_path
        else
            flash[:info] = "更新失败"
            redirect_to :back
        end
    end

    def destroy
    end

    private

        def category_params
            params.require(:category).permit(:title,:weight,:ancestry)
        end

end