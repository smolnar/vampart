require 'rails_helper'

RSpec.describe DataRepository do
  subject { described_class }

  describe '.all' do
    it 'provides all data' do
      expect(subject.all.size).to eql(2149)
      expect(subject.all).to include(
        id: 'SVK:SNG.O_6269',
        source: 'api.webumenia.sk',
        year: '1846',
        title: 'Podobizeň M.M.Hodžu',
        author: ["Klemens, Jozef Božetech"],
        url: 'http://webumenia.sk/dielo/SVK:SNG.O_6269',
        image_url: 'http://www.webumenia.sk/images/diela/SNG/13/SVK_SNG.O_6269/SVK_SNG.O_6269.jpeg',
        image: "0cb56d7d92b31fb8d6295c6a62ffc4641f468b1fd42012d29915d997ee67c000.jpg"
      )
    end
  end

  describe '.save' do
    it 'extends existing data with new' do
      file = double(:file)
      data = [{
        id: 'ID123',
        source: 'SOURCE123'
      }]

      expect(File).to receive(:open).with(Rails.root.join('data.json'), 'w').and_yield(file)
      expect(file).to receive(:write).with(JSON.pretty_generate(data + subject.all))

      subject.save(data)
    end

    it 'updates existing data' do
      file = double(:file)
      data = [{
        id: 'SVK:SNG.O_6269',
        source: 'api.webumenia.sk',
        year: '177', # Change
        title: 'Podobizeň M.M.Hodžu',
        author: ["Klemens, Jozef Božetech"],
        url: 'http://webumenia.sk/dielo/SVK:SNG.O_6269',
        image_url: 'http://www.webumenia.sk/images/diela/SNG/13/SVK_SNG.O_6269/SVK_SNG.O_6269.jpeg'
      }]

      other = subject.all.select { |e| e[:id] != 'SVK:SNG.O_6269' }

      expect(File).to receive(:open).with(Rails.root.join('data.json'), 'w').and_yield(file)
      expect(file).to receive(:write).with(JSON.pretty_generate(data + other))

      subject.save(data)
    end
  end
end
