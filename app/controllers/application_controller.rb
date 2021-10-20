class ApplicationController < ActionController::API
  include Pundit

  before_action :set_current_user
  after_action :verify_authorized

  rescue_from Pundit::NotAuthorizedError do |exception|
    render text: "unauthorized", status: 401
  end

  def set_current_user
    @current_user = User.find_by(id: params["auth_user_id"])

    render text: "unauthenticated", status: 403 unless @current_user
  end

  def current_user
    @current_user
  end
end
