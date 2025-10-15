defmodule DancingDots.Animation do
  @type dot :: DancingDots.Dot.t()
  @type opts :: keyword
  @type error :: any
  @type frame_number :: pos_integer

  @callback init(options :: opts) :: {:ok, opts} | {:error, error}
  @callback handle_frame(dot :: dot, fnum :: frame_number, options :: opts) :: dot

  defmacro __using__(_) do
    quote do
      @behaviour DancingDots.Animation
      def init(options), do: {:ok, options}
      defoverridable init: 1
    end
  end
end

defmodule DancingDots.Flicker do
  use DancingDots.Animation

  @impl DancingDots.Animation
  def handle_frame(dot, fnum, _options) do
    if rem(fnum, 4) == 0, do: %{dot | opacity: dot.opacity / 2}, else: dot
  end
end

defmodule DancingDots.Zoom do
  use DancingDots.Animation

  @impl DancingDots.Animation
  def init(options) do
    if Keyword.has_key?(options, :velocity) and is_number(Keyword.get(options, :velocity)),
      do: {:ok, options},
      else:
        {:error,
         "The :velocity option is required, and its value must be a number. Got: #{inspect(options[:velocity])}"}
  end

  @impl DancingDots.Animation
  def handle_frame(dot, fnum, options) do
    %{dot | radius: dot.radius + ((fnum - 1) * options[:velocity])}
  end
end
