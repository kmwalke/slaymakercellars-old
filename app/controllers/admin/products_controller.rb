class Admin::ProductsController < ApplicationController
  before_action :logged_in_as_admin?

  def xero_item_codes
    if xero
      xero.Item.all.map(&:code)
    else
      ['ITEM']
    end
  end

  def index
    @products = Product.order('category DESC, name')

    respond_to do |format|
      format.html
      format.json { render json: @products }
    end
  end

  def new
    @product         = Product.new
    @xero_item_codes = xero_item_codes

    respond_to do |format|
      format.html
      format.json { render json: @product }
    end
  end

  def edit
    @product         = Product.find(params[:id])
    @xero_item_codes = xero_item_codes
  end

  def create
    @product = Product.create(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to admin_products_path, notice: 'Product was successfully created.' }
        format.json { render json: @product, status: :created, location: @product }
      else
        format.html { render action: 'new' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @product = Product.find(params[:id])

    respond_to do |format|
      if @product.update!(product_params)
        format.html { redirect_to admin_products_path, notice: 'Product was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: 'edit' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    respond_to do |format|
      format.html { redirect_to admin_products_path }
      format.json { head :ok }
    end
  end

  private

  def product_params
    params.require(:product).permit(
      :name,
      :desc,
      :photo_content_type,
      :photo_file_size,
      :position,
      :category,
      :is_public,
      :in_production,
      :xero_item_code,
      :photo
    )
  end
end
