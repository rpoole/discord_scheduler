require 'rake'
require 'active_record'

app = Rake.application
app.init
app.load_rakefile

app['environment'].invoke

module Helpers
  def to_discord_markdown(user_id_str)
    "<@!#{user_id_str}>"
  end
end

class Event < ActiveRecord::Base
  include Helpers

  has_many :event_players

  def to_discord_s
    "Event: #{name}, needed players: #{required_players}, event time: <t:#{start_time}>, ID: #{id}"
  end

  def attending_player_discord_ids_markdown
    event_players.map do |ep|
      to_discord_markdown ep.discord_user_id
    end
  end

  def created_by_discord_id_markdown
    to_discord_markdown(created_by_discord_user_id)
  end

  def to_discord_embed(embed)
    embed.title = "#{name} on <t:#{start_time}>"
    embed.description = "📅 Scheduled by"\
      "\n"\
      "- #{created_by_discord_id_markdown}"\
      "\n"\
      "\n"\
      "🎮 Players (#{event_players.length}/#{required_players})\n"\
      "- #{attending_player_discord_ids_markdown.join(',')}"\
      "\n"\
      "\n"\
      "Type `!join #{id}` to join this event"\
      "\n"\
      "Type `!leave #{id}` to leave this event"\
      "\n"\
      "Type `!delete #{id}` to delete this event if you created it"\

    embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: "Stackly",
                                                        icon_url: "https://cdn.discordapp.com/embed/avatars/0.png")

    embed
  end
end

class EventPlayer < ActiveRecord::Base
  belongs_to :event
  validates_presence_of :event, message: 'not found'
  validates_uniqueness_of :event_id, scope: :discord_user_id, message: "already joined"
end
