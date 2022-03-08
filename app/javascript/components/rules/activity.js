import React from "react"
import { AppProvider, Layout, Card, Badge, DescriptionList, Caption } from '@shopify/polaris'

class Activity extends React.Component {
  render () {
    return (
      <AppProvider>
        <Layout>
          { this.props.events.map((event, i) => {
            let description = <div>
              <b>Webhook ID</b><br />
              <Caption>{ event.identifier }</Caption>
            </div>

            return(
              <Layout.AnnotatedSection key={ i } title={ event.timestamp } description={ description }>
                <Card sectioned>
                  <DescriptionList items={
                    event.details.map((details, j) => {
                      let badgeStatus = details.level === "info" ? "info" : "warning";

                      return({
                        term: <Badge status={ badgeStatus }>{ details.level }</Badge>,
                        description: details.message
                      });
                    })
                  } />
                </Card>
              </Layout.AnnotatedSection>
            );
          })}
        </Layout>
      </AppProvider>
    );
  }
}

export default Activity
