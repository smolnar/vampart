class ImagesController < ApplicationController
  def new
    @image = Image.new
  end

  def create
    @image = Image.create(image_params)
  end

  private

  def image_params
    params.require(:image).permit(:photo)
  end
end
