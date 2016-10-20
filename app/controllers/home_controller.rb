class HomeController < ApplicationController
  def show
    file = File.read(Rails.root.join 'data.json')
    @images = JSON.parse(file)
  end
end
