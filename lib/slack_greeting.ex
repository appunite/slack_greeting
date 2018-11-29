defmodule SlackGreeting do
  @enforce_keys [:otp_app, :hook_url]
  defstruct [:otp_app, :hook_url, :channel_name, enabled: true]

  def child_spec(opts) do
    opts = struct(__MODULE__, opts)

    Task.child_spec(fn -> if opts.enabled, do: send_notification(opts) end)
  end

  defp send_notification(opts) do
    hook_url = String.to_charlist(opts.hook_url)
    channel_name = opts.channel_name
    application = opts.otp_app
    version = fetch_version(opts.otp_app)

    payload = '''
    {
    "icon_emoji": ":white_check_mark:",
    "username": "#{application} (#{Node.self()})",
    "text": "<!here> Hi, I am up with version *#{version}*!",
    "channel": "##{channel_name}",
    }
    '''

    {:ok, _} = :httpc.request(:post, {hook_url, [], 'application/json', payload}, [], [])
  end

  defp fetch_version(otp_app), do: Application.spec(otp_app, :vsn)
end
