module NavigationHelper
  def nav_link(link_text, link_path, options={})
    check_paths = (options[:alternative_paths].to_a << link_path)
    class_name = (check_paths.any? { |path| current_page?(path) }) ? 'active' : ''
    (class_name += ' ' + options[:class]) if options[:class]
    options.merge!(class: class_name) if class_name.present?

    link_to link_text, link_path, options
  end
end
