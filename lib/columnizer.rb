class Columnizer

  def initialize(list, number_of_columns)
    @list = Columnizer.convert_to_array(list)
    @column_count = number_of_columns
    @items_by_column = []
    columnize!
  end

  def columnize!
    (1..@column_count).each do |column_number|
      @items_by_column[column_number] = find_items_for_column(column_number)
    end
  end

  def items_for_column(column_number)
    @items_by_column[column_number]
  end

  def find_items_for_column(column_number)
    zero_based_column_number = column_number-1
    return [] if item_count_by_column[zero_based_column_number]==0
    first_item_index = 0 if zero_based_column_number==0
    first_item_index ||= (item_count_by_column[0..zero_based_column_number-1]).inject(:+)
    last_item_index = first_item_index+item_count_by_column[zero_based_column_number]-1
    Columnizer.truncate_list(@list, first_item_index..last_item_index)
  end

  def item_count_by_column
    item_count_by_column = []
    total_item_count = total_item_count_for_collection(@list)
    balanced_item_count = total_item_count / @column_count
    unbalanced_item_count = total_item_count % @column_count
    @column_count.times { item_count_by_column << balanced_item_count }
    item_count_by_column[-unbalanced_item_count..-1] = item_count_by_column[-unbalanced_item_count..-1].collect { |n| n+1 } if unbalanced_item_count > 0
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

    list = convert_to_array(list)

    first_index, last_index = range.begin, range.end
    first_item, last_item = list.flatten[first_index], list.flatten[last_index]

    list.each { |o| o.extend(IsOrIncludes) }
    list.flatten(1).each { |o| o.extend(IsOrIncludes) }
    list.flatten(2).each { |o| o.extend(IsOrIncludes) }

    first_item_index = list.index { |o| o.is_or_includes?(first_item) }
    last_item_index = list.index { |o| o.is_or_includes?(last_item) }

    last_item_container = list[last_item_index]
    if last_item_container.is_a?(Array)
       unless last_item_container[1].eql?(last_item) || last_item_container[1].last.eql?(last_item) || last_item_container[1].empty?
          last_item_index -= 1
       end
    end

    list[first_item_index..last_item_index]

  end

  def self.convert_to_array(list)
    truncated_list = []
    if list.respond_to?(:keys)
      keys = list.keys
      keys.each do |key|
        list[key.to_s] = list.delete(key)
      end
      list.each do |key, value|
        validate_depth(value)
        truncated_list << [key.dup, value]
      end
    else
      truncated_list = list
    end
    truncated_list
  end

  def self.validate_depth(value)
    if value.respond_to?(:each) then
      value.each { |item| raise "Columns not supported for lists nested more than one level" if item.respond_to?(:keys) }
    end
  end


end

module IsOrIncludes

  def is_or_includes?(object)
    if self.is_a?(Array)
      return self.index { |o| o.is_or_includes?(object) }
    else
      return object.equal?(self)
    end
  end

end