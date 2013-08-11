#Listify Rails Plugin

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
