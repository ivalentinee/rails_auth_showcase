class ApplicationController < ActionController::API
  before_action :set_current_user

  def set_current_user
    @current_user = User.find_by(id: params["auth_user_id"])

    render text: "unauthenticated", status: 403 unless @current_user
  end
end
