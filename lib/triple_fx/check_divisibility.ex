defmodule TripleFx.CheckDivisibility do
  @moduledoc """
  Checks if half_sum is evenly divisible by the candidate m.

  If divisible, computes quotient (which becomes m + n in Euclid's formula).
  """
  @behaviour Funx.Monad.Behaviour.Bind

  alias Funx.Monad.Maybe

  @impl true
  def bind(%{half_sum: half_sum, candidate: candidate}, _opts, _env) do
    half_sum
    |> Maybe.lift_predicate(divisible_by(candidate))
    |> Funx.Monad.map(compute_quotient(candidate))
  end

  defp divisible_by(candidate), do: fn half_sum -> rem(half_sum, candidate) == 0 end

  defp compute_quotient(candidate),
    do: fn half_sum -> %{candidate: candidate, quotient: div(half_sum, candidate)} end
end
