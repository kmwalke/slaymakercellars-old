class Admin::StatesController < ApplicationController
  before_action :set_state, only: [:show, :edit, :update, :destroy]

  def index
    @states = State.all
  end

  def show; end

  def new
    @state = State.new
  end

  def edit; end

  def create
    @state = State.new(state_params)

    if @state.save
      redirect_to admin_states_path, notice: 'State was successfully created.'
    else
      render :new
    end
  end

  def update
    if @state.update(state_params)
      redirect_to edit_admin_state_path(@state), notice: 'State was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @state.destroy
    redirect_to admin_states_url, notice: 'State was successfully destroyed.'
  end

  private

  def state_params
    params.require(:state).permit(:name)
  end
end
