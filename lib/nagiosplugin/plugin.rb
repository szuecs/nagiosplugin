module NagiosPlugin
  EXIT_CODES = {
    :ok       => 0,
    :warning  => 1,
    :critical => 2,
    :unknown  => 3,
  }
  
  class Plugin
    def initialize
      @status = :unknown
    end
    
    def self.check!
      plugin = self.new
      plugin.check
    ensure
      puts plugin.message
      exit plugin.code
    end
    
    def check
      measure if respond_to?(:measure)
      @status = [:critical, :warning, :ok].select { |s| send("#{s}?") }.first
      raise if @status.nil?
    rescue
      @status = :unknown
      raise
    end
    
    def message
      "#{service} #{status}"
    end
    
    def service
      self.class.name.upcase
    end
    
    def status
      @status.upcase
    end
    
    def code
      EXIT_CODES[@status]
    end
    
    def ok?
      true
    end
  end
end