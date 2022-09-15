# frozen_string_literal: true

require "active_support/core_ext/string/inflections"

module InferModel::To
  class Migration
    extend Dry::Initializer
    extend InferModel::Callable

    TIMESTAMP_FORMAT = "%Y%m%d%H%M%S"

    param :model
    option :attributes_map, optional: true
    option :filter_on_attribute_mapping, default: -> { true }
    option :rails_version, default: -> { "7.0" }
    option :table_name, optional: true
    option :target_dir, default: -> { "db/migrate" }

    def call
      FileUtils.mkdir_p(target_dir)
      File.write(migration_filename, migration_content)
    end

    private

    def migration_filename
      timestamp = Time.now.localtime.strftime(TIMESTAMP_FORMAT)
      File.join(target_dir, "#{timestamp}_create_#{given_or_inferred_tablename}.rb")
    end

    def given_or_inferred_tablename
      table_name || model.source_name.pluralize
    end

    def given_or_mapped_attributes
      return model.attributes unless attributes_map

      if filter_on_attribute_mapping
        attributes_map.to_h { |old_key, new_key| [new_key, model.attributes[old_key]] }
      else
        model.attributes.transform_keys { |key| attributes_map.fetch(key, key) }
      end
    end

    def migration_content
      <<~RUBY
        # frozen_string_literal: true

        class Create#{given_or_inferred_tablename.camelize} < ActiveRecord::Migration[#{rails_version}]
          def change
            create_table "#{given_or_inferred_tablename}" do |t|
              #{column_ddl_lines}

              t.timestamps
            end
          end
        end
      RUBY
    end

    COLUMN_DDL_LINES_WITH_INDENTATION_JOINER = "\n#{"  " * 3}".freeze

    def column_ddl_lines
      column_definitions = given_or_mapped_attributes.map do |key, common_type|
        attribute_and_name = %(t.#{common_type.detected_type} "#{key}")
        non_null_constraint = common_type.non_null_constraint_possible ? "null: false" : nil

        [attribute_and_name, non_null_constraint].compact.join(", ")
      end
      index_definitions = given_or_mapped_attributes.filter_map do |key, common_type|
        next unless common_type.unique_constraint_possible

        %(t.index ["#{key}"], unique: true)
      end

      (column_definitions + index_definitions).join(COLUMN_DDL_LINES_WITH_INDENTATION_JOINER)
    end
  end
end
