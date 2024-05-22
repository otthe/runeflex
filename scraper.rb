require 'net/http'
require 'uri'
require 'nokogiri'

class Scraper
  def initialize(rsn)
    @rsn = rsn

    @stats = {
      attack: { level: 99 },
      defence: { level: 99 },
      strength: { level: 99 },
      hitpoints: { level: 99 },
      ranged: { level: 99 },
      prayer: { level: 99 },
      magic: { level: 99 },
      cooking: { level: 99 },
      woodcutting: { level: 99 },
      fletching: { level: 99 },
      fishing: { level: 99 },
      firemaking: { level: 99 },
      crafting: { level: 99 },
      smithing: { level: 99 },
      mining: { level: 99 },
      herblore: { level: 99 },
      agility: { level: 99 },
      thieving: { level: 99 },
      slayer: { level: 99 },
      farming: { level: 99 },
      runecraft: { level: 99 },
      hunter: { level: 99 },
      construction: { level: 99 },
      overall: {level: 2277},
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

    hiscores_table.css('tr').each_with_index do |row, index|
      next if index == 0 #skip header

      cells = row.css('td')
      skill = cells[1]&.text&.strip&.downcase&.to_sym
      level = cells[3]&.text&.strip

      #puts "Skill: #{skill}, Level: #{level}"

      if @stats.key?(skill)
        @stats[skill][:level] = level.to_i
      end
    end

    @stats.each do |skill, data|
      puts "Skill #{skill.capitalize}, Level: #{data[:level]}"
    end

  end
end