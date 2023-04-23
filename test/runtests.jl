#!/usr/bin/env julia
using Taglit
using Test

@testset "One Value" begin
    tagmap = Tagmap()
    @test length(tagmap) == 0
    push!(tagmap, "User 1", "Programmer", "Father", "Smart")
    @test length(tagmap) == 3
    @test references(tagmap, "User 1") == Set(["Programmer", "Father", "Smart"])
    @test tagmap["Programmer"] == ["User 1"]
    @test tagmap[["Programmer"]] == ["User 1"]
    @test tagmap[Set(["Programmer"])] == ["User 1"]
    @test tagmap["Programmer", "Father"] == ["User 1"]
    @test tagmap["Programmer", "Father"] == tagmap["Programmer", "Father"]
    push!(tagmap, "User 1", ["Programmer", "Father", "Smart", "Nerd"])
    @test length(tagmap) == 4
    @test references(tagmap, "User 1") == Set(["Programmer", "Father", "Smart", "Nerd"])
    push!(tagmap, "User 1", Set(["Programmer", "Father", "Smart"]))
    @test length(tagmap) == 3
    @test references(tagmap, "User 1") == Set(["Programmer", "Father", "Smart"])
end

@testset "Two Value" begin
    tagmap = Tagmap()
    @test length(tagmap) == 0
    push!(tagmap, "User 1", "Programmer", "Father", "Smart")
    push!(tagmap, "User 2", "Programmer", "Single", "Dumb")
    @test length(tagmap) == 5
    @test references(tagmap, "User 1") == Set(["Programmer", "Father", "Smart"])
    @test references(tagmap, "User 2") == Set(["Programmer", "Single", "Dumb"])
    @test length(tagmap["Programmer"]) == 2
    @test length(tagmap["Father"]) == 1
    push!(tagmap, "User 2", "Programmer", "Father", "Dumb")
    @test references(tagmap, "User 2") == Set(["Programmer", "Father", "Dumb"])
    @test length(tagmap["Father"]) == 2
end
