class ImageFactory
  attr_reader :image, :attributes

  def initialize(attributes)
    @attributes = attributes
  end

  def save
    @image = Image.new(attributes)

    return unless @image.save

    image_path = image.relative_path
    model = OpenFace.generate_model(image_path)

    return unless model

    @image.update_attributes(model: model)
  end

  def error_message
    return I18n.t('errors.invalid_image') unless image.valid?
    return I18n.t('errors.no_face_found') unless image.model?
  end
end

class OpenFace
  def self.generate_model(path)
    response = Curl.get("http://0.0.0.0:1337?path=#{path}")
    face = JSON.parse(response.body_str)[0]

    face ? face['model'] : nil
  end
end
