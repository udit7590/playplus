class CourseBatchesController < ApplicationController
  before_action :load_course_level, only: :index

  def index
    @course_batches = @course_level.course_batches.future
    respond_to do |format|
      format.json { render :index }
    end
  end

  private
    def load_course_level
      @course_level = CourseLevel.find(params[:course_level_id])
    end
end
