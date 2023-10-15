{
  "Comment": "List Templates.",
  "StartAt": "ListTemplates",
  "States": {
    "ListTemplates": {
      "Type": "Task",
      "Resource": "docker://docker.io/agrare/list-templates:latest",
      "End": true,
      "Credentials": {
        "api_user.$": "$.api_user",
        "api_password.$": "$.api_password"
      },
      "Parameters": {
        "API_URL.$": "$$.Execution._manageiq_api_url",
        "VERIFY_SSL.$": "$.dialog.dialog_verify_ssl",

        "PROVIDER_ID.$": "$.dialog.dialog_provider"
      }
    }
  }
}
