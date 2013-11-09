require 'hive/client'

describe Hive::Client do
  def stub_query_results(query, results)
    Process.stub(:spawn) do |*command|
      file = command[4]
      File.open(file, "w") do |io|
        pk = MessagePack::Packer.new(io)
        results.each { |result| pk.write(result) }
        pk.flush
      end
    end

    Process.stub(:wait2).and_return([1234, double(:success? => true)])
  end

  def stub_query_results_as_error(query, error_message)
    Process.stub(:spawn) do |*command|
      file = command[4]
      File.write(file, error_message)
    end

    Process.stub(:wait2).and_return([1234, double(:success? => false)])
  end

  it 'returns query results' do
    expected = [{"id" => "1", "word" => "one"}, {"id" => "2", "word" => "two"}]
    stub_query_results('select * from foo', expected)

    client = Hive::Client.new
    actual = []
    client.query('select * from foo') do |row|
      actual << row
    end

    expect(actual).to eq(expected)
  end

  it 'raises an error if something went wrong' do
    stub_query_results_as_error('select * from foo', 'boomtown')

    client = Hive::Client.new
    exception = expect {
      client.query('select * from foo') { |row| }
    }.to raise_error(Hive::RuntimeError, /boomtown/)
  end
end
