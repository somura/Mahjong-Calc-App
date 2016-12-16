# ApplicationController
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :check_login_session, except: :login

  private
  def check_login_session
    login_session = cookies['login_session']
    return redirect_to controller: 'login', action: 'index' unless login_session
  end
end
