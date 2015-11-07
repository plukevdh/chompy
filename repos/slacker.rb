require 'slack-ruby-client'
require_relative '../models/slack_user'
require_relative '../models/slack_channel'

module Chompy
  class Slacker
    include Singleton

    def initialize(client=Slack::Web::Client.new)
      @client = client
    end

    def channel_member_ids(channel_id)
      resp = @client.channels_info(channel: channel_id)
      resp['channel']['members']
    end

    def all_members
      members = @client.users_list['members']
      members.map {|u| SlackUser.new u }
    end

    def all_channels
      channels = @client.channels_list(exclude_archived: 1)['channels']
      channels.map {|u| SlackChannel.new u }
    end

    def user_by_name(name)
      search_name = name.gsub('@', '')
      all_members.find {|u| u.name == search_name }
    end

    def channel_by_name(name)
      search_name = name.gsub('#', '')
      all_channels.find {|u| u.name == search_name }
    end

    def away(user)
      @client.users_setPresence(user: user, presence: 'away')
    end

    def present(user)
      @client.users_setPresence(user: user, presence: 'auto')
    end

    def away?(user)
      resp = @client.users_getPresence(user: user)
      resp['presence'] == 'away'
    end

  end
end
