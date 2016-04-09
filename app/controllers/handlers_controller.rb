class HandlersController < ShopifyApp::AuthenticatedController
  def new
    @handler = rule.handlers.build
  end

  def edit
    @handler = rule.handlers.find(params[:id])
  end

  def create
    @handler = rule.handlers.build(handler_params)

    if @handler.save
      redirect_to(rule_path(rule))
    else
      render('new')
    end
  end

  private

  def rule
    @rule ||= shop.rules.find(params[:rule_id])
  end

  def handler_params
    params.require(:handler).permit(:service_name).tap do |handler|
      handler[:settings] = params[:handler][:settings]
    end
  end
end
