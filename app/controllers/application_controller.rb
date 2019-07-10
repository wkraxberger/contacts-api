class ApplicationController < ActionController::API
  protected

  def not_found(error)
    render json: { "errors": error }, status: :not_found
  end
end
