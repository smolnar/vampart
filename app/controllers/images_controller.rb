class ImagesController < ApplicationController
  def create
    @image = Image.create(image_params)
    render 'home/show'
  end

  private

  def user_params
    params.require(:image).permit(:photo)
  end
end
