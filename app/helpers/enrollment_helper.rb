module EnrollmentHelper
  def states_help
    Enrollment.state_descriptions.map do |k,v|
      "#{ k } : #{ v }"
    end.join("<br />").html_safe
  end
end
