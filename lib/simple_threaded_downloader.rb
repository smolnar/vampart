class SimpleThreadedDownloader
  def initialize
    @pool = Typhoeus::Hydra.new(max_concurrency: 50)
  end

  def enqueue(url, &block)
    request = Typhoeus::Request.new(url, followlocation: true)

    request.on_success(&block)
    request.on_failure do |response|
      warn "Download failed (#{response.code}). Retrying #{response.effective_url} ..."

      pool.queue(request)
    end

    @pool.queue(request)
  end

  def run
    @pool.run
  end
end
