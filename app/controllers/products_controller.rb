class ProductsController < ApplicationController
  def index
    category  = params[:category] || 'Year Round'
    @products = Product.where(category: category, is_public: true).order(:name)
    @title    = "#{category} Cheeses"
    @active   = params[:category] || Product::TYPES[0]

    respond_to do |format|
      format.html
      format.json { render json: @products }
    end
  end
end
