import React from "react"
import { AppProvider, Layout, Card, Badge } from '@shopify/polaris'

class Index extends React.Component {
  render () {
    return (
      <AppProvider>
        <Layout>
          <Layout.AnnotatedSection
            id="ruleIndex"
            title="Rules"
            description="These are the rules you created."
          >
            {
              this.props.rules.map(function(rule, index) {
                let badge;

                if (rule.enabled) {
                  badge = <Badge status="success">Enabled</Badge>
                } else {
                  badge = <Badge status="warning">Disabled</Badge>
                }
                
                return (
                  <Card key={ index }>
                    <Card.Section title={ rule.name }
                      actions={[
                        {
                          content: 'Activity',
                          url: `/rules/${ rule.id }/activity`
                        },
                        {
                          content: 'Edit',
                          url: `/rules/${ rule.id }`
                        },
                        {
                          content: 'Delete',
                          url: `/rules/${ rule.id }`,
                          onAction: (event) => {
                            if (event.currentTarget.getAttribute('data-remote'))
                              return;

                            event.preventDefault();
                            event.stopPropagation();

                            if (window.confirm('Delete this rule?')) {
                              event.currentTarget.setAttribute("data-remote", "remote");
                              event.currentTarget.setAttribute("data-method", "delete");

                              event.currentTarget.click();
                            }
                          }
                        }
                      ]}
                    >
                      <p>
                        { badge }
                      </p>
                    </Card.Section>
                  </Card>
                );
              })
            }
          </Layout.AnnotatedSection>
        </Layout>
      </AppProvider>
    );
  }
}

export default Index
