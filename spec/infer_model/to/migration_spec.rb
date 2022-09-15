# frozen_string_literal: true

require "spec_helper"

RSpec.describe InferModel::To::Migration do
  include ActiveSupport::Testing::TimeHelpers

  around { |ex| travel_to(Time.new(2022, 11, 2, 11, 2, 11)) { ex.run } }
  before { FileUtils.rm_rf(target_dir) }

  let(:target_dir) { "tmp/spec/db/migrate" }
  let(:expected_filename) { File.join(target_dir, "20221102110211_create_happy_paths.rb") }

  describe "#call" do
    subject(:call) { described_class.call(model, target_dir:) }
    let(:model) do
      InferModel::Model.new(
        source_name: "happy_path",
        attributes: {
          integer_col: InferModel::CommonType.new(:integer),
          decimal_col: InferModel::CommonType.new(:decimal),
          datetime_col: InferModel::CommonType.new(:datetime),
          time_col: InferModel::CommonType.new(:time),
          boolean_col: InferModel::CommonType.new(:boolean),
          json_col: InferModel::CommonType.new(:json),
          uuid_col: InferModel::CommonType.new(:uuid),
          string_col: InferModel::CommonType.new(:string),
        },
      )
    end

    it "creates a migration file" do
      expect { call }.to change { File.exist?(expected_filename) }.from(false).to(true)
      expect(File.read(expected_filename)).to eq(<<~RUBY)
        # frozen_string_literal: true

        class CreateHappyPaths < ActiveRecord::Migration[7.0]
          def change
            create_table "happy_paths" do |t|
              t.integer "integer_col"
              t.decimal "decimal_col"
              t.datetime "datetime_col"
              t.time "time_col"
              t.boolean "boolean_col"
              t.json "json_col"
              t.uuid "uuid_col"
              t.string "string_col"

              t.timestamps
            end
          end
        end
      RUBY
    end

    context "with detailed constraint information" do
      let(:model) do
        InferModel::Model.new(
          source_name: "happy_path",
          attributes: {
            integer_col: InferModel::CommonType.new(:integer, unique_constraint_possible: true, non_null_constraint_possible: true),
            decimal_col: InferModel::CommonType.new(:decimal),
            datetime_col: InferModel::CommonType.new(:datetime, non_null_constraint_possible: true),
            time_col: InferModel::CommonType.new(:time),
            boolean_col: InferModel::CommonType.new(:boolean, non_null_constraint_possible: true),
            json_col: InferModel::CommonType.new(:json),
            uuid_col: InferModel::CommonType.new(:uuid, unique_constraint_possible: true),
            string_col: InferModel::CommonType.new(:string),
          },
        )
      end

      it "creates a migration file" do
        expect { call }.to change { File.exist?(expected_filename) }.from(false).to(true)
        expect(File.read(expected_filename)).to eq(<<~RUBY)
          # frozen_string_literal: true

          class CreateHappyPaths < ActiveRecord::Migration[7.0]
            def change
              create_table "happy_paths" do |t|
                t.integer "integer_col", null: false
                t.decimal "decimal_col"
                t.datetime "datetime_col", null: false
                t.time "time_col"
                t.boolean "boolean_col", null: false
                t.json "json_col"
                t.uuid "uuid_col"
                t.string "string_col"
                t.index ["integer_col"], unique: true
                t.index ["uuid_col"], unique: true

                t.timestamps
              end
            end
          end
        RUBY
      end
    end

    context "with an attributes map" do
      subject(:call) { described_class.call(model, attributes_map:, target_dir:) }
      let(:attributes_map) do
        {
          integer_col: :some_unique_present_number,
          decimal_col: :a_floating_number,
          datetime_col: :birthday,
          time_col: :some_time,
          boolean_col: :truthSpoken?,
          uuid_col: :unique_uuid,
        }
      end
      let(:model) do
        InferModel::Model.new(
          source_name: "happy_path",
          attributes: {
            integer_col: InferModel::CommonType.new(:integer, unique_constraint_possible: true, non_null_constraint_possible: true),
            decimal_col: InferModel::CommonType.new(:decimal),
            datetime_col: InferModel::CommonType.new(:datetime, non_null_constraint_possible: true),
            time_col: InferModel::CommonType.new(:time),
            boolean_col: InferModel::CommonType.new(:boolean, non_null_constraint_possible: true),
            json_col: InferModel::CommonType.new(:json),
            uuid_col: InferModel::CommonType.new(:uuid, unique_constraint_possible: true),
            string_col: InferModel::CommonType.new(:string),
          },
        )
      end

      it "creates a migration file" do
        expect { call }.to change { File.exist?(expected_filename) }.from(false).to(true)
        expect(File.read(expected_filename)).to eq(<<~RUBY)
          # frozen_string_literal: true

          class CreateHappyPaths < ActiveRecord::Migration[7.0]
            def change
              create_table "happy_paths" do |t|
                t.integer "some_unique_present_number", null: false
                t.decimal "a_floating_number"
                t.datetime "birthday", null: false
                t.time "some_time"
                t.boolean "truthSpoken?", null: false
                t.uuid "unique_uuid"
                t.index ["some_unique_present_number"], unique: true
                t.index ["unique_uuid"], unique: true

                t.timestamps
              end
            end
          end
        RUBY
      end
    end
  end
end
