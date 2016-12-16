class RegisterController < ApplicationController
  def index
    return render template: 'register/index'
  end

  def create
    login_id   = params['login_id']
    login_pass = params['login_pass']
    return render template: 'register/index', status: 400 if !login_id || !login_pass

    users = User.where(login_id: login_id)
    return render template: 'register/index', status: 400 if users.size > 0

    user_data = { login_id: login_id, login_pass: login_pass }
    user = User.new user_data
    user.save

    cookies[:login_session] = "#{login_id}:#{login_pass}"
    return redirect_to :root
  end

  private
  def check_login_session
    login_session = cookies['login_session']
    return redirect_to :root if login_session
  end
end
