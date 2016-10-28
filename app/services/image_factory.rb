class ImageFactory
  attr_reader :image, :attributes

  def initialize(attributes)
    @attributes = attributes
  end

  def save
    @image = Image.new(attributes)

    return unless @image.save

    image_path = image.relative_path
    @model = OpenFace.generate_model(image_path)

    return unless @model

    @image.update_attributes(model: @model)
  end

  def errors
    return image.errors.full_messages unless image.valid?
    return 'No face found. Please, provide an image with a face.' unless @model
  end
end

class OpenFace
  def self.generate_model(path)
    response = Curl.get("http://0.0.0.0:1337?path=#{path}")
    face = JSON.parse(response.body_str)[0]

    face ? face['model'] : nil
  end
end
