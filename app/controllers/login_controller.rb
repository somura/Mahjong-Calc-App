# Login Controller
class LoginController < ApplicationController
  include LoginHelper

  def index
    render template: 'login/index'
  end

  def create
    login_id   = params['login_id']
    login_pass = params['login_pass']

    if login_id && login_pass
      user = User.where(login_id: login_id)
      if !user.empty? && user.first.login_pass == login_pass
        cookies[:login_session] = create_login_session(login_id)
        return redirect_to :root
      end
    end
    render template: 'login/index', status: 400
  end

  private

  def check_login_session
    login_session = cookies['login_session']
    login_id = decrypt_login_session login_session
    user = User.where(login_id: login_id)

    return redirect_to :root unless user.empty?
  end
end
