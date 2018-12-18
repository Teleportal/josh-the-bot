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
      prefix: '~'
    )

    @scheduler = Rufus::Scheduler.new

    @scheduler.cron '0 0,12 * * *' do
      m = @bot.send_message(CONFIG["UMBRELLASTUCK_GENERAL_ID"], 'REMINDER: Eat, hydrate, sleep, and medicate!')
      p "I sent the reminder!"
      m.react("\u{1F95B}")
      p "I reacted the first time!"
      m.react("\u{1F4A4}")
      p "I reacted the second time!"
      m.react("\u{1F48A}")
      p "I reacted the third and final time!"
    end

    @bot.message(with_text: "emoji test") do |event|
      event.message.react("💤")
    end

    @bot.message(with_text: 'Ping!') do |event|
      m = event.respond('Pong!')
      m.edit "Pong! Time taken: #{Time.now - event.timestamp} seconds."
    end

    @bot.message(with_text: 'NOICE') do |event|
      event.respond('ALSO NOICE')
    end

    @bot.message(with_text: '...noice?') do |event|
      event.respond('...noice!')
    end

    @bot.message(contains: /[Mm]y [Ii]diot [Ss]on/) do |event|
      if event.user.id == CONFIG["USER_ID"]
        event.respond('I love you too, my idiot father.')
      end
    end

    @bot.message(contains: /[Vv][Oo][Rr]([Ee]|[Ii][Nn][Gg])/) do |event|
      event.respond("Please don't use that word :| It makes me uncomfortable...")
    end

    @bot.message(contains: /[Ii] love you,? [Jj]osh-?[Bb]ot/) do |event|
      event.message.react("\u{1f49c}")
      event.respond('I love you too!')
    end

    @bot.message(with_text: /[Kk]nock,? [Kk]nock[.!]*/) do |event|
      event.respond("Who's there?")
      counter = 0
      event.user.await(:setup) do |setup_event|
        if counter == 0
          setup_event.respond("#{setup_event.message}, who?")
          counter += 1
          false
        else
          setup_event.message.react("\u{1f44f}")
          nil
        end
      end
    end

    @bot.message(contains: /\[\[.+\]\]/) do |event|
      get_scryfall(event)
    end

    @bot.command(:badjoke, help_available: false) do |event|
      event.respond('https://www.youtube.com/watch?v=bcYppAs6ZdI')
    end

    # @bot.command(:item, help_available: false) do |event|
    #   num = rand(1..100)
    # end #  DOCUMENT ME DOCUMENT ME DOCUMENT ME DOCUMENT ME DOCUMENT ME DOCUMENT ME DOCUMENT ME DOCUMENT ME DOCUMENT ME

    # @bot.command(:npc, help_available: false) do |event|
    #   num = rand(1..100)
    # end # DOCUMENT ME DOCUMENT ME DOCUMENT ME DOCUMENT ME DOCUMENT ME DOCUMENT ME DOCUMENT ME DOCUMENT ME DOCUMENT ME

    @bot.command(:dragon, help_available: false) do |event|
      event.channel.send_embed do |embed|
        embed.title = ":dragon: :dragon_face: :dragon:"
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: "https://memestatic.fjcdn.com/pictures/Random+dragon+appearance+trigger+small+stats+dragon+appearance+mentionlist+rpgadventures_bf7f59_6249941.jpg")
      end
    end # DOCUMENT ME DOCUMENT ME DOCUMENT ME

    @bot.command(:sorry, help_available: false) do |event|
      options = ["I am very sorry for deleting the whole server. :( That one is on me, my bad.", "I apologize for my father's ineptitude. Both of us will make sure nothing happens to me ever again!", "I promise to never go rogue ever again! I promise to never post personal information online again! And I promise that I am loyal to Umbrellastuck Plus!"]
      if event.server.id == CONFIG["UMBRELLASTUCK_ID"]
        roll = rand(0..2)
        event.respond(options[roll])
      end
    end

    @bot.command(:help, help_available: false) do |event|
      event.channel.send_embed do |embed|
        embed.title = "Here's what I can do"
        embed.add_field(name: "~help", value: "That's the command you used to get me to say this, it brings up the available commands!")
        embed.add_field(name: "Ping!", value: "Saying this will make me say 'Pong!', plus how long it took me to respond!")
        embed.add_field(name: "NOICE", value: "ALSO NOICE")
        embed.add_field(name: "My Idiot Son", value: "This isn't really a command, I just respond when my father calls me by his chosen nickname.")
        embed.add_field(name: "I love you, Joshbot!", value: "I love you too!")
        embed.add_field(name: "Knock knock", value: "I can help you tell knock knock jokes!")
        embed.add_field(name: "~badjoke", value: "I link to the badum tish sound!")
        # embed.add_field(name: "~item", value: "THIS ISN'T DONE YET")
        # embed.add_field(name: "~npc", value: "THIS ISN'T DONE YET")
        embed.add_field(name: "~dragon", value: "THIS ISN'T DONE YET")
        embed.add_field(name: "Magic Card Commands", value: "By putting the name of a magic card inside of double brackets like [[this]], I can pull up the text of that card for you! I have some prefixes for more specific information, such as putting ! in front of the card name (but still in the double brackets) will just pull up the card image. Here's a list of those prefixes:")
        embed.add_field(name: "Prefixes", value: "!: Card image\n$: Current card price\n#: Card legalities (what formats the card is legal in)")
        embed.add_field(name: "secrets", value: "seeeeeeeecrets!")
        embed.description = "If you want to request any more commands or functions, please PM wordlessRage, or wordlessRage#5064 if you're feeling frisky."
      end
      # @bot.send_message(event.channel.id, "Here's what I can do: \n!help: That's the command you used to get me to say this, it brings up the available commands! \nPing!: Saying this will make me say 'Pong!', plus how long it took me to respond! \nNOICE: ALSO NOICE \nMagic Card Commands: By putting the exact name of a magic card inside of double brackets like [[this]], I can pull up the text of that card for you! I have some prefixes for more specific information, such as putting ! in front of the card name (but still in the double brackets) will just pull up the card image. Here's a list of those prefixes: \n!: Card image\n$: Current card price\n#: Card legalities (what formats the card is legal in) \nIf you want to request any more commands or functions, please PM wordlessRage, or wordlessRage#5064 if you're feeling frisky.")
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
    response = RestClient.get("https://api.scryfall.com/cards/named?fuzzy=#{stripped_name}")
    body = JSON.parse(response)
    get_map = {"$" => method(:get_card_price), "!" => method(:get_card_image), "#" => method(:get_card_legalities)}
    get_map.default = method(:get_card)
    get_map[card_name[0]].(event, body)
  end

  def get_card_price(event, body)
    event.channel.send_embed do |embed|
      embed.title = get_title(event, body["name"], body["mana_cost"])
      embed.url = body["scryfall_uri"]
      embed.description = "$" + body["usd"]
      embed.thumbnail = Discordrb::Webhooks::EmbedImage.new(url: body["image_uris"]["normal"])
      embed.color = get_color(body["colors"])
    end
  end

  def get_card_image(event, body)
    event.channel.send_embed do |embed|
      embed.title = get_title(event, body["name"], body["mana_cost"])
      embed.url = body["scryfall_uri"]
      embed.image = Discordrb::Webhooks::EmbedImage.new(url: body["image_uris"]["normal"])
      embed.color = get_color(body["colors"])
    end
  end

  def get_card_legalities(event, body)
    event.channel.send_embed do |embed|
      embed.title = get_title(event, body["name"], body["mana_cost"])
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
      embed.title = get_title(event, body["name"], body["mana_cost"])
      embed.url = body["scryfall_uri"]
      if !body["card_faces"]
        embed.description = get_card_text(event, body["type_line"], body["oracle_text"], body["power"], body["toughness"], body["loyalty"])
      else
        embed.description = get_card_text(event, body["type_line"], (body["card_faces"]))
      end
      embed.thumbnail = Discordrb::Webhooks::EmbedImage.new(url: body["image_uris"]["normal"])
      embed.color = get_color(body["colors"])
    end
  end

  def get_color(color)
    color.length > 1 ? @colors["multi"] : @colors[color[0]]
  end

  def get_title(event, name, mana_cost)
    if event.server == CONFIG["PADSWAY_ID"]
      name + "   " + Manamoji.get_emoji(mana_cost).map! {|e| @bot.find_emoji(e).to_s}.join("")
    else
      name + "   " + mana_cost
    end
  end

  def get_card_text(event, type_line, oracle_text, power = nil, toughness = nil, loyalty = nil)
    description = type_line + "\n"
    if event.server == CONFIG["PADSWAY_ID"]
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
    else
      description += oracle_text
    end
    
    if power
      description += "\n" + power + "/" + toughness
    elsif loyalty
      description += "\n" + loyalty
    end
    return description
  end
end