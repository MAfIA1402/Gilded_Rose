class GildedRose
  MAX_QUALITY = 50 #Quality can be (0 .. 50)
  MIN_QUALITY = 0
  LEGENDARY_ITEM = "Sulfuras, Hand of Ragnaros" #Quality doesn't change
  BRIE = "Aged Brie" #Quality increases by each day, Max up to 50
  BACKSTAGE_PASSES = "Backstage passes to a TAFKAL80ETC concert" 
  #Quality increases by 2 when sell_in is 10 days or less & by 3 when 5 days or less & becomes 
  #0 when sell_in date reaches 0
  CONJURED = "Conjured"  #Quality decreases twice as fast from everything else

  def initialize(items) #Constructor for list of items
    @items = items
  end

  def update_quality() 
    @items.each do |item| #Loops through each item in the inventory
      update_item_quality(item) 
      update_item_sell_in(item)
      handle_expired_item(item) if item.sell_in < 0 #Only gets called when sell_in becomes < 0
    end
  end

  def update_item_quality(item)
    return if legendary?(item) #Legendary item's quality doesn't change & method exits 

    if increasing_quality_item?(item) #Only Brie & Backstage pass increase in quality over time
      increase_quality(item) # Increase the Quality by 1 when Quality < 50; Backstage pass +1 
      handle_backstage_pass_increase(item) #Backstage pass quality based on days left for concert
    else
      degrade_item(item) #Decrease the quality of Conjured items at twice the rate of anything else
    end
  end

  def update_item_sell_in(item) #Decrease the Quality by 1 except Sulfuras being a legendary item
    item.sell_in -= 1 unless legendary?(item) #Boolean check to avoid sulfuras
  end

  def handle_expired_item(item) #Called when item sell_in < 0
    return if legendary?(item) #Exits the method when sulfuras is obtained as the item

    if increasing_quality_item?(item) #Brie & Backstage pass increase in Quality over time
      if item.name == BACKSTAGE_PASSES
        item.quality = MIN_QUALITY #Backstage pass is useless after the concert
      else
        increase_quality(item) #Increase the Quality of Brie by 1 if Quality < 50
      end
    else
      degrade_item(item) #Degrades the conjured item twice as fast as everything else
    end
  end

  def increase_quality(item) #Called for Brie & Backstage pass
    item.quality += 1 if item.quality < MAX_QUALITY
  end

  def degrade_item(item) #Degrade conjured item twice as fast as everything else
    degradation_rate = item.name == CONJURED ? 2 : 1 #Ternary check for conjured item
    item.quality -= degradation_rate if item.quality > MIN_QUALITY
  end

  def handle_backstage_pass_increase(item)
    return unless item.name == BACKSTAGE_PASSES #Exits method for everything except Backstage pass

    increase_quality(item) if item.sell_in < 11 #Backstage pass Quality +2
    increase_quality(item) if item.sell_in < 6 ##Backstage pass Quality +3
  end

  def increasing_quality_item?(item) #Returns True for Brie & Backstage pass
    item.name == BRIE || item.name == BACKSTAGE_PASSES
  end

  def legendary?(item) #Returns True for Legendary item
    item.name == LEGENDARY_ITEM
  end
end

class Item
  attr_accessor :name, :sell_in, :quality #Read & write access to the parameters of Item's object

  def initialize(name, sell_in, quality) #Constructor for item class
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s #String interpolation for printing the name, sell_in, quality
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end

