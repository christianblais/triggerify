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

  def update
    @rule = shop.rules.find(params[:id])

    if @rule.update_attributes(rule_params)
      redirect_to(rule_path(@rule))
    else
      render('show')
    end
  end

  def destroy
    @rule = shop.rules.find(params[:id])

    if @rule.destroy
      redirect_to(rules_path)
    else
      render('show')
    end
  end

  private

  def rule_params
    rule = params.require(:rule)
    rule = rule.permit(:name, :topic, handlers_attributes: [:id, :service_name])
    rule[:handlers_attributes].each do |k, _v|
      rule[:handlers_attributes][k][:settings] = params[:rule][:handlers_attributes][k][:settings]
    end
    rule
  end
end
