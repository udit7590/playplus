module ApplicationHelper
  def tooltip(text, direction = :bottom, html = false)
    "title='#{ text }' data-toggle='tooltip' data-html='#{ html }' data-placement='#{ direction }'".html_safe
  end
end
