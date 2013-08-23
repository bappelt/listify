require 'spec_helper'

describe 'Columnizer' do

  it 'should split an array evenly into an evenly divisible number of columns' do
    list = %w[first second third fourth fifth sixth]
    columnizer = Columnizer.new(list, 3)
    columnizer.items_for_column(1).should == %w[first second]
    columnizer.items_for_column(2).should == %w[third fourth]
    columnizer.items_for_column(3).should == %w[fifth sixth]
  end

  it 'should split a hash evenly into an evenly divisible number of columns' do
    list = {first_category: %w[item1 item2 item3], second_category: %w[item4 item5 item6]}
    columnizer = Columnizer.new(list, 2)
    columnizer.items_for_column(1).should == {first_category: %w[item1 item2 item3]}
    columnizer.items_for_column(2).should == {second_category: %w[item4 item5 item6]}
  end

  it 'should split a more complex hash evenly into an evenly divisible number of columns' do
    list = {first_category: %w[item1 item2], second_category: %w[item3], third_category: %w[item1 item2 item3 item4]}
    columnizer = Columnizer.new(list, 2)
    columnizer.items_for_column(1).should == {first_category: %w[item1 item2], second_category: %w[item3]}
    columnizer.items_for_column(2).should == {third_category: %w[item1 item2 item3 item4]}
  end

  it 'should truncate hash list by range' do
    list = {first_category: %w[item1 item2 item3], second_category: %w[item4 item5 item6], third_category: 'item7'}
    Columnizer.truncate_list(list, 4..7).should == {second_category: %W[item4 item5 item6]}

    list = {first_category: %w[item1 item2 item3], second_category: %w[item4 item5 item6], third_category: 'item7', fourth_category: %w[item8 item9]}
    Columnizer.truncate_list(list, 4..9).should == {second_category: %W[item4 item5 item6], third_category: 'item7'}

    list = {first_category: %w[item1 item2 item3], second_category: %w[item4 item5 item6], third_category: %w[item8 item9], fourth_category: 'item7'}
    Columnizer.truncate_list(list, 4..10).should == {second_category: %W[item4 item5 item6], third_category: %w[item8 item9]}


  end

  it 'should truncate array list by range' do
    list = ['first', 'second', 'third', 'fourth', 'fifth', 'sixth']
    Columnizer.truncate_list(list, 3..4).should == ['fourth', 'fifth']
  end

  it 'should truncate array list with duplicate items by range' do
    list = ['dupe', 'dupe', 'dupe', 'diff', 'dupe', 'dupe']
    Columnizer.truncate_list(list, 2..4).should == ['dupe', 'diff', 'dupe']
  end


end