require 'net/http'
require 'uri'
require 'nokogiri'

class Scraper

  attr_accessor :stats

  def initialize(rsn)
    @rsn = rsn

    @stats = {
      attack: { level: '--' },
      defence: { level: '--' },
      strength: { level: '--' },
      hitpoints: { level: '--' },
      ranged: { level: '--' },
      prayer: { level: '--' },
      magic: { level: '--' },
      cooking: { level: '--' },
      woodcutting: { level: '--' },
      fletching: { level: '--' },
      fishing: { level: '--' },
      firemaking: { level: '--' },
      crafting: { level: '--' },
      smithing: { level: '--' },
      mining: { level: '--' },
      herblore: { level: '--' },
      agility: { level: '--' },
      thieving: { level: '--' },
      slayer: { level: '--' },
      farming: { level: '--' },
      runecraft: { level: '--' },
      hunter: { level: '--' },
      construction: { level: '--' },
      overall: {level: '--'},
    }

    fetch_data
  end

  def fetch_data
    uri = URI.parse("https://secure.runescape.com/m=hiscore_oldschool/hiscorepersonal")
    form_data = {
      "user1" => @rsn,
      "submit" => "Search"
    }

    request = Net::HTTP::Post.new(uri.path)
    request.set_form_data(form_data)

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    response = http.request(request)

    if response.code == "200"
      parse_hiscores(response.body)
    else
      puts "failed to fecth hiscores. code: #{response.code}"
    end
  end

  def parse_hiscores(html)
    doc = Nokogiri::HTML(html)

    hiscores_table = doc.css('table')[0]
    overall_level = 0

    hiscores_table.css('tr').each_with_index do |row, index|
      next if index == 0 #skip header

      cells = row.css('td')
      skill = cells[1]&.text&.strip&.downcase&.to_sym
      level = cells[3]&.text&.strip

      if @stats.key?(skill) && skill != :overall
        @stats[skill][:level] = level.to_i
        overall_level += level.to_i
      end
    end
    @stats[:overall][:level] = overall_level
  end
end