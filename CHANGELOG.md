## 0.2.0

Features

 - listify now takes an option columns which will split the list into multiple lists intended for multiple columns

        listify( %w[first second third fourth], columns: 2 ) => <ul><li>first</li><li>second</li></ul><ul><li>third</li><li>fourth</li></ul>

## 0.1.0

Features

 - listify now takes an options hash for HTML attributes to the main list tag

         listify(['first', 'second'], class: 'awesome') => <ul class="awesome"><li>first</li><li>second</li>