module Play24
  module Dwr
    class Request
      attr_reader :mechanize, :script, :method, :page, :session, :batch_id

      def initialize(mechanize, page)
        @mechanize = mechanize
        @page = page
        @batch_id = 0
      end

      def call(script, method, params = [], session = "")
        url = "https://24.play.pl/Play24/dwr/call/plaincall/#{script}.#{method}.dwr"
        data = generate_data(script, method, params, session)
        content = mechanize.post(url, data).content
        bump_batch_id
        content
      end

      private

      def data(script, method, params, session)
        {
          "callCount" => 1, 
          "c0-scriptName" => script, 
          "c0-methodName" => method, 
          "c0-id" => "0", 
          "batchId" => batch_id, 
          "instanceId" => "0", 
          "page" => page, 
          "scriptSessionId" => session, 
          "windowName" => ""
        }.merge params.each_with_index.inject({}) { |hash, (param, index)| 
          hash["c0-param#{index}"] = param
        }
      end

      def bump_batch_id
        @batch_id += 1
      end
    end
  end
end