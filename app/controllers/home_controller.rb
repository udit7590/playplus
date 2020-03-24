class HomeController < ApplicationController
  layout 'standard'

  def index
    @popular_courses = Course.active.recent.limit(3)
  end

  def about
  end

  def contact
  end

  def privacy_policy
  end

  def terms_and_conditions
  end

  def how_to_enroll
  end

end
