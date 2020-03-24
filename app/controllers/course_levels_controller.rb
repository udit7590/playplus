class CourseLevelsController < ApplicationController
  before_action :load_course_provider, only: :index

  def index
    @course_levels = @course_provider.course_levels.active.includes(:course_batches)
    respond_to do |format|
      format.json { render :index }
    end
  end

  private
    def load_course_provider
      @course_provider = CourseProvider.find(params[:course_provider_id])
    end
end
