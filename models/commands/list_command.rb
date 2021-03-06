module Chompy
  class ListCommand
    def initialize(cmd, context)
      @cmd = cmd.strip
      @context = context

      @location = format_channel(@context.channel_id, @context.channel_name)
    end

    def run
      return many_response channel_chompies(@context.channel_id) if here?
      return many_response channel_chompies(get_channel(@cmd)) if channel_provided?
      return single_response(@cmd) if user_provided?

      many_response all_chompies, "everywhere"
    end

    def type
      'ephemeral'
    end

    private

    def many_response(users, location=@location)
      statuses = users.empty? ?
        ":foreveralone:" :
        users.map {|u| format_name(u)}.join(', ')

      "Currently :chompy: #{location}: #{statuses}"
    end

    def single_response(username)
      user = Slacker.instance.user_by_name(username)
      status = user_status(user)

      "#{user.slack_name} #{status}"
    end

    def format_name(user)
      "<@#{user}>"
    end

    def format_channel(id, name)
      "in <##{id}|#{name}>"
    end

    def here?
      @cmd.start_with? '@here'
    end

    def user_provided?
      @cmd.start_with? '@'
    end

    def channel_provided?
      @cmd.start_with? '#'
    end

    def channel_chompies(channel_id)
      channelers = Slacker.instance.channel_member_ids(channel_id)
      chompers = Statuses.instance.all.keys

      channelers & chompers
    end

    def all_chompies
      Statuses.instance.all.keys
    end

    def get_channel(name)
      channel = Slacker.instance.channel_by_name(name)
      @location = format_channel(channel.id, channel.name)

      channel.id
    end

    def user_status(user)
      user = Statuses.instance.find(user.id)

      if user.away?
        "has been :chompy: #{user.status} since #{user.away_in_words}"
      else
        "is currently not :chompy:"
      end
    end
  end
end
