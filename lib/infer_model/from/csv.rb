# frozen_string_literal: true

require "csv"

module InferModel::From
  class CSV
    extend Dry::Initializer
    extend InferModel::Callable

    param :filename
    option :available_types, default: -> { ::InferModel::ValueTypeGuesser::RESULT_TYPES }
    option :multi, default: -> { false }
    option :csv_options, default: -> { { col_sep: ",", encoding: "utf-8", headers: true, quote_char: "\x00" } }

    def call
      csv.by_col!.to_h do |header, contents|
        [
          header.downcase.to_sym,
          ::InferModel::CommonTypeGuesser.call(contents, available_types:),
        ]
      end
    end

    private

    def csv = ::CSV.parse(file_content, **csv_options)

    def file_content = File.read(filename)
  end
end
