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
    pool = Curl::Multi.new
    pool.max_connects = 25

    DataRepository.all.each do |artwork|
      image_url = artwork[:image_url]

      curl = Curl::Easy.new(image_url) do |http|
        http.follow_location = true
        http.on_success do |response|
          name = "#{Digest::SHA256.hexdigest(response.body_str)}.jpg"

          File.open(Rails.root.join("storage/images/#{name}"), 'wb') do |f|
            f.write(response.body_str)
          end

          artwork['image'] = name
        end

        http.on_failure do |response|
          puts "Retrying: #{response.last_effective_url}"
          pool.add(response)
        end
      end

      pool.add(curl)
    end

    pool.perform

    DataRepository.save
  end
end
