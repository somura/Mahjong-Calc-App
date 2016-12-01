# ApplicationController
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def top
    render text: 'hello, world'
  end
end
