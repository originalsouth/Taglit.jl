#!/usr/bin/env julia
using Taglit
using Test

@testset "Creation" begin
    typeset = [String, Symbol, Int64, UInt64, Float64, Set{Int64}, Dict{String, Int64}, Vector{Float64}]
    typeval = ["test", :tests, 12345, UInt64(0xFF), 0.12345, Set([1,1,2,3,4,5]), Dict{String, Int64}(["One" => 1, "Two" => 2]), collect(1.0:17.0)]
    for ((t, u), (x, y)) in zip(Iterators.product(typeset, typeset), Iterators.product(typeval, typeval))
        tagmap = Tagmap(t, u)
        push!(tagmap, x, y)
        @test first(tagmap[y]) == x
        push!(tagmap, x)
        @test isempty(tagmap[y])
    end
end
