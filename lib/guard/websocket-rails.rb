require 'guard/compat/plugin'

module Guard
  class WebsocketRails < Plugin
    attr_reader :options

    MAX_WAIT_COUNT = 10
    DEFAULT_OPTIONS = {
      environment: 'development',
      bundler: false,
      zeus: false,
      pid_file: nil,
      timeout: 30
    }

    def initialize(options={})
      super
      @options = DEFAULT_OPTIONS.merge(options)
      @root = options[:root] ? File.expand_path(options[:root]) : Dir.pwd
    end

    def start
      if ( redis_guards = Guard.state.session.plugins.all('redis') ).empty?
        UI.info "[Guard::WebsocketRails::Error] Could not find zeus socket file."
        return false
      end
      if options[:zeus] && !wait_for_zeus
        UI.info "[Guard::WebsocketRails::Error] Could not find zeus socket file."
        return false
      end
      run_wsr_command!('start_server')
      wait_for_pid
      UI.info "Websocket standalone server started (#{options[:environment]})"
      redis_guards[0].add_callback(-> { puts 'I GET CALLED!'; stop }, self, :stop_begin)
    end

    def stop
      return unless has_pid?
      run_wsr_command!('stop_server')
      wait_for_no_pid
      UI.info "Websocket standalone server stopped (#{options[:environment]})"
    end

    def reload
      stop
      start
    end

    def run_on_change(path)
      reload
    end

    private
    def pid_file
      @pid_file ||= File.expand_path( options[:pid_file] || File.join( @root,
        'tmp', 'pids', pid_filename ) )
    end
    def pid_filename
      return options[:pid_file].to_s.split('/').last if options[:pid_file]
      o = 'websocket_rails'
      o << "_#{options[:environment]}" if options[:environment].to_s != 'development'
      o << '.pid'
    end
    def pid; has_pid? ? read_pid : nil end
    def has_pid?; File.file? pid_file end
    def read_pid; Integer(File.read(pid_file)); rescue ArgumentError; nil end

    def environment
      { 'RAILS_ENV' => options[:zeus] ? nil : options[:environment].to_s }
    end

    def build_rake_command
      cmd = []
      cmd << 'bundle exec' if options[:bundler]
      cmd << 'zeus' if options[:zeus]
      cmd << 'rake'
      cmd.join ' '
    end
    def build_wsr_command(cmd)
      "#{build_rake_command} websocket_rails:#{cmd}"
    end
    def run_wsr_command!(cmd)
      if options[:zeus]
        without_bundler_env { system environment, build_wsr_command(cmd) }
      else system environment, build_wsr_command(cmd) end
    end
    def without_bundler_env
      defined?(::Bundler) ? ::Bundler.with_clean_env { yield } : yield
    end

    def sleep_time; options[:timeout].to_f / MAX_WAIT_COUNT.to_f end
    def wait_for_loop
      count = 0
      while !yield && count < MAX_WAIT_COUNT
        wait_for_action
        count += 1
      end
      !(count == MAX_WAIT_COUNT)
    end
    def wait_for_action; sleep sleep_time end
    def wait_for_pid;    wait_for_loop {  has_pid? } end
    def wait_for_no_pid; wait_for_loop { !has_pid? } end
    def wait_for_zeus; wait_for_loop { File.exist? zeus_sockfile } end
    def zeus_sockfile; File.join(@root, '.zeus.sock') end

  end
end
