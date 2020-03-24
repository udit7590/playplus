json.course_levels @course_levels.each do |course_level|
  json.id course_level.id
  json.name course_level.level_name
  json.price course_level.price
  json.taxes course_level.taxes
  json.net_amount course_level.net_amount
  json.price_display course_level.price_display
  json.taxes_display course_level.taxes_display
  json.net_amount_display course_level.net_amount_display
  json.coach_name course_level.coach_name
  json.description course_level.description
  json.instructions course_level.instructions
  json.prerequisites course_level.prerequisites
  json.duration course_level.duration
  json.duration_display ("#{ course_level.duration } Hours")
  json.sessions course_level.sessions
  json.session_duration course_level.session_duration
  json.session_duration_display ("#{ course_level.session_duration } Minutes")
  json.has_batches course_level.has_batches

  json.partial! partial: 'course_batches/batches', locals: { course_batches: course_level.course_batches }
end
json.has_multiple_levels (@course_levels.length > 1)
json.has_levels (@course_levels.length > 0)
