#!/usr/bin/env ruby

require 'bundler/setup'
require "rbvmomi"
require "json"

secrets = JSON.load(File.read(ENV.fetch("_CREDENTIALS")))

vcenter_host     = ENV.fetch("VCENTER_HOST")
vcenter_user     = secrets["vcenter_user"]
vcenter_password = secrets["vcenter_password"]

task_ref = ENV.fetch("TASK")

vim = RbVmomi::VIM.connect(
  host: vcenter_host,
  user: vcenter_user,
  password: vcenter_password,
  insecure: true
)

task = RbVmomi::VIM::Task(vim, task_ref)

result = {
  "state" => task.info.state,
  "vm"    => task.info.result&._ref
}

vim.close

# Output the result in JSON format to STDOUT
puts result.to_json
