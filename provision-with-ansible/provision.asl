{
    "Comment": "Provision then run an ansible playbook",
    "StartAt": "PreProvision",
    "States": {
      "PreProvision": {
        "Type": "Pass",
        "Next": "Provision"
      },
      "Provision": {
        "Type": "Task",
        "Resource": "manageiq://provision_execute",
        "Next": "UpdateSystemPackages"
      },
      "UpdateSystemPackages":{
        "Type": "Task",
        "Resource": "manageiq://embedded_ansible",
        "Parameters": {
          "RepositoryUrl": "https://github.com/ManageIQ/ansible-examples",
          "RepositoryBranch": "master",
          "PlaybookName": "dnf-install.yml",
          "Hosts.$": "$.ipaddress"
        },
        "Next": "SendEmail"
      },
      "SendEmail": {
        "Type": "Task",
        "Resource": "manageiq://email",
        "Parameters": {
          "To": "user@example.com",
          "Title": "Your provisioning has completed",
          "Body": "Your provisioning request has completed"
        },
        "Next": "Finished"
      },
      "Finished": {
        "Type": "Succeed"
      }
    }
  }
