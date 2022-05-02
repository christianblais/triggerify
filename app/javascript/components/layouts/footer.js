import React from "react"
import { AppProvider, FooterHelp, Link } from '@shopify/polaris'

class Footer extends React.Component {
  render () {
    return (
      <AppProvider>
        <FooterHelp>
          We'd love to hear about your experience; you can{' '}
          <Link url={ "https://docs.google.com/forms/d/e/1FAIpQLSdHStoRIefu86gEpKa1cSqakpv2m9x4SCifdO_4IymwgjN2fw/viewform?usp=pp_url&entry.1673643580=" + document.getElementById("shopify-app-init").dataset.shopOrigin } external>
            leave us feedback
          </Link>
        </FooterHelp>
      </AppProvider>
    );
  }
}

export default Footer
