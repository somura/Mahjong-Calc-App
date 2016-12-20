# ApplicationHelper
module ApplicationHelper
  def user_id
    login_session = cookies[:login_session]
    return nil unless login_session

    login_id = decrypt_login_session login_session
    return nil unless login_id

    user = User.where(login_id: login_id)
    return nil if user.empty?

    return user.first.id
  end
end
