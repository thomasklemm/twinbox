class PlansController < ApplicationController
  before_filter :authenticate_user!
  before_filter :ensure_current_owned_account

  def show
    @plans = Plan.ordered
    @current_plan = @owned_account.plan
  end

  def edit
    raise 'Not implemented'
  end

  def update
    raise 'Not implemented'
  end
end
