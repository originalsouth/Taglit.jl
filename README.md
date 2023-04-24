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
This means it implements a data structure that allows multiple tags to be associated with each object it stores.
When looking up an object by the desired tags an intersection operation is performed to find objects that solely tagged by all desired tags.
If that does not make sense go to the test section to see some easy examples, if it still does not make sense you probably not in need of this data structure.
Taglit.jl is implement in Julia and does not use any dependencies other than the Julia standard library.

### Acknowledgements
* [chickenLags](https://github.com/chickenLags) for motivating me to write this
