# Login Controller
class LoginController < ApplicationController
  include LoginHelper

  def index
    @user = User.new
    render template: 'login/index'
  end

  def create
    login_id   = user_params[:login_id]
    login_pass = user_params[:login_pass]

    user = User.where(login_id: login_id)
    if !user.empty? && user.first.login_pass == login_pass
      cookies[:login_session] = create_login_session(login_id)
      return redirect_to :root
    end

    render template: 'login/index', status: 400
  end

  private

  def check_login_session
    login_session = cookies['login_session']
    return true unless login_session

    login_id = decrypt_login_session login_session
    return true unless login_id

    user = User.where(login_id: login_id)
    return redirect_to :root unless user.empty?
  end

  private

  def user_params
    params.require(:user).permit(:login_id, :login_pass)
  end
end
