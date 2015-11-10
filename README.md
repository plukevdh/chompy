## Chompy Tracker ![:chompy:](https://psr.slack.com/emoji/chompy/3f6fe5cb31c69b3d.gif)

Track who's away for lunch and over time, build a "usually away at" schedule so you know when not to try to ping someone who might otherwise be needing to :chompy:

### Slack Integration

Toggling your :chompy: status:

- Lunch is just a `/chompy` away
- Tell chompy your menu options `/chompy :chicken:`

Status Reporting:

- `/chompy status` => list of all current chompers system-wide. Chompapalooza!
- `/chompy status @username` => status of a particular chomper
- `/chompy status @here` or `/chompy status #channel` => status of chompers in a particular channel

**Never be alone at lunch!**

### Status API

Write your own integration from our wide variety of chompy related data.

Check out our sweet [available routes](/endpoints/status_api.rb).

### Developer setup

1. Install [Docker Toolbox](https://www.docker.com/docker-toolbox) and follow the getting started guide to get docker up and running
2. Clone this repo: `git clone https://github.com/plukevdh/chompy.git`
  - **Note:** On Windows, you will need to clone the repo into your C:\Users\ folder for now
3. `cd` into your freshly cloned repo
4. Get a slack token for your user account from the [Slack Web API page](https://api.slack.com/web)
4. Create a `.env` file in the root of the repo and add `SLACK_TOKEN=[your-slack-toekn]` to the `.env` file you created
3. From within the repo's root directory:
  - `docker-compose build`
  - `docker-compose up`
4. Point your browser to http://192.168.99.100:9393 (or whatever IP is reported by `docker-machine ip default`)
5. :chompy: