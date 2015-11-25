# Chompy

> The status tracker Slack forgot.

## Install

The Chompy service was built to run via Docker in the AWS ecosystem via ElasticBeanstalk. Other Docker environments can be used.

You'll need to follow your own setup procedures to launch it in EB because it takes too many steps to write down here. Good luck!

Otherwise, you can use Docker alone or your own standalone hosting solution. The only requirement is you will need a Redis instance available to the app. You'll need to get that setup and add the `REDIS_URL` environment variable set.

## Slack integration

This service is built for slack integration and requires two configuration parts and one token:

1. The [slash command](https://api.slack.com/slash-commands): You'll need a slash command setup to trigger the away/present toggle. We use `/chompy` for ours, as the project name suggests. This is because of our lovable `:chompy:` emoji:

  ![chompy emoji](http://d.pr/i/GNme/51hC7aDO+)

  We definitely recommend using this little guy as well.

  Okay back to the slash command. You'll want to set it up to make a POST request to `https://my-chompy-server.example.com/slack/chompy`, the path (`/slack/chompy`) being the important part. Slack also generally requires that commands be sent to HTTPS endpoints, so watch for that. We named that command... Chompy (big surprise). All other settings are pretty open to you.

  Lastly, save the command token provided in the configuration screen. We'll need that in a sec.

2. You'll also need an [incoming web hook](https://api.slack.com/incoming-webhooks) for command responses. You'll select a default channel, but it's irrelevant as the responder will send it to the channel that the command was triggered from. For safety's sake I recommend the use of a low-populated channel by default in case errors happen or something is misconfigured. No accidental message blasts to #general. You'll probably want to label the name of this webhook the same as the slash command (again, ours is Chompy). If you specified a logo for the slash command, use it here as well. Helps for a nice uniform integration of the two components. All you really care about from this endpoint is the webhook url. Hold on to this for a hot minute.

3. Obtain an auth token for your API. This can either be via a [bot user](https://api.slack.com/bot-users) specific for this, or you can generate a [personal one](https://api.slack.com/web) for use with the normal web APIs for the account you wish to use.

Okay, with the command token, the webhook url and the api token in hand, you can set the environment params for the slack integration for your app.

- `SLACK_TOKEN` = your api token
- `SLASH_COMMAND_TOKEN` = the slash command token
- `SLACK_RESPONSE_HOOK` = the url from your incoming webhook integration.

With those and the `REDIS_URL` to your Redis instance, you're good to go!

## Development / Local Runtime

So long as you have [Docker](https://docs.docker.com/engine/installation/mac/) and [Docker Compose](https://docs.docker.com/compose/) installed and running (via [docker-machine](https://docs.docker.com/machine/) on OSX):

`docker-compose build` then `docker-compose up`.

This will spin up the app and the Redis instance. If you have a way to proxy the calls from Slack to your local machine to be available externally (with something like [ngrok](https://ngrok.com/)), then you can test it against your real Slack, so long as your webhook and slash command are setup to point at your local endpoint.

## Usage

This service comes with a few commands:

- `/chompy [my away message]` will toggle your presence. `[my away message]` will be used as your away message of sorts, though it is entirely optional.
- `/chompy status [qualifier]` reports the status of users. You can add the following qualifiers: `@username` to get the status (and message) for a specific user, `@here` to get the status of all users in the current channel and `#channel` to get the statuses of users in the specified channel. In the absence of any qualifiers, it will show the status of all users across your Slack instance.

Lastly, if no one is away, it will give the `:foreveralone:` emoji status. For that to work, you need the `:foreveralone:` emoji. Here you go:

![foreveralone](http://d.pr/i/11Rps/4wGBNgyF+)

## Caveats

These commands will not work from private channels and DMs, as slack has outlawed the use of non-bot integrations in these venues (due to securitah concerns).
