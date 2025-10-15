# Use the Plot struct as it is provided
defmodule Plot do
  @enforce_keys [:plot_id, :registered_to]
  defstruct [:plot_id, :registered_to]
end

defmodule CommunityGarden do
  def start(), do: Agent.start_link(fn -> %{counter: 1, plots: []} end)

  def list_registrations(pid), do: Agent.get(pid, fn state -> state.plots end)

  def register(pid, register_to) do
    updated =
      Agent.get_and_update(pid, fn state ->
        {
          %{
            counter: state.counter + 1,
            plots: [%Plot{plot_id: state.counter, registered_to: register_to} | state.plots]
          },
          %{
            counter: state.counter + 1,
            plots: [%Plot{plot_id: state.counter, registered_to: register_to} | state.plots]
          }
        }
      end)

    List.first(updated.plots)
  end

  def release(pid, plot_id),
    do: Agent.update(pid, fn state ->
      %{ counter: state.counter, plots: Enum.reject(state.plots, &(&1.plot_id == plot_id)) } end)


  def get_registration(pid, plot_id) do
    plot = Agent.get(pid, fn state -> Enum.find(state.plots, &(&1.plot_id == plot_id)) end)
    if plot == nil, do: {:not_found, "plot is unregistered"}, else: plot
  end
end
