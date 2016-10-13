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
    pool = Typhoeus::Hydra.new(max_concurrency: 50)
    data = DataRepository.all

    data.each do |artwork|
      image_url = artwork[:image_url]
      request = Typhoeus::Request.new(image_url, followlocation: true)

      request.on_success do |response|
        puts "Downloaded Image: #{response.effective_url} (#{response.body.size / 1000 } kb)"
        name = "#{Digest::SHA256.hexdigest(response.body)}.jpg"

        File.open(Rails.root.join("storage/images/#{name}"), 'wb') do |f|
          f.write(response.body)
        end

        artwork['image'] = name
      end

      request.on_failure do |response|
        warn "Image download failed (#{response.code}). Retrying #{response.effective_url} ..."

        pool.queue(request)
      end

      pool.queue(request)
    end

    pool.run

    DataRepository.save(data)
  end
end
