require 'victor'

class Generator
  attr_accessor :svg

  def generate_svg_template(stats)
    @svg = Victor::SVG.new width: 256+64, height: 128, style: {background: '#ddd', margin: 'auto'}
    
    @svg.build do
      row_length = 8
      image_size = 16
      padding = 24
      text_offset = 4
      
      rect x: 0, y: 0, width: 256+64, height: 128, rx: 0, fill: '#C2AB79'

      stats.each_with_index do |(key, stat), index|

        if key.to_s != "overall"
          xo = (index % row_length) * (image_size + padding)
          yo = (index / row_length) * (image_size + padding)

          base64_icons = JSON.parse(File.read('base64_icons.json'))
          base64_image = base64_icons[key.to_s]
          image href: base64_image, x: xo, y: yo, width: image_size, height: image_size
        end
      end
    end
    svg.save 'template'
  end

  def generate_stats_svg(stats)
    svg_template = File.read('template.svg')
    @svg = Victor::SVG.new(content: svg_template)

    @svg.build do 
      row_length = 8
      image_size = 16
      padding = 24
      text_offset = 4

      stats.each_with_index do |(key, stat), index|
        if key.to_s != "overall"
          xo = (index % row_length) * (image_size + padding)
          yo = (index / row_length) * (image_size + padding)
          text stat[:level], x: xo + image_size + text_offset, y: yo + image_size / 2, dy: "0.35em", fill: 'black', 'font-size': '16px'
        end
      end

      text "Wrath Tiara [2277]", x: 4, y: 112, dy: "0.35em", fill: 'black', 'font-size': '16px'
   
    end
  end

end