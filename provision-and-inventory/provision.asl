{
  "Comment": "Provision VM and install packages",
  "StartAt": "DetermineSize",
  "States": {
    "DetermineSize": {
      "Comment": "Determine dialog value",
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$.size",
          "StringEquals": "small",
          "Next": "SmallSizeState"
        },
        {
          "Variable": "$.size",
          "StringEquals": "large",
          "Next": "LargeSizeState"
        }
      ],
      "Default": "SmallSizeState"
    },
    "SmallSizeState": {
      "Type": "Pass",
      "Next": "SmallSetMemory"
    },
    "SmallSetMemory": {
      "Comment": "set vm_memory=2GB for small",
      "Type": "Pass",
      "ResultPath": "$.vm_memory",
      "Result":     "2048",
      "Next": "SmallSetCpus"
    },
    "SmallSetCpus": {
      "Comment": "1 cpu for small",
      "Type": "Pass",
      "ResultPath": "$.number_of_sockets",
      "Result":     "1",
      "Next": "SmallPackageList"
    },
    "SmallPackageList": {
      "Comment": "fewer components for small",
      "Type": "Pass",
      "ResultPath": "$.ansible_packages",
      "Result":     "http_small.yml",
      "Next": "Provision"
    },
    "LargeSizeState": {
      "Type": "Pass",
      "Next": "LargeSetMemory"
    },
    "LargeSetMemory": {
      "Comment": "set vm_memory=4GB for medium",
      "Type": "Pass",
      "ResultPath": "$.vm_memory",
      "Result":     "4096",
      "Next": "LargeSetCpus"
    },
    "LargeSetCpus": {
      "Comment": "2 cpus for medium",
      "Type": "Pass",
      "ResultPath": "$.number_of_sockets",
      "Result":     "2",
      "Next": "LargePackageList"
    },
    "LargePackageList": {
      "Comment": "more components for large",
      "Type": "Pass",
      "ResultPath": "$.ansible_packages",
      "Result":     "http_large.yml",
      "Next": "Provision"
    },
    "Provision": {
      "Type": "Task",
      "Resource": "manageiq://provision_execute",
      "Next": "InstallPackages"
    },
    "InstallPackages":{
      "Type": "Task",
      "Resource": "manageiq://embedded_ansible",
      "Parameters": {
        "RepositoryUrl": "https://github.com/kbrock/ansible-examples",
        "RepositoryBranch": "dialog-ansible",
        "PlaybookName.$": "$.ansible_packages",
        "Hosts.$": "$.ipaddress"
      },
      "Next": "SendEmail"
    },
    "SendEmail": {
      "Type": "Task",
      "Resource": "manageiq://email",
      "Parameters": {
        "Title": "Your VM is ready",
        "Body": "Your provisioning request has completed"
      },
      "Next": "Finished"
    },
    "Finished": {
      "Type": "Succeed"
    }
  }
}
