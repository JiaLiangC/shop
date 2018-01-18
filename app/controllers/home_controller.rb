class HomeController < ApplicationController

    def index
        fetch_home_data
        @products = Product.onshelf.paginate(page: params[:page],per_page: 20)
        .order("id desc").includes(:cover_image)
    end
end
