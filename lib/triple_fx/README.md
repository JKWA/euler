# TripleFx

Finds a Pythagorean triple with a given perimeter and returns its product.

## Usage

```elixir
TripleFx.find_product(1000)
#=> %Funx.Monad.Maybe.Just{value: 31875000}

TripleFx.find_product(999)
#=> %Funx.Monad.Maybe.Nothing{}
```

## The Problem

Given a perimeter (sum), find integers `{a, b, c}` where:
- `a² + b² = c²` (Pythagorean triple)
- `a + b + c = sum` (perimeter constraint)

Return the product `a * b * c`.

## The Algorithm

Uses [Euclid's formula](https://en.wikipedia.org/wiki/Pythagorean_triple#Generating_a_triple) to generate triples efficiently.

Given parameters `m` and `n` where `m > n >= 1`:
```
a = m² - n²
b = 2mn
c = m² + n²
```

The perimeter is `a + b + c = 2m(m + n)`.

For a target sum: `m(m + n) = sum / 2`

## The Pipeline

```elixir
maybe %{half_sum: half_sum, candidate: candidate} do
  bind CheckDivisibility    # half_sum divisible by candidate?
  bind ValidateBounds       # n = quotient - candidate valid?
  map BuildTriple           # {m, n} → {a, b, c}
  map ComputeProduct        # {a, b, c} → a * b * c
end
```

## Data Flow

```
%{half_sum: 500, candidate: 20}
    ↓ CheckDivisibility
%{candidate: 20, quotient: 25}
    ↓ ValidateBounds
%{m: 20, n: 5}
    ↓ BuildTriple
{375, 200, 425}
    ↓ ComputeProduct
31875000
```

## Modules

| Module | Type | Purpose |
|--------|------|---------|
| `CheckDivisibility` | Bind | Checks if `half_sum % candidate == 0`, computes quotient |
| `ValidateBounds` | Bind | Validates `1 <= n < m`, returns Either for validation semantics |
| `BuildTriple` | Map | Applies Euclid's formula to produce `{a, b, c}` |
| `ComputeProduct` | Map | Computes `a * b * c` |

## Built With

[Funx](https://github.com/JKWA/funx) - Functional programming utilities for Elixir, using the Maybe DSL with Bind/Map behaviours.
