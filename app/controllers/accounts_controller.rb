class AccountsController < ApplicationController
  # Some authorization before filters in Saucy

  # GET /plans/:id/accounts/new
  def new
    @plan = Plan.find(params[:plan_id])
    @signup = Signup.new
  end

  # POST /plans/:id/accounts
  def create
    @plan = Plan.find(params[:plan_id])
    @signup = Signup.new(params[:signup])

    @signup.user = current_user
    @signup.plan = @plan

    if @signup.save
      sign_in @signup.user
      redirect_to new_account_project_path(@signup.account)
    else
      render action: :new
    end
  end

  # GET /accounts
  def index
    if current_user.projects.size == 1
      flash.keep
      project = current_user.projects.first
      redirect_to account_project_path(project.account, project)
    else
      @accounts = current_user.accounts
    end
  end

  # GET /accounts/:id/edit
  def edit
    @account = current_account
  end

  # PUT /accounts/:id
  def update
    @account = current_account
    if @account.update_attributes(params[:account])
      flash[:success] = 'Your account has been updated.'
      redirect_to edit_profile_url
    else
      render action: :edit
    end
  end

  # DELETE /accounts/:id
  def destroy
    current_account.destroy
    flash[:success] = 'Your account has been deleted.'
    redirect_to root_url
  end

  private

  def current_account
    Account.find_by_keyword!(params[:id])
  end

  def current_account?
    params[:id].present?
  end
end

