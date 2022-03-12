import React from "react"
import { AppProvider, Layout, Card, Badge } from '@shopify/polaris'

class RuleStatus extends React.Component {
  render () {
    const rule = this.props.rule;

    let status;
    let text;
    if (!rule.enabled) {
      status = "new";
      text = "Disabled";
    }
    else if (rule.events.length === 0) {
      status = "new";
      text = "No activity";
    }
    else if (rule.events.length > 0 && rule.events[rule.events.length - 1].error) {
      status = "warning";
      text = "Warning";
    }
    else {
      status = "success";
      text = "Healthy";
    }

    return (
      <Badge status={status}>{text}</Badge>
    )
  }
}

class Rule extends React.Component {
  render () {
    const rule = this.props.rule;

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
            <RuleStatus rule={rule}/>
          </p>
        </Card.Section>
      </Card>
    );
  }
}

class SectionEnabled extends React.Component {
  render () {
    return(
      <Layout.AnnotatedSection
        id="ruleIndex"
        title="Enabled rules"
        description="Rules are listening to events produced by your Shopify store."
      >
        {
          this.props.rules.map(function(rule, index) {
            return <Rule rule={ rule } key={ index } />
          })
        }
      </Layout.AnnotatedSection>
    )
  }
}

class SectionDisabled extends React.Component {
  render () {
    if (this.props.rules.length === 0) {
      return (
        <></>
      )
    }

    return(
      <Layout.AnnotatedSection
        id="ruleIndex"
        title="Disabled rules"
        description="Rules can be enabled from their edit section."
      >
        {
          this.props.rules.map(function(rule, index) {
            return <Rule rule={ rule } key={ index } />
          })
        }
      </Layout.AnnotatedSection>
    )
  }
}

class Index extends React.Component {
  render () {
    const rules_enabled = [];
    const rules_disabled = [];
    this.props.rules.forEach((rule) => {
      rule.enabled ? rules_enabled.push(rule) : rules_disabled.push(rule)
    });

    return (
      <AppProvider>
        <Layout>
          <SectionEnabled rules={rules_enabled} />
          <SectionDisabled rules={rules_disabled} />
        </Layout>
      </AppProvider>
    );
  }
}

export default Index
