require 'guard'
require 'guard/guard'
require 'guard/websocket-rails/version'

module Guard
  class WebsocketRails < Guard

    def initialize(watchers=[], options={})
      super

      @environment = options[:environment] || 'development'
    end

    def start
      system("rake sunspot:solr:start RAILS_ENV=#{@environment}")
      UI.info "Websocket standalone server started (#{@environment})"
    end

    def stop
      system("rake sunspot:solr:stop RAILS_ENV=#{@environment}")
      UI.info "Websocket standalone server stopped (#{@environment})"
    end

    def reload
      stop
      start
    end

    def run_on_change(path)
      reload
    end

  end
end
