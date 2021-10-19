class ApplicationController < ActionController::API
  before_action :set_current_user

  rescue_from CanCan::AccessDenied do |exception|
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
