class BasicLogger
  def self.log(message)
    puts message if Rails.env.development?
  end
end
