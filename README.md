# Work Automation & Hubspot

## Object
Blueprint for integrating work automation with Hubspot ticket. 

## Hubspot
HubSpot is an AI-powered customer platform with all the software, integrations, and resources you need to connect your marketing, sales, and customer service. HubSpot's connected platform enables you to grow your business faster by focusing on what matters most: your customers.
We utilize the HubSpot API to seamlessly integrate HubSpot tickets with Genesys Cloud Work Automation.

* Register a free account at https://hubspot.com
* Obtain the link to the HubSpot ticket for integration use by the GC Client Application. For example:  https://app.hubspot.com/contacts/NNNNNNNN/objects/0-5/views/all/list
<img width="1220" alt="image" src="https://github.com/xuheng44/workautomation/assets/89450349/a60906f4-49e2-4464-8713-9a344432603b">

* Prepare API Key for Work Automation Integration
Goto Setting → Integrations → Private Apps, create a private app for GC integration, and obtain the Access-Token
<img width="1220" alt="image" src="https://github.com/xuheng44/workautomation/assets/89450349/f7d14c16-7458-458f-8d02-a2c741e15fe1">
<img width="1220" alt="image" src="https://github.com/xuheng44/workautomation/assets/89450349/1a53ccfa-ab3a-4a55-8301-d1138215c19f">

* For integration purposes, we will utilize the HubSpot Insert Ticket API.
Hubspot provide rich API(https://developers.hubspot.com/docs/api/crm/tickets) to Create/Retrieve/Update/Delete tickets. For Demo purpose, here only use the Creation API.
<img width="1220" alt="image" src="https://github.com/xuheng44/workautomation/assets/89450349/4c428a19-3bde-454a-bbd3-7fe309b25724">

## Genesys Cloud
Genesys Cloud creates workitems using API triggered events. Workitems belong to specific worktypes with custom attributes and are routed automatically to queues like an ACD interaction or are routed using workflows.

### Configure workitem automation(workbins/worktypes/custom attributes)
* Create workbin
<img width="1220" alt="image" src="https://github.com/xuheng44/workautomation/assets/89450349/d20e4f5c-3e62-4a79-8595-9b72d530b21f">
Use below API to find workbin id, which will be used in the subsequent step.
https://developer.genesys.cloud/devapps/api-explorer#post-api-v2-taskmanagement-workbins-query

Post Data:

```
{
    "filters": [
        {
            "name": "name",
            "type": "String",
            "operator": "CONTAINS",
            "values": ["cases"]
        }
    ]
}
```

* Create worktypes
Create worktypes: configure queue, status and others based on requirements.
<img width="1020" alt="image" src="https://github.com/xuheng44/workautomation/assets/89450349/e0b44cad-38b9-4b50-8d9f-7c5908a4ba78">
Use below API to find worktypes id, which will be used in the subsequent step.

https://developer.genesys.cloud/devapps/api-explorer#post-api-v2-taskmanagement-worktypes-query

Post data:  

```
{
    "filters": [
        {
            "name": "name",
            "type": "String",
            "operator": "IN",
            "values": ["cases"]
        }
    ]
}
```

* create custom attributes
Create schema for cases attributes based on requirement.
<img width="1247" alt="image" src="https://github.com/xuheng44/workautomation/assets/89450349/ad7a7fe0-050d-49ca-a3b1-97f3b00bcf0f">


### Add Client Application Integration with previous hunspot link. 
https://app.hubspot.com/contacts/NNNNNNNN/objects/0-5/views/all/list
<img width="1220" alt="image" src="https://github.com/xuheng44/workautomation/assets/89450349/5245dc85-8988-427d-96bc-31460b7d6dee">
<img width="1220" alt="image" src="https://github.com/xuheng44/workautomation/assets/89450349/6e4422c8-d39a-431e-a7e1-430c7135a8b4">
**Attention: Please log into HubSpot in another tab first, then click the link in the Apps**

### Add integration for HB Web Service
Just need to add integration, keep the default configuration.
<img width="1220" alt="image" src="https://github.com/xuheng44/workautomation/assets/89450349/2ae94ed6-d291-4ae8-9b0b-1946d3bcfc00">

### Add oAuth and integration for work automation
Before adding Data Action for Work Automation API, need to add Oauth and Integration first.
For Oauth, please add role have permission on workitem.*
<img width="1220" alt="image" src="https://github.com/xuheng44/workautomation/assets/89450349/04859540-0a18-4305-a573-fade6537692a">
For Integration, need to use above values to configure client Id and Client Secret for Genesys Cloud Data Actions integration.
<img width="1220" alt="image" src="https://github.com/xuheng44/workautomation/assets/89450349/f0c3247b-2787-48b3-9887-b6f856686faf">

### Add DataAction for creating HubSpot tickets
Below the export Dataction JSON  for HotSport ticket creation, you need to  replace Authorization with your API key from above step beofore import to your GC org.

```
{
  "name": "Hubspot insert ticket",
  "integrationType": "custom-rest-actions",
  "actionType": "custom",
  "config": {
    "request": {
      "requestUrlTemplate": "https://api.hubapi.com/crm/v3/objects/tickets",
      "requestType": "POST",
      "headers": {
        "Authorization": "Bearer pat-na1-9de5c5c1-XXXX-XXXX-a417-716a3ae3e998",
        "Content-Type": "application/json"
      },
      "requestTemplate": "{\"properties\": {\"hs_pipeline\": \"${input.hs_pipeline}\", \"hs_pipeline_stage\": \"${input.hs_pipeline_stage}\", \"hs_ticket_priority\": \"${input.hs_ticket_priority}\", \"subject\": \"${input.subject}\" }   }"
    },
    "response": {
      "translationMap": {},
      "translationMapDefaults": {},
      "successTemplate": "${rawResult}"
    }
  },
  "contract": {
    "input": {
      "inputSchema": {
        "type": "object",
        "properties": {
          "hs_pipeline": {
            "type": "string"
          },
          "hs_pipeline_stage": {
            "type": "string"
          },
          "hs_ticket_priority": {
            "type": "string"
          },
          "subject": {
            "type": "string"
          }
        },
        "additionalProperties": true
      }
    },
    "output": {
      "successSchema": {
        "type": "object",
        "properties": {
          "id": {
            "type": "string"
          }
        },
        "additionalProperties": true
      }
    }
  },
  "secure": false
}
```

### Add Dataaction for creating workitem
Below is JSON sample for workitem creation dataaction, which cloud be used in the Architect or Script for Demo purpose.

```
{
  "name": "New WorkItem",
  "integrationType": "purecloud-data-actions",
  "actionType": "custom",
  "config": {
    "request": {
      "requestUrlTemplate": "/api/v2/taskmanagement/workitems",
      "requestType": "POST",
      "headers": {},
      "requestTemplate": "{\"name\": \"${input.name}\" ,  \"priority\": ${input.priority}, \"workbinId\": \"${input.workbinId}\", \"typeId\":  \"${input.typeId}\", \"externalContactId\": \"${input.externalcontactid}\"  ,\"customFields\" : {\"casetype_text\": \"${input.casetype_text}\" , \"customername_text\": \"${input.customername_text}\" , \"customernumber_text\": \"${input.customernumber_text}\", \"memo_longtext\": \"${input.memo_longtext}\" , \"hb_ticketid_text\": \"${input.hb_ticketid}\", \"hb_url_url\": \"${input.hb_url}\"}}"
    },
    "response": {
      "translationMap": {},
      "translationMapDefaults": {},
      "successTemplate": "${rawResult}"
    }
  },
  "contract": {
    "input": {
      "inputSchema": {
        "title": "source",
        "type": "object",
        "properties": {
          "name": {
            "type": "string"
          },
          "priority": {
            "type": "integer"
          },
          "workbinId": {
            "type": "string"
          },
          "typeId": {
            "type": "string"
          },
          "casetype_text": {
            "type": "string"
          },
          "customername_text": {
            "type": "string"
          },
          "customernumber_text": {
            "type": "string"
          },
          "memo_longtext": {
            "type": "string"
          },
          "hb_ticketid": {
            "type": "string"
          },
          "externalcontactid": {
            "type": "string"
          },
          "hb_url": {
            "type": "string"
          }
        },
        "additionalProperties": true
      }
    },
    "output": {
      "successSchema": {
        "type": "object",
        "properties": {
          "id": {
            "type": "string"
          }
        },
        "additionalProperties": true
      }
    }
  },
  "secure": false
}
```

### Script for Voice Call
In this blueprint, we use script to insert Hubsport Ticket and workitem.
You need to import below json to script.
```
{"id":"5193e813-f0a1-4367-9aec-5c1a9b08d4a7","createdDate":"2024-06-13T02:08:34.408Z","modifiedDate":"2024-06-13T02:08:34.408Z","name":"Sky Inbound Case","organizationId":"0439ee65-1c41-4857-9c64-5ca3499a6c75","versionId":"9187dea0-2117-4b54-8dd0-53e421fdd84d","startPageId":"a556a442-ffc0-11e4-8df6-17ce7d092df5","pages":[{"id":"a556a442-ffc0-11e4-8df6-17ce7d092df5","name":"Start Page","organizationId":"0439ee65-1c41-4857-9c64-5ca3499a6c75","scriptId":"5193e813-f0a1-4367-9aec-5c1a9b08d4a7","versionId":"9187dea0-2117-4b54-8dd0-53e421fdd84d","properties":{"onLoadAction":{"typeName":"action","value":{"actionName":"72af764f-0c30-401e-9527-ccfbae4dd53e","actionArgumentValues":[]}},"backgroundColor":{"typeName":"null"}},"dataVersion":0,"rootContainer":{"type":"verticalStackContainer","properties":{"margin":{"typeName":"spacing","value":[5,5,5,5]},"alignment":{"typeName":"alignment","value":"start"},"width":{"typeName":"sizing","value":{"sizeType":"stretch","size":100}},"height":{"typeName":"sizing","value":{"sizeType":"stretch","size":100}},"visible":{"typeName":"variable"},"preserveLayoutLocation":{"typeName":"boolean","value":false},"backgroundColor":{"typeName":"null"},"padding":{"typeName":"spacing","value":[5,5,5,5]},"childArrangement":{"typeName":"childArrangement","value":"start"},"border":{"typeName":"border","value":[{"width":0,"style":"solid","color":"000000"},{"width":0,"style":"solid","color":"000000"},{"width":0,"style":"solid","color":"000000"},{"width":0,"style":"solid","color":"000000"}]}},"children":[{"type":"text","properties":{"margin":{"typeName":"spacing","value":[5,5,5,5]},"alignment":{"typeName":"alignment","value":"start"},"width":{"typeName":"sizing","value":{"sizeType":"auto"}},"height":{"typeName":"sizing","value":{"sizeType":"auto"}},"visible":{"typeName":"variable"},"preserveLayoutLocation":{"typeName":"boolean","value":false},"text":{"typeName":"interpolatedText","value":"New Case:"},"bold":{"typeName":"boolean","value":true},"italic":{"typeName":"boolean","value":false},"underline":{"typeName":"boolean","value":false},"font":{"typeName":"font","value":"Arial, \"Helvetica Neue\", Helvetica, sans-serif"},"fontSize":{"typeName":"integer","value":16},"justification":{"typeName":"text","value":"left"},"backgroundColor":{"typeName":"null"},"textColor":{"typeName":"null"},"padding":{"typeName":"spacing","value":0}}},{"type":"horizontalStackContainer","properties":{"margin":{"typeName":"spacing","value":0},"alignment":{"typeName":"alignment","value":"start"},"width":{"typeName":"sizing","value":{"sizeType":"stretch","size":100}},"height":{"typeName":"sizing","value":{"sizeType":"auto"}},"visible":{"typeName":"variable"},"preserveLayoutLocation":{"typeName":"boolean","value":false},"backgroundColor":{"typeName":"null"},"padding":{"typeName":"spacing","value":10},"childArrangement":{"typeName":"childArrangement","value":"start"},"border":{"typeName":"border","value":{"width":0,"style":"solid","color":"000000"}}},"children":[{"type":"text","properties":{"margin":{"typeName":"spacing","value":[5,5,5,5]},"alignment":{"typeName":"alignment","value":"start"},"width":{"typeName":"sizing","value":{"sizeType":"auto"}},"height":{"typeName":"sizing","value":{"sizeType":"auto"}},"visible":{"typeName":"variable"},"preserveLayoutLocation":{"typeName":"boolean","value":false},"text":{"typeName":"interpolatedText","value":"Customer Number:"},"bold":{"typeName":"boolean","value":true},"italic":{"typeName":"boolean","value":false},"underline":{"typeName":"boolean","value":false},"font":{"typeName":"font","value":"Arial, \"Helvetica Neue\", Helvetica, sans-serif"},"fontSize":{"typeName":"integer","value":10},"justification":{"typeName":"text","value":"left"},"backgroundColor":{"typeName":"null"},"textColor":{"typeName":"null"},"padding":{"typeName":"spacing","value":0}}},{"type":"input","properties":{"margin":{"typeName":"spacing","value":[5,5,5,5]},"alignment":{"typeName":"alignment","value":"start"},"width":{"typeName":"sizing","value":{"sizeType":"auto"}},"height":{"typeName":"sizing","value":{"sizeType":"auto"}},"visible":{"typeName":"variable"},"preserveLayoutLocation":{"typeName":"boolean","value":false},"placeholderText":{"typeName":"interpolatedText","value":"{{scripter.customersFormattedNumber}}"},"validation":{"typeName":"inputValidation"},"doesRequireValue":{"typeName":"boolean","value":true},"isMultilineInput":{"typeName":"boolean","value":false},"isPasswordInput":{"typeName":"boolean","value":false},"isPasswordToggleVisible":{"typeName":"boolean","value":false},"value":{"typeName":"variable","value":"45c1e8c0-fe01-430c-9776-0d1daf2d1871"},"changeAction":{"typeName":"action","value":{}},"disabled":{"typeName":"variable","value":"285d64bd-e4f4-4fab-92a2-499c59ea8834"}}},{"type":"text","properties":{"margin":{"typeName":"spacing","value":[5,5,5,5]},"alignment":{"typeName":"alignment","value":"start"},"width":{"typeName":"sizing","value":{"sizeType":"auto"}},"height":{"typeName":"sizing","value":{"sizeType":"auto"}},"visible":{"typeName":"variable"},"preserveLayoutLocation":{"typeName":"boolean","value":false},"text":{"typeName":"interpolatedText","value":"Customer Name:"},"bold":{"typeName":"boolean","value":true},"italic":{"typeName":"boolean","value":false},"underline":{"typeName":"boolean","value":false},"font":{"typeName":"font","value":"Arial, \"Helvetica Neue\", Helvetica, sans-serif"},"fontSize":{"typeName":"integer","value":10},"justification":{"typeName":"text","value":"left"},"backgroundColor":{"typeName":"null"},"textColor":{"typeName":"null"},"padding":{"typeName":"spacing","value":[0,0,0,0]}}},{"type":"input","properties":{"margin":{"typeName":"spacing","value":[5,5,5,5]},"alignment":{"typeName":"alignment","value":"start"},"width":{"typeName":"sizing","value":{"sizeType":"auto"}},"height":{"typeName":"sizing","value":{"sizeType":"auto"}},"visible":{"typeName":"variable"},"preserveLayoutLocation":{"typeName":"boolean","value":false},"placeholderText":{"typeName":"interpolatedText","value":"Customer Name\n"},"validation":{"typeName":"inputValidation"},"doesRequireValue":{"typeName":"boolean","value":true},"isMultilineInput":{"typeName":"boolean","value":false},"isPasswordInput":{"typeName":"boolean","value":false},"isPasswordToggleVisible":{"typeName":"boolean","value":false},"value":{"typeName":"variable","value":"6b760046-749c-4b2c-acd1-61f89282286c"},"changeAction":{"typeName":"action","value":{}},"disabled":{"typeName":"variable","value":"285d64bd-e4f4-4fab-92a2-499c59ea8834"}}}]},{"type":"horizontalStackContainer","properties":{"margin":{"typeName":"spacing","value":0},"alignment":{"typeName":"alignment","value":"start"},"width":{"typeName":"sizing","value":{"sizeType":"auto"}},"height":{"typeName":"sizing","value":{"sizeType":"auto"}},"visible":{"typeName":"variable"},"preserveLayoutLocation":{"typeName":"boolean","value":false},"backgroundColor":{"typeName":"null"},"padding":{"typeName":"spacing","value":10},"childArrangement":{"typeName":"childArrangement","value":"start"},"border":{"typeName":"border","value":{"width":0,"style":"solid","color":"000000"}}},"children":[{"type":"text","properties":{"margin":{"typeName":"spacing","value":[5,5,5,5]},"alignment":{"typeName":"alignment","value":"start"},"width":{"typeName":"sizing","value":{"sizeType":"auto"}},"height":{"typeName":"sizing","value":{"sizeType":"auto"}},"visible":{"typeName":"variable"},"preserveLayoutLocation":{"typeName":"boolean","value":false},"text":{"typeName":"interpolatedText","value":"Case Type: "},"bold":{"typeName":"boolean","value":true},"italic":{"typeName":"boolean","value":false},"underline":{"typeName":"boolean","value":false},"font":{"typeName":"font","value":"Arial, \"Helvetica Neue\", Helvetica, sans-serif"},"fontSize":{"typeName":"integer","value":10},"justification":{"typeName":"text","value":"left"},"backgroundColor":{"typeName":"null"},"textColor":{"typeName":"null"},"padding":{"typeName":"spacing","value":0}}},{"type":"dropdown","properties":{"margin":{"typeName":"spacing","value":[5,5,5,5]},"alignment":{"typeName":"alignment","value":"start"},"width":{"typeName":"sizing","value":{"sizeType":"pixels","size":200}},"height":{"typeName":"sizing","value":{"sizeType":"auto"}},"visible":{"typeName":"variable"},"preserveLayoutLocation":{"typeName":"boolean","value":false},"placeholderText":{"typeName":"interpolatedText","value":""},"options":{"typeName":"list","value":[[{"typeName":"interpolatedText","value":"Sales"},{"typeName":"interpolatedText","value":"Sales"}],[{"typeName":"interpolatedText","value":"Delivery"},{"typeName":"interpolatedText","value":"Delivery"}],[{"typeName":"interpolatedText","value":"Support"},{"typeName":"interpolatedText","value":"Support"}]]},"doesRequireValue":{"typeName":"boolean","value":true},"value":{"typeName":"variable","value":"583f0bf8-4017-4013-884a-717a1d7b40ff"},"changeAction":{"typeName":"action","value":{}},"disabled":{"typeName":"variable","value":"285d64bd-e4f4-4fab-92a2-499c59ea8834"}}}]},{"type":"horizontalStackContainer","properties":{"margin":{"typeName":"spacing","value":0},"alignment":{"typeName":"alignment","value":"start"},"width":{"typeName":"sizing","value":{"sizeType":"stretch","size":100}},"height":{"typeName":"sizing","value":{"sizeType":"auto"}},"visible":{"typeName":"variable"},"preserveLayoutLocation":{"typeName":"boolean","value":false},"backgroundColor":{"typeName":"null"},"padding":{"typeName":"spacing","value":10},"childArrangement":{"typeName":"childArrangement","value":"start"},"border":{"typeName":"border","value":{"width":0,"style":"solid","color":"000000"}}},"children":[{"type":"text","properties":{"margin":{"typeName":"spacing","value":[5,5,5,5]},"alignment":{"typeName":"alignment","value":"start"},"width":{"typeName":"sizing","value":{"sizeType":"auto"}},"height":{"typeName":"sizing","value":{"sizeType":"auto"}},"visible":{"typeName":"variable"},"preserveLayoutLocation":{"typeName":"boolean","value":false},"text":{"typeName":"interpolatedText","value":"Memo:     "},"bold":{"typeName":"boolean","value":true},"italic":{"typeName":"boolean","value":false},"underline":{"typeName":"boolean","value":false},"font":{"typeName":"font","value":"Arial, \"Helvetica Neue\", Helvetica, sans-serif"},"fontSize":{"typeName":"integer","value":10},"justification":{"typeName":"text","value":"left"},"backgroundColor":{"typeName":"null"},"textColor":{"typeName":"null"},"padding":{"typeName":"spacing","value":0}}},{"type":"input","properties":{"margin":{"typeName":"spacing","value":[5,5,5,5]},"alignment":{"typeName":"alignment","value":"start"},"width":{"typeName":"sizing","value":{"sizeType":"pixels","size":600}},"height":{"typeName":"sizing","value":{"sizeType":"auto"}},"visible":{"typeName":"variable"},"preserveLayoutLocation":{"typeName":"boolean","value":false},"placeholderText":{"typeName":"interpolatedText","value":"Input Anything here"},"validation":{"typeName":"inputValidation"},"doesRequireValue":{"typeName":"boolean","value":false},"isMultilineInput":{"typeName":"boolean","value":true},"isPasswordInput":{"typeName":"boolean","value":false},"isPasswordToggleVisible":{"typeName":"boolean","value":false},"value":{"typeName":"variable","value":"dc405d57-73ec-4399-8fb1-bd3423a75c02"},"changeAction":{"typeName":"action","value":{}},"disabled":{"typeName":"variable","value":"285d64bd-e4f4-4fab-92a2-499c59ea8834"}}}]},{"type":"button","properties":{"margin":{"typeName":"spacing","value":[5,5,5,5]},"alignment":{"typeName":"alignment","value":"start"},"width":{"typeName":"sizing","value":{"sizeType":"auto"}},"height":{"typeName":"sizing","value":{"sizeType":"auto"}},"visible":{"typeName":"variable"},"preserveLayoutLocation":{"typeName":"boolean","value":false},"text":{"typeName":"interpolatedText","value":"Submit"},"clickAction":{"typeName":"action","value":{"actionName":"50d608ec-614d-4ade-b4aa-4b159eb1719e","actionArgumentValues":[]}},"backgroundColor":{"typeName":"null"},"textColor":{"typeName":"null"},"bold":{"typeName":"boolean","value":false},"italic":{"typeName":"boolean","value":false},"underline":{"typeName":"boolean","value":false},"font":{"typeName":"font","value":"Arial, \"Helvetica Neue\", Helvetica, sans-serif"},"fontSize":{"typeName":"integer","value":10},"justification":{"typeName":"text","value":"center"},"disabled":{"typeName":"variable","value":"285d64bd-e4f4-4fab-92a2-499c59ea8834"}}},{"type":"text","properties":{"margin":{"typeName":"spacing","value":[5,5,5,5]},"alignment":{"typeName":"alignment","value":"start"},"width":{"typeName":"sizing","value":{"sizeType":"stretch","size":100}},"height":{"typeName":"sizing","value":{"sizeType":"auto"}},"visible":{"typeName":"variable"},"preserveLayoutLocation":{"typeName":"boolean","value":false},"text":{"typeName":"interpolatedText","value":"CaseID:  {{82afc208-0ff1-46be-bdf2-10bbadb44e9a}}"},"bold":{"typeName":"boolean","value":false},"italic":{"typeName":"boolean","value":false},"underline":{"typeName":"boolean","value":false},"font":{"typeName":"font","value":"Arial, \"Helvetica Neue\", Helvetica, sans-serif"},"fontSize":{"typeName":"integer","value":10},"justification":{"typeName":"text","value":"left"},"backgroundColor":{"typeName":"null"},"textColor":{"typeName":"null"},"padding":{"typeName":"spacing","value":0}}},{"type":"text","properties":{"margin":{"typeName":"spacing","value":[5,5,5,5]},"alignment":{"typeName":"alignment","value":"start"},"width":{"typeName":"sizing","value":{"sizeType":"stretch","size":100}},"height":{"typeName":"sizing","value":{"sizeType":"auto"}},"visible":{"typeName":"variable"},"preserveLayoutLocation":{"typeName":"boolean","value":false},"text":{"typeName":"interpolatedText","value":"HB_TicketID:  {{7589a213-e8a7-460d-8861-07f6d7f1eba6}}"},"bold":{"typeName":"boolean","value":false},"italic":{"typeName":"boolean","value":false},"underline":{"typeName":"boolean","value":false},"font":{"typeName":"font","value":"Arial, \"Helvetica Neue\", Helvetica, sans-serif"},"fontSize":{"typeName":"integer","value":10},"justification":{"typeName":"text","value":"left"},"backgroundColor":{"typeName":"null"},"textColor":{"typeName":"null"},"padding":{"typeName":"spacing","value":0}}},{"type":"text","properties":{"margin":{"typeName":"spacing","value":[5,5,5,5]},"alignment":{"typeName":"alignment","value":"start"},"width":{"typeName":"sizing","value":{"sizeType":"stretch","size":100}},"height":{"typeName":"sizing","value":{"sizeType":"auto"}},"visible":{"typeName":"variable"},"preserveLayoutLocation":{"typeName":"boolean","value":false},"text":{"typeName":"interpolatedText","value":"ExternalContactID:  {{dc6def03-ea28-4df9-914c-330d4c82e27f}}"},"bold":{"typeName":"boolean","value":false},"italic":{"typeName":"boolean","value":false},"underline":{"typeName":"boolean","value":false},"font":{"typeName":"font","value":"Arial, \"Helvetica Neue\", Helvetica, sans-serif"},"fontSize":{"typeName":"integer","value":10},"justification":{"typeName":"text","value":"left"},"backgroundColor":{"typeName":"null"},"textColor":{"typeName":"null"},"padding":{"typeName":"spacing","value":0}}}]}}],"features":{"dialer":{"properties":{"enabled":{"typeName":"boolean","value":false},"contactListId":{"typeName":"text","value":""},"onContactDataLoadAction":{"typeName":"action","value":{}}}},"scripter":{"properties":{"enabled":{"typeName":"boolean","value":true}}},"screenPop":{"properties":{"enabled":{"typeName":"boolean","value":true}}},"callback":{"properties":{"enabled":{"typeName":"boolean","value":false}}},"chat":{"properties":{"enabled":{"typeName":"boolean","value":false}}},"email":{"properties":{"enabled":{"typeName":"boolean","value":true}}},"message":{"properties":{"enabled":{"typeName":"boolean","value":true}}},"bridge":{"properties":{"enabled":{"typeName":"boolean","value":true}}},"uuiData":{"properties":{"enabled":{"typeName":"boolean","value":true}}},"customerSecuredData":{"properties":{"enabled":{"typeName":"boolean","value":false}}},"list":{"properties":{"enabled":{"typeName":"boolean","value":false}}}},"variables":[{"id":"6b760046-749c-4b2c-acd1-61f89282286c","name":"Customer Name","description":"","type":{"isDynamic":false,"isList":false,"name":"string"},"value":"Unknown","input":true,"output":false},{"id":"45c1e8c0-fe01-430c-9776-0d1daf2d1871","name":"Customer Number","description":"","type":{"isDynamic":false,"isList":false,"name":"string"},"value":"+8613763339070","input":true,"output":false},{"id":"583f0bf8-4017-4013-884a-717a1d7b40ff","name":"Case Type","description":"","type":{"isDynamic":false,"isList":false,"name":"string"},"value":"Sales","input":true,"output":false},{"id":"dc405d57-73ec-4399-8fb1-bd3423a75c02","name":"Memo","description":"","type":{"isDynamic":false,"isList":false,"name":"string"},"value":"","input":false,"output":false},{"id":"82afc208-0ff1-46be-bdf2-10bbadb44e9a","name":"caseid","description":"","type":{"isDynamic":false,"isList":false,"name":"string"},"value":"","input":false,"output":false},{"id":"285d64bd-e4f4-4fab-92a2-499c59ea8834","name":"disablebutton","description":"","type":{"isDynamic":false,"isList":false,"name":"boolean"},"value":false,"input":false,"output":false},{"id":"7589a213-e8a7-460d-8861-07f6d7f1eba6","name":"HB_ticketid","description":"","type":{"isDynamic":false,"isList":false,"name":"string"},"value":"","input":false,"output":false},{"id":"dc6def03-ea28-4df9-914c-330d4c82e27f","name":"externalContactID","description":"","type":{"isDynamic":false,"isList":false,"name":"string"},"value":"e06e1127-ee6b-4c8f-aefc-3bcdf9768216","input":true,"output":false},{"id":"f0109e3f-8a8a-4af6-98a5-69385c356aab","name":"hburl","description":"https://app.hubspot.com/contacts/43911275/ticket/","type":{"isDynamic":false,"isList":false,"name":"string"},"value":"https://app.hubspot.com/contacts/43911275/ticket/","input":true,"output":false}],"customActions":[{"id":"50d608ec-614d-4ade-b4aa-4b159eb1719e","name":"create new task","action":{"block":[{"type":"action","actionName":"bridge.bridge","actionArgumentValues":[{"typeName":"bridgeActionArguments","value":{"actionName":"custom_-_7a72eadc-a359-4732-9196-75f7101c33a6","inputProperty":{"typeName":"objectFields","value":{"fieldProperties":{"hs_pipeline":{"typeName":"interpolatedText","value":"0"},"hs_pipeline_stage":{"typeName":"interpolatedText","value":"1"},"hs_ticket_priority":{"typeName":"interpolatedText","value":"HIGH"},"subject":{"typeName":"interpolatedText","value":"{{dc405d57-73ec-4399-8fb1-bd3423a75c02}}"}}}},"successProperty":{"typeName":"objectFields","value":{"fieldProperties":{"id":{"typeName":"variable","value":"7589a213-e8a7-460d-8861-07f6d7f1eba6"}}}},"isHedwigAction":true}}]},{"type":"action","actionName":"bridge.bridge","actionArgumentValues":[{"typeName":"bridgeActionArguments","value":{"actionName":"custom_-_2ea13bc2-ffda-43a5-b577-5020bf88bd58","inputProperty":{"typeName":"objectFields","value":{"fieldProperties":{"name":{"typeName":"interpolatedText","value":"{{6b760046-749c-4b2c-acd1-61f89282286c}}{{583f0bf8-4017-4013-884a-717a1d7b40ff}}{{scripter.agentsCallStartTime}}"},"priority":{"typeName":"integer","value":20},"workbinId":{"typeName":"interpolatedText","value":"61dc4c7f-0851-4752-99b5-3f86e0db6503"},"typeId":{"typeName":"interpolatedText","value":"4e6370bb-6569-4794-b70f-a79c402ab8fe"},"casetype_text":{"typeName":"interpolatedText","value":"{{583f0bf8-4017-4013-884a-717a1d7b40ff}}"},"customername_text":{"typeName":"interpolatedText","value":"{{6b760046-749c-4b2c-acd1-61f89282286c}}"},"customernumber_text":{"typeName":"interpolatedText","value":"{{45c1e8c0-fe01-430c-9776-0d1daf2d1871}}"},"memo_longtext":{"typeName":"interpolatedText","value":"{{dc405d57-73ec-4399-8fb1-bd3423a75c02}}"},"hb_ticketid":{"typeName":"interpolatedText","value":"{{7589a213-e8a7-460d-8861-07f6d7f1eba6}}"},"externalcontactid":{"typeName":"interpolatedText","value":"{{dc6def03-ea28-4df9-914c-330d4c82e27f}}"},"hb_url":{"typeName":"interpolatedText","value":"{{f0109e3f-8a8a-4af6-98a5-69385c356aab}}{{7589a213-e8a7-460d-8861-07f6d7f1eba6}}"}}}},"successProperty":{"typeName":"objectFields","value":{"fieldProperties":{"id":{"typeName":"variable","value":"82afc208-0ff1-46be-bdf2-10bbadb44e9a"}}}},"isHedwigAction":true}}]},{"type":"action","actionName":"scripter.setVariable","actionArgumentValues":[{"typeName":"variableWithValue","value":{"variable":{"typeName":"variable","value":"285d64bd-e4f4-4fab-92a2-499c59ea8834"},"valueOfVariableProperty":{"typeName":"boolean","value":true}}}]}]}}],"dataVersion":0}
```

After import script, you need to configure Actions in the script, associate with above hubspot ticket insert and New workitem dataaction, also need to update the workbinid and worktypeid with previous creation.

### Architect flow for Inbound Call
You can import Inbound Case_v4-0.i3InboundFlow in your ORG.
For Demo/Script integration, need to set screen popup and related input for Inbound Script. You can get the externalcontactID from External Contacts.

<img width="263" alt="image" src="https://github.com/xuheng44/workautomation/assets/89450349/ae840cb3-4728-4d8c-af13-5f1e185f351c">


### Configure DID with Inbound Call flow

## Making a test call
Then you can make call to test.

* Agent receive the call
<img width="1220" alt="image" src="https://github.com/xuheng44/workautomation/assets/89450349/b6b2505a-12f4-4b2c-813b-e6f2a86d9a39">
* Agent submit the workitem
<img width="1220" alt="image" src="https://github.com/xuheng44/workautomation/assets/89450349/69f66410-e234-4d20-9417-cfb6826a6ea4">
* Agent receive the workitem
<img width="1285" alt="image" src="https://github.com/xuheng44/workautomation/assets/89450349/c12195c1-85f5-4327-a979-989f037974d0">
* WorkItem Listview
<img width="1282" alt="image" src="https://github.com/xuheng44/workautomation/assets/89450349/39b33a68-b4bc-49d1-b0de-21e25abed945">
* Hubspot tickets list view
<img width="1285" alt="image" src="https://github.com/xuheng44/workautomation/assets/89450349/e6246552-69c9-4d14-a7b8-ac9e60c1312f">
* Hubspot ticket view
<img width="1277" alt="image" src="https://github.com/xuheng44/workautomation/assets/89450349/06991f22-352f-4e45-b915-d9f3cd1603c4">

## Appendix other use case

### Trigger and Workflow

A trigger is a resource within Genesys Cloud that allows customers to configure a reaction to specific events that occur within Genesys Cloud. The actions are workflows that you can create using Architect.
We can use the trigger+workflow to do advanced workitems routing after Agents process workitem.

Usecase:
* Agent receive the workitem, Change Status from "Open" or any other status to "On Hold", then park it.
* Matching the predefined trigger, launch the configured Architect workflow.
* Worflow get the JSON data, and send a email to a User.

#### Create an architect workflow
In workflow, need to Add Variable in the Data as below: must toggle on "input to flow", name is "jsonData".
<img width="1261" alt="image" src="https://github.com/xuheng44/workautomation/assets/89450349/ef98cbd5-fab1-48b9-9c39-454a0dc1ecef">
Workflow is very simple with "Send Notification" block:
<img width="1261" alt="image" src="https://github.com/xuheng44/workautomation/assets/89450349/86639e61-e776-483d-9ed1-cd76bc9779ec">
Notify Body expression: ToString(Flow.jsonData.customFields.hb_ticketid_text.value)

#### Create a trigger
<img width="1261" alt="image" src="https://github.com/xuheng44/workautomation/assets/89450349/f3996ae4-4109-4ae5-97c8-9e9f624a3d42">

statusCategory == Waiting  (on Hold status)

assignmentState == Disconnected

workbinId:  cases(id), same as above setting

#### Assign workitem to Queue in workflow
Workflow don't support "Transfer to ACD", need to use Data action to assign workitem to ACD queue, but workitem status *must not be in "Parked"*.

Please refer to below link for detail information.

https://developer.genesys.cloud/commdigital/taskmanagement/task-management-assignment#queue-assignment-alerting

You can import below data action to GC:

```
{
  "name": "Workitem-Assign - Exported 2024-06-20 @ 21:58",
  "integrationType": "purecloud-data-actions",
  "actionType": "custom",
  "config": {
    "request": {
      "requestUrlTemplate": "/api/v2/taskmanagement/workitems/${input.workitemid}",
      "requestType": "PATCH",
      "headers": {},
      "requestTemplate": "{\n    \"assignmentOperation\": \"QueueAssignmentAlerting\",\n    \"queueId\": \"${input.queueid}\"\n}"
    },
    "response": {
      "translationMap": {},
      "translationMapDefaults": {},
      "successTemplate": "${rawResult}"
    }
  },
  "contract": {
    "input": {
      "inputSchema": {
        "type": "object",
        "properties": {
          "workitemid": {
            "type": "string"
          },
          "queueid": {
            "type": "string"
          }
        },
        "additionalProperties": true
      }
    },
    "output": {
      "successSchema": {
        "type": "object",
        "properties": {},
        "additionalProperties": true
      }
    }
  },
  "secure": false
}
```

Then you can import the sample workflow to GC architect, don't forget to update the queueid with your value.

<img width="1261" alt="image" src="https://github.com/xuheng44/workautomation/assets/89450349/e310323e-2fb9-44ea-9e56-b69db2480e46">








