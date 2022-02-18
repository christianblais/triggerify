import React from "react"
import { AppProvider, Card, EmptyState } from '@shopify/polaris'

class Empty extends React.Component {
  render () {
    return (
      <AppProvider>
        <Card sectioned>
          <EmptyState
            heading="Create your first rule"
            action={{
              content: 'Add transfer',
              url: this.props.new_rule_path
            }}
            secondaryAction={{
              content: 'Learn more',
              external: true,
              url: 'https://github.com/christianblais/triggerify/wiki/Rules'
            }}
            image="https://cdn.shopify.com/s/files/1/0262/4071/2726/files/emptystate-files.png"
          >
            <p>React to what's happening on your store by creating custom rules.</p>
          </EmptyState>
        </Card>
      </AppProvider>
    );
  }
}

export default Empty
