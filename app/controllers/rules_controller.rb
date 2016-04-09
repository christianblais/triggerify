class RulesController < ShopifyApp::AuthenticatedController
  def index
    @rules = shop.rules
  end

  def new
    @rule = shop.rules.build
  end

  def show
    @rule = shop.rules.find(params[:id])
  end

  def create
    @rule = shop.rules.build(rule_params)

    if @rule.save
      redirect_to(rules_path)
    else
      render('new')
    end
  end

  private

  def rule_params
    params.require(:rule).permit(:topic)
  end
end
