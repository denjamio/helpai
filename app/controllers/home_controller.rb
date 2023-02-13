class HomeController < ApplicationController
  http_basic_authenticate_with name: ENV.fetch("AUTH_USER"), password: ENV.fetch("AUTH_PASS")

  def index
    @answer = SearchService.new(params[:q]).call
  end
end
