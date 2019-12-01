class Admin::TownsController < ApplicationController
  before_action :logged_in_as_admin?
  before_action :set_town, only: [:show, :edit, :update, :destroy]

  def index
    @towns = Town.all
  end

  def show; end

  def new
    @town = Town.new
  end

  def edit; end

  def create
    @town = Town.new(town_params)

    if @town.save
      redirect_to admin_towns_path, notice: 'Town was successfully created.'
    else
      render :new
    end
  end

  def update
    if @town.update(town_params)
      redirect_to edit_admin_town_path(@town), notice: 'Town was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @town.destroy
    redirect_to admin_towns_url, notice: 'Town was successfully destroyed.'
  end

  private

  def town_params
    params.require(:town).permit(:state_id, :name)
  end
end
