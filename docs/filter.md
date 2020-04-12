# Filter

Filters are optional. 

When the event match all filters of a rule (or if none are present), [actions](/) will be performed.


## Field

The field is used to reference a particular attribute of the event information.

Those attribute change depending on the webhook you're listening to. [Shopify documentation](https://shopify.dev/docs/admin-api/rest/reference/events/webhook) will contain the different topic events samples.

### For arrays

Sometimes, the event payload will contain an array.

A good example to this is `orders/create` to contain a list of `line_items` representing what the customer purchased.

A special syntax is available to iterate over the elements.

`line_items[+].compare_at_price` will iterate over all elements and validate that all of them match the value.

`line_items[*].compare_at_price` will iterate over all elements and validate that at least one of them match the value.

`line_items[3].compare_at_price` will select the item at the position #3 of the list. The list is zero-based numbering.


## Verb

The verb represents how the comparison is going to be performed between the field attribute and the filter value.

### For arrays

In the case of a list, when using the `+` or `*` operator in the field section, `variants[n].price` will refer the appropriate item.


## Value

Value the event attribute will be compared to.

[back to index](/)











* Field: 
* Value: `Equals`
* Value: `true`

* Field: `line_items[0].requires_shipping`
* Value: "Equals"
* Value: `true`
