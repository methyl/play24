module Play24
  module Dwr
    class ViewParser
      def self.parse(response)
        response = extract_content(response)
        response = remove_white_characters(response)
        response = convert_unicode_literals_to_characters(response)
      end

      private

      def self.extract_content(response)
        response.split('view:')[1].split('"}))')[0]
      end

      def self.remove_white_characters(response)
        response.gsub('\\r', '').gsub('\\n', '').gsub('\\t', '').gsub('\\"', '"')
      end

      def self.convert_unicode_literals_to_characters(response)
        response.gsub(/\\u([\da-fA-F]{4})/) {|m| [$1].pack("H*").unpack("n*").pack("U*")}
      end
    end
  end
end