---
title: Integrate work automation with HubSpot
author: marlowe.tutor
indextype: blueprint
icon: blueprint
image: images/overview.png
category: 6
summary: |
  This Genesys Cloud Developer Blueprint explains how to integrate work automation with HubSpot.
---

This Genesys Cloud Developer Blueprint explains how to integrate work automation with HubSpot.

![Work automation with HubSpot flow](images/overview.png "Work automation with HubSpot flow")

## Solution components

* **Genesys Cloud** - A suite of Genesys cloud services for enterprise-grade communications, collaboration, and contact center management. Contact center agents use the Genesys Cloud user interface.
* **Genesys Cloud API** - A set of RESTful APIs that enables you to extend and customize your Genesys Cloud environment.
* **Data Action** - Provides the integration point to invoke a third-party REST web service or AWS lambda.
* **Integration** - Genesys Cloud integrations connect Genesys Cloud with other tools, systems, services, and applications.
* **Work Automation** - Work automation helps you define tasks and automate their flow according to a pre-defined process. When the workitem is created, it moves through different stages, with a unique status at each stage. Based on the category of work, you can define a worktype each having its own data attributes, and life cycle. When the workitem requires an agent’s attention, the task either routes to an agent like a regular ACD interaction or moves to a common location from which the agent can assign themselves the task. Also, you can set up the automation to capture the events and run a workflow based on the business needs.
* **Architect flows** - A flow in Architect, a drag and drop web-based design tool, dictates how Genesys Cloud handles inbound or outbound interactions.

## Prerequisites

### Specialized knowledge

* Experience using the Genesys Cloud Work Automation, Integrations, and Inbound Call Flow
* Experience using HubSpot
* Experience using REST API

### Genesys Cloud account

* A Genesys Cloud license. For more information, see [Genesys Cloud Pricing](https://www.genesys.com/pricing "Opens the Genesys Cloud pricing page") in the Genesys website.
* (Recommended) The role of Master Admin. For more information, see [Roles and permissions overview](https://help.mypurecloud.com/articles/about-roles-permissions/ "Opens the Roles and permissions overview page") on Resource Center.


### HubSpot account

* Create a HubSpot account. For more information, see [Get started with HubSpot](https://app.hubspot.com/signup-hubspot/crm?hubs_signup-cta=login-signup-cta&step=landing_page "Opens the HubSpot account creation page").

## Implementation steps

You can implement Genesys Cloud objects manually or with Terraform.
* [Configure Genesys Cloud using Terraform](#configure-genesys-cloud-using-terraform)
* [Configure Genesys Cloud manually](#configure-genesys-cloud-manually)

### Download the repository containing the project files
Clone the [workautomation-hubspot-ticketing-sample repository](https://github.com/GenesysCloudBlueprints/workautomation-hubspot-ticketing-sample "Goes to the workautomation-hubspot-ticketing-sample repository") in GitHub.

## Configure Genesys Cloud using Terraform

### Set up Genesys Cloud

1. Open a Terminal window and set the following environment variables:

  * `GENESYSCLOUD_OAUTHCLIENT_ID` - The Genesys Cloud client credential grant ID that CX as Code executes against.
  * `GENESYSCLOUD_OAUTHCLIENT_SECRET` - The Genesys Cloud client credential secret that CX as Code executes against.
  * `GENESYSCLOUD_REGION` - The Genesys Cloud region in your organization.

2. Run Terraform in the folder in which you set the environment variables.

### Configure your Terraform build

* `client_id` - The value of your OAuth Client ID to be used for the data action integration.
* `client_secret`- The value of your OAuth Client secret to be used for the data action integration.
* `account_id`- The value of your account ID created on HubSpot to be used for the integration.
* `division_id`- The value of your Division ID to be used for creating task management objects.
* `email`- The value of your account email address ID to be used for creating a group.
* `bearer_token`- The value of your access token obtained on HubSpot private app to be used for creating data actions.

```
client_id       = "your-client-id"
client_secret   = "your-client-secret"
account_id      = "12345678"
division_id     = "12345678-1234-1234-1234-001123456789"
email           = "test.email@genesys.com"
bearer_token    = "Bearer 123-abc-12345678-1234-1234-1234-1234567890ab"
```

### Run Terraform

The blueprint solution is now ready for your organization to use. 

1. Change to the **/terraform** folder 
2. Run the following commands:

  * `terraform init` - Initializes a working directory that contains the Terraform configuration files. 
  * `terraform plan` - Executes a trial run against your Genesys Cloud organization and shows you a list of all the Genesys Cloud resources it creates. Review this list and make sure that you are comfortable with the plan before you continue.
  * `terraform apply --auto-approve` -  Creates and deploys the necessary objects in your Genesys Cloud account. The --auto-approve flag completes the required approval step before the command creates the objects.

After the `terraform apply --auto-approve` command successfully runs, you see the output with the number of objects that Terraform successfully created. Keep the following points in mind:

  * This project assumes that you run this blueprint solution with a local Terraform backing state. This means that the tfstate files are created in the same folder where you run the project. Terraform recommends that you use local Terraform backing state files only if you run from a desktop and are comfortable with the deleted files.

  * As long as you keep your local Terraform backing state projects, you can tear down this blueprint solution. To tear down the solution, change to the docs/terraform folder and issue the terraform destroy --auto-approve command. This command destroys all objects that the local Terraform backing state currently manages.

## Configure Genesys Cloud manually

### Create a private app on HubSpot and obtain access token

1. Log on to HubSpot with your account.
2. To create a private app on HubSpot, go to **Settings** → **Account Management** > **Integrations** > **Private Apps** > **Create Private App** > **Basic Info**.

    ![Create private app](images/create-private-app.png "Create private app")

3. On the Scopes tab, set the scope to **tickets**.

    ![Select scope](images/select-scope.png "Select scope")

4. Obtain the access token from the **Auth** tab.

    ![Obtain access token](images/obtain-access-token.png "Obtain access token")

For integration purposes, we will utilize the HubSpot Insert Ticket API. For more information, see [HubSpot API Docs](https://developers.hubspot.com/docs/api/crm/tickets "Opens the HubSpot API Docs page") to Create/Retrieve/Update/Delete tickets. For the purpose of this blueprint, we will only use the Create API.

### Create workbin, worktype and custom attributes on Genesys Cloud

Genesys Cloud creates workitems using API-triggered events. Each workitem is of a specific worktype with its own custom attributes. Workitems are routed automatically to queues like an ACD interaction or are routed using workflows.

1. Create a workbin 

  ![Create workbin](images/create-workbin.png "Create workbin")

    * Use this API to find workbin ID, which will be used in the subsequent step [Genesys API Explorer](https://developer.genesys.cloud/devapps/api-explorer "Genesys API Explorer").
    1. Click **Admin**.
    2. Under **Task Management**, click **Workbin**. The workbin dashboard opens. 
    3. Click **Create New Workbin**. Enter the details and create a new workbin.
    4. Run the POST request with the following request body.

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

  ![Get workbin id](images/get-workbin-id-api.png "Get workbin id")
  ![Get workbin id api result](images/get-workbin-id-api-result.png "Get workbin id api result")

2. Create a worktype

  ![Create worktype](images/create-worktype.png "Create worktype")

  Note: Make sure you use the workbin you created.

  ![Select workbin](images/create-worktype-select-workbin.png "Select workbin")

  * Use this API to find worktype ID, which will be used in the subsequent step [Genesys API Explorer](https://developer.genesys.cloud/devapps/api-explorer "Genesys API Explorer").
  1. Click **Admin**.
  2. Under **Task Management**, click **Worktypes**. The worktype dashboard opens.
  3. Click **Create New Worktype**. Enter the details and create a new worktype.
  4. Run the POST request with the following request body.
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

  ![Get worktype id](images/get-worktype-id-api.png "Get worktype id")

* Run the POST request with the following request body

  ![Get worktype id api result](images/get-worktype-id-api-result.png "Get worktype id api result")

3. Create custom attributes

  1. Click **Admin**.
  2. Under **Task Management**, click **Custom Attributes**. The custom attributes dashboard opens. 
  3. Click **Create Schema**. Enter the details and create the custom attributes.

  ![Create custom attributes](images/create-custom-attributes.png "Create custom attributes")

### Add Client Application integration
1. To get the HubSpot URL to use for the client application, on HubSpot page, search "tickets".

  ![Search hubspot tickets page](images/search-hubspot-tickets-page.png "Search hubspot tickets page")

The URL should look something like this: https://app.hubspot.com/contacts/NNNNNNNN/objects/0-5/views/all/list

  ![Get hubspot tickets page](images/get-hubspot-tickets-page.png "Get hubspot tickets page")

2. To create a group for the client application integration, go to **Directory** > **Groups**. 

  ![Create group](images/create-group.png "Create group")

3. Create client application integration and use the URL above as the Application URL.

  ![Create client application](images/create-client-application.png "Create client application")

4. Set client application integration to **Active**.

  ![Set application to active](images/set-application-to-active.png "Set application to active")

5. Go to **Apps** > **Application**, and open the client application.

  ![Open client application](images/open-client-application.png "Open client application")

* Make sure you open the HubSpot page on the same window with the Genesys Cloud.

### Add HB Web Service integration
Keep the default configuration and add the integration:
1. Click **Admin**.
2. Under **Integrations**, click **Integrations**.
3. Click **Integrations**.
4. In the Search box, type you integration, and click **Install**.

  ![Create HB Web Service integration](images/create-hb-web-service.png "Create HB Web Service integration")

### Add oAuth for work automation
Add the Oauth and Integration before adding Data Action for Work Automation API. 
1. Click **Admin**.
2. Under **Integrations**, click **Integrations**.
3. Click **OAuth** and open your app.
4. For Oauth, add the roles that have permission for the workitem.


  ![Add oAuth](images/add-oauth.png "Add oAuth")

### Add integration for work automation
For Data Action integration, use above values to configure client Id and Client Secret for Genesys Cloud Data Actions integration.

1. Click **Admin**.
2. Under **Integrations**, click **Integrations**
3. Find and open the integration that you previously installed.
4. Click **Configuration** > **Credentials** tab and enter the client ID and client secret values. 
5. Click **Save**.

  ![Create data action integration](images/create-data-action-integration.png "Create data action integration")

### Add DataAction for creating HubSpot tickets and workitem
1. Add DataAction for creating HubSpot tickets

  * To replace Authorization with your API key from the created HubSpot private app, open the src folder and edit the 'Add DataAction for creating HubSpot tickets.json'.
  ```
  "request": {
    "requestUrlTemplate": "https://api.hubapi.com/crm/v3/objects/tickets",
    "requestType": "POST",
    "headers": {
      "Authorization": "Bearer pat-na1-XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX",
      "Content-Type": "application/json"
    },
    "requestTemplate": "{\"properties\": {\"hs_pipeline\": \"${input.hs_pipeline}\", \"hs_pipeline_stage\": \"${input.hs_pipeline_stage}\", \"hs_ticket_priority\": \"${input.hs_ticket_priority}\", \"subject\": \"${input.subject}\" }   }"
  }
  ```

  * Import the json to Actions

  ![Import JSON create ticket](images/import-json-create-ticket.png "Import JSON create ticket")

2. Add DataAction for creating workitem

  * Open the src folder and import the 'Add Dataaction for creating workitem.json' to Actions. yoiu can use this in the Architect or Script for demo purpose.

  ![Import JSON create workitem](images/import-json-create-workitem.png "Import JSON create workitem")

### Import JSON to script
In this blueprint, we use script to insert Hubsport Ticket and workitem.

1. Open the src folder and edit the 'Sky Inbound Case.script' to replace the 'workbinId with the WorkBin ID' and 'typeId with the WorkType ID' created in Genesys Cloud.

  * Use this API to find these IDs, which are used for this step [Genesys API Explorer](https://developer.genesys.cloud/devapps/api-explorer "Genesys API Explorer").

  ```
  "workbinId": {
    "typeName": "interpolatedText",
    "value": "61dc4c7f-0851-4752-99b5-3f86e0db6503"
  },
  "typeId": {
    "typeName": "interpolatedText",
    "value": "4e6370bb-6569-4794-b70f-a79c402ab8fe"
  },
  ```

2. Import the script on Genesys Cloud.

3. Configure Actions in the script, associate with above Create HubSpot ticket and New workitem DataAction

4. Publish script.

### Import Architect Flow for Inbound Call
In this blueprint, we can use the Inbound Flow provided.

  1. Inside the src folder, import the 'Inbound Case_v4-0.i3InboundFlow' in your Genesys Cloud organization.

  2. Set screen popup for Inbound Script.
    * Select the correct script imported earlier.

    * Set the externalcontactID:
      * You can get the externalcontactID from External Contacts.
      * Use this API to find the id, which will be used in the subsequent step [Genesys API Explorer](https://developer.genesys.cloud/devapps/api-explorer "Genesys API Explorer").
      * Look for External Contacts → Search for external contacts

    * Set the correct URL to be used with your HubSpot Account ID
      ```
        https://app.hubspot.com/contacts/{account-id}/ticket/
      ```

  3. Set queue on Transfer to ACD.

  4. Publish Inbound Call Flow.

### Test the Solution

  1. As a customer, call an agent to report a case.

  2. As an agent, receive the call.

  3. As an agent, submit case as workitem.

  4. As an agent, receive workitem.

  5. As an agent, open the Application Integration under 'Apps' on Genesys Cloud.

  6. As an agent, manage the newly created ticket on HubSpot.

## Appendix other use case

### Trigger and Workflow

A trigger is a resource within Genesys Cloud that allows customers to configure a reaction to specific events that occur within Genesys Cloud. The actions are workflows that you can create using Architect. We can use the trigger+workflow to do advanced workitems routing after Agents process workitem. 

Use case:

  * Agent receives the workitem and changes Status from "Open" or any other status to "On Hold", then parks it.
  * Match with the predefined trigger to launch the configured Architect workflow.
  * Worflow gets the JSON data and sends an email to the customer.

1. Create an architect workflow.

2. Create a trigger. 

3. Assign workitem to Queue in workflow. 

## Additional resources

* [Genesys Cloud API Explorer](https://developer.genesys.cloud/devapps/api-explorer "Opens the GC API Explorer") in the Genesys Cloud Developer Center.
* [HubSpot](https://www.hubspot.com/ "Opens the HubSpot page").
* The [workautomation-hubspot-ticketing-sample](https://github.com/GenesysCloudBlueprints/workautomation-hubspot-ticketing-sample) repository in GitHub.