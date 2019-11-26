class Admin::DistributionCentersController < ApplicationController
  before_action :logged_in_as_admin?

  def index
    @distribution_centers = DistributionCenter.all

    respond_to do |format|
      format.html
      format.json { render json: @distribution_centers }
    end
  end

  def show
    @distribution_center = DistributionCenter.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @distribution_center }
    end
  end

  def new
    @distribution_center = DistributionCenter.new

    respond_to do |format|
      format.html
      format.json { render json: @distribution_center }
    end
  end

  def edit
    @distribution_center = DistributionCenter.find(params[:id])
  end

  def create
    @distribution_center = DistributionCenter.create(distribution_center_params)

    respond_to do |format|
      if @distribution_center.save
        format.html do
          redirect_to edit_admin_distribution_center_path(@distribution_center),
                      notice: 'Distribution center was successfully created.'
        end
        format.json { render json: @distribution_center, status: :created, location: @distribution_center }
      else
        format.html { render action: 'new' }
        format.json { render json: @distribution_center.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @distribution_center = DistributionCenter.find(params[:id])

    respond_to do |format|
      if @distribution_center.update!(distribution_center_params)
        format.html do
          redirect_to edit_admin_distribution_center_path(@distribution_center),
                      notice: 'Distribution center was successfully updated.'
        end
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @distribution_center.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @distribution_center = DistributionCenter.find(params[:id])
    @distribution_center.destroy

    respond_to do |format|
      format.html { redirect_to admin_distribution_centers_url }
      format.json { head :no_content }
    end
  end

  private

  def distribution_center_params
    params.require(:distribution_center).permit(:name, :phone, :email, :contact_point, :line_items_attributes)
  end
end
