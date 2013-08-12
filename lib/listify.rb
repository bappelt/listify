module Listify

  module Helper

    # Generate an HTML list from a ruby collection
    # @param [Array, Hash{sublist_name => sublist[Array, Hash]}] collection the collection to render as a list
    # @return ActiveSupport::SafeBuffer
    #
    # @example Simple List
    #   listify( ['first item', 'second item', 'third item'] )
    #   => "<ul>
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
    def listify(collection)
      content_tag :ul do
        concat list_items_for(collection)
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
