# TODO:
#   1. error handling: file not exists, yaml format error, network connection error.

require 'json'
require 'yaml'
require 'faraday'
require 'colorize'

config_file = ARGV[0] || '.gitlab-ci.yml'

print "Validation #{config_file}..."

content = JSON.pretty_generate(YAML.load(File.read(config_file)))

connection = Faraday.new(:url => 'https://gitlab.com') do |conn|
  #conn.response :json, :content_type => /\bjson$/
  conn.adapter Faraday.default_adapter
end

res = connection.post do |req|
  req.url '/api/v4/ci/lint'
  req.headers['Content-Type'] = 'application/json'
  req.body = { content: content }.to_json
end

res = JSON.parse(res.body)

if res["status"] == 'valid'
  puts "ok".colorize(:green)
else
  puts "invalid".colorize(:red)
  puts res["errors"].to_s.colorize(:red)
end
