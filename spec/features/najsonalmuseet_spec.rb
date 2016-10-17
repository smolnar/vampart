require 'rails_helper'

RSpec.describe 'Najsonalmuseet API' do
  it 'provides all portraits', :vcr do
    data = Nasjonalmuseet.get('portrett', size: 50)

    expect(data.size).to eql(20)

    item = data.first

    expect(item).to eql(
      id: '148839',
      source: 'nkl.snl.no/api/v1',
      url: 'https://snl.no/portrettkunst',
      year: nil,
      title: 'portrettkunst',
      image_url: 'https://media.snl.no/system/images/9019/portrettkunst2.jpg'
    )
  end
end
