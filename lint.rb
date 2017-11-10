# TODO:
#   1. error handling: file not exists, yaml format error, network connection error.
#   2. linter display

require 'json'
require 'yaml'
require 'faraday'

config_file = ARGV[0] || '.gitlab-ci.yml'

content = JSON.pretty_generate(YAML.load(File.read(config_file)))

conn = Faraday.new(:url => 'https://gitlab.com')

res = conn.post do |req|
  req.url '/api/v4/ci/lint'
  req.headers['Content-Type'] = 'application/json'
  req.body = { content: content }.to_json
end

p res
