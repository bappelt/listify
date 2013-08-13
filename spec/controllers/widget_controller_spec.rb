require "spec_helper"
ActionView::Base.send(:include, Listify::Helper)

describe WidgetController do

  describe "GET index", :type => :view do

    it "should render an inline template" do
      render :inline => "<%= who%> rocks!", :locals => {:who => "Byron"}
      rendered.should == "Byron rocks!"
    end

    it "should render a list", :type => :view do
      render :inline => "<%= listify( collection, {class: 'parts-list'} ) %>", :locals => {:collection => ['first', 'second', 'third']}
      expected = <<-DOC
        <ul class=\"parts-list\">
          <li>first</li>
          <li>second</li>
          <li>third</li>
        </ul>
      DOC
      rendered.should == expected.gsub(/\n/, "").gsub(/\s+</, '<')
    end

    it "should render a nested list", :type => :view do
      render :inline => "<%= listify( collection, {class: 'shopping-list'} ) %>", :locals => {:collection => {'First-Category' => ['item-one', 'item-two'], 'Second-Category' => ['item-three', 'item-four']}}
      expected = <<-DOC
                  <ul class=\"shopping-list\">
                    <li>First-Category
                      <ul>
                        <li>item-one</li>
                        <li>item-two</li>
                      </ul>
                    </li>
                    <li>Second-Category
                      <ul>
                        <li>item-three</li>
                        <li>item-four</li>
                      </ul>
                    </li>
                  </ul>
      DOC
      rendered.should == expected.gsub(/\n/, "").gsub(/\s+</, '<')
    end

    it "should render a partially nested list", :type => :view do
      render :inline => "<%= listify( collection ) %>", :locals => {:collection => {'First-Category' => ['item-one', 'item-two'], 'Second-Category' => ['item-three', 'item-four'], 'Third-Item' => [], 'Fourth-Item' => []}}
      expected = <<-DOC
                      <ul>
                        <li>First-Category
                          <ul>
                            <li>item-one</li>
                            <li>item-two</li>
                          </ul>
                        </li>
                        <li>Second-Category
                          <ul>
                            <li>item-three</li>
                            <li>item-four</li>
                          </ul>
                        </li>
                        <li>Third-Item</li>
                        <li>Fourth-Item</li>
                      </ul>
      DOC
      rendered.should == expected.gsub(/\s+/, "")
    end

    it "should render a deeply nested list", :type => :view do
      render :inline => "<%= listify( collection ) %>",
             :locals => {:collection => {'First-Category' => ['item-one', 'item-two'],
                                         'Second-Category' => ['item-three', 'item-four', {'sub-cat-one' => ['sub-item-one', 'sub-item-two']}, {'sub-cat-two' => ['sub-item-three', 'sub-item-four']}],
                                         'Third-Item' => [],
                                         'Fourth-Item' => []}}
      expected = <<-DOC
                          <ul>
                            <li>First-Category
                              <ul>
                                <li>item-one</li>
                                <li>item-two</li>
                              </ul>
                            </li>
                            <li>Second-Category
                              <ul>
                                <li>item-three</li>
                                <li>item-four</li>
                                <li>sub-cat-one
                                  <ul>
                                    <li>sub-item-one</li>
                                    <li>sub-item-two</li>
                                  </ul>
                                </li>
                                <li>sub-cat-two
                                  <ul>
                                    <li>sub-item-three</li>
                                    <li>sub-item-four</li>
                                  </ul>
                                </li>
                              </ul>
                            </li>
                            <li>Third-Item</li>
                            <li>Fourth-Item</li>
                          </ul>
      DOC
      rendered.should == expected.gsub(/\s+/, "")
    end


    it "should render a really deeply nested list", :type => :view do
      render :inline => "<%= listify( collection ) %>",
             :locals => {:collection => {'First-Category' => ['item-one', 'item-two'],
                                         'Second-Category' => ['item-three', 'item-four', {'sub-cat-one' => ['sub-item-one', 'sub-item-two', {'sub-sub-cat-one' => ['sub-sub-item-one', 'sub-sub-item-two']}]}],
                                         'Third-Item' => [],
                                         'Fourth-Item' => []}}
      expected = <<-DOC
                            <ul>
                              <li>First-Category
                                <ul>
                                  <li>item-one</li>
                                  <li>item-two</li>
                                </ul>
                              </li>
                              <li>Second-Category
                                <ul>
                                  <li>item-three</li>
                                  <li>item-four</li>
                                  <li>sub-cat-one
                                    <ul>
                                      <li>sub-item-one</li>
                                      <li>sub-item-two</li>
                                      <li>sub-sub-cat-one
                                        <ul>
                                          <li>sub-sub-item-one</li>
                                          <li>sub-sub-item-two</li>
                                        </ul>
                                      </li>
                                    </ul>
                                  </li>
                                </ul>
                              </li>
                              <li>Third-Item</li>
                              <li>Fourth-Item</li>
                            </ul>
      DOC
      rendered.should == expected.gsub(/\s+/, "")
    end
  end
end