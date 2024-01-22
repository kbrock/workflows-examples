#!/usr/bin/env ruby

require 'bundler/setup'
require "pathname"
require "json"
require "rbvmomi"
require "manageiq-api-client"

# Image-specific parameters
ems_id       = ENV.fetch("PROVIDER_ID")
template_ref = ENV.fetch("TEMPLATE")
folder_ref   = ENV.fetch("FOLDER", nil)
host_ref     = ENV.fetch("HOST", nil)
pool_ref     = ENV.fetch("RESPOOL", nil)
vm_name      = ENV.fetch("NAME")

secrets = JSON.load(File.read(ENV.fetch("_CREDENTIALS")))

# ManageIQ API login
api_secrets = secrets.select { |k, _| k.start_with?("api_") }
api_secrets.transform_keys! { |k| k.sub(/^api_/, "").to_sym }

url        = ENV.fetch("API_URL", "http://localhost:3000")
verify_ssl = ENV.fetch("VERIFY_SSL", "true") == "true"

api_options = {url: url, ssl: {verify: verify_ssl}}.merge(api_secrets)
api = ManageIQ::API::Client.new(api_options)

# Clone the template
vcenter_host = api.providers.pluck(:id, :hostname).detect { |id, _| id == ems_id }.last

# vCenter login
vim = RbVmomi::VIM.connect(
  host: vcenter_host,
  user: secrets["vcenter_user"],
  password: secrets["vcenter_password"],
  insecure: true
)

template = RbVmomi::VIM::VirtualMachine(vim, template_ref)

folder_ref ||= template.parent._ref
host_ref   ||= template.runtime.host._ref
pool_ref   ||= template.runtime.host.parent.resourcePool._ref

spec = RbVmomi::VIM::VirtualMachineCloneSpec(
  location: RbVmomi::VIM::VirtualMachineRelocateSpec(
    host: host_ref,
    pool: pool_ref
  ),
  powerOn: false,
  template: false
)

task = template.CloneVM_Task(folder: folder_ref, name: vm_name, spec: spec)
result = {"task": task._ref, "vcenter_host": vcenter_host}

vim.close

# Output the result in JSON format to STDOUT
puts result.to_json
