# Register Controller
class RegisterController < ApplicationController
  include LoginHelper

  def index
    @user = User.new
    render template: 'register/index'
  end

  def create
    users = User.where(login_id: user_params[:login_id])
    return render template: 'register/index', status: 400 unless users.empty?

    user = User.new user_params
    user.save

    cookies[:login_session] = create_login_session(user_params[:login_id])
    redirect_to :root
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
    params.require(:user).permit(:name, :login_id, :login_pass)
  end
end
