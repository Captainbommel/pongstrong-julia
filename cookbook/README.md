# Julia Cookbook

A quick reference for some Julia idioms and features. See [`cookbook.jl`](cookbook.jl) for runnable examples of everything listed here. 

I originally created this because I thought I would need to upgrade my Julia skills for the Project. I left this in because I genuinely forgot a lot of these.

---

## Numbers & Types

| Feature | Example |
|---|---|
| Binary representation | `bitstring(0.1)` |
| Variable info | `varinfo()` |
| Approximate equality | `0.1 + 0.2 ≈ 0.3` |
| Rationals | `1//3` |
| Underscores in literals | `1_000_000_000` |
| Scientific notation | `10e5` |
| Cube root | `cbrt(8)` |
| Strict equality | `3.0 === 3` → `false` |
| Unicode variable names | `⛄ = 5`, `🐶 = 42` |
| Symbols | `color = :magenta` |
| Styled printing | `printstyled("Hello", bold=true, color=:magenta)` |
| Method listing | `methods(+)` |
| Type hierarchy | `AbstractFloat`, `Integer`, `Float64` (primitive) |
| Naming convention | CamelCase for composite types |
| Find all matching | `findall(isequal(x), X)` / `findall(v -> v == x, X)` |

---

## Strings

| Feature | Example |
|---|---|
| Escape sequences | `\"`, `\n`, `\t`, `\$` |
| Concatenation | `"Hello" * " World"` → `"Hello World"` |
| Repetition | `"ab"^3` → `"ababab"` |
| Read input | `readline()` |
| Parse / stringify | `parse(Int, "42")` ↔ `string(42)` |
| Case conversion | `lowercase("HI")`, `uppercase("hi")` |
| Reverse | `reverse("abc")` → `"cba"` |
| Substring check | `occursin("ell", "Hello")` |
| Replace | `replace("Hello", "ell" => "XYZ")` |
| Split / join | `split("a,b,c", ",")`, `join(["a","b","c"], ",")` |

---

## Collections

### Dicts
```julia
d = Dict("A" => 1, "B" => 2, "C" => 3)
d["A"]          # access
d["E"] = 5      # add
keys(d)         # keys
values(d)       # values
merge(d1, d2)   # merge dicts
pop!(d, "A")    # remove key
push!(d, "F" => 6)
"A" in keys(d)  # membership
```

### Arrays & Tuples
| Feature | Example |
|---|---|
| Slice with step | `A[2:2:20]` |
| Extremes | `extrema(A)` → `(min, max)` |
| Membership | `x in A` or `x ∈ A` |
| Swap variables | `(x, y) = (y, x)` |
| Transpose | `A'` |
| Fill array | `fill(π, 5, 5)`, `zeros(5)`, `ones(5)`, `trues(5)`, `falses(5)` |
| Vertical concat | `vcat(A, B)` or `[A; B]` |
| Horizontal concat | `hcat(A, B)` or `[A B]` |
| Set union | `union(A, B)` |
| Set intersect | `intersect(A, B)` |
| Named tuples | `(name="Julia", version=1.11)` — struct-like but immutable |

> **Tip:** Tuples are immutable and very memory-efficient.

---

## Ranges & Comprehensions

| Feature | Example |
|---|---|
| Range with steps | `collect(range(0, 10, length=20))` |
| Char ranges | `'a':'z'`, `'z':-1:'a'`, `'α':'ω'` |
| List comprehension | `[x^2 for x in 1:10]` |
| 2-D comprehension | `[i+j for i in 1:5, j in 1:5]` |
| Dict comprehension | `Dict(k => k^2 for k in 1:5)` |

### FizzBuzz one-liner
```julia
[i % 15 == 0 ? "FizzBuzz" : i % 3 == 0 ? "Fizz" : i % 5 == 0 ? "Buzz" : i for i in 1:30]
```

---

*Run `cookbook.jl` to see all of the above in action.*
