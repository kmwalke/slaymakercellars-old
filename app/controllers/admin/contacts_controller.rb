class Admin::ContactsController < ApplicationController
  before_action :logged_in_as_admin?
  helper_method :sort_column, :sort_direction

  def index
    @show = params[:show]
    case @show
    when 'target'
      @contacts = Contact.target_contacts
      @title    = 'Target Contacts'
    when 'misc'
      @contacts = Contact.misc_contacts
      @title    = 'Misc. Contacts'
    when 'urgent'
      @contacts = Contact.urgent_contacts
      @title    = 'Urgent Contacts'
    when 'inactive'
      @contacts = Contact.where('deleted_at is not null')
                         .search(params[:search]).order(sort_column + ' ' + sort_direction)
      @title    = 'Deleted Contacts'
    else
      @show     = 'active'
      @contacts = Contact.current_contacts.search(params[:search]).order(sort_column + ' ' + sort_direction)
      @title    = 'Active Contacts'
    end

    @contacts = @contacts.paginate(per_page: 50, page: params[:page])

    respond_to do |format|
      format.html
      format.json { render json: @contacts }
    end
  end

  def repeat_last_order
    contact   = Contact.find(params[:id])
    new_order = contact.repeat_last_order
    redirect_to edit_admin_order_path(new_order)
  end

  def new
    @contact = Contact.new

    respond_to do |format|
      format.html
      format.json { render json: @contact }
    end
  end

  def edit
    @contact = Contact.find(params[:id])
    @notes   = @contact.notes.order('created_at desc')
  end

  def create
    @contact            = Contact.create(contact_params)
    @contact.updated_by = current_user

    respond_to do |format|
      if @contact.save
        format.html { redirect_to edit_admin_contact_path(@contact.id), notice: 'Contact was successfully created.' }
        format.json { render json: @contact, status: :created, location: @contact }
      else
        format.html { render action: 'new' }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @contact            = Contact.find(params[:id])
    @contact.updated_by = current_user

    respond_to do |format|
      if @contact.update!(contact_params)
        format.html { redirect_to edit_admin_contact_path(@contact), notice: 'Contact was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: 'edit' }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  def undestroy
    @contact            = Contact.find(params[:id])
    @contact.deleted_at = nil
    @contact.save

    redirect_to admin_contacts_url
  end

  def destroy
    @contact            = Contact.find(params[:id])
    @contact.deleted_at = DateTime.now
    @contact.is_public  = false
    @contact.save

    redirect_to admin_contacts_url
  end

  private

  def sort_column
    Contact.column_names.include?(params[:sort]) ? params[:sort] : 'business'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end

  def contact_params
    params.require(:contact).permit(
      :name,
      :business,
      :title,
      :town,
      :comments,
      :price_point,
      :created_at,
      :updated_at,
      :status,
      :address,
      :url,
      :is_public,
      :phone,
      :email,
      :deleted_at,
      :paperless_billing,
      :state,
      :distribution_center_id,
      :mark_retail,
      :price_per_ounce,
      :town_id,
      :tax_id_number,
      :user_id
    )
  end
end
