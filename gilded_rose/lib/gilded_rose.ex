defmodule GildedRose do
  # Example
  # update_quality([%Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 9, quality: 1}])
  # => [%Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 8, quality: 3}]

  def update_quality(items) do
    Enum.map(items, &update_item/1)
  end

  def update_item(item) do
    item
    |> update_quality_for_item()
    |> update_sell_in()
    |> handle_sell_in_expiration()
  end


  defp update_quality_for_item(item) do
    cond do
      item.name != "Aged Brie" && item.name != "Backstage passes to a TAFKAL80ETC concert" ->
        degrade_quality(item, 1)
      true ->
        if item.quality < 50, do: handle_special_items(item), else: item
    end
  end

  defp update_sell_in(item) do
    if should_decrease_sell_in?(item) do
      %{item | sell_in: item.sell_in - 1}
    else
      item
    end
  end

  defp handle_sell_in_expiration(item) do
    if item.sell_in < 0, do: handle_expired(item), else: item
  end

  defp degrade_quality(item, amount) do
    if item.name != "Sulfuras, Hand of Ragnaros" and item.quality > 0 do
      %{item | quality: item.quality - amount}
    else
      item
    end
  end

  defp increase_quality(item, amount \\ 1) do
    if item.quality + amount <= 50 do
      %{item | quality: item.quality + amount}
    else
      item
    end
  end

  defp update_backstage_passes(item) do
    item
    |> increase_quality()
    |> (fn item -> if item.sell_in < 11, do: increase_quality(item), else: item end).()
    |> (fn item -> if item.sell_in < 6, do: increase_quality(item), else: item end).()
  end

  defp handle_expired(%{name: "Aged Brie"} = item), do: handle_aged_brie(item)
  defp handle_expired(%{name: "Backstage passes to a TAFKAL80ETC concert"} = item), do: handle_backstage_passes(item)
  defp handle_expired(%{quality: quality} = item) when quality > 0, do: handle_normal_item(item)
  defp handle_expired(item), do: item

  defp handle_aged_brie(item) do
    increase_quality(item)
  end

  defp handle_backstage_passes(item) do
    %{item | quality: 0}
  end

  defp handle_normal_item(item) do
    degrade_quality(item, 1)
  end

  defp handle_special_items(%{name: "Aged Brie"} = item), do: increase_quality(item)
  defp handle_special_items(%{name: "Backstage passes to a TAFKAL80ETC concert"} = item), do: update_backstage_passes(item)
  defp handle_special_items(item), do: degrade_quality(item, 1)


  @items_no_decrement ["Sulfuras, Hand of Ragnaros"]

  defp should_decrease_sell_in?(item) do
    not Enum.member?(@items_no_decrement, item.name)
  end

end
