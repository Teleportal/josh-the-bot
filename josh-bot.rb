require 'discordrb'
require 'yaml'
require 'rufus-scheduler'
require_relative './modules/magic_symbol_parser'

class JoshTheBot
  CONFIG = YAML.load_file('config.yaml')

  include Manamoji

  def initialize
    @colors = {"multi" => 14799002, "W" => 16579807, "U" => 9622767, "B" => 0, "R" => 16754056, "G" => 8772015}
    @colors.default = 13550272

    @bot = Discordrb::Commands::CommandBot.new(
      log_mode: :normal,
      fancy_log: true,
      token: CONFIG["DISCORD_TOKEN"], 
      prefix: '!'
    )

    @scheduler = Rufus::Scheduler.new

    @scheduler.cron '30 18 * * *' do
      @bot.send_message(CONFIG["BOT_CHANNEL_ID"], 'My scheduler is working!')
    end

    @bot.message(with_text: 'Ping!') do |event|
      m = event.respond('Pong!')
      m.edit "Pong! Time taken: #{Time.now - event.timestamp} seconds."
    end

    @bot.message(with_text: 'NOICE') do |event|
      event.respond('ALSO NOICE')
    end

    @bot.message(contains: /\[\[.+\]\]/) do |event|
      get_scryfall(event)
    end

    @bot.command(:exit, help_available: false) do |event|
      # This is a check that only allows a user with a specific ID to execute this command. Otherwise, everyone would be
      # able to shut your bot down whenever they wanted.
      break unless event.user.id == CONFIG["USER_ID"]
      @bot.send_message(event.channel.id, 'Bot is shutting down')
      exit
    end
  end

  def run
    @bot.run(:async)
    # Sends a message to the bot channel on start up
    @bot.send_message(CONFIG["BOT_CHANNEL_ID"], 'Bot is now running!') 
    @bot.sync()
  end

  def get_scryfall(event)
    card = event.content.match(/\[\[.+\]\]/)
    card_name = card.to_s.split("[[")[1].split("]]")[0]
    stripped_name = ["!", "$", "#"].include?(card_name[0]) ? card_name[1..-1] : card_name
    response = RestClient.get("https://api.scryfall.com/cards/named?exact=#{stripped_name}")
    body = JSON.parse(response)
    get_map = {"$" => method(:get_card_price), "!" => method(:get_card_image), "#" => method(:get_card_legalities)}
    get_map.default = method(:get_card)
    get_map[card_name[0]].(event, body)
  end

  def get_card_price(event, body)
    event.channel.send_embed do |embed|
      embed.title = get_title(body["name"], body["mana_cost"])
      embed.url = body["scryfall_uri"]
      embed.description = "$" + body["usd"]
      embed.thumbnail = Discordrb::Webhooks::EmbedImage.new(url: body["image_uris"]["normal"])
      embed.color = get_color(body["colors"])
    end
  end

  def get_card_image(event, body)
    event.channel.send_embed do |embed|
      embed.title = get_title(body["name"], body["mana_cost"])
      embed.url = body["scryfall_uri"]
      embed.image = Discordrb::Webhooks::EmbedImage.new(url: body["image_uris"]["normal"])
      embed.color = get_color(body["colors"])
    end
  end

  def get_card_legalities(event, body)
    event.channel.send_embed do |embed|
      embed.title = get_title(body["name"], body["mana_cost"])
      embed.url = body["scryfall_uri"]
      body["legalities"].each do |magic_format, legalese|
        legality = (legalese == "not_legal" ? "Not Legal" : legalese.capitalize)
        embed.add_field(name: magic_format.capitalize, value: legality, inline: true)
      end
      embed.color = get_color(body["colors"])
    end
  end

  def get_card(event, body)
    event.channel.send_embed do |embed|
      embed.title = get_title(body["name"], body["mana_cost"])
      embed.url = body["scryfall_uri"]
      embed.description = get_card_text(body["type_line"], body["oracle_text"], body["power"], body["toughness"], body["loyalty"])
      embed.thumbnail = Discordrb::Webhooks::EmbedImage.new(url: body["image_uris"]["normal"])
      embed.color = get_color(body["colors"])
    end
  end

  def get_color(color)
    color.length > 1 ? @colors["multi"] : @colors[color[0]]
  end

  def get_title(name, mana_cost)
    name + "   " + Manamoji.get_emoji(mana_cost).map! {|e| @bot.find_emoji(e).to_s}.join("")
  end

  def get_card_text(type_line, oracle_text, power = nil, toughness = nil, loyalty = nil)
    description = type_line + "\n"
    text_array = oracle_text.split(/\{(.{1,3})\}/)
    is_emoji = false
    text_array.each do |possible_emoji|
      if is_emoji
        description += @bot.find_emoji(Manamoji.get_emoji(possible_emoji)[0]).to_s
        is_emoji = false
      else
        description += possible_emoji
        is_emoji = true
      end
    end
    if power
      description += "\n" + power + "/" + toughness
    elsif loyalty
      description += "\n" + loyalty
    end
    return description
  end
end