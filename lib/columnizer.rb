class Columnizer

  def initialize(list, number_of_columns)
    @list = list
    @column_count = number_of_columns
  end

  def items_for_column(column_number)
    zero_based_column_number = column_number-1
    first_item_index = 0 if zero_based_column_number==0
    first_item_index ||= (item_count_by_column[0..zero_based_column_number-1]).inject(:+)
    last_item_index = first_item_index+item_count_by_column[zero_based_column_number]-1
    Columnizer.truncate_list(@list, first_item_index..last_item_index)
  end

  def item_count_by_column
    item_count_by_column = []
    balanced_item_count = total_item_count_for_collection(@list) / @column_count
    @column_count.times { item_count_by_column << balanced_item_count }
    item_count_by_column
  end

  def total_item_count_for_collection(list)
    item_count = 0
    list.each do |item|
      if item.is_a?(Enumerable)
        item_count += total_item_count_for_collection(item)
      else
        item_count += 1
      end
    end
    item_count
  end

  def self.truncate_list(list, range)
    first_index, last_index = range.begin, range.end

    truncated_list = list.clone
    first_item = list.to_a.flatten[first_index]
    last_item = list.to_a.flatten[last_index]

    found_first_item, found_last_item = false, false


    list.each do |key, item|

      if found_first_item
        truncated_list.delete_if {|o| o.equal?(key)} if found_last_item
      else
        truncated_list.delete_if {|o| o.equal?(key)} unless key.equal?(first_item) || (item && item.include?(first_item))
        found_first_item = true if key.equal?(first_item) || (list.is_a?(Hash) && list[key].include?(first_item))
      end

      found_last_item = true if key.equal?(last_item) || (list.is_a?(Hash) && list[key].include?(last_item) )

    end
    truncated_list
  end




end