class User::ContactsController < ApplicationController
  before_action :logged_in?

  # GET /contacts/1/edit
  def edit
    @contact = current_user.contact
    @notes   = @contact.notes.order('created_at desc')
  end

  # PUT /contacts/1
  # PUT /contacts/1.json
  def update
    @contact = current_user.contact

    respond_to do |format|
      if @contact.update!(contact_params)
        format.html { redirect_to edit_user_contact_path(@contact), notice: 'Contact was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: 'edit' }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :business, :title, :town, :comments,
                                    :created_at, :updated_at, :address, :url, :is_public, :phone, :email, :deleted_at,
                                    :paperless_billing,
                                    :tax_id_number)
  end
end
