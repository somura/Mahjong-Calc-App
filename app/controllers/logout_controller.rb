class LogoutController < ApplicationController
  def index
    render template: 'logout/index'
  end

  def create
    cookies.delete :login_session
    return redirect_to controller: 'login', action: 'index'
  end
end
