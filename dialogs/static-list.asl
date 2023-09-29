{
  "Comment": "Static List",
  "StartAt": "Pass",
  "States": {
    "Pass":{
      "Type": "Pass",
      "Result": {"list": ["a","b","c"]},
      "ResultPath": "$",
      "End": true
    }
  }
}
