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
end
