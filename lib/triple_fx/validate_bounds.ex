defmodule TripleFx.ValidateBounds do
  @moduledoc """
  Validates that n = quotient - candidate satisfies Euclid's constraint: 1 <= n < m.

  If valid, produces %{m: m, n: n} for Euclid's formula.
  """
  @behaviour Funx.Monad.Behaviour.Bind

  alias Funx.Monad.Either

  @impl true
  def bind(%{candidate: candidate, quotient: quotient}, _opts, _env) do
    n = quotient - candidate

    n
    |> Either.lift_predicate(valid_for_euclid?(candidate), invalid_bounds())
    |> Funx.Monad.map(to_params(candidate))
  end

  defp valid_for_euclid?(m), do: fn n -> n >= 1 and n < m end

  defp invalid_bounds, do: fn _n -> :invalid_bounds end

  defp to_params(m), do: fn n -> %{m: m, n: n} end
end
