require 'faraday'

module Instapaper
  class InstapaperClient

    attr_accessor :username, :password

    def initialize (username, password)
      @conn = Faraday.new(:url => 'https://www.instapaper.com/api/')
      @conn.basic_auth(username, password)

      self.username = username
      self.password = password
    end

    def authenticated?
      res = @conn.get('authenticate')
      res.status == 200
    end

    def add (url, title)
      @conn.get do |req|
        req.url 'add'
        req.params['url'] = url
        req.params['title'] = title
      end
    end
  end
end
