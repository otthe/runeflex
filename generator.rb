class Generator
  attr_accessor :svg

  def initialize(stats)
    @stats = stats
    @base64_icons = JSON.parse(File.read('base64_icons.json'))
  end

end