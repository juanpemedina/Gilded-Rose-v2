defmodule GildedRose do
  # Example
  # update_quality([%Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 9, quality: 1}])
  # => [%Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 8, quality: 3}]

  def update_quality(items) do
    Enum.map(items, &update_item/1)
  end

  def update_item(item) do
    item = update_quality_for_item(item)
    item = update_sell_in(item)
    item = handle_sell_in_expiration(item)
    item
  end

  defp update_quality_for_item(%{name: "Aged Brie", quality: quality} = item) do
    new_quality = if quality < 50, do: quality + 1, else: quality
    %{item | quality: new_quality}
  end

  defp update_quality_for_item(%{name: "Backstage passes to a TAFKAL80ETC concert"} = item) do
    handle_special_items(item)
  end

  defp update_quality_for_item(item), do: degrade_quality(item, 1)

  defp update_sell_in(%{name: "Sulfuras, Hand of Ragnaros"} = item), do: item
  defp update_sell_in(item), do: %{item | sell_in: item.sell_in - 1}

  defp handle_sell_in_expiration(item) when item.sell_in < 0 do
    handle_expired(item)
  end

  defp handle_sell_in_expiration(item), do: item

  defp degrade_quality(item, amount) do
    if item.name != "Sulfuras, Hand of Ragnaros" and item.quality > 0 do
      %{item | quality: item.quality - amount}
    else
      item
    end
  end

  defp increase_quality(item, amount \\ 1) do
    %{item | quality: min(item.quality + amount, 50)}
  end

  defp update_backstage_passes(item) do
    item
    |> increase_quality()
    |> increase_quality_if_near_deadline()
    |> increase_quality_if_expired()
  end

  defp increase_quality_if_near_deadline(item) when item.sell_in < 11, do: increase_quality(item)
  defp increase_quality_if_near_deadline(item), do: item

  defp increase_quality_if_expired(item) when item.sell_in < 6, do: increase_quality(item)
  defp increase_quality_if_expired(item), do: item


  defp handle_expired(%{name: "Aged Brie"} = item), do: handle_aged_brie(item)

  defp handle_expired(%{name: "Backstage passes to a TAFKAL80ETC concert"} = item), do: handle_backstage_passes(item)

  defp handle_expired(item) when item.quality > 0, do: handle_normal_item(item)

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


  defp should_decrease_sell_in?(item) do
    item.name != "Sulfuras, Hand of Ragnaros"
  end
end
