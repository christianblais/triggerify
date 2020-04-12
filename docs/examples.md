# Examples

The following examples showcase common use cases.

The actions specific configurations are left out and can be found at the [action](/) help page.


## On order, send an email

Base:
* Name: Order received
* Topic: `orders/create`

Filters: none

Action: Send an email


## On order, send an email if at least one item requires shipping

Base:
* Name: `Order received with a shippable goods`
* Topic: `orders/create`

Filter #1:
* Field: `line_items[*].requires_shipping`
* Value: `Equals`
* Value: `true`

Action: Send an email


## On order, if all items require shipping, send an email

Base:
* Name: `Order received with only shippable goods`
* Topic: `orders/create`

Filter #1:
* Field: `line_items[+].requires_shipping`
* Value: `Equals`
* Value: `true`

Action: Send an email


## On product updates, if the `compare_at_price` of a variant is greater than it's `price`, send a Tweet

Base:
* Name: `Alert on bad compare at price`
* Topic: `products/update`

Filter #1:
* Field: `variants[*].compare_at_price`
* Value: `Greater than`
* Value: `{{ variants[n].price }}`

Action: Send an tweet


[back to index](/)
