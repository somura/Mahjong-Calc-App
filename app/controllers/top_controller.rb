# Top Controller
class TopController < ApplicationController
  def index
    render template: 'top/index'
  end
end
