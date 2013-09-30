require_relative 'columnizer'

module Listify

  module Helper

    # Generate an HTML list from a ruby collection
    # @param [Array, Hash{sublist_name => sublist[Array, Hash]}] collection the collection to render as a list
    # @param [Hash] options
    # @option options [String] :class HTML class to apply to the <ul> elements
    # @option options [Integer] :columns (1) When specified, break list into multiple lists. Breaks will occur at top level only if list is nested. Not supported for lists nested more than one level deep.
    # @return ActiveSupport::SafeBuffer
    #
    # @example Simple List
    #   listify( ['first item', 'second item', 'third item'], class: 'parts-list' )
    #   => "<ul class='parts-list'>
    #        <li>first item</li>
    #        <li>second item</li>
    #        <li>third item</li>
    #      </ul>"
    #
    # @example Nested List
    #   listify( {'First Category' => ['item one', 'item two'], 'Second Category' => ['item three', 'item four'] } )
    #     => "<ul>
    #           <li>First Category
    #             <ul>
    #               <li>item one</li>
    #               <li>item two</li>
    #             </ul>
    #           </li>
    #         <li>Second Category
    #           <ul>
    #             <li>item three</li>
    #             <li>item four</li>
    #           </ul>
    #         </li>
    #       </ul>"
    #
    # @example Multiple Column List
    #   listify( ['first item', 'second item', 'third item', 'fourth item', 'fifth item'], columns: 2 )
    #   => "<ul>
    #        <li>first item</li>
    #        <li>second item</li>
    #      </ul>
    #      <ul>
    #        <li>third item</li>
    #        <li>fourth item</li>
    #        <li>fifth item</li>
    #      </ul>"
    def listify(collection, options = {})
      number_of_columns = options.fetch(:columns, 1)

      if number_of_columns > 1
        options.delete(:columns)
        columnizer = Columnizer.new(collection, number_of_columns)

        elements = []
        (1..number_of_columns).each do |column|
          items_for_column = columnizer.items_for_column(column)
          next if items_for_column.empty?
          column_element = content_tag :ul, options do
            list_items_for(items_for_column)
          end
          elements << column_element
        end


        return elements.inject(:+)

      else
        content_tag :ul, options do
          list_items_for(collection)
        end
      end

    end

    private

    def list_items_for(collection)
      capture do
        collection.each do |item|
          if item.is_a?(Array)
            concat sub_list(item[0], item[1])
          else
            concat content_tag :li, item
          end
        end
      end
    end

    def list_for_array(collection)
      content_tag :ul do
        collection.collect do |item|
          if item.is_a?(Hash)
            concat sub_list(item.to_a[0][0], item.to_a[0][1])
          else
            concat content_tag :li, item
          end
        end
      end
    end

    def sub_list(heading, items)
      content_tag :li do
        concat heading
        concat list_for_array(items) unless items.empty?
      end
    end
  end
end

ActionView::Base.send(:include, Listify::Helper) if defined?(ActionView::Base)
