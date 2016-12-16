class LoginController < ApplicationController
  def index
    return render template: 'login/index'
  end

  def create
    login_id   = params['login_id']
    login_pass = params['login_pass']

    if login_id && login_pass
      user = User.where(login_id: login_id)
      if !user.empty? && user.first.login_pass == login_pass
        cookies[:login_session] = "#{login_id}:#{login_pass}"
        return redirect_to :root
      else
        return render template: 'login/index', status: 400
      end
    else
      return render template: 'login/index', status: 400
    end
  end

  private
  def check_login_session
    login_session = cookies['login_session']
    return redirect_to :root if login_session
  end
end
