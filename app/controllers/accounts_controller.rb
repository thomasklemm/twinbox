class AccountsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :ensure_current_account

  # GET /account
  def show
  end

  # GET /account/edit
  def edit
  end

  # PUT /account
  def update
    if @account.update_attributes(params[:account])
      flash[:success] = 'Account updated.'
      redirect_to account_path
    else
      render action: :edit
    end
  end

  # DELETE /account
  def destroy
    raise 'Account destruction is not implemented.'
  end

  private

  def ensure_current_account
    @account ||= current_account
    raise 'Not authorized' unless @account.present? # TODO: How else can authorization be ensured?
  end

  # Access only to owned account for account owner
  def current_account
    current_user.owned_account
  end

  def current_account?
    current_account.present?
  end
end

