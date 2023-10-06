#!/usr/bin/env ruby

require "json"
require "rbvmomi"

secrets = JSON.load(File.read(ENV.fetch("_CREDENTIALS")))

vcenter_host     = ENV.fetch("VCENTER_HOST")
vcenter_user     = secrets["vcenter_user"]
vcenter_password = secrets["vcenter_password"]

vm_ref = ENV.fetch("VM")

vim = RbVmomi::VIM.connect(
  host: vcenter_host,
  user: vcenter_user,
  password: vcenter_password,
  insecure: true
)

vm = RbVmomi::VIM::VirtualMachine(vim, vm_ref)
task = vm.PowerOnVM_Task

result = {"task_id": task._ref}.to_json

vim.close

puts result
