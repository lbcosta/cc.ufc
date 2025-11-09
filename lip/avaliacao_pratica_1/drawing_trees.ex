defmodule TreeDrawer do
  @scale 30

  def example_tree do
    %{
      key: "a",
      val: 111,
      left: %{
        key: "b",
        val: 55,
        left: %{
          key: "x",
          val: 100,
          left: %{
            key: "z",
            val: 56,
            left: :leaf,
            right: :leaf
          },
          right: %{
            key: "w",
            val: 23,
            left: :leaf,
            right: :leaf
          }
        },
        right: %{
          key: "y",
          val: 105,
          left: :leaf,
          right: %{
            key: "r",
            val: 77,
            left: :leaf,
            right: :leaf
          }
        }
      },
      right: %{
        key: "c",
        val: 123,
        left: %{
          key: "d",
          val: 119,
          left: %{
            key: "g",
            val: 44,
            left: :leaf,
            right: :leaf
          },
          right: %{
            key: "h",
            val: 50,
            left: %{
              key: "i",
              val: 5,
              left: :leaf,
              right: :leaf
            },
            right: %{
              key: "j",
              val: 6,
              left: :leaf,
              right: :leaf
            }
          }
        },
        right: %{
          key: "e",
          val: 133,
          left: :leaf,
          right: :leaf
        }
      }
    }
  end

  def draw(tree) do
    tree_with_coord_fields = add_xy(tree)
    {final_tree, _, _} =
      depth_first(tree_with_coord_fields, 1, @scale)

    final_tree
  end

  # Add XY
  # - Caso 1: folha
  defp add_xy(:leaf), do: :leaf
  # - Caso 2: árvore
  defp add_xy(node = %{left: l, right: r}) do
    new_l = add_xy(l)
    new_r = add_xy(r)
    node
    |> Map.put(:left, new_l)
    |> Map.put(:right, new_r)
    |> Map.merge(%{x: nil, y: nil})
  end

  # Depth First Traversal
  # - Caso 1: folha, folha
  defp depth_first(node = %{left: :leaf, right: :leaf}, level, left_lim) do
    root_x = left_lim
    right_lim = left_lim
    y = @scale * level

    updated_node = Map.merge(node, %{x: root_x, y: y})

    {updated_node, root_x, right_lim}
  end
  # - Caso 2: árvore, folha
  defp depth_first(node = %{left: l, right: :leaf}, level, left_lim) do
    y = @scale * level

    {updated_l, l_root_x, l_right_lim} =
      depth_first(l, level + 1, left_lim)

    root_x = l_root_x
    right_lim = l_right_lim

    updated_node =
      node
      |> Map.merge(%{x: root_x, y: y})
      |> Map.put(:left, updated_l)

    {updated_node, root_x, right_lim}
  end
  # - Caso 3: folha, árvore
  defp depth_first(node = %{left: :leaf, right: r}, level, left_lim) do
    y = @scale * level

    {updated_r, r_root_x, r_right_lim} =
      depth_first(r, level + 1, left_lim)

    root_x = r_root_x
    right_lim = r_right_lim

    updated_node =
      node
      |> Map.merge(%{x: root_x, y: y})
      |> Map.put(:right, updated_r)

    {updated_node, root_x, right_lim}
  end
  # - Caso 4: árvore, árvore
  defp depth_first(node = %{left: l, right: r}, level, left_lim) do
    y = @scale * level

    # árvore da esquerda
    {updated_l, l_root_x, l_right_lim} =
      depth_first(l, level + 1, left_lim)
    r_left_lim = l_right_lim + @scale

    # árvore da direita
    {updated_r, r_root_x, r_right_lim} =
      depth_first(r, level + 1, r_left_lim)
    root_x = div(l_root_x + r_root_x, 2)
    right_lim = r_right_lim

    updated_node =
      node
      |> Map.merge(%{x: root_x, y: y})
      |> Map.put(:left, updated_l)
      |> Map.put(:right, updated_r)

    {updated_node, root_x, right_lim}
  end

  defp print_coords(node, indent \\ 0)
  defp print_coords(:leaf, _), do: nil
  defp print_coords(%{key: key, x: x, y: y, left: l, right: r}, indent) do
    IO.puts("#{String.duplicate("  ", indent)}Node #{key}: (x: #{x}, y: #{y})")
    print_coords(l, indent + 1)
    print_coords(r, indent + 1)
  end

  def run do
    IO.puts("\n--- Coordenadas Calculadas ---")
    final_tree = draw(example_tree())
    print_coords(final_tree)
  end
end

TreeDrawer.run()
