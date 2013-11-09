# hive-client

Barebones client for making Hive queries from Ruby.

Requires `java` in `$PATH` and `hive --service hiveserver` running somewhere.

## Usage

```ruby
# By default, `hive --service hiveserver` runs on localhost:10000
client = Hive::Client.new(host: "localhost", port: 10000)
client.query("select id, str from foo") do |row|
  puts "#{row["id"]}: #{row["str"]}"
end
```

... that's all, folks.
