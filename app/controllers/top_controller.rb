class TopController < ApplicationController
  def index
    return render template: 'top/index'
  end
end
