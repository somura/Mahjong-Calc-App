# ApplicationController
class ApplicationController < ActionController::Base
  include LoginHelper

  protect_from_forgery with: :exception

  before_action :check_login_session, except: :login

  private

  def check_login_session
    login_session = cookies['login_session']
    return redirect_to controller: 'login', action: 'index' unless login_session

    login_id = decrypt_login_session login_session
    return redirect_to controller: 'login', action: 'index' unless login_id

    user = User.where(login_id: login_id)
    return redirect_to controller: 'login', action: 'index' if user.empty?
  end
end
