class ImagesController < ApplicationController
  def new
    @image = Image.new
  end

  def create
    @factory = ImageFactory.new(image_params)

    if @factory.save
      redirect_to @factory.image
    else
      message = @factory.error_message

      @factory.image.destroy

      flash[:notice] = message
      redirect_to new_image_url
    end
  end

  def show
    @image = Image.find(params[:id])
    @similar_faces = SimilarFacesFinder.for(@image.model).sort_by { |face|
      face[:artwork][:year].to_i || -1
    }.reverse
  end

  private

  def image_params
    params.require(:image).permit(:photo)
  end
end
