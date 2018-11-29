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
      {SlackGreeting,
        hook_url: "YOUR_SLACK_HOOK",
        application: :my_app,
        channel_name: "channel-name"}
    ], strategy: :one_for_one, name: MyApp.Supervisor)
  end
end
```

Optionally, you can pass `enabled` flag that will not send message unless `true`:


```elixir
defmodule MyApp.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
      {SlackGreeting,
        hook_url: "YOUR_SLACK_HOOK",
        application: :my_app,
        channel_name: "channel-name",
        enabled: System.get_env("SEND_NOTIFICATION") == "true"}
    ], strategy: :one_for_one, name: MyApp.Supervisor)
  end
end
```
