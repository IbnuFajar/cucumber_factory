module Cucumber
  class Factory
    class MultilineParser

      STEP_PREFIX_PATTERN = /\A(with|and) these attributes:/
      DOC_STRING_PATTERN = /^\s*(.+):(.+)$/
      DATA_TABLE_PATTERN = /^\s*\|(.+)\|(.+)\|$/

      # MultilineParser allows to use doc string or data tables for factory attributes:
      #
      # https://cucumber.io/docs/reference#doc-strings
      # https://cucumber.io/docs/reference#data-tables
      #
      # Example usage:
      #
      # Given there is a user with these attributes:
      #   """
      #   name: Jane
      #   locked: true
      #   """
      #
      # Given there is a user with the email "test@invalid.com" and these attributes:
      #   """
      #   name: Jane
      #   """
      #
      # Given there is a user with these attributes:
      #   | name   | Jane |
      #   | locked | true |
      #
      # Given there is a user with the email "test@invalid.com" and these attributes:
      #   | name | Jane |
      #
      #
      # Example inputs:
      #
      # " with these attributes:\n  name: Jane\n  locked: true\n""
      # " and these attributes:\n  name: Jane\n"
      # " with these attributes:\n  | name   | Jane |\n  | locked | true |\n"
      # " and these attributes:\n  | name | Jane |\n"

      def initialize(multiline_attributes)
        @multiline_attributes = multiline_attributes
      end

      def extract_attributes
        strip_multiline_attributes

        if doc_string?
          parse_doc_string
        elsif data_table?
          parse_data_table
        else
          raise "Expected '#{multiline_attributes}' to be a valid doc string or data table, but it was not parsable."
        end
      end

      private

      attr_accessor :multiline_attributes

      def strip_multiline_attributes
        self.multiline_attributes = multiline_attributes.strip
        self.multiline_attributes = multiline_attributes.gsub(STEP_PREFIX_PATTERN, '')
        self.multiline_attributes = multiline_attributes.strip
      end

      def doc_string?
        DOC_STRING_PATTERN =~ multiline_attributes
      end

      def parse_doc_string
        attributes = {}

        multiline_attributes.scan(DOC_STRING_PATTERN) do |attribute_name, attribute_value|
          attributes[attribute_name.strip] = attribute_value.strip
        end

        attributes
      end

      def data_table?
        DATA_TABLE_PATTERN =~ multiline_attributes
      end

      def parse_data_table
        attributes = {}

        multiline_attributes.scan(DATA_TABLE_PATTERN) do |attribute_name, attribute_value|
          attributes[attribute_name.strip] = attribute_value.strip
        end

        attributes
      end

    end
  end
end
