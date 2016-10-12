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

  def self.save(other)
    reload!

    File.open(path, 'w') do |f|
      data = (all + other).uniq { |e| e.values_at(:id, :source) }

      f.write(JSON.pretty_generate(data))
    end
  end
end
