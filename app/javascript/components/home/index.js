import React from "react"
import { AppProvider, SkeletonBodyText } from '@shopify/polaris'

class Index extends React.Component {
  render () {
    return (
      <AppProvider>
        <SkeletonBodyText />
      </AppProvider>
    );
  }
}

export default Index
