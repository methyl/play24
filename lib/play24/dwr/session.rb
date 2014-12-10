module Play24
  module Dwr
    class Session
      attr_accessor :mechanize, :page

      def initialize(mechanize, page)
        @mechanize = mechanize
        @page = page
      end

      def id_with_token
        @id_with_token ||= generate_id_with_token
      end

      def reset
        @id_with_token = nil
      end

      private

      def generate_id_with_token
        id = generate_id
        token = generate_token
        "#{id}/#{token}"
      end

      def generate_id
        request = new Request(mechanize, page)
        content = request.call('__System', 'generateId')
        content.split('r.handleCallback("0","0","')[1].split('");')[0]
      end

      def generate_token
        tokenify(epoch) + '-' + tokenify(Random.rand(1e16).to_i)
      end

      def tokenify(number)
        tokenbuf = ""
        charmap = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ*$".split('')
        while (number > 0) do
          tokenbuf += charmap[number & 0x3F];
          number = (number / 64);
        end
        tokenbuf
      end

      def epoch
        (Time.now.to_f * 1000).to_i
      end
    end
  end
end