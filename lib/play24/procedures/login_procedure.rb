module Play24
  class LoginProcedure
    attr_reader :mechanize

    def initialize(mechanize)
      @mechanize = mechanize
    end

    def run!(login, password, retry_times=10)
      retry_times.times do |i|
        begin
          mechanize.get('https://logowanie.play.pl')
          mechanize.get("https://logowanie.play.pl/p4webportal/SsoRequest")
          submit
          random = page.content.match(/jQuery\('input\[name="random"\]'\)\.val\('(.+)'\)/)[-1]
          page.forms[0].random = random
          page.forms[0].login = login
          page.forms[0].password = password
          4.times { submit }
          break
        rescue Mechanize::ResponseCodeError
          puts "Retrying LoginProcedure #{i} time..."
          sleep (2 ** i) / 5 # sleep in exponential time
        end
      end
    end

    private

    def submit(form_number = 0)
      page.forms[form_number].submit
    end

    def page
      mechanize.page
    end
  end
end