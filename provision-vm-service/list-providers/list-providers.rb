#!/usr/bin/env ruby

require "json"
require "manageiq-api-client"

secrets = JSON.load(File.read(ENV.fetch("_CREDENTIALS")))

user     = secrets.fetch("api_user", "admin")
password = secrets.fetch("api_password", "smartvm")

url           = ENV.fetch("API_URL", "http://localhost:3000")
provider_type = ENV.fetch("PROVIDER_TYPE", nil)
verify_ssl    = ENV.fetch("VERIFY_SSL", "true") == "true"

api = ManageIQ::API::Client.new(
  :url      => url,
  :user     => user,
  :password => password,
  :ssl      => {:verify => verify_ssl}
)

response = api.providers
response = response.where(:type => provider_type) if provider_type
response = response.pluck(:id, :name)

# Output the list of providers in JSON format to STDOUT
puts({"values" => response.to_h}.to_json)
