defmodule Fauxpets do
  use Application
  def start(_args, _opts) do
    children = [
      Fauxpets.Repo,
      :ranch.child_spec({__MODULE__, :listen}, :ranch_tcp, [{:port, 8000}], Fauxpets.Protocol, [])
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
