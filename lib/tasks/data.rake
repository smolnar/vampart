namespace :data do
  desc 'Download data from Webumenia API'
  task get: :environment do
    [
      Webumenia.get('portret podobizen'),
      Nasjonalmuseet.get('portrett')
    ].each do |data|
      DataRepository.save(data)
    end
  end

  desc 'Download all images, fast!'
  task :download_images do
    data = DataRepository.all
    downloader = SimpleThreadedDownloader.new

    data.each do |artwork|
      image_url = artwork[:image_url]

      downloader.enqueue(image_url) do |response|
        puts "Downloaded Image for \"#{artwork[:title]}\" (#{artwork[:image_url]}) ... (#{response.body.size / 1000 } kb)"
        name = "#{Digest::SHA256.hexdigest(response.body)}.jpg"

        File.open(Rails.root.join("storage/images/#{name}"), 'wb') do |f|
          f.write(response.body)
        end

        artwork['image'] = name
      end
    end

    downloader.run
    DataRepository.save(data)
  end
end
