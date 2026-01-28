defmodule TripleFx.BuildTriple do
  @moduledoc """
  Generates a Pythagorean triple {a, b, c} using Euclid's formula.

  Given m and n where m > n:
    a = m² - n²
    b = 2mn
    c = m² + n²
  """
  @behaviour Funx.Monad.Behaviour.Map

  @impl true
  def map(%{m: m, n: n}, _opts, _env) do
    {side_a(m, n), side_b(m, n), hypotenuse(m, n)}
  end

  defp side_a(m, n), do: m * m - n * n
  defp side_b(m, n), do: 2 * m * n
  defp hypotenuse(m, n), do: m * m + n * n
end
