require 'rails_helper'

RSpec.describe 'Upload Image', type: :feature, js: true do
  before :each do
    visit root_path
    page.execute_script('$("#image_photo").attr("hidden", false);')
    expect(Image.count).to eql(0)
  end

  it 'uploads an image with a face' do
    first('#image_photo').send_keys(Rails.root.join('spec/fixtures/elon.jpeg'))

    expect(page).to have_css('.face', count: 10)
    expect(Image.count).to eql(1)
  end

  it 'uploads an image without a face' do
    first('#image_photo').send_keys(Rails.root.join('spec/fixtures/mountains.jpeg'))

    expect(page).to have_content('Oh snap! We could not find a face in that picture. Be kind and provide another one, pretty please!')
    expect(Image.count).to eql(0)
  end
end
