defmodule TripleFx.ComputeProduct do
  @moduledoc "Computes product of a Pythagorean triple."
  @behaviour Funx.Monad.Behaviour.Map

  @impl true
  def map({a, b, c}, _opts, _env), do: a * b * c
end
