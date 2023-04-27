module Taglit

export Tagmap, references

struct Object{T, U}
    data::T
    references::Set{U}
end
Object(value::T, ::Type{U} = String) where {T, U} = Object(value, Set{U}())
data(object::Object) = object.data
references(object::Object) = object.references
key(object::Object) = hash(object.data)

function Base.show(io::IO, ::MIME"text/plain", object::Object)
    show(io, "text/plain", data(object))
    print(io, " <= $(collect(references(object)))")
end

struct Tagmap{T, U}
    references::Dict{U, Set{UInt}}
    objects::Dict{UInt, Object{T, U}}
end
Tagmap(::Type{T} = String, ::Type{U} = String) where {T, U} = Tagmap(Dict{U, Set{UInt}}(), Dict{UInt, Object{T, U}}())
objecttype(_::Tagmap{T, U}) where {T, U} = T
referencetype(_::Tagmap{T, U}) where {T, U} = U
references(tagmap::Tagmap) = tagmap.references
references(tagmap::Tagmap, value) = references(objects(tagmap)[key(Object(value))])
objects(tagmap::Tagmap) = tagmap.objects
Base.keys(tagmap::Tagmap) = keys(objects(tagmap))
Base.values(tagmap::Tagmap) = data.(values(objects(tagmap)))
Base.length(tagmap::Tagmap) = length(objects(tagmap))

function Base.show(io::IO, ::MIME"text/plain", tagmap::Tagmap{T, U}) where {T, U}
    print(io, "$(length(tagmap))-element Tagmap{$T, $U}:")
    for value in collect(values(objects(tagmap)))
        print(io, "\n ")
        show(io, "text/plain", value)
    end
end

function Base.push!(tagmap::Tagmap{T, U}, value::Object{T, U}) where {T, U}
    k = key(value)
    if haskey(objects(tagmap), k)
        for reference in setdiff(references(value), references(objects(tagmap)[k]))
            if haskey(tagmap.references, reference)
                push!(tagmap.references[reference], k)
            else
                push!(tagmap.references, reference => Set(k))
            end
        end
        for reference in setdiff(references(objects(tagmap)[k]), references(value))
            pop!(tagmap.references[reference], k)
            if isempty(tagmap.references[reference])
                pop!(tagmap.references, reference)
            end
        end
        if isempty(references(value))
            pop!(tagmap.objects, k)
        else
            push!(objects(tagmap), k => value)
        end
    else
        if !isempty(references(value))
            push!(tagmap.objects, k => value)
            for reference in references(value)
                if haskey(tagmap.references, reference)
                    push!(tagmap.references[reference], k)
                else
                    push!(tagmap.references, reference => Set(k))
                end
            end
        end
    end
    return tagmap
end
Base.push!(tagmap::Tagmap{T, U}, value::T, args::Set{U}) where {T, U} = push!(tagmap, Object{T, U}(value, args))
Base.push!(tagmap::Tagmap{T, U}, value::T, args::U...) where {T, U} = push!(tagmap, Object(value, Set{U}(args)))
Base.push!(tagmap::Tagmap{T, U}, value::T, args::Vector{U} = U[]) where {T, U} = push!(tagmap, Object(value, Set{U}(args)))

function Base.getindex(tagmap::Tagmap{T, U}, args::Set{U}) where {T, U}
    targets = [references(tagmap)[arg] for arg in filter(x -> haskey(references(tagmap), x), args)]
    return isempty(targets) ? empty(values(tagmap)) : data.([objects(tagmap)[target] for target in intersect(targets...)])
end
Base.getindex(tagmap::Tagmap{T, U}, args::Vector{U} = U[]) where {T, U} = getindex(tagmap, Set{U}(args))
Base.getindex(tagmap::Tagmap{T, U}, args::U...) where {T, U} = getindex(tagmap, Set{U}([args...]))

end
