# Provision VM Service Example Workflow

This example shows creating a dynamic dialog that can fetch values from the ManageIQ API, then using those values can kick off a VM provisioning task to a VMware provider.

## Architecture

- `list-providers.asl`: This workflow is responsible for contacting the ManageIQ API and retrieving a list of providers. It is a single state workflow that runs the `list-providers` image.  This will be used in a ManageIQ Service Dialog dynamic dropdown.
- `list-templates.asl`: This workflow is responsible for contacting the ManageIQ API and retrieving a list of templates for the given `PROVIDER_ID`. It is a single state workflow that runs the `list-templates` image.  This will be used in a ManageIQ Service Dialog dynamic dropdown.
- `provision-vm.asl`: This workflow is responsible for cloning a VM using the given `PROVIDER_ID`, `TEMPLATE`, and VM `NAME`. It is a multi-stage workflow that runs the `clone-template`, `check-task-complete`, and `power-on-vm` images. This will be used as a ManageIQ Service's Provisioning Entry Point.

  ![](provision-vm.png)

## Setup within ManageIQ

### Set up the workflow repository

1. Add this repository to Automation -> Embedded Workflows -> Repositories.
2. Add a credential to the ManageIQ API under Automation -> Embedded Workflows -> Credentials.
3. Add a credential to a vCenter under Automation -> Embedded Workflows -> Credentials.
4. Map the ManageIQ API credential to the `list-providers` and `list-templates` workflows.
5. Map the vCenter credential to the `clone-template`, `check-task-complete`, and `power-on-vm` workflows.

### Create a dynamic service dialog

1. Create a new Service Dialog under Automation -> Embedded Automation -> Customization -> Service Dialog.
2. Add a text box, named `vm_name`.
3. Add a drop down, named `provider`, making it dynamic and pointing to the `list-providers` workflow.
4. Add a drop down, named `source_template`, making it dynamic and pointing to the `list-templates` workflow.
5. Edit the `provider` dropdown, and change it to trigger the `source_template` dropdown as a field to refresh.
6. Add a checkbox, named `verify_ssl`, default unchecked, and hidden.

### Create a service catalog item

1. Create a new Generic service catalog item.
2. Set the Dialog to the Service Dialog created above.
3. Change the Provisioning Entry Point to the `provision-vm` workflow.

## Local Development

In order to run these example workflow images outside of ManageIQ Embedded Workflows for testing, you must build them locally and then execute them with the correct parameters.

For example, using the `list-providers` image:

1. Pre-requisites

  - The ManageIQ server is running at `http://localhost:3000`.
  - A VMware provider has been added to ManageIQ.
  - You have authentication credentials in the `../sample_credentials.json` file. The credentials can be an api_user/api_password pair or api_token or api_bearer_token.

2. Optionally build the container if you are verifying any local changes.

   ```sh
   cd list-providers
   docker build . -t docker.io/manageiq/workflows-examples-provision-vm-service-list-providers:latest
   ```

3. Run the container.

   ```sh
   cd list-providers
   docker run --rm -it \
     --net host \
     -v $(realpath $PWD/../sample_credentials.json):/run/secrets/_CREDENTIALS:z \
     -e _CREDENTIALS=/run/secrets/_CREDENTIALS \
     -e API_URL=http://localhost:3000 \
     -e VERIFY_SSL=false \
     -e PROVIDER_TYPE=ManageIQ::Providers::Vmware::InfraManager \
     docker.io/manageiq/workflows-examples-provision-vm-service-list-providers
   ```
