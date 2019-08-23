# SlackGreeting

Sends a notification on Slack when the application starts.

## Installation

```elixir
def deps do
  [
    {:slack_greeting, "~> 0.1.0", github: "appunite/slack_greeting"}
  ]
end
```

## Usage

Just add a task to your main supervisor like that:


```elixir
defmodule MyApp.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
      SlackGreeting.task(
        hook_url: "YOUR_SLACK_HOOK",
        application: :my_app,
        channel_name: "channel-name",
        text: "My custom greeting",
        icon_emoji: "heart"
      )
    ], strategy: :one_for_one, name: MyApp.Supervisor)
  end
end
```

Where `text` and `icon_emoji` are optional.

Optionally, you can pass an anonymous function as a `toggle`. If that function
returns a value that is not true, a notification won't be sent:


```elixir
defmodule MyApp.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
      SlackGreeting.task(
        hook_url: "YOUR_SLACK_HOOK",
        application: :my_app,
        channel_name: "channel-name",
        toggle: fn -> System.get_env("SEND_NOTIFICATION") == "true" end
      )
    ], strategy: :one_for_one, name: MyApp.Supervisor)
  end
end
```
