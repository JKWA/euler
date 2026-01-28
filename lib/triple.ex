defmodule Triple do
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

  @spec triple(pos_integer(), pos_integer()) :: {pos_integer(), pos_integer(), pos_integer()}
  def triple(m, n) when m > n do
    {
      m * m - n * n,
      2 * m * n,
      m * m + n * n
    }
  end

  @spec candidate_n(pos_integer(), pos_integer()) :: {:ok, pos_integer()} | :error
  def candidate_n(s2, m) do
    with true <- rem(s2, m) == 0,
         k = div(s2, m),
         n = k - m,
         true <- n > 0 and n < m do
      {:ok, n}
    else
      _ -> :error
    end
  end

  @spec find_product(pos_integer()) :: {:ok, pos_integer()} | :error
  def find_product(sum) when rem(sum, 2) != 0, do: :error

  def find_product(sum) do
    s2 = div(sum, 2)

    2
    |> Stream.iterate(&(&1 + 1))
    |> Stream.take_while(fn m -> m * (m + 1) <= s2 end)
    |> Enum.find_value(:error, fn m ->
      case candidate_n(s2, m) do
        {:ok, n} ->
          {a, b, c} = triple(m, n)
          {:ok, a * b * c}

        :error ->
          nil
      end
    end)
  end
end
