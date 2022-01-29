defmodule Exquisitle.Runtime.Application do
  use Application

  @super_name GameStarter

  def start(_type, _args) do
    supervisor_spec = [
      {DynamicSupervisor, strategy: :one_for_one, name: @super_name}
    ]

    Supervisor.start_link(supervisor_spec, strategy: :one_for_one)
  end

  def start_game(opts) do
    {:ok, pid} = DynamicSupervisor.start_child(@super_name, {Exquisitle.Runtime.Server, opts})
    pid
  end
end
