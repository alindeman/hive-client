require 'tempfile'
require 'msgpack'
require 'hive/client/version'

module Hive
  RuntimeError = Class.new(StandardError)

  class Client
    # Creates a Hive client
    def initialize(options = {})
      @host = options.fetch(:host, "localhost")
      @port = options.fetch(:port, "10000")
    end

    # Queries Hive, invoking a block for each row. If no block is given, an
    # `Enumerator` is returned.
    #
    # query: the HiveQL query as a string
    def query(query)
      return enum_for(:query, query) unless block_given?

      Tempfile.open("hive-client") do |file|
        spawn_hive_query(query, file.path)
        MessagePack::Unpacker.new(file).each(&Proc.new)
      end
    end

    private
    def spawn_hive_query(query, output_filename)
      command_line = ["java", "-jar", hive_msgpack_jar_path]
      command_line.concat(["-o", output_filename])
      command_line.concat(hive_msgpack_options(query))

      pid = Process.spawn(*command_line)

      _, status = Process.wait2(pid)
      raise RuntimeError, File.read(output_filename) unless status.success?
    end

    def hive_msgpack_options(query)
      ["--host", @host, "--port", @port, query]
    end

    def hive_msgpack_jar_path
      File.join(File.dirname(__FILE__), '..', '..', 'ext', 'hive-msgpack-0.1.0-standalone.jar')
    end
  end
end
