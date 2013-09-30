#Listify Rails Plugin
[![Gem Version](https://badge.fury.io/rb/listify.png)](http://badge.fury.io/rb/listify)
[![Build Status](https://travis-ci.org/bappelt/listify.png)](https://travis-ci.org/bappelt/listify)
[![Coverage Status](https://coveralls.io/repos/bappelt/listify/badge.png?branch=master)](https://coveralls.io/r/bappelt/listify?branch=master)
[![Code Climate](https://codeclimate.com/github/bappelt/listify.png)](https://codeclimate.com/github/bappelt/listify)

The Listify rails plugin provides a simple method to use in views and helpers to render an HTML list from a ruby array or hash.

##Installation

###Rails 3

Add the following line to your gemfile
```
gem 'listify'
```

##Usage

###Simple List

Arrays are rendered as simple lists: 
```
listify( ['first item', 'second item', 'third item'] )
   => "<ul>
        <li>first item</li>
        <li>second item</li>
        <li>third item</li>
      </ul>"
```

###HTML Attributes

  Attributes can be specified for the outer tag
  ```
  listify( ['first item', 'second item', 'third item'], class: 'todo-list' )
     => "<ul class="todo-list">
          <li>first item</li>
          <li>second item</li>
          <li>third item</li>
        </ul>"
  ```

###Multilevel lists

Hashes are rendered as a sub-list: 
```
listify( {'First Category' => ['item one', 'item two'], 'Second Category' => ['item three', 'item four'] } )
  => "<ul>
        <li>First Category
          <ul>
            <li>item one</li>
            <li>item two</li>
          </ul>
        </li>
        <li>Second Category
          <ul>
            <li>item three</li>
            <li>item four</li>
          </ul>
        </li>
      </ul>"
```

###Multi-Column lists

If you specify a number of columns > 1, the list will be broken up into multiple unordered lists intended for use as separate columns
```
listify( %w[first second third fourth fifth sixth seventh], columns: 3 )
 => "<ul>
       <li>first</li>
       <li>second</li>
     </ul>
     <ul>
       <li>third</li>
       <li>fourth</li>
     </ul>
     <ul>
       <li>fifth</li>
       <li>sixth</li>
       <li>seventh</li>
     </ul>"
```

###Complex lists

And you can get more complex, though maybe you shouldn't:
```
listify( {'First-Category' => ['item-one', 'item-two'],
          'Second-Category' =>['item-three', 
                                'item-four',
                                {'sub-cat-one' => [ 'sub-item-one', 
                                                    'sub-item-two', 
                                                    { 'sub-sub-cat-one' => ['sub-sub-item-one', 'sub-sub-item-two'] }
                                                  ]
                                }
                              ],
          'Third-Item' => [],
          'Fourth-Item' => []}
          }
      )
  => "<ul>
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
      </ul>"
```
