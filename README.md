# engrade

Ruby wrapper for the Engrade API

## Installation

```
gem install 'engrade'
```

## Usage

```ruby
require 'engrade'

# Getting started

Engrade.set_apikey('123456789')
Engrade.login('username', 'password')

# Grabbing classes

classes = Engrade.classes
classes = Engrade.classes(:only => "Sem1")
classes = Engrade.classes(:except => "Biology")

# Getting assignments from classes

assignments = Engrade.assignments(classes)
assignments = Engrade.assignments(classes, :only => "Final")
assignments = Engrade.assignments(classes, :except => "Quiz")

# Deleting assignments

Engrade.delete!(assignments)

# Posting directly to Engrade
# (make sure to set apikey and login first)

Engrade.post(:apitask => 'assignment', :clid => '101', :assnid => '1')
```
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Contact
Comments? Concerns? Want additional features?
Contact me by email at zgthompson@gmail.com.
