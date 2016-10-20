class HomeController < ApplicationController
  def show
    @image = Image.new
    file = File.read(Rails.root.join 'data.json')
    @images = JSON.parse(file)
  end
end
