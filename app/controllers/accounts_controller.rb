class AccountsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :ensure_current_owned_account

  # GET /account
  def show
  end

  # GET /account/edit
  def edit
  end

  # PUT /account
  def update
    if @owned_account.update_attributes(params[:account])
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
end

