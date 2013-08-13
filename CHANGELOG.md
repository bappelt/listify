## 0.1.0

Features

 - listify now takes an options hash for HTML attributes to the main list tag

         listify(['first', 'second'], class: 'awesome') => <ul class="awesome"><li>first</li><li>second</li>