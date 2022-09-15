# frozen_string_literal: true

require "active_support/core_ext/hash/reverse_merge"
require "csv"

module InferModel::From
  class CSV
    extend Dry::Initializer
    extend InferModel::Callable

    DEFAULT_CSV_OPTIONS = { col_sep: ",", encoding: "utf-8", headers: true, quote_char: "\x00" }.freeze

    param :filename
    option :available_types, default: -> { ::InferModel::ValueTypeGuesser::RESULT_TYPES }
    option :multi, default: -> { false }
    option :rename_attributes, optional: true
    option :csv_options, default: -> { {} }

    def call
      ::InferModel::Model.new(source_name:, attributes:)
    end

    private

    def source_name = File.basename(filename, File.extname(filename))

    def attributes
      csv.by_col!.to_h do |header, contents|
        [
          transform_header(header),
          ::InferModel::CommonTypeGuesser.call(contents, available_types:),
        ]
      end
    end

    def transform_header(header)
      header = header.downcase.to_sym
      return header unless rename_attributes

      rename_attributes.to_proc.call(header) || header
    end

    def csv = ::CSV.parse(file_content, **csv_options_with_defaults)

    def file_content = File.read(filename)

    def csv_options_with_defaults = csv_options.with_defaults(DEFAULT_CSV_OPTIONS)
  end
end
