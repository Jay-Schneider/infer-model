# frozen_string_literal: true

module InferModel::To
  class Text
    extend Dry::Initializer
    extend InferModel::Callable

    param :model
    option :outstream, default: -> { $stdout }

    def call
      outstream << <<~TEXT
        #{title}
        #{formatted_attributes.join("\n\n")}
      TEXT
    end

    private

    def title
      source_name_line = "Source Name: '#{model.source_name}'"
      <<~TEXT
        #{source_name_line}
        #{"#" * source_name_line.size}

        Attributes:
        -----------
      TEXT
    end

    def formatted_attributes
      model.attributes.map do |attr_name, common_type|
        formatted_attribute(attr_name, common_type)
      end
    end

    def formatted_attribute(attr_name, common_type)
      attr_____string = "#{attr_name}:"
      type_____string = "  Type:     #{common_type.detected_type}"
      unique___string = "  Unique:   contains only unique values" if common_type.unique_constraint_possible
      non_null_string = "  Non null: does not contain empty values" if common_type.non_null_constraint_possible
      [
        attr_____string,
        type_____string,
        unique___string,
        non_null_string,
      ].compact.join("\n")
    end
  end
end
