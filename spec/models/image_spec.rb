require 'rails_helper'

RSpec.describe Image, type: :model do
  describe 'callbacks' do
    describe '#generate_uid' do
      it 'generates key' do
        allow(SecureRandom).to receive(:urlsafe_base64).and_return('value')

        image = FactoryGirl.create(:image)

        expect(image.uid).to eql('value')
      end

      context 'when key already exists' do
        it 'tries to generate another one in a loop' do
          allow(SecureRandom).to receive(:urlsafe_base64).and_return('value', 'another value')

          images = 2.times.map { FactoryGirl.create(:image) }

          expect(images[0].uid).to eql('value')
          expect(images[1].uid).to eql('another value')
        end
      end
    end
  end
end
