class AccountsController < ApplicationController
  # GET /accounts
  # GET /accounts.json
  def index
    @towns  = Contact.where(is_public: true).map(&:town).uniq
    @states = @towns.map { |c| c&.state }.uniq

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @accounts }
    end
  end
end
