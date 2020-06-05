# Pipe Operators

Enhancement of Elixir pipe operator (also known as threading macros in Racket and Clojure).

```
import PipeOperators
```

Examples:

```elixir
%{
 first_name: "Michael",
 last_name: "Corleone"
}
~> Map.put(:age, 28)
~>> struct(Something)
```

You can be explicit where to put pipe


```elixir
%{
 first_name: "Michael",
 last_name: "Corleone"
}
~> Map.put(_, :age, 28)
~> struct(Something, _)
```

Then you can use `pipef` (pipe first) or `pipel` (pipe last) to pipe multiple expressions


```
pipef do
 [1, 2, 3, 4]
 Enum.reject(&odd/1)
 Enum.count()
end
```

`pipef` and `pipel` also supports placeholders


```
pipel do
 [1, 2, 3, 4]
 Enum.reject(_, &odd/1)
 Enum.count()
end
```

## Credits

I started from nearly copy pasting [https://github.com/taiansu/pipe_to](taiansu/pipe_to)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `pipe_operators` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:pipe_operators, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/pipe_operators](https://hexdocs.pm/pipe_operators).
