class ActivitiesController < ApplicationController
  before_action :set_contact
  before_action :set_activity, except: [:create]

  # GET /contacts/:contact_id/activities/:id
  def show
    render json: @activity, status: :ok
  end

  # POST /contacts/:contact_id/activities
  def create
    activity = @contact.activities.new(activity_params)

    if activity.save
      render json: activity, status: :created
    else
      render json: { errors: activity.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /contacts/:contact_id/activities/:id
  def update
    if @activity.update(activity_params)
      render json: @activity, status: :ok
    else
      render json: { errors: @activity.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /contacts/:contact_id/activities/:id
  def destroy
    @activity.destroy
    head :no_content
  end

  private

  def activity_params
    params.require(:activity).permit(:description)
  end

  def set_contact
    @contact = Contact.find_by_id(params[:contact_id])
    not_found(contact_id: ['does not exist.']) unless @contact
  end

  def set_activity
    @activity = @contact.activities.find_by_id(params[:id])
    not_found(activity_id: ['does not exist for this contact.']) unless @activity
  end
end
