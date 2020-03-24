class Users::EnrollmentsController < Users::BaseController
  def show
    @enrollment = current_user.enrollments.find(params[:id])
  end

  def index
    @enrollments = current_user.enrollments.includes(course_batch: { course_level: :course_provider })
  end
end
