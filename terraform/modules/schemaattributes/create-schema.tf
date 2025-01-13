resource "genesyscloud_task_management_workitem_schema" "caseattributes" {
  enabled     = "true"
  name        = "caseattributes"
  description = "The workitem schema description"
  properties = jsonencode({
    "casetype_text" : {
      "allOf" : [
        {
          "$ref" : "#/definitions/text"
        }
      ],
      "title" : "casetype",
      "description" : "Custom attribute for text",
      "minLength" : 0,
      "maxLength" : 100
    },
    "customername_text" : {
      "allOf" : [
        {
          "$ref" : "#/definitions/text"
        }
      ],
      "title" : "customername",
      "description" : "Custom attribute for text",
      "minLength" : 0,
      "maxLength" : 100
    },
    "customernumber_text" : {
      "allOf" : [
        {
          "$ref" : "#/definitions/text"
        }
      ],
      "title" : "customernumber",
      "description" : "Custom attribute for text",
      "minLength" : 0,
      "maxLength" : 100
    },
    "hb_ticketid_text" : {
      "allOf" : [
        {
          "$ref" : "#/definitions/text"
        }
      ],
      "title" : "hb_ticketid",
      "description" : "Custom attribute for text",
      "minLength" : 0,
      "maxLength" : 100
    },
    "hb_url_url" : {
      "allOf" : [
        {
          "$ref" : "#/definitions/url"
        }
      ],
      "title" : "hb_url",
      "description" : "Custom attribute for url",
      "minLength" : 0,
      "maxLength" : 200
    },
    "memo_longtext" : {
      "allOf" : [
        {
          "$ref" : "#/definitions/longtext"
        }
      ],
      "title" : "Memo",
      "description" : "Custom attribute for long text",
      "minLength" : 0,
      "maxLength" : 1000
    },
    
  })
}