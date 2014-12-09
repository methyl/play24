module Play24
  class Client
    def initialize(configuration)
      @login = configuration[:login]
      @password = configuration[:password]
    end

    def ensure_logged_in
      return true if logged_in?
      login
    end

    private

    def login
      mechanize.reset
      LoginProcedure.new(mechanize).run!(@login, @password)
    end

    def logged_in?
      page && page.content && page.content.match(/Wyloguj/) != nil
    end

    def page
      mechanize.page
    end

    def mechanize
      @mechanize ||= Mechanize.new
    end
  end
end