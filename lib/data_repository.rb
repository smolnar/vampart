class DataRepository
  def self.path
    @path ||= Rails.root.join('data.json')
  end

  def self.all
    @data ||= File.exists?(path) ? JSON.parse(File.read(path), symbolize_names: true) : Array.new
  end

  def self.reload!
    @data = nil
  end

  def self.save(other = {})
    reload!

    data = (other + all).uniq { |e| e.values_at(:id, :source) }

    File.open(path, 'w') do |f|
      f.write(JSON.pretty_generate(data))
    end
  end
end
