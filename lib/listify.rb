module Listify

  module Helper

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
