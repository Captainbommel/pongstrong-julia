###############################################################################
#  Julia Cheat Sheet — Interactive Demo
#  Run this file to see every feature from the README in action.
#  julia> include("cheatsheet_demo.jl")
###############################################################################

println("=" ^ 60)
println("  Julia Cheat Sheet Demo")
println("=" ^ 60)


# ——— Numbers & Types ———
println("\n### 1 — Numbers & Types ###\n")

# Binary representation
println("bitstring(0.1)  = ", bitstring(0.1))

# Approximate equality (≈)
println("0.1 + 0.2 ≈ 0.3 ? ", 0.1 + 0.2 ≈ 0.3)

# Rationals
println("1//3 + 1//6    = ", 1//3 + 1//6)

# Underscores in literals
big_number = 1_000_000_000
println("1_000_000_000  = ", big_number)

# Scientific notation
println("10e5           = ", 10e5)

# Cube root
println("cbrt(8)        = ", cbrt(8))

# Strict equality (=== checks type too)
println("3.0 === 3      ? ", 3.0 === 3)
println("3.0 == 3       ? ", 3.0 == 3)

# Unicode variable names
⛄ = 5
🐶 = 42
println("⛄ = ", ⛄, "   🐶 = ", 🐶)

# Symbols
color = :magenta
println("typeof(:magenta) = ", typeof(color))

# Styled printing
printstyled("  This text is bold magenta!\n", bold=true, color=:magenta)

# Method listing (first 5)
println("methods(+) count = ", length(methods(+)))

# Type hierarchy
println("Float64 <: AbstractFloat ? ", Float64 <: AbstractFloat)
println("Int64   <: Integer       ? ", Int64 <: Integer)

# findall
X = [3, 1, 4, 1, 5, 9, 2, 6, 5, 3]
println("X = ", X)
println("findall(isequal(1), X) = ", findall(isequal(1), X))
println("findall(x -> x > 4, X) = ", findall(x -> x > 4, X))


# ——— Strings ───
println("\n### 2 — Strings ###\n")

# Escape sequences
println("Escape sequences: \" \\n \\t \\\$")

# Concatenation with *
println("\"Hello\" * \" World\" = ", "Hello" * " World")

# Repetition with ^
println("\"ab\"^3 = ", "ab"^3)

# Parse ↔ string
println("parse(Int, \"42\") = ", parse(Int, "42"))
println("string(42)        = ", string(42))

# Case conversion
println("lowercase(\"HELLO\") = ", lowercase("HELLO"))
println("uppercase(\"hello\") = ", uppercase("hello"))

# Reverse
println("reverse(\"Julia\")   = ", reverse("Julia"))

# occursin
println("occursin(\"ell\", \"Hello\") = ", occursin("ell", "Hello"))

# replace
println("replace(\"Hello\", \"ell\" => \"XYZ\") = ", replace("Hello", "ell" => "XYZ"))

# split & join
parts = split("a,b,c,d", ",")
println("split(\"a,b,c,d\", \",\") = ", parts)
println("join([\"a\",\"b\",\"c\"], \"-\") = ", join(["a","b","c"], "-"))


# ——— Collections ────
println("\n### 3 — Collections ###\n")

# Dicts
println("— Dicts —")
d = Dict("A" => 1, "B" => 2, "C" => 3)
println("d = ", d)
println("d[\"A\"] = ", d["A"])

d["E"] = 5
println("After d[\"E\"] = 5 : ", d)

println("keys(d)   = ", collect(keys(d)))
println("values(d) = ", collect(values(d)))

d2 = Dict("X" => 10, "Y" => 20)
println("merge(d, d2) = ", merge(d, d2))

popped = pop!(d, "E")
println("pop!(d, \"E\") = ", popped, "  d is now ", d)

println("\"A\" in keys(d) ? ", "A" in keys(d))

# Arrays
println("\n— Arrays —")
A = collect(1:20)
println("A = 1:20")
println("A[2:2:20] = ", A[2:2:20])
println("extrema(A) = ", extrema(A))

# Membership
println("5 in A  ? ", 5 in A)
println("5 ∈ A   ? ", 5 ∈ A)

# Swap variables
x = 1; y = 2
println("Before swap: x=$x, y=$y")
(x, y) = (y, x)
println("After  swap: x=$x, y=$y")

# Transpose
M = [1 2 3; 4 5 6]
println("M  = ", M)
println("M' = ", M')

# Fill helpers
println("fill(π, 2, 3) = ", fill(π, 2, 3))
println("zeros(3)  = ", zeros(3))
println("ones(3)   = ", ones(3))
println("trues(3)  = ", trues(3))
println("falses(3) = ", falses(3))

# Concatenation
A1 = [1, 2, 3]; A2 = [4, 5, 6]
println("vcat(A1, A2) = [A1; A2] = ", vcat(A1, A2))
println("hcat(A1, A2) = [A1 A2]  = ", hcat(A1, A2))

# Set operations
S1 = [1, 2, 3, 4]; S2 = [3, 4, 5, 6]
println("union(S1, S2)     = ", union(S1, S2))
println("intersect(S1, S2) = ", intersect(S1, S2))

# Named tuples
nt = (name="Julia", version=1.11)
println("Named tuple: ", nt)
println("nt.name = ", nt.name)


# ——— Ranges & Comprehensions ───
println("\n### 4 — Ranges & Comprehensions ###\n")

# Range with steps
r = collect(range(0, 10, length=5))
println("range(0, 10, length=5) = ", r)

# Char ranges
println("'a':'e'  = ", collect('a':'e'))
println("'e':-1:'a' = ", collect('e':-1:'a'))
println("'α':'ε'  = ", collect('α':'ε'))

# List comprehension
squares = [x^2 for x in 1:10]
println("[x^2 for x in 1:10] = ", squares)

# 2-D comprehension
grid = [i + j for i in 1:3, j in 1:3]
println("[i+j for i in 1:3, j in 1:3] =")
display(grid)
println()

# Dict comprehension
dc = Dict(k => k^2 for k in 1:5)
println("Dict(k => k^2 for k in 1:5) = ", dc)

# FizzBuzz
println("\nFizzBuzz 1–30:")
fizzbuzz = [i % 15 == 0 ? "FizzBuzz" : i % 3 == 0 ? "Fizz" : i % 5 == 0 ? "Buzz" : string(i) for i in 1:30]
println(fizzbuzz)

println("\n", "=" ^ 60)
println("  Done! 🎉")
println("=" ^ 60)
