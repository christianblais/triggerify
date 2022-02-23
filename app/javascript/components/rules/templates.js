import React from "react"
import { AppProvider, Layout, Card } from '@shopify/polaris'

class Templates extends React.Component {
  render () {
    return (
      <AppProvider>
        <Layout>
          <Layout.AnnotatedSection
            id="ruleTemplates"
            title="Templates"
            description="Select a template to help you jumpstart your own rule."
          >
            {
              this.props.templates.map(function(template, index) {
                return (
                  <Card
                    sectioned
                    key={ index }
                    title={ template.rule.name }
                    actions={[
                      {
                        content: 'Select',
                        url: `/rules/new?template=${ template.handle }`
                      }
                    ]}
                  >
                    <p>
                      { template.description }
                    </p>
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

export default Templates
