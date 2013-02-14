class PlansController < ApplicationController
  def index
    @plans = Plan.ordered
  end
end
