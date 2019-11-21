class Admin::TownsController < ApplicationController
  before_action :logged_in_as_admin?
  before_action :set_town, only: [:show, :edit, :update, :destroy]

  # GET /towns
  def index
    @towns = Town.all
  end

  # GET /towns/1
  def show; end

  # GET /towns/new
  def new
    @town = Town.new
  end

  # GET /towns/1/edit
  def edit; end

  # POST /towns
  def create
    @town = Town.new(town_params)

    if @town.save
      redirect_to admin_towns_path, notice: 'Town was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /towns/1
  def update
    if @town.update(town_params)
      redirect_to edit_admin_town_path(@town), notice: 'Town was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /towns/1
  def destroy
    @town.destroy
    redirect_to admin_towns_url, notice: 'Town was successfully destroyed.'
  end

  private

  def town_params
    params.require(:town).permit(:state_id, :name)
  end
end
