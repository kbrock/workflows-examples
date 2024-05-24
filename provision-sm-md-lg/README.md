# Provision VM Service Small Medium Large Example

This example shows creating a provisioning dialog that modifies provisioning parameters.

## Architecture

- `provision-vm-small-med-large.asl`: This workflow is run for every vm provisioned and is responsible for modifying the vm size. This is the ManageIQ Service's Provisioning Entry Point.

Set the ManageIQ provisioning service entry point to this script. For example, this workflow is run for every provisioned Virtual Machine (VM), and modifies the VM size.

## Add a Workflow Repository

1. **Click Automation** > **Embedded Workflows** > **Repositories**.
2. **Click Configuration** > **Add new Repository**.
3. Provide the `Name` and `URL` for the repository:
   - **Name**: Local name to identify this repository. For example, `Example Workflows`.
   - **Url**: Git repository URL. For example, `https://github.com/ManageIQ/workflows-examples`.
4. Click **Save**.

## Create a Provisioning Dialog

1. Click **Automation** > **Embedded Automate** > **Customization**.
2. Click **Service Dialogs** > **All Dialogs**.
3. Click **Configuration** > **Add a new Dialog**.
4. Provide a `Name` and `Description` for the dialog:
   - **Name**: Name used in the Service Catalog. For example, `sm-med-lg dialog`.
   - **Description**: More information. For example, `Dialog choosing vm size`.
5. Add a text box named **vm_name**.
6. Add a dropdown named **size**.
7. Click the edit pencil icon for the **size** dropdown.
8. Under **Options** > **Entries** enter the dropdown values:
   - Change the first entry:
      - For **Name** field, enter **Large**.
      - For **Value** field, enter **large**.
   - Change the second entry:
      - For **Name** field, enter **Medium**.
      - For **Value** field, enter **medium**.
   - Change the third entry:
      - For **Name** field, enter **Small**.
      - For **Value** field, enter **small**.
9. Click **Save**.

## Create a Service Catalog Item

1. Click **Service** > **Catalogs**.
2. Click **Catalogs** > **All Catalogs**.
3. Click **Configuration** > **Add a New Catalog**.
4. Provide a `Name` and `Description`:
   - **Name**: Name displayed in the catalog. For example, `Provision Vm`.
   - **Description**: More information. For example, `Provisioning Vm by size`.
5. Click **Save**.
6. Click **Catalog Items** > **All Catalog Items** > **Provisioning**.
7. Click **Configuration** > **Add a New Catalog Item**.
   - 8. **Catalog Item Type**: The functionality of this catalog item. Choose `VmWare`.
9. Under the **Basic Information** tab, provide the default VM values:
   - **Name**: Name displayed in the catalog. For example, `Provision Vm with Size`.
   - **Description**: More information. For example, `Provision a vm choosing size`.
   - **Display in Catalog**: Check to display this catalog item.
   - **Catalog**: Organization concept. For example, `My Company/Provisioning`.
   - **Dialog**: The dialog created above. For example, `sm-med-lg dialog`.
   - **Provisioning Entry Point**:
     - For **endpoint type**, choose **Embedded Workflow**.
     - For the **endpoint value** choose the workflow chosen above. For example, `provision-vm-small-med-large.asl`.
17. Under the **Request Info** > **Catalog** tab enter the following values:
     - **VM Name**: Name that will be overwritten by the **VM name** in the dialog. Enter anything here.
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
   - **size**: The desired vm size. For example, **small**.
1. Click **Submit**
