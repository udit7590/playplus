class CoursesController < ApplicationController
  load_resource only: :show

  def index
    @courses = Course.active.page(params[:page])
  end

  def search
    @courses = Course.active.search_everything(params[:q])
    @search  = true
    render :index
  end

  def show
    @enrollment = Enrollment.new
  end
end
