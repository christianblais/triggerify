import React from "react"
import { AppProvider, Card, EmptyState, Link } from '@shopify/polaris'

class Empty extends React.Component {
  render () {
    return (
      <AppProvider>
        <Card sectioned>
          <EmptyState
            heading="Get started by creating your first rule!"
            action={{
              content: 'Create a rule',
              url: this.props.new_rule_path
            }}
            secondaryAction={{
              content: 'Start with an existing template',
              url: this.props.templates_rules_path
            }}
            image="https://cdn.shopify.com/s/files/1/0262/4071/2726/files/emptystate-files.png"
          >
            <p>
              React to what's happening on your store by creating custom rules. Send an email when a customer receive
              a specific tag, send a slack message when a specific item is sold, or tweet whenever a product goes on sale -
              sky's the limit!
            </p>
            <p>
              <Link url="https://github.com/christianblais/triggerify/wiki/Rules">Learn more.</Link>
            </p>
          </EmptyState>
        </Card>
      </AppProvider>
    );
  }
}

export default Empty
