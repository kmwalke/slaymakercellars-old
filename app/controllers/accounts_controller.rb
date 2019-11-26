class AccountsController < ApplicationController
  def index
    @towns  = Contact.where(is_public: true).map(&:town).uniq
    @states = @towns.map { |c| c&.state }.uniq

    respond_to do |format|
      format.html
      format.json { render json: @accounts }
    end
  end
end
