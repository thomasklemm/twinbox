class ProjectsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :ensure_current_project

  def show
  end
end
