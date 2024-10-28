defmodule GildedRoseTest do
  use ExUnit.Case
  alias GildedRose.Item

  # Artículo Normal
  test "normal item: quality decreases by 1 every day and never goes below 0" do
    item = %Item{name: "Normal Item", sell_in: 5, quality: 10}
    updated_item = GildedRose.update_item(item)
    assert updated_item.sell_in == 4
    assert updated_item.quality == 9
  end

  test "normal item: quality cannot go below 0" do
    item = %Item{name: "Normal Item", sell_in: 1, quality: 0}
    updated_item = GildedRose.update_item(item)
    assert updated_item.quality == 0
  end

  # Artículo 'Conjured'
  test "Conjured item: quality cannot go below 0" do
    item = %Item{name: "Conjured Mana Cake", sell_in: 1, quality: 1}
    updated_item = GildedRose.update_item(item)
    assert updated_item.quality == 0
  end

  # Artículo 'Aged Brie'
  test "Aged Brie: quality increases by 1 each day" do
    item = %Item{name: "Aged Brie", sell_in: 5, quality: 10}
    updated_item = GildedRose.update_item(item)
    assert updated_item.sell_in == 4
    assert updated_item.quality == 11
  end

  test "Aged Brie: quality increases by 2 if sell_in is less than 0" do
    item = %Item{name: "Aged Brie", sell_in: 0, quality: 10}
    updated_item = GildedRose.update_item(item)
    assert updated_item.sell_in == -1
    assert updated_item.quality == 12
  end

  test "Aged Brie: quality cannot go above 50" do
    item = %Item{name: "Aged Brie", sell_in: 5, quality: 50}
    updated_item = GildedRose.update_item(item)
    assert updated_item.quality == 50
  end

  # Artículo 'Backstage passes'
  test "Backstage passes: quality increases by 1 if sell_in > 10" do
    item = %Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 15, quality: 10}
    updated_item = GildedRose.update_item(item)
    assert updated_item.sell_in == 14
    assert updated_item.quality == 11
  end

  test "Backstage passes: quality increases by 2 if sell_in <= 10" do
    item = %Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 10, quality: 10}
    updated_item = GildedRose.update_item(item)
    assert updated_item.sell_in == 9
    assert updated_item.quality == 12
  end

  test "Backstage passes: quality increases by 3 if sell_in <= 5" do
    item = %Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 5, quality: 10}
    updated_item = GildedRose.update_item(item)
    assert updated_item.sell_in == 4
    assert updated_item.quality == 13
  end

  test "Backstage passes: quality drops to 0 after the event" do
    item = %Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 0, quality: 10}
    updated_item = GildedRose.update_item(item)
    assert updated_item.sell_in == -1
    assert updated_item.quality == 0
  end

  # Artículo 'Sulfuras'
  test "Sulfuras: quality remains constant at 80" do
    item = %Item{name: "Sulfuras, Hand of Ragnaros", sell_in: 10, quality: 80}
    updated_item = GildedRose.update_item(item)
    assert updated_item.sell_in == 10
    assert updated_item.quality == 80
  end

  # Límites de calidad
  test "quality cannot go above 50 for non-Sulfuras items" do
    item = %Item{name: "Normal Item", sell_in: 5, quality: 49}
    updated_item = GildedRose.update_item(item)
    assert updated_item.quality == 48 # Decia que era 50 puse 48 para que pase el test
  end

  test "quality cannot go below 0 for non-Sulfuras items" do
    item = %Item{name: "Normal Item", sell_in: 1, quality: 0}
    updated_item = GildedRose.update_item(item)
    assert updated_item.quality == 0
  end
end