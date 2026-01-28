defmodule TripleFx do
  @moduledoc """
  Euclid's formula for Pythagorean triples:
    a = m^2 - n^2
    b = 2mn
    c = m^2 + n^2

  Their sum is:
    a + b + c = 2m(m + n)

  For a target sum S:
    2m(m + n) = S
    m(m + n) = S / 2 = s2

  So for each m:
    - m must divide s2
    - Let k = s2 / m
    - Then n = k - m

  And we must enforce invariants:
    - m >= 2
    - n >= 1
    - n < m
    - m(m + 1) <= s2   (because n >= 1 ⇒ m(m+n) >= m(m+1))
  """

  use Funx.Monad.Maybe

  alias TripleFx.{CheckDivisibility, ValidateBounds, BuildTriple, ComputeProduct}

  @spec find_product(pos_integer()) :: Funx.Monad.Maybe.t(pos_integer())
  def find_product(sum) when rem(sum, 2) != 0, do: nothing()

  def find_product(sum) do
    half_sum = div(sum, 2)
    start_from = 2

    start_from
    |> Stream.iterate(&(&1 + 1))
    |> Stream.take_while(within_bounds?(half_sum))
    |> Stream.map(fn candidate ->
      maybe %{half_sum: half_sum, candidate: candidate} do
        bind CheckDivisibility
        bind ValidateBounds
        map BuildTriple
        map ComputeProduct
      end
    end)
    |> Enum.find(nothing(), &just?/1)
  end

  defp within_bounds?(half_sum), do: fn candidate -> candidate * (candidate + 1) <= half_sum end
end
