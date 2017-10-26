# Triggerify

## Rule details

### Name

The name is only used internally for you to better reference that rule. It isn't shown anywhere else than in this app.

### Topic

The topic reference one of the numerous Shopify webhook. You can basically listen to anything, and act accordingly. The webhook you're listening to will influence the payload you have access to, hence the filters and actions you can trigger. Click [here](https://help.shopify.com/api/reference/webhook) for additional details on available webhooks.

## Filters

### Field

The field should be used to reference a particular snippet of the payload you'll want to compare with the value to determine if the rule should trigger or not. Those snippets change depending on the webhook you're listening to.

### Verb

The verb represents the way we're going to compare the field with the value.

### Value

For the filter to be valid, the evaluated field will need to match this value against the chosen verb.

## Examples

### 1) For each order, send an email if at least one item requires shipping

**Details**

* Name: Send an email for shippable goods
* Topic: `orders/create`

**Filter 1**

* Field: `line_items[*].requires_shipping`
* Value: "Equals"
* Value: `true`


### 2) For each order, send an email if all items require shipping

**Details**

* Name: Send an email for shippable goods
* Topic: `orders/create`

**Filter 1**

* Field: `line_items[+].requires_shipping`
* Value: "Equals"
* Value: `true`

### 3) For each order, send an email if the first item requires shipping

**Details**

* Name: Send an email for shippable goods
* Topic: `orders/create`

**Filter 1**

* Field: `line_items[0].requires_shipping`
* Value: "Equals"
* Value: `true`

### 3) Send an email if the `compare_at_price` of a variant is greater than it's `price`

**Details**

* Name: Alert on bad compare at price
* Topic: `products/update`

**Filter 1**

* Field: `variants[*].compare_at_price`
* Value: "Greater than"
* Value: `{{ variants[n].price }}`

