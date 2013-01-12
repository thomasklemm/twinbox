class QueriesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_company

  def index
    @queries = @company.queries
    @new_query = Query.new
  end

  def create
    @query = @company.queries.build(params[:query].merge(type: 'search'))
    if @query.save
      flash.notice = 'Query was successfully created.'
    else
      flash.alert = 'Query creation has failed.'
    end
    redirect_to queries_path
  end

  def destroy
    @query = @company.queries.find(params[:id])
    @query.destroy
    redirect_to queries_path
  end

protected

  def find_company
    @company = current_user.company
  end
end
