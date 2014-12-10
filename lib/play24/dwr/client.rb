module Play24
  module Dwr
    class Client
      attr_reader :mechanize, :page

      def initialize(mechanize, page)
        @mechanize = mechanize
        @page = page
      end

      def reset
        session.reset
      end

      def request_view(name)
        params = ["string:#{name}", "string:trueDown"]
        result = request('templateRemoteService', 'sortData', params)
        ViewParser.parse(result)
      end

      private

      def session_id
        session.id_with_token
      end

      def request(script, method)
        @request ||= new Request(mechanize, page)
        @request.call(script, method, params, session_id)
      end

      def session
        @session ||= new Session(mechanize, page)
      end

      def dwr_token
        @dwr_token ||= tokenify(epoch) + '-' + tokenify(Random.rand(1e16).to_i)
      end
    end
  end
end