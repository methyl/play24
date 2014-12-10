module Play24
  class LoginProcedure
    attr_reader :mechanize

    def initialize(mechanize)
      @mechanize = mechanize
    end

    def run!(login, password, retry_times=10)
      mechanize.reset
      mechanize.get('https://24.play.pl')
      submit_saml

      if page.forms[0].random.length < 10
        random = page.content.match(/jQuery\('input\[name="random"\]'\)\.val\('(.+)'\)/)
        if random.nil?
          puts "PROCESS_PID: #{Process.pid}" 
          puts 'kurwa'
          binding.pry
          run!(login, password)
        else
          random = random[-1]
        end
        page.forms[0].random = random
      end
      puts "RANDOM: #{random}"

      page.forms[0].login = login
      page.forms[0].password = password
      submit
      loop do
        begin
          submit
          break
        rescue Exception => e
          puts e
        end
      end
    end

    private

    def submit_saml(form_number = 0)
      return unless mechanize.page.forms[0].fields[0]
      name = mechanize.page.forms[0].fields[0].name
      if name == 'SAMLRequest' || name == 'SAMLResponse'
        submit
        submit_saml
      end
    end

    def submit
      mechanize.page.forms[0].submit
    end

    def page
      mechanize.page
    end
  end
end