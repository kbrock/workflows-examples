#!/usr/bin/env ruby

require "manageiq-api-client"

secrets = JSON.load(File.read(ENV.fetch("SECRETS")))

api_user     = secrets.fetch("api_user", "admin")
api_password = secrets.fetch("api_password", "smartvm")

api_url    = ENV.fetch("API_URL", "http://localhost:3000")
ems_id     = ENV.fetch("PROVIDER_ID")
verify_ssl = ENV.fetch("VERIFY_SSL", "true") == "true"

api = ManageIQ::API::Client.new(
  :url      => api_url,
  :user     => api_user,
  :password => api_password,
  :ssl      => {:verify => verify_ssl}
)

resources = api.templates.where(:ems_id => ems_id).pluck(:ems_ref, :name)

puts({"values" => resources.to_h}.to_json)
