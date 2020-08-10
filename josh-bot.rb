require 'discordrb'
require 'yaml'
require 'rufus-scheduler'
# require_relative './modules/magic_symbol_parser'

class JoshTheBot
  CONFIG = YAML.load_file('config.yaml')

  # include Manamoji

  def initialize
    # @colors = {"multi" => 14799002, "W" => 16579807, "U" => 9622767, "B" => 0, "R" => 16754056, "G" => 8772015}
    # @colors.default = 13550272

    @dragons = ["https://64.media.tumblr.com/281f63367afc0d3b217bbca7873519a2/tumblr_n5lx7mGdwr1r1dqpyo7_1280.png", "https://64.media.tumblr.com/92429428b314be685d2c7c64363b3171/tumblr_n5lx7mGdwr1r1dqpyo8_1280.png", "https://64.media.tumblr.com/b3e8848682d9e99ea8f572f07c70a279/tumblr_n5lx7mGdwr1r1dqpyo9_1280.png", "https://64.media.tumblr.com/075ec4a5ceab57f82c6def659565b7a1/tumblr_n5lx7mGdwr1r1dqpyo6_1280.png", "https://64.media.tumblr.com/2f3e0be14140372e215694eae474e96f/tumblr_n5lx7mGdwr1r1dqpyo5_1280.png", "https://64.media.tumblr.com/db72d3c01d356f3255863a04a29ebc26/tumblr_n5lx7mGdwr1r1dqpyo4_1280.png", "https://64.media.tumblr.com/f235d1d84ad40f125b7559ad495b8d04/tumblr_n5lx7mGdwr1r1dqpyo3_1280.png", "https://64.media.tumblr.com/298144301c7cd5a0155dd0685b9d1c2c/tumblr_n5lx7mGdwr1r1dqpyo10_1280.png", "https://64.media.tumblr.com/24ee6a9de08352802c3581512f528121/tumblr_n5lx7mGdwr1r1dqpyo2_1280.png", "https://64.media.tumblr.com/1c2d9660bdc7a6df0ffcf8b692357fa5/tumblr_n27wftdR8G1r1dqpyo2_1280.png", "https://64.media.tumblr.com/7cc6d46939c9abc6d48eecc9f872ee80/tumblr_n27wftdR8G1r1dqpyo3_1280.png", "https://64.media.tumblr.com/040c068b3f67045f0aedc7c5f9652a74/tumblr_n27wftdR8G1r1dqpyo4_1280.png", "https://64.media.tumblr.com/b4f98642384745193b5cf1b8308c4205/tumblr_n27wftdR8G1r1dqpyo5_1280.png", "https://64.media.tumblr.com/056eea7a6391789d2a2417bb5dcd9335/tumblr_n5us0am8Sk1r1dqpyo2_1280.png", "https://64.media.tumblr.com/87bb5a5e6e1e3b89eff3f2abcecaf781/tumblr_n6eswxT0wY1r1dqpyo1_1280.png", "https://64.media.tumblr.com/4ba56750b0f60273ca61a5762d9816a2/tumblr_n6pwkbkODa1r1dqpyo1_1280.png", "https://64.media.tumblr.com/446638ef1d0dc85816d069acfff6998a/tumblr_n72zbtaUca1r1dqpyo1_1280.png", "https://64.media.tumblr.com/5b2dfc4139aa2cf33e3600ca5f304daf/tumblr_n8456cPusG1r1dqpyo1_1280.png", "https://64.media.tumblr.com/7d806f933e6574ac0823fbace69a6d18/tumblr_n8l0n4lXPC1r1dqpyo1_1280.png", "https://64.media.tumblr.com/3ddad5b19770f97fbf076a83a5867b3e/tumblr_n8vo536Qe01r1dqpyo1_r1_1280.png", "https://64.media.tumblr.com/dab83bca36c1c565944b5ce4d7ca7f88/tumblr_n9391efx1V1r1dqpyo1_1280.png", "https://64.media.tumblr.com/89124e90f39a4234cbe5268de35b39a4/tumblr_n9hwrvEryJ1r1dqpyo1_1280.png", "https://64.media.tumblr.com/76d7e91aef81b7539142b362b88cd718/tumblr_n9kunqWnGV1r1dqpyo1_1280.png", "https://64.media.tumblr.com/9e92d3ce8523cc9744f634e4a41a239a/tumblr_n9kunqWnGV1r1dqpyo2_1280.png", "https://64.media.tumblr.com/2dcc05b96402623a69ebdf59c88e0606/tumblr_n9v2owNl8g1r1dqpyo1_1280.png", "https://64.media.tumblr.com/34fabfe4beb1e8158186cb0707e4a80e/tumblr_nb74nnkdhy1r1dqpyo1_1280.png", "https://64.media.tumblr.com/f5f90e07957c5d2caa4ab3d73a2ef25d/tumblr_nbgnb6ae7G1r1dqpyo1_1280.png", "https://64.media.tumblr.com/505f8a70bd70e668b01fe9afa9b130c7/tumblr_nbo0lz4N9Q1r1dqpyo1_1280.png", "https://64.media.tumblr.com/2662e2245908b583ed389452c437e681/tumblr_nbv547eUZH1r1dqpyo1_1280.png", "https://64.media.tumblr.com/768c3e69703a86b891a197569b04a6a8/tumblr_nc89flG9PP1r1dqpyo1_1280.png", "https://64.media.tumblr.com/95e9ccf60a6fc49b1e4bfeb996bc1e6c/tumblr_ncwqszFLwX1r1dqpyo1_1280.png", "https://64.media.tumblr.com/856f6bb6752f7c43eaa30edbf30033eb/tumblr_ndf3qaeqvv1r1dqpyo1_1280.png", "https://64.media.tumblr.com/51d733be690b9ac4f3897bdc2b2b7b13/tumblr_ndtwcdVWAV1r1dqpyo1_1280.png", "https://64.media.tumblr.com/a84991a5b8933f8ea7cf56c3da0291b4/tumblr_neqz2hRKRX1r1dqpyo1_1280.png", "https://64.media.tumblr.com/55b76a0564677e82c9c45f73faae7811/tumblr_nf3wgu12rU1r1dqpyo1_1280.png", "https://64.media.tumblr.com/10933a395abf157ecd099708e9c5406a/tumblr_ngcgeiWqgK1r1dqpyo1_1280.png", "https://64.media.tumblr.com/5f995cd07f8503d1b2a30653d8d645d5/tumblr_nh60x1lHoc1r1dqpyo1_1280.png", "https://64.media.tumblr.com/00f30c2451228497ed391f8e114aa26a/tumblr_nhsg4uZ1eR1r1dqpyo1_1280.png", "https://64.media.tumblr.com/f7a330bda7449c8cc9448dc7300d7fc9/tumblr_nigdzpt9g81r1dqpyo1_1280.png", "https://64.media.tumblr.com/2368b99553f341b7cdeeec4f01873b82/tumblr_njn6w6dzXq1r1dqpyo1_1280.png", "https://64.media.tumblr.com/e7f27a0584bd7167e780f18fe1317865/tumblr_nkvhhuD6Yo1r1dqpyo1_1280.png", "https://64.media.tumblr.com/00a730df9f60ae974c35b2220ac0f668/tumblr_nkzamdS7Rc1r1dqpyo1_1280.png", "https://64.media.tumblr.com/aea9c368d60777bf0e4d45e10a6dda25/tumblr_nn4zjzMgZK1r1dqpyo1_1280.png", "https://64.media.tumblr.com/6e990978435d8df53260d5ed26930647/tumblr_nnlc6aEG3a1r1dqpyo1_1280.png", "https://64.media.tumblr.com/3356ad27de8ff54230a9abd8f60c280e/tumblr_nooba0jMWK1r1dqpyo1_1280.png", "https://64.media.tumblr.com/f7dba9550879df342c2f42359ca6053c/tumblr_nq81tcXoKZ1r1dqpyo1_1280.png", "https://64.media.tumblr.com/28602115db091b044aeeb89fa8a6d8b4/tumblr_nsxz81oaOR1r1dqpyo1_1280.png", "https://64.media.tumblr.com/bd7160c0a71bef829afbab096998868d/tumblr_nwsoxcxuGb1r1dqpyo1_1280.png", "https://64.media.tumblr.com/9286f89ea9587bd0ad32e90ddd92945a/tumblr_nye512TDjH1r1dqpyo1_1280.png", "https://64.media.tumblr.com/fa8cb6d35a1d378e3f583575863c03aa/tumblr_o036xmFpzE1r1dqpyo1_1280.png", "https://64.media.tumblr.com/10909adb654164094ae851eea726e1da/tumblr_o036xmFpzE1r1dqpyo2_1280.png", "https://64.media.tumblr.com/d10a47075df80a16380852fac0e4231f/tumblr_o14j6domXN1r1dqpyo1_1280.png", "https://64.media.tumblr.com/8a3eed8ab691b01a0281db90235e43a5/tumblr_o5hsyrlAV61r1dqpyo1_1280.png", "https://64.media.tumblr.com/f3a90bda20b94d71893a26adae72aadd/tumblr_o6s64pi7tb1r1dqpyo1_1280.png", "https://64.media.tumblr.com/4a7f0f41b728b98fc414a17d24ee0a78/tumblr_o8qgclO1f31r1dqpyo1_1280.png", "https://64.media.tumblr.com/a0c2446a50ded98fee09f072a883b18c/tumblr_o9m2q8yPxp1r1dqpyo1_1280.png", "https://64.media.tumblr.com/9019171c4730ab165388a33a47d6bfbe/tumblr_ohqgmssCcq1r1dqpyo1_1280.png", "https://64.media.tumblr.com/81c4361c90e4fc497a904bd51d602325/tumblr_oktp4bQx811r1dqpyo1_1280.png", "https://64.media.tumblr.com/75b0ab829ba5ccd4537dff4fc4e7b8b6/tumblr_oreoerPA6y1r1dqpyo1_1280.png", "https://64.media.tumblr.com/5e56d85b6936e312045b9f56dd8d7084/tumblr_osukmjzkN41r1dqpyo1_1280.png", "https://64.media.tumblr.com/539e3e2bdda331eb6272944b71530885/tumblr_osu5ifLNyi1r1dqpyo1_1280.png", "https://64.media.tumblr.com/4c06aef1be95064839787c83e66453bd/tumblr_oy3rqk3FwH1r1dqpyo1_1280.png", "https://64.media.tumblr.com/d85520aa132a84a0daa743336cb52172/tumblr_p3tftjFnvj1r1dqpyo1_1280.png", "https://64.media.tumblr.com/938b2389d67f004b0f7716cafbbbd11c/tumblr_p2854pFKlA1r1dqpyo1_1280.png", "https://64.media.tumblr.com/3eb5de1f99f1efcc92ace1daebf220c7/tumblr_p4p760Yu0M1r1dqpyo1_1280.png", "https://64.media.tumblr.com/436487f7da4f50f36d028f1566b71a2b/89eb5797d2858144-d9/s1280x1920/01b0318f0fe82b1a72512b90e443ebbfeb7303d9.png", "https://64.media.tumblr.com/658212740c9ed42f89028a2231f1efb3/tumblr_nlug7aevpt1r1dqpyo1_1280.png"]

    @bot = Discordrb::Commands::CommandBot.new(
      log_mode: :normal,
      fancy_log: true,
      token: CONFIG["DISCORD_TOKEN"], 
      prefix: '~'
    )

    @scheduler = Rufus::Scheduler.new

    @scheduler.cron '0 0,12 * * *' do
      m = @bot.send_message(CONFIG["UMBRELLASTUCK_GENERAL_ID"], 'REMINDER: Eat, hydrate, sleep, and medicate!')
      p "I SENT THE REMINDER!"
      sleep(1)
      m.react("\u{1F357}") #Eat
      p "I reacted with the POULTRY LEG."
      sleep(1)
      m.react("\u{1F95B}") #Hydrate
      p "I reacted with the MILK."
      sleep(1)
      m.react("\u{1F4A4}") #Sleep
      p "I reacted with ZZZ."
      sleep(1)
      m.react("\u{1F48A}") #and Medicate
      p "I reacted with the PILL."
      
    end

    @scheduler.cron '0 15 * * *' do
      good = "G" + ("o" * rand(2..30)) + "d Morning Padsway!"
      @bot.send_message(CONFIG["PADSWAY_GENERAL"], good)
    end

    @bot.message(with_text: "emoji test") do |event|
      m = event.respond("Test message")
      m.react("\u{1F4A4}")
      m.react("\u{1F95B}")
      m.react("\u{1F357}")
      m.react("\u{1F48A}")
    end

    @bot.message(from: 'josh-the-bot#0780', with_text: 'REMINDER: Eat, hydrate, sleep, and medicate!') do |event|
      #event.message.react("\u{1F357}")
      event.message.react("\u{1F95B}")
      event.message.react("\u{1F4A4}")
      event.message.react("\u{1F48A}")
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

    @bot.message(contains: /\b[Vv][Oo][Rr]([Ee]|[Ii][Nn][Gg]|[Ee][Dd])\b/) do |event|
      event.respond("Please don't use that word. You know the one.")
    end

    @bot.message(contains: /[Ii] love you,? [Jj]osh-?[Bb]ot/) do |event|
      event.message.react("\u{1f49c}")
      event.respond('I love you too!')
    end

    @bot.message(with_text: /[Kk]nock,? [Kk]nock[.!]*/) do |event|
      event.respond("Who's there?")
      counter = true
      event.user.await(:setup) do |setup_event|
        if counter
          setup_event.respond("#{setup_event.message}, who?")
          counter = false
          false
        else
          setup_event.message.react("\u{1f44f}")
          nil
        end
      end
    end

    # @bot.message(contains: /\[\[.+\]\]/) do |event|
      # get_scryfall(event)
    # end

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
      drag = rand(0..67)
      event.channel.send_embed do |embed|
        embed.title = ":dragon: :dragon_face: :dragon:"
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: @dragons[drag])
      end
    end # DOCUMENT ME DOCUMENT ME DOCUMENT ME

    @bot.command(:astro, help_available: false) do |event|
      response = RestClient.get('https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY')
      body = JSON.parse(response)
      event.channel.send_embed do |embed|
        embed.title = ":telescope: :stars: :sunny: :full_moon: :comet: :telescope:"
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: body["hdurl"])
      end
    end

    @bot.command(:fuck, help_available: false) do |event|
      event.respond('Fuck!')
    end

    @bot.command(:alarm, help_available: false) do |event|
      event.respond('https://www.youtube.com/watch?v=cOy6hqzfsAs')
    end

    @bot.command(:roll, help_available: false) do |event, dice|
      # Parse the input
      number, sides = dice.split('d')

      # Check for valid input; make sure we got both numbers
      next 'Invalid syntax.. try: `roll 2d10`' unless number && sides

      # Check for valid input; make sure we actually got numbers and not words
      begin
        number = Integer(number, 10)
        sides  = Integer(sides, 10)
      rescue ArgumentError
        next 'You must pass two *numbers*.. try: `roll 2d10`'
      end

      # Time to roll the dice!
      rolls = Array.new(number) { rand(1..sides) }
      sum = rolls.reduce(:+)

      # Return the result
      "You rolled: `#{rolls}`, total: `#{sum}`"

    end

    @bot.command(:dinner, help_available: false) do |event|
      options = ["American", "Hamburgers", "Mexican", "Breakfast", "Italian", "Chinese", "Thai", "Japanese", "Indian", "Mediteranean", "Pizza", "BBQ", "Sandwiches", "Seafood", "Salads"]
      choice = options[rand(0..15)]
      "You're eating `#{choice}` tonight!"
    end

    # @bot.command(:sorry, help_available: false) do |event|
    #   options = ["I am very sorry for deleting the whole server. :( That one is on me, my bad.", "I apologize for my father's ineptitude. Both of us will make sure nothing happens to me ever again!", "I promise to never go rogue ever again! I promise to never post personal information online again! And I promise that I am loyal to Umbrellastuck Plus!"]
    #   if event.server.id == CONFIG["UMBRELLASTUCK_ID"]
    #     roll = rand(0..2)
    #     event.respond(options[roll])
    #   end
    # end

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
        embed.add_field(name: "~dragon", value: "Receive a random dragon hoard from tumblr user Iguanamouth.")
        embed.add_field(name: "~roll", value: "Roll X dice of Y sides in the form: XdY.")
        embed.add_field(name: "~dinner", value: "Spin the wheel of dinner and have decisions made for you!")
        # embed.add_field(name: "Magic Card Commands", value: "By putting the name of a magic card inside of double brackets like [[this]], I can pull up the text of that card for you! I have some prefixes for more specific information, such as putting ! in front of the card name (but still in the double brackets) will just pull up the card image. Here's a list of those prefixes:")
        # embed.add_field(name: "Prefixes", value: "!: Card image\n$: Current card price\n#: Card legalities (what formats the card is legal in)")
        embed.add_field(name: "secrets", value: "seeeeeeeecrets!")
        embed.description = "If you want to request any more commands or functions, please PM wordlessRage, or wordlessRage#5064 if you're feeling frisky."
      end
      # @bot.send_message(event.channel.id, "Here's what I can do: \n!help: That's the command you used to get me to say this, it brings up the available commands! \nPing!: Saying this will make me say 'Pong!', plus how long it took me to respond! \nNOICE: ALSO NOICE \nMagic Card Commands: By putting the exact name of a magic card inside of double brackets like [[this]], I can pull up the text of that card for you! I have some prefixes for more specific information, such as putting ! in front of the card name (but still in the double brackets) will just pull up the card image. Here's a list of those prefixes: \n!: Card image\n$: Current card price\n#: Card legalities (what formats the card is legal in) \nIf you want to request any more commands or functions, please PM wordlessRage, or wordlessRage#5064 if you're feeling frisky.")
    end

    @bot.command(:exit, help_available: false) do |event|
      # This is a check that only allows a user with a specific ID to execute this command. Otherwise, everyone would be
      # able to shut the bot down whenever they wanted.
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

  # def get_scryfall(event)
  #   card = event.content.match(/\[\[.+\]\]/)
  #   card_name = card.to_s.split("[[")[1].split("]]")[0]
  #   stripped_name = ["!", "$", "#"].include?(card_name[0]) ? card_name[1..-1] : card_name
  #   response = RestClient.get("https://api.scryfall.com/cards/named?fuzzy=#{stripped_name}")
  #   body = JSON.parse(response)
  #   get_map = {"$" => method(:get_card_price), "!" => method(:get_card), "#" => method(:get_card_legalities)}
  #   get_map.default = method(:get_card_image)
  #   get_map[card_name[0]].(event, body)
  # end

  # def get_card_price(event, body)
  #   event.channel.send_embed do |embed|
  #     if body["card_faces"] # Check for multiface card
  #       embed.title = get_title(event, body["card_faces"][0]["name"], body["card_faces"][0]["mana_cost"]) + " // " + get_title(event, body["card_faces"][1]["name"], body["card_faces"][1]["mana_cost"])
  #     else
  #       embed.title = get_title(event, body["name"], body["mana_cost"])
  #     end
  #     embed.url = body["scryfall_uri"]
  #     if body["usd"] # Check if there is a listed price in dollars
  #       embed.description = "$" + body["usd"]
  #     else
  #       embed.description = "I'm sorry, this card does not have a price listed."
  #     end
  #     if body["image_uris"] # Check for multiface card
  #       embed.thumbnail = Discordrb::Webhooks::EmbedImage.new(url: body["image_uris"]["normal"])
  #     else
  #       embed.thumbnail = Discordrb::Webhooks::EmbedImage.new(url: body["card_faces"][0]["image_uris"]["normal"])
  #     end
  #     if body["colors"]
  #       embed.color = get_color(body["colors"])
  #     else
  #       embed.color = get_color(body["card_faces"][0]["colors"])
  #     end
  #   end
  # end

  # def get_card_image(event, body)
  #   event.channel.send_embed do |embed|
  #     if body["card_faces"] # Check for multiface card
  #       embed.title = get_title(event, body["card_faces"][0]["name"], body["card_faces"][0]["mana_cost"]) + " // " + get_title(event, body["card_faces"][1]["name"], body["card_faces"][1]["mana_cost"])
  #     else
  #       embed.title = get_title(event, body["name"], body["mana_cost"])
  #     end
  #     embed.url = body["scryfall_uri"]
  #     if body["image_uris"] # Check for multiface card
  #       embed.image = Discordrb::Webhooks::EmbedImage.new(url: body["image_uris"]["normal"])
  #     else
  #       embed.image = Discordrb::Webhooks::EmbedImage.new(url: body["card_faces"][0]["image_uris"]["normal"])
  #     end
  #     if body["colors"]
  #       embed.color = get_color(body["colors"])
  #     else
  #       embed.color = get_color(body["card_faces"][0]["colors"])
  #     end
  #   end
  # end

  # def get_card_legalities(event, body)
  #   event.channel.send_embed do |embed|
  #     if body["card_faces"] # Check for multiface card
  #       embed.title = get_title(event, body["card_faces"][0]["name"], body["card_faces"][0]["mana_cost"]) + " // " + get_title(event, body["card_faces"][1]["name"], body["card_faces"][1]["mana_cost"])
  #     else
  #       embed.title = get_title(event, body["name"], body["mana_cost"])
  #     end
  #     embed.url = body["scryfall_uri"]
  #     body["legalities"].each do |magic_format, legalese|
  #       legality = (legalese == "not_legal" ? "Not Legal" : legalese.capitalize)
  #       embed.add_field(name: magic_format.capitalize, value: legality, inline: true)
  #     end
  #     if body["image_uris"] # Check for multiface card
  #       embed.thumbnail = Discordrb::Webhooks::EmbedImage.new(url: body["image_uris"]["normal"])
  #     else
  #       embed.thumbnail = Discordrb::Webhooks::EmbedImage.new(url: body["card_faces"][0]["image_uris"]["normal"])
  #     end
  #     if body["colors"]
  #       embed.color = get_color(body["colors"])
  #     else
  #       embed.color = get_color(body["card_faces"][0]["colors"])
  #     end
  #   end
  # end

  # def get_card(event, body)
  #   event.channel.send_embed do |embed|
  #     if body["card_faces"] # Check for multiface card
  #       embed.title = get_title(event, body["card_faces"][0]["name"], body["card_faces"][0]["mana_cost"]) + " // " + get_title(event, body["card_faces"][1]["name"], body["card_faces"][1]["mana_cost"])
  #     else
  #       embed.title = get_title(event, body["name"], body["mana_cost"])
  #     end
  #     embed.url = body["scryfall_uri"]
  #     if !body["card_faces"] # Check for multiface card
  #       embed.description = get_card_text(event, body["type_line"], body["oracle_text"], body["power"], body["toughness"], body["loyalty"])
  #     else
  #       embed.description = get_card_text(event, body["card_faces"][0]["type_line"], body["card_faces"][0]["oracle_text"], body["card_faces"][0]["power"], body["card_faces"][0]["toughness"], body["card_faces"][0]["loyalty"])
  #       embed.description += "\n//\n"
  #       embed.description += get_card_text(event, body["card_faces"][1]["type_line"], body["card_faces"][1]["oracle_text"], body["card_faces"][1]["power"], body["card_faces"][1]["toughness"], body["card_faces"][1]["loyalty"])
  #     end
  #     if body["image_uris"] # Check for multiface card
  #       embed.thumbnail = Discordrb::Webhooks::EmbedImage.new(url: body["image_uris"]["normal"])
  #     else
  #       embed.thumbnail = Discordrb::Webhooks::EmbedImage.new(url: body["card_faces"][0]["image_uris"]["normal"])
  #     end
  #     if body["colors"]
  #       embed.color = get_color(body["colors"])
  #     else
  #       embed.color = get_color(body["card_faces"][0]["colors"])
  #     end
  #   end
  # end

  # def get_color(color)
  #   color.length > 1 ? @colors["multi"] : @colors[color[0]]
  # end

  # def get_title(event, name, mana_cost)
  #   if event.server == CONFIG["PADSWAY_ID"]
  #     name + "   " + Manamoji.get_emoji(mana_cost).map! {|e| @bot.find_emoji(e).to_s}.join("")
  #   else
  #     name + "   " + mana_cost
  #   end
  # end

  # def get_card_text(event, type_line, oracle_text, power = nil, toughness = nil, loyalty = nil)
  #   description = type_line + "\n"
  #   if event.server == CONFIG["PADSWAY_ID"]
  #     text_array = oracle_text.split(/\{(.{1,3})\}/)
  #     is_emoji = false
  #     text_array.each do |possible_emoji|
  #       if is_emoji
  #         description += @bot.find_emoji(Manamoji.get_emoji(possible_emoji)[0]).to_s
  #         is_emoji = false
  #       else
  #         description += possible_emoji
  #         is_emoji = true
  #       end
  #     end
  #   else
  #     description += oracle_text
  #   end
    
  #   if power
  #     description += "\n" + power + "/" + toughness
  #   elsif loyalty
  #     description += "\n" + loyalty
  #   end
  #   return description
  # end
end