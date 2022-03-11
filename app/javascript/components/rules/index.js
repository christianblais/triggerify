import React from "react"
import { AppProvider, Layout, Card, Badge } from '@shopify/polaris'

class Rule extends React.Component {
  render () {
    let rule = this.props.rule;

    let status;
    if (!rule.enabled) {
      status = <Badge status="new">Disabled</Badge>;
    }
    else if (rule.events.length === 0) {
      status = <Badge status="new">No activity</Badge>;
    }
    else if (rule.events.length > 0 && rule.events[rule.events.length - 1].error) {
      status = <Badge status="warning">Warning</Badge>;
    }
    else {
      status = <Badge status="success">Healthy</Badge>;
    }

    return (
      <Card>
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
            { status }
          </p>
        </Card.Section>
      </Card>
    );
  }
}

class Index extends React.Component {
  render () {
    let rules_enabled = [];
    let rules_disabled = [];
    this.props.rules.forEach((rule) => {
      rule.enabled ? rules_enabled.push(rule) : rules_disabled.push(rule)
    });

    let enabled_section = <Layout.AnnotatedSection
      id="ruleIndex"
      title="Enabled rules"
      description="Rules are listening to events produced by your Shopify store."
    >
      {
        rules_enabled.map(function(rule, index) {
          return <Rule rule={ rule } key={ index } />
        })
      }
    </Layout.AnnotatedSection>;

    let disabled_section;
    if (rules_disabled.length > 0) {
      disabled_section =
        <Layout.AnnotatedSection
          id="ruleIndex"
          title="Disabled rules"
          description="Rules can be enabled from their edit section."
        >
          {
            rules_disabled.map(function(rule, index) {
              return <Rule rule={ rule } key={ index } />
            })
          }
        </Layout.AnnotatedSection>
    }
 

    return (
      <AppProvider>
        <Layout>
          { enabled_section }
          { disabled_section }
        </Layout>
      </AppProvider>
    );
  }
}

export default Index
