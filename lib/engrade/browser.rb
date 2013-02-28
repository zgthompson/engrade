require 'mechanize'

module Engrade

  class Browser

    def initialize
      @agent
    end

    def login(u, p)
      @agent = Mechanize.new
      form = @agent.get('https://www.engrade.com/user/login.php').forms.first
      form.usr = u
      form.pwd = p
      @agent.submit(form)
    end

    def remove_comments(clid, assnid)
      page = @agent.get "https://www.engrade.com/class/assignments/edit.php?assnid=#{assnid}&clid=#{clid}"
      scores = page.form.fields_with(:name => /^score/)
      scores.each { |score| score.value = "" }
      @agent.submit(page.form)
    end

  end

end
