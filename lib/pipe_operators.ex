defmodule PipeOperators do
  defmacro pipef(block) do
    [do: {:__block__, [], expressions}] = block
    [{h, _} | t] = __MODULE__.unpipe({:~>, [], expressions})

    fun = fn {x, pos}, acc ->
      Macro.pipe(acc, x, pos)
    end

    :lists.foldl(fun, h, t)
  end

  defmacro pipel(block) do
    [do: {:__block__, [], expressions}] = block
    [{h, _} | t] = __MODULE__.unpipe({:~>>, [], expressions})

    fun = fn {x, pos}, acc ->
      Macro.pipe(acc, x, pos)
    end

    :lists.foldl(fun, h, t)
  end

  def and_pipel do
    [do: {:__block__, [], expressions}] = block
    [{h, _} | t] = __MODULE__.unpipe({:~>>, [], expressions})

    fun = fn {x, pos}, acc ->
      Macro.pipe(acc, x, pos)
    end

    :lists.foldl(fun, h, t)
  end

  defmacro left ~> right do
    [{h, _} | t] = __MODULE__.unpipe({:~>, [], [left, right]})

    fun = fn {x, pos}, acc ->
      Macro.pipe(acc, x, pos)
    end

    :lists.foldl(fun, h, t)
  end

  defmacro left ~>> right do
    [{h, _} | t] = __MODULE__.unpipe({:~>>, [], [left, right]})

    fun = fn {x, pos}, acc ->
      Macro.pipe(acc, x, pos)
    end

    :lists.foldl(fun, h, t)
  end

  def unpipe(expr) do
    :lists.reverse(unpipe(expr, []))
  end

  defp unpipe({:~>, _, [left, right]}, acc) do
    unpipe(right, unpipe(left, acc), :~>)
  end

  defp unpipe({:~>>, _, [left, right]}, acc) do
    unpipe(right, unpipe(left, acc), :~>>)
  end

  defp unpipe(ast = {_, _, args}, acc, pipe_type) when is_list(args) do
    placeholder_index =
      Enum.find_index(args, &is_placeholder/1)

    fixed_ast = remove_placeholder(ast, placeholder_index)

    [{fixed_ast, pipe_position(placeholder_index, pipe_type)} | acc]
  end

  defp unpipe(other, acc) do
    [{other, 0} | acc]
  end

  defp is_placeholder({:_, _, _}),  do: true
  defp is_placeholder(_), do: false

  defp pipe_position(nil, :~>), do: 1
  defp pipe_position(nil, :~>>), do: -1
  defp pipe_position(index, _pipe_type), do: index

  defp remove_placeholder(ast, nil), do: ast
  defp remove_placeholder({fun, meta, args}, index) do
    {fun, meta, List.delete_at(args, index)}
  end
end
