module Play24
  class Client
    def initialize(configuration)
      @login = configuration[:login]
      @password = configuration[:password]
    end

    def mechanize
      if @mechanize
        @mechanize
      else
        @mechanize = Mechanize.new
        @mechanize.user_agent_alias = Mechanize::AGENT_ALIASES.keys.sample(1).first
        @mechanize
      end
    end

    def unpaid_invoices
      ensure_logged_in
      @dwr_batch_id ||= 0
      link = 'https://24.play.pl/Play24/dwr/call/plaincall/templateRemoteService.sortData.dwr'
      data = {
        "callCount" => '1',
        "c0-scriptName" => 'templateRemoteService',
        "c0-methodName" => 'sortData',
        "c0-id" => '0',
        "c0-param0" => 'string:INVOICES_UNPAID',
        "c0-param1" => 'string:trueDown',
        "batchId" => @dwr_batch_id,
        "instanceId" => '0',
        "page" => '%2FPlay24%2FInvoices',
        "scriptSessionId" => "#{dwr_session}/#{dwr_token}",
        "windowName" => ""
      }
      @dwr_batch_id += 1
      mechanize.post(link, data)
    end

    def paid_invoices
      ensure_logged_in
      @dwr_batch_id ||= 0
      link = 'https://24.play.pl/Play24/dwr/call/plaincall/templateRemoteService.sortData.dwr'
      data = {
        "callCount" => '1',
        "c0-scriptName" => 'templateRemoteService',
        "c0-methodName" => 'sortData',
        "c0-id" => '0',
        "c0-param0" => 'string:INVOICES_PAID',
        "c0-param1" => 'string:trueDown',
        "batchId" => @dwr_batch_id,
        "instanceId" => '0',
        "page" => '%2FPlay24%2FInvoices',
        "scriptSessionId" => "#{dwr_session}/#{dwr_token}",
        "windowName" => ""
      }
      @dwr_batch_id += 1
      mechanize.post(link, data)
    end


    def dwr_session
      return @dwr_session if @dwr_session
      mechanize.post('https://24.play.pl/Play24/dwr/call/plaincall/__System.generateId.dwr', {"callCount" => 1, "c0-scriptName" => "__System", "c0-methodName" => "generateId", "c0-id" => "0", "batchId" => "0", "instanceId" => "0", "page" => "/Play24/Invoices", "scriptSessionId" => "", "windowName" => ""})
      @dwr_session = mechanize.page.content.split('r.handleCallback("0","0","')[1].split('");')[0]
    end

    def dwr_token
      @dwr_token ||= tokenify(epoch) + '-' + tokenify(Random.rand(1e16).to_i)
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

    def ensure_logged_in
      return true if logged_in?
      login
    end

    def login
      mechanize.reset
      LoginProcedure.new(mechanize).run!(@login, @password)
    end

    def logged_in?
      mechanize.get('https://24.play.pl/Play24/Welcome')
      page && page.content && page.content.match(/Wyloguj/) != nil
    end

    def page
      mechanize.page
    end

  end
end