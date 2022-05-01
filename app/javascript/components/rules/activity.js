import React from "react"
import { AppProvider, Layout, Card, EmptyState, Badge, DescriptionList, Caption, Link } from '@shopify/polaris'

class Empty extends React.Component {
  render () {
    return (
      <AppProvider>
        <Card sectioned>
          <EmptyState
            heading="Nothing to show yet"
            image="https://cdn.shopify.com/s/files/1/0262/4071/2726/files/emptystate-files.png"
          >
            <p>
              Once events start being processed by this rule, you'll get a detailed view of
              what's happening, when it's happening, as well as information on potential errors.
            </p>
          </EmptyState>
        </Card>
      </AppProvider>
    );
  }
}

class CaptionHooklysPreview extends React.Component {
  render () {
    if (this.props.identifier === "") {
      return(<></>);
    }
    
    return (
      <Caption>
        <Link url={ "https://app.hooklys.com/view/webhooks/" + this.props.identifier } external={true}>Show details</Link>
      </Caption>
    );
  }
}

class Activity extends React.Component {
  render () {
    if (this.props.events.length === 0) {
      return <Empty />
    }

    return (
      <AppProvider>
        <Layout>
          { this.props.events.map((event, i) => {
            let description = <>
              <b>Webhook ID</b><br />
              <Caption>{ event.shopify_identifier }</Caption>
              <CaptionHooklysPreview identifier={ event.hooklys_identifier } />
            </>;

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
