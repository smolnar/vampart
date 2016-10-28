class ImagesController < ApplicationController
  def new
    @image = Image.new
  end

  def create
    @factory = ImageFactory.new(image_params)

    if @factory.save
      redirect_to @factory.image
    else
      render json: @factory.errors
    end
  end

  private

  def image_params
    params.require(:image).permit(:photo)
  end
end
