class EnrollmentsController < ApplicationController
  # TODO:
  # 1. Ensure active course provider and active course level
  before_action :active_course_provider_and_level
  # 2. Ensure sufficient seats
  before_action :ensure_sufficient_seats
  # 3. Ensure start_date is greater than next batch date if any
  before_action :ensure_future_batch
  # TODO_SKIP: 4. Ensure end_date > start_date
  # TODO_SKIP: 5. Ensure end_date > duration of course + start_date
  # TODO_SKIP: 6. Check enquiry or apt state
  # 7. User logged in. If not, need to show login/signup page.
  before_action :authenticate_user!, only: :create
  # TODO_SKIP: 8. Tell user if batch about to start and user's location is far away
  # TODO: 9. Ensure no overlapping course enrollment / Max 3 courses overlapping

  # POST
  def create
    @enrollment = current_user.enrollments.build(enrollment_params)
    respond_to do |format|
      if @enrollment.save
        format.html { redirect_to user_enrollment_path(current_user, @enrollment), notice: 'We have received your request for enrollment. We\'ll contact you with further details.' }
      else
        flash[:alert] = @enrollment.errors.full_messages.to_sentence
        format.html { redirect_to request.referrer }
      end
    end
  end

  private
    def enrollment_params
      params.require(:enrollment).permit(permitted_enrollment_attributes)
    end

    def active_course_provider_and_level
      @course_provider = CourseProvider.active.where(id: params[:enrollment][:course_provider_id]).first
      @course_level    = CourseLevel.active.where(id: params[:enrollment][:course_level_id]).first
      @course_batch    = CourseBatch.where(id: params[:enrollment][:course_batch_id]).first
      if !@course_provider || !@course_level || !@course_batch
        raise ActiveRecord::RecordNotFound
      end
    end

    # TODO: Should be validation
    def ensure_sufficient_seats
      if !!@course_batch && !@course_batch.seats_available?
        redirect_to :back, alert: 'Sorry. There are not enough seats left. Please select some different batch.'
      end
    end

    # TODO: Should be validation
    def ensure_future_batch
      if !!@course_batch && @course_batch.expired?
        redirect_to :back, alert: 'Sorry. There but the batch has already started. Please select some different batch.'
      end
    end

end
