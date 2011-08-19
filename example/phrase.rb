# Phrase: Array with size limit
#===========================================================
class ArrayWithSizeLimit < Array
  def initialize(max_size)
    super()
    @max_size = max_size
  end

  def push(val)
    self.concat([val])
    shift if size > @max_size
    self
  end
  alias_method :<<, :push
end

ary = []
ary << 1 # => [1]
ary << 2 # => [1, 2]
ary << 3 # => [1, 2, 3]
ary << 4 # => [1, 2, 3, 4]
ary << 5 # => [1, 2, 3, 4, 5]
ary << 6 # => [1, 2, 3, 4, 5, 6]
ary << 7 # => [1, 2, 3, 4, 5, 6, 7]

ary_with_max = ArrayWithSizeLimit.new(3)
ary_with_max << 1 # => [1]
ary_with_max << 2 # => [1, 2]
ary_with_max << 3 # => [1, 2, 3]
ary_with_max << 4 # => [2, 3, 4]
ary_with_max << 5 # => [3, 4, 5]
ary_with_max << 6 # => [4, 5, 6]
ary_with_max << 7 # => [5, 6, 7]

# Phrase: Arity
#===========================================================
class Cla2
  def meth1; end
  def meth2(arg1) end
  def meth3(arg1, arg2) end
  def meth4(arg1, *arg2) end
end

# Arity return numbe orf required argments, if method can accept 
# variable args, it return number of argments at least required with '-N' form
#
Cla2.instance_method(:meth1).arity # => 0
Cla2.instance_method(:meth2).arity # => 1
Cla2.instance_method(:meth3).arity # => 2
Cla2.instance_method(:meth4).arity # => -2

# Phrase: SysLogger from mojombo's God
#===========================================================
require 'syslog'

class SysLogger
  SYMBOL_EQUIVALENTS = {
    :fatal => Syslog::LOG_CRIT,
    :error => Syslog::LOG_ERR,
    :warn  => Syslog::LOG_WARNING,
    :info  => Syslog::LOG_INFO,
    :debug => Syslog::LOG_DEBUG
  }

  # Set the log level
  #   +level+ is the Symbol level to set as maximum. One of:
  #           [:fatal | :error | :warn | :info | :debug ]
  #
  # Returns Nothing
  def self.level=(level)
    Syslog.mask = Syslog::LOG_UPTO(SYMBOL_EQUIVALENTS[level])
  end

  # Log a message to syslog.
  #   +level+ is the Symbol level of the message. One of:
  #           [:fatal | :error | :warn | :info | :debug ]
  #   +text+ is the String text of the message
  #
  # Returns Nothing
  def self.log(level, text)
    Syslog.log(SYMBOL_EQUIVALENTS[level], text)
  end
end

# Syslog must be opend before Syslog.mask= is called in SysLogger.level
begin
  Syslog.open('t9md')
rescue RuntimeError
  Syslog.reopen('t9md')
end

Syslog.info("Syslog enabled.")
SysLogger.level = :warn
SysLogger.log(:debug, "this is debug message")
SysLogger.log(:info, "this is info message")
SysLogger.log(:warn, "this is warn message")
SysLogger.log(:fatal, "this is fatal message")

