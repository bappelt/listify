require 'spec_helper'

describe 'Columnizer' do

  it 'should split an array evenly into an evenly divisible number of columns' do
    list = %w[first second third fourth fifth sixth]
    columnizer = Columnizer.new(list, 3)
    columnizer.items_for_column(1).should == %w[first second]
    columnizer.items_for_column(2).should == %w[third fourth]
    columnizer.items_for_column(3).should == %w[fifth sixth]
  end

  it 'should split an array with empty columns when there is not enough items' do
    list = %w[first second]
    columnizer = Columnizer.new(list, 3)
    columnizer.items_for_column(1).should == []
    columnizer.items_for_column(2).should == %w[first]
    columnizer.items_for_column(3).should == %w[second]
  end

  it 'should split an array into uneven columns when not evenly divisible with remainder of one' do
    list = %w[first second third fourth fifth sixth seventh]
    columnizer = Columnizer.new(list, 3)
    columnizer.items_for_column(1).should == %w[first second]
    columnizer.items_for_column(2).should == %w[third fourth]
    columnizer.items_for_column(3).should == %w[fifth sixth seventh]
  end

  it 'should split an array into uneven columns when not evenly divisible with remainder of two' do
    list = %w[first second third fourth fifth sixth seventh eighth]
    columnizer = Columnizer.new(list, 3)
    columnizer.items_for_column(1).should == %w[first second]
    columnizer.items_for_column(2).should == %w[third fourth fifth]
    columnizer.items_for_column(3).should == %w[sixth seventh eighth]
  end

  it 'should split a hash evenly into an evenly divisible number of columns' do
    list = {first_category: %w[item1 item2 item3], second_category: %w[item4 item5 item6]}
    columnizer = Columnizer.new(list, 2)
    columnizer.items_for_column(1).should == [['first_category', %w[item1 item2 item3]]]
    columnizer.items_for_column(2).should == [['second_category', %w[item4 item5 item6]]]
  end

  it 'should split a more complex hash evenly into an evenly divisible number of columns' do
    list = {first_category: %w[item1 item2], second_category: %w[item3], third_category: %w[item1 item2 item3 item4]}
    columnizer = Columnizer.new(list, 2)
    columnizer.items_for_column(1).should == [['first_category', %w[item1 item2]], ['second_category', %w[item3]]]
    columnizer.items_for_column(2).should == [['third_category', %w[item1 item2 item3 item4]]]
  end

  it 'should split a complex hash into uneven columns when not evenly divisible with a remainder of one' do
    list = {first_category: %w[item1 item2 item3],
            second_category: %w[item4 item5 item6],
            third_category: %w[item7 item8 item9 item10 item11],
            fourth_category: %w[item12],
            fifth_category: %w[item13 item14 item15 item16],
            sixth_category: %w[item18 item19 item20]}
    columnizer = Columnizer.new(list, 3)
    columnizer.items_for_column(1).should == [['first_category', %w[item1 item2 item3]], ['second_category', %w[item4 item5 item6]]]
    columnizer.items_for_column(2).should == [['third_category', %w[item7 item8 item9 item10 item11]], ['fourth_category', %w[item12]]]
    columnizer.items_for_column(3).should == [['fifth_category', %w[item13 item14 item15 item16]], ['sixth_category', %w[item18 item19 item20]]]
  end

  it 'should split a complex hash into uneven columns when not evenly divisible with a remainder of two' do
    #list has 26 items, so column count should be 8,9,9
    list = {first_category: %w[item1 item2 item3],
            second_category: %w[item4 item5 item6],
            third_category: %w[item7 item8 item9 item10 item11],
            fourth_category: %w[item12 itemX],
            fifth_category: %w[item13 item14 item15 item16],
            sixth_category: %w[item18 item19 item20]}
    columnizer = Columnizer.new(list, 3)
    columnizer.items_for_column(1).should == [['first_category', %w[item1 item2 item3]], ['second_category', %w[item4 item5 item6]]]
    columnizer.items_for_column(2).should == [['third_category', %w[item7 item8 item9 item10 item11]], ['fourth_category', %w[item12 itemX]]]
    columnizer.items_for_column(3).should == [['fifth_category', %w[item13 item14 item15 item16]], ['sixth_category', %w[item18 item19 item20]]]
  end

  it 'should split a complex hash into uneven columns breaking only at top level' do
    list = {first_category: %w[one two three four five], second_category: %w[one two], third_category: %w[one two], fourth_category: %w[one two], fifth_category: %w[one two three four]}
    columnizer = Columnizer.new(list, 3)
    columnizer.items_for_column(1).should == [['first_category', %w[one two three four five]]]
    columnizer.items_for_column(2).should == [['second_category', %w[one two]], ['third_category', %w[one two]]]
    columnizer.items_for_column(3).should == [['fourth_category', %w[one two]], ['fifth_category', %w[one two three four]]]
  end

  it 'should return the entire list if columns=1' do
    list = {'First-Category' => ['item-one', 'item-two'], 'Second-Category' => ['item-three', 'item-four'], 'Third-Item' => [], 'Fourth-Item' => []}
    columnizer = Columnizer.new(list, 1)
    columnizer.find_items_for_column(1).should == list.to_a
  end


  it 'should truncate hash list by range' do
    list = {first_category: %w[item1 item2 item3], second_category: %w[item4 item5 item6], third_category: 'item7'}
    Columnizer.truncate_list(list, 4..7).should == [['second_category', %W[item4 item5 item6]]]

    list = {first_category: %w[item1 item2 item3], second_category: %w[item4 item5 item6], third_category: 'item7', fourth_category: %w[item8 item9]}
    Columnizer.truncate_list(list, 4..9).should == [['second_category', %W[item4 item5 item6]], ['third_category', 'item7']]

    list = {first_category: %w[item1 item2 item3], second_category: %w[item4 item5 item6], third_category: %w[item8 item9], fourth_category: 'item7'}
    Columnizer.truncate_list(list, 4..10).should == [['second_category', %W[item4 item5 item6]], ['third_category', %w[item8 item9]]]
  end

  it 'should truncate array list by range' do
    list = ['first', 'second', 'third', 'fourth', 'fifth', 'sixth']
    Columnizer.truncate_list(list, 3..4).should == ['fourth', 'fifth']
  end

  it 'should truncate array list with duplicate items by range' do
    list = ['dupe', 'dupe', 'dupe', 'diff', 'dupe', 'dupe']
    Columnizer.truncate_list(list, 2..4).should == ['dupe', 'diff', 'dupe']
  end

  it 'should truncate a hash list with duplicates items by range' do
    list = {first_cat: %w[one two three four], second_cat: %w[one two three], third_cat: %w[one two]}
    Columnizer.truncate_list(list, 0..8).should == [['first_cat', %w[one two three four]], ['second_cat', %w[one two three]]]
  end

  it 'should truncate to the first top level item when range falls across items' do
    list = {first_cat: %w[one two three four five], second_cat: %w[one two], third_cat: %w[one two], fourth_cat: %w[one two], fifth_cat: %w[one two three four]}
    Columnizer.truncate_list(list, 0..7).should == [['first_cat', %w[one two three four five]]]
  end


end