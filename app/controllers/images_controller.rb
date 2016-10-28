class ImagesController < ApplicationController
  def new
    @image = Image.new
  end

  def create
    @factory = ImageFactory.new(image_params)

    if @factory.save
      redirect_to @factory.image
    else
      @factory.image.destroy

      flash[:notice] = @factory.errors
      redirect_to new_image_url
    end
  end

  def show
    @image = Image.find(params[:id])
  end

  private

  def image_params
    params.require(:image).permit(:photo)
  end
end
