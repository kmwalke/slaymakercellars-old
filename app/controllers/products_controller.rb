class ProductsController < ApplicationController
  # GET /products
  # GET /products.json
  def index
    category  = params[:category] || 'Year Round'
    @products = Product.where(category: category, is_public: true).order(:name)
    @title    = "#{category} Cheeses"
    @active   = params[:category] || Product::TYPES[0]

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @products }
    end
  end
end
