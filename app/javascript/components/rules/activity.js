import React from "react"
import { AppProvider, Layout, Card, Badge, Caption, TextContainer, Banner } from '@shopify/polaris'

class Activity extends React.Component {
  render () {
    return (
      <AppProvider>
        <Layout>
          <Layout.AnnotatedSection
            id="ruleActivity"
            title="Activity"
            description="See the most recent activity pertaining to this rule."
          >
            { this.props.events.map((event, i) => {
              let banner;

              if (event.error) {
                banner =
                  <Card.Section>
                    <Banner status="warning">
                      <p>There has been a problem executing this rule.</p>
                    </Banner>
                  </Card.Section>
              }

              return(
                <Card title={ event.name } key={ i }>
                  { banner }

                  { event.details.map((details, j) => {
                    let badgeStatus = details.level == "info" ? "info" : "warning";

                    return(
                      <Card.Section key={ j }>
                        <TextContainer>
                          <p>
                            <Badge status={ badgeStatus }>{ details.level }</Badge>
                            &nbsp;
                            { details.message }
                          </p>
                          <p>
                            <Caption>{ details.timestamp }</Caption>
                          </p>
                        </TextContainer>
                      </Card.Section>
                    );
                  }) }
                </Card>
              );
            }) }
          </Layout.AnnotatedSection>
        </Layout>
      </AppProvider>
    );
  }
}

export default Activity
