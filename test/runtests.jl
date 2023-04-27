#!/usr/bin/env julia
using Taglit
using Test
using Random

@testset "One Value" begin
    tagmap = Tagmap()
    @test length(tagmap) == 0
    push!(tagmap, "User 1", "Programmer", "Father", "Smart")
    @test length(references(tagmap)) == 3
    @test references(tagmap, "User 1") == Set(["Programmer", "Father", "Smart"])
    @test tagmap["Programmer"] == ["User 1"]
    @test tagmap[["Programmer"]] == ["User 1"]
    @test tagmap[Set(["Programmer"])] == ["User 1"]
    @test tagmap["Programmer", "Father"] == ["User 1"]
    @test tagmap["Programmer", "Father"] == tagmap["Programmer", "Father"]
    push!(tagmap, "User 1", ["Programmer", "Father", "Smart", "Nerd"])
    @test length(references(tagmap)) == 4
    @test references(tagmap, "User 1") == Set(["Programmer", "Father", "Smart", "Nerd"])
    push!(tagmap, "User 1", Set(["Programmer", "Father", "Smart"]))
    @test length(references(tagmap)) == 3
    @test references(tagmap, "User 1") == Set(["Programmer", "Father", "Smart"])
end

@testset "Two Value" begin
    tagmap = Tagmap()
    @test length(tagmap) == 0
    push!(tagmap, "User 1", "Programmer", "Father", "Smart")
    push!(tagmap, "User 2", "Programmer", "Single", "Dumb")
    @test length(references(tagmap)) == 5
    @test references(tagmap, "User 1") == Set(["Programmer", "Father", "Smart"])
    @test references(tagmap, "User 2") == Set(["Programmer", "Single", "Dumb"])
    @test length(tagmap["Programmer"]) == 2
    @test length(tagmap["Father"]) == 1
    @test length(tagmap["Potato"]) == 0
    push!(tagmap, "User 2", "Programmer", "Father", "Dumb")
    @test references(tagmap, "User 2") == Set(["Programmer", "Father", "Dumb"])
    @test length(tagmap["Father"]) == 2
    @test length(tagmap["Smart"]) == 1
    @test length(tagmap["Dumb"]) == 1
    @test length(tagmap["Potato"]) == 0
end

@testset "Two Symbols" begin
    tagmap = Tagmap(Symbol, Symbol)
    @test length(tagmap) == 0
    push!(tagmap, :User1, :Programmer, :Father, :Smart)
    push!(tagmap, :User2, :Programmer, :Single, :Dumb)
    @test length(references(tagmap)) == 5
    @test references(tagmap, :User1) == Set([:Programmer, :Father, :Smart])
    @test references(tagmap, :User2) == Set([:Programmer, :Single, :Dumb])
    @test length(tagmap[:Programmer]) == 2
    @test length(tagmap[:Father]) == 1
    push!(tagmap, :User2, :Programmer, :Father, :Dumb)
    @test references(tagmap, :User2) == Set([:Programmer, :Father, :Dumb])
    @test length(tagmap[:Father]) == 2
end

@testset "Clear" begin
    tagmap = Tagmap()
    @test length(references(tagmap)) == 0
    @test length(tagmap) == 0
    push!(tagmap, "User 1", "Programmer", "Father", "Smart")
    push!(tagmap, "User 2", "Programmer", "Single", "Dumb")
    @test length(references(tagmap)) == 5
    @test Set(values(tagmap)) == Set(["User 1", "User 2"])
    push!(tagmap, "User 1")
    @test length(references(tagmap)) == 3
    @test Set(values(tagmap)) == Set(["User 2"])
    push!(tagmap, "User 2")
    @test length(references(tagmap)) == 0
    @test length(tagmap) == 0
    push!(tagmap, "User 1")
    push!(tagmap, "User 2")
    @test length(references(tagmap)) == 0
    @test length(tagmap) == 0
end

@testset "Stress" begin
    N = 2^16
    M = 2^4
    K = 2^6
    L = 2^10
    rg = Random.seed!(57)
    objects = [randstring(rg) for _ in 1:N]
    utags = [randstring(rg) for _ in 1:K]
    tagmap = Tagmap()
    @test length(tagmap) == 0
    for object in objects
        push!(tagmap, object, rand(rg, utags, rand(rg, 1:M)))
    end
    @test length(tagmap) == N
    for lookup in rand(rg, reduce(vcat, Iterators.product(utags, utags)), L)
        @test tagmap[lookup...] == tagmap[Set([lookup...])]
    end
    @test length(tagmap) == N
    for object in objects
        push!(tagmap, object)
    end
    @test length(tagmap) == 0
end
