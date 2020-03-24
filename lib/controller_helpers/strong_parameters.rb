module ControllerHelpers
  module StrongParameters
    def permitted_attributes
      PermittedAttributes
    end

    delegate *PermittedAttributes::ATTRIBUTES,
             to: :permitted_attributes,
             prefix: :permitted

    def permitted_course_attributes
      permitted_attributes.course_attributes + [
        course_providers_attributes: permitted_course_provider_attributes
      ]
    end

    def permitted_course_provider_attributes
      permitted_attributes.course_provider_attributes + [
        course_levels_attributes: permitted_course_level_attributes
      ]
    end

    def permitted_course_level_attributes
      permitted_attributes.course_level_attributes + [
        course_batches_attributes: permitted_course_batch_attributes
      ]
    end
  end
end
