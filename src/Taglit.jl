module Taglit

export Tagmap, references

struct Object{T}
    data::T
    references::Set{String}
end
Object(value::T) where T = Object(value, Set{String}())
data(object::Object) = object.data
references(object::Object) = object.references
key(object::Object) = hash(object.data)

struct Tagmap
    references::Dict{String, Set{UInt}}
    objects::Dict{UInt, Object}
end
Tagmap() = Tagmap(Dict{String, Set{UInt}}(), Dict{UInt, Object}())
references(container::Tagmap) = container.references
references(container::Tagmap, value::T) where T = references(objects(container)[key(Object(value))])
objects(container::Tagmap) = container.objects
Base.keys(container::Tagmap) = keys(objects(container))
Base.values(container::Tagmap) = values(objects(container))
Base.length(container::Tagmap) = length(references(container))

function Base.push!(container::Tagmap, value::Object)
    k = key(value)
    if haskey(objects(container), k)
        for reference in setdiff(references(value), references(objects(container)[k]))
            if haskey(container.references, reference)
                push!(container.references[reference], k)
            else
                push!(container.references, reference => Set(k))
            end
        end
        for reference in setdiff(references(objects(container)[k]), references(value))
            pop!(container.references[reference], k)
            if isempty(container.references[reference])
                pop!(container.references, reference)
            end
        end
        if isempty(references(value))
            pop!(container.objects, k)
        else
            push!(objects(container), k => value)
        end
    else
        push!(container.objects, k => value)
        for reference in references(value)
            if haskey(container.references, reference)
                push!(container.references[reference], k)
            else
                push!(container.references, reference => Set(k))
            end
        end
    end
    return container
end
Base.push!(container::Tagmap, value::T, args::Set{String}) where T = push!(container, Object(value, args))
Base.push!(container::Tagmap, value::T, args::String...) where T = push!(container, Object(value, Set([args...])))
Base.push!(container::Tagmap, value::T, args::Vector{String}) where T = push!(container, Object(value, Set(args)))

function Base.getindex(container::Tagmap, args::Set{String})
    targets = [references(container)[arg] for arg in args]
    return isempty(targets) ? nothing : data.([objects(container)[target] for target in intersect(targets...)])
end
Base.getindex(container::Tagmap, args::Vector{String}) = getindex(container, Set(args))
Base.getindex(container::Tagmap, args::String...) = getindex(container, Set([args...]))

end
