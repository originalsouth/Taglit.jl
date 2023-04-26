# Taglit.jl

A lit `tagmap` implementation

```
# By BC van Zuiden -- Amstelveen, April 2023
# Probably very buggy USE AT OWN RISK this will brick everything you own
# NOBODY but YOU is liable for anything that happened in result of using this
# WARNING: DON'T RUN THIS PROGRAM THIS WILL DESTROY YOUR COMPUTER AND/OR HOUSE
# Any copyrighted piece of code within this code is NOT mine
# Inclusion of that code is forced upon me by a scary anonymous guy with a gun
```

Feel free to reuse and contribute, pull requests are very welcome!
This code is (and forever will be) a work in progress.

Taglit.jl is a quick implementation of a multi label hash map that does an intersection search on the labels when looking up values.
This means it implements a data structure that allows multiple labels or tags to be associated with each object it stores.
When looking up an object by the desired tags, an intersection operation is performed to find objects that are solely tagged by all desired tags.
If that does not make sense, go to the test section to see some easy examples.
If that still does not make sense you probably not in need of this data structure.
Taglit.jl is implement in Julia and does not use any dependencies other than the Julia standard library.

## Basic usage

Creating a tagmap:
```
tagmap = Tagmap()
```

Adding an object:
```
push!(tagmap, "Object", "tag1", "tag2", ...)
push!(tagmap, "Object", ["tag1", "tag2", ...])
push!(tagmap, "Object", Set(["tag1", "tag2", ...]))
```

Finding an object:
```
tagmap["tag1"]
tagmap["tag1", "tag2", ...]
```

Deleting an object:
```
push!(tagmap, "Object")
```

### Acknowledgements
* [chickenLags](https://github.com/chickenLags) for motivating me to write this
