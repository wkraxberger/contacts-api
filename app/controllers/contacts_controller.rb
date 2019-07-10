class ContactsController < ApplicationController
  before_action :set_contact, except: [:create, :index]
  # GET /contacts
  def index
    render json: Contact.all, status: :ok
  end

  # GET /contacts/1
  def show
    render json: @contact, status: :ok
  end

  # POST /contacts
  def create
    contact = Contact.new(contact_params)

    if contact.save
      render json: contact, status: :created
    else
      render json: { errors: contact.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /contacts/1
  def update
    if @contact.update(contact_params)
      render json: @contact, status: :ok
    else
      render json: { errors: @contact.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /contacts/1
  def destroy
    @contact.destroy
    head :no_content
  end

  private

  def contact_params
    params.require(:contact).permit(:first_name, :last_name, :cell_phone, :zip_code)
  end

  def set_contact
    @contact = Contact.find_by_id(params[:id])
    not_found({ contact_id: [ 'does not exist.' ] }) unless @contact
  end
end
