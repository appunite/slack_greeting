defmodule SlackGreeting do
  import Supervisor.Spec

  def task(opts \\ []) do
    worker(
      Task,
      [fn -> send_notification(opts) end],
      restart: :temporary,
      id: __MODULE__
    )
  end

  defp send_notification(opts) do
    enabled? = Keyword.get(opts, :toggle, default_toggle())
    hook_url = Keyword.get(opts, :hook_url)
    channel_name = Keyword.get(opts, :channel_name, "app-notification")
    application = Keyword.get(opts, :application)
    version = fetch_version(opts)
    icon_emoji = opts[:icon_emoji] || ":white_check_mark:"
    text = text(opts[:text], version)

    if enabled?.() do
      payload = "{
      'icon_emoji': '#{icon_emoji}',
      'username': '#{to_string(application)} (#{Node.self()})',
      'text': '#{text}',
      'channel': '##{channel_name}',
      'link_names': '1'
      }"

      args = [
        "-X",
        "POST",
        "-H",
        "Content-type: application/json",
        "-d",
        payload,
        hook_url
      ]

      {_resp, _} = System.cmd("curl", args)
    end
  end

  defp default_toggle, do: fn -> true end

  defp fetch_version(opts) do
    opts
    |> Keyword.get(:application)
    |> :application.get_key(:vsn)
    |> elem(1)
    |> List.to_string()
  end

  defp text(message, version) when is_binary(message) do
    message <> " Version: *#{version}*"
  end

  defp text(_, version) do
    "<!here> Hi, I am up with version *#{version}*!"
  end
end
