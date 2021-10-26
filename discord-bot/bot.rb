# frozen_string_literal: true

require 'discordrb'
require 'chronic'
require_relative 'db/models'

bot = Discordrb::Commands::CommandBot.new token: ENV['DISCORD_BOT_TOKEN'], prefix: '!'

bot.command(:stackly, min_args: 2) do |bot_event, *args|
  event_and_needed_players = args[0]
  event_time = Chronic.parse(args[1..].join(" ")).to_i

  needed_players = 0
  if event_and_needed_players.include? ":"
    name, needed_players = event_and_needed_players.split(":")
  else
    name = event_and_needed_players
  end

  ActiveRecord::Base.transaction do
    created_event = Event.create(
      created_by_discord_user_id: bot_event.user.id,
      discord_server_id: bot_event.server.id,
      start_time: event_time,
      name: name,
      required_players: needed_players
    )

    created_event.event_players.create(
      discord_user_id: bot_event.user.id
    )

    bot_event.channel.send_embed(&created_event.method(:to_discord_embed))
  end
end

bot.command(:events, max_args: 0) do |bot_event|
  events = Event.where(discord_server_id: bot_event.server.id).order(created_at: :desc)

  return "No events to show" if events.empty?

  events.each do |event|
    bot_event.channel.send_embed(&event.method(:to_discord_embed))
  end

  nil
end

bot.command(:join, min_args: 1, max_args: 1) do |bot_event, event_id|
  event_player = EventPlayer.create(
    event_id: event_id,
    discord_user_id: bot_event.user.id
  )

  return "Unable to join event: #{event_player.errors.full_messages.join(',')}" unless event_player.valid?

  bot_event.channel.send_embed(&event_player.event.method(:to_discord_embed))
end

bot.command(:delete, min_args: 1, max_args: 1) do |bot_event, event_id|
  deleted_count = Event.delete_by(
    created_by_discord_user_id: bot_event.user.id,
    id: event_id,
    discord_server_id: bot_event.server.id
  )

  if deleted_count.zero?
    created_by_discord_user_id = Event.where(id: event_id).pluck(:created_by_discord_user_id).first
    if !created_by_discord_user_id.nil? && created_by_discord_user_id != bot_event.user.id
      return "You must be the event creator to delete"
    end
  end

  return "Unable to delete event" if deleted_count.zero?

  return "Deleted event #{event_id}"
end

bot.command(:leave, min_args: 1, max_args: 1) do |bot_event, event_id|
  deleted_count = EventPlayer.delete_by(
    event_id: event_id,
    discord_user_id: bot_event.user.id
  )

  if deleted_count.zero?
    user_attending_event = EventPlayer.where(id: event_id, discord_user_id: bot_event.user.id).exists?

    return "Unable to leave event you have not joined" unless user_attending_event
  end

  return "Unable to leave event #{event_id}" unless deleted_count == 1

  event = Event.find(event_id)
  bot_event.channel.send_embed(&event.method(:to_discord_embed))
end

bot.run
