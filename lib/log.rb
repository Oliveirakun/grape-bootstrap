require 'syslog/logger'
require 'socket'

class Log
  include Singleton

  def initialize
    @logger = logger
    @hostname = Socket.gethostname
    @pid = Process.pid
    @appname = 'Tio Patinhas'
    apply_formatter
  end

  %w{debug info warn error}.each do |level|
    define_method(level) { |msg| @logger.send(level, msg) }
  end

  def log_request(level, env, status)
    msg =  "#{env['REQUEST_METHOD']} #{env['REQUEST_URI']} #{env['HTTP_VERSION']} #{status}"
    log = self.method(level)
    log.call(msg)
  end

  private

  def logger
    if production?
      Logger.new appname
    else
      Logger.new(STDOUT)
    end
  end

  def production?
    ENV['RACK_ENV'] == 'production'
  end

  def apply_formatter
    @logger.formatter = -> (severity, time, progname, msg) {
      "#{time.strftime '%FT%T%:z'} [#{severity}] [#{@hostname}] [#{progname || @appname}] [#{@pid}] #{msg}\n"
    }
  end
end
