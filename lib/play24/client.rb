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

    def dwr_client
      Dwr::Client.new(mechanize, 'INVOICES_PAID')
    end

    def unpaid_invoices
      ensure_logged_in
      dwr_client.request_view('INVOICES_UNPAID')
    end

    def paid_invoices
      ensure_logged_in
      dwr_client.request_view('INVOICES_PAID')
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