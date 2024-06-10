# Example: Provisioning a VM service

The following example shows how to create a Provisioning Dialog that modifies the parameters for provisioning a small, medium, or large service.

## Architecture

The `provision-vm-small-med-large.asl` workflow runs for every provisioned VM and is responsible for modifying the VM size. This workflow is the `<ManageIQ>` service Provisioning Entry Point.

You need to set the ManageIQ Provisioning service entry point to workflow script. For example, this workflow is run for every provisioned Virtual Machine (VM), and modifies the VM size.

Use the following sections and follow them in order to provision a VM service and modify the paramaters.

## Create a workflow (optional)

**Note**: If you want to use the existing `provision-vm-small-med-large.asl` workflow script without any changes, you can skip this section and proceed to `Add a Workflow Repository` section.

1. Fork `https://github.com/ManageIQ/workflows-examples` repository or create your own repository.
2. Clone the repo locally by using the clone command:

   ```bash
   git clone https://github.com/<owner>/workflows-examples
   ```
   Where `<owner>` is the owner of the repository.

3. Create a new branch:

   ```bash
   git checkout -b sm-md-lg
   ```
3. Create your own script or edit the existing script that is provided. The script used in this example is `provision-vm-small-med-large.asl`.
4. Push code changes to your branch.

## Add a Workflow Repository

Use the following steps to add a Workflow Repository.

1. Click **Automation** > **Embedded Workflows** > **Repositories**.
2. Click **Configuration** > **Add new Repository**.
3. Provide the **Name** and **URL** for the repository:
   - **Name**: Local name to identify this repository. For example, `Example Workflows`.
   - **Url**: Git repository URL. For example, `https://github.com/ManageIQ/workflows-examples`.
   - **SCM Branch**: Git repository branch name. For example, leave this field blank if you want to use the existing `provision-vm-small-med-large.asl` script blank or use a branch name like `sm-md-lg` if you have edited or created your own workflow script.
4. Click **Save**.

## Create a Provisioning Dialog

Use the following steps to create a Provisioning Dialog.

1. Click **Automation** > **Embedded Automate** > **Customization**.
2. Click **Service Dialogs** > **All Dialogs**.
3. Click **Configuration** > **Add a new Dialog**.
4. Provide a **Name** and **Description** for the dialog:
   - **Name**: Name used in the Service Catalog. For example, `sm-med-lg dialog`.
   - **Description**: Description for the dialog. For example, `Dialog choosing vm size`.
5. Add a text box named **vm_name**.
6. Add a dropdown named **size**.
7. Click the edit pencil icon for the **size** dropdown.
8. Under **Options** > **Entries** enter the following values:
   - Enter the following for the first row:
      - For **Name** field, choose **Large**.
      - For **Value** field, choose **large**.
   - Enter the following for the second row:
      - For **Name** field, choose **Medium**.
      - For **Value** field, choose **medium**.
   - Enter the following for the third row:
      - For **Name** field, choose **Small**.
      - For **Value** field, choose **small**.
9. Click **Save**.

## Create a Service Catalog Item

Use the following steps to create a Service Catalog Item.

1. Click **Service** > **Catalogs**.
2. Click **Catalogs** > **All Catalogs**.
3. Click **Configuration** > **Add a New Catalog**.
4. Provide a **Name** and **Description**:
   - **Name**: Name displayed in the catalog. For example, `Provision VM`.
   - **Description**: Desription of the catalog. For example, `Provisioning VM by size`.
5. Click **Save**.
6. Click **Catalog Items** > **All Catalog Items** > **Provisioning**.
7. Click **Configuration** > **Add a New Catalog Item**.
8. Provide a value for `Catalog Item Type`:
   - **Catalog Item Type**: The functionality of this catalog item. Choose **VmWare**.
9. Under the **Basic Information** tab, provide the values for the following fields:
   - **Name**: Name displayed in the catalog. For example, `Provision VM with Size`.
   - **Description**: Description of the catalog. For example, `Provision a VM choosing size`.
   - **Display in Catalog**: Check to display this catalog item.
   - **Catalog**: Organization concept. For example, `My Company/Provisioning`.
   - **Dialog**: The dialog created previously. For example, `sm-med-lg dialog`.
   - **Provisioning Entry Point**:
     - For **endpoint type**, choose **Embedded Workflow**.
     - For the **endpoint value** choose the workflow script. For example, `provision-vm-small-med-large.asl`.
17. Under the **Request Info** > **Catalog** tab enter the following values:
     - **VM Name**: Name that is overwritten by the **VM name** in the dialog. Enter anything here.
20. Under the **Environment** tab, choose an appropriate **Host** and **Datastore**:
    - **Host**: Host that runs the VM.
    - **Datastore**: Disk that stores the VM.
22. Under the **Networking** tab, choose an appropriate **Network Adapter**.
24. Click **Add**.

## Provisioning a Virtual Machine

1. Click **Services** > **Catalogs** > **Service Catalogs**.
2. Click **Order** under the newly created service, **Vm with Size**.
3. Provide the following fields:
   - **VM name**: Name for the newly created vm. For example `demo-1`.
   - **size**: The desired VM size. You can choose `small`, `medium` or `large`. For example, choose **small**.
1. Click **Submit**

## Iterate

If the provisioning did not go as planned use the following steps:

1. Edit the workflow script.
2. Push code changes to your branch.
3. Refresh the Workflow repository.
4. You can follow the workflows link to view the version of the script is stored on the server.
5. If you changed the script name, edit the Service Catalog Item that you previously created.
6. Provision the Virtual Machine.
