require 'rails_helper'

RSpec.describe 'Najsonalmuseet API' do
  it 'provides all portraits', :vcr do
    data = Nasjonalmuseet.get('portrett')

    expect(data.size).to eql(100)

    item = data.first
    expect(item).to eql(
      id: 'SVK:SNG.O_6269',
      source: 'api.webumenia.sk',
      year: '1846',
      title: 'Podobizeň M.M.Hodžu',
      author: ['Klemens, Jozef Božetech'],
      url: 'http://webumenia.sk/dielo/SVK:SNG.O_6269',
      image_url: 'http://www.webumenia.sk/images/diela/SNG/13/SVK_SNG.O_6269/SVK_SNG.O_6269.jpeg'
    )
  end
end
