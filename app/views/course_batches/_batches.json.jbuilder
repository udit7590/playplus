json.course_batches course_batches.each do |course_batch|
  json.id course_batch.id
  json.start_date course_batch.start_date
  json.start_date_display course_batch.start_date.to_date.to_s(:long)
  json.end_date course_batch.end_date
  json.end_date_display course_batch.end_date.to_date.to_s(:long)
  json.start_time1 course_batch.start_time1
  json.start_time1_display course_batch.start_time1.to_time.to_s(:long)
  json.end_time1 course_batch.end_time1
  json.end_time1_display course_batch.end_time1.to_time.to_s(:long)
end
