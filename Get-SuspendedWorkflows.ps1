Add-PSSnapin microsoft.sharepoint.powershell -ErrorAction SilentlyContinue
[Reflection.Assembly]::Load("Microsoft.Workflow.Client, Version=1.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35") | Out-Null

$web = get-spweb "http://webapplication"
$list = $web.lists["SampleListThatAssociatedWithWorkflow"]
$items = $List.getItems()

# Get a Workflow manager object to work with.
$wfm = New-object Microsoft.SharePoint.WorkflowServices.WorkflowServicesManager($web)

# Get the subscriptions service
$sub = $wfm.GetWorkflowSubscriptionService()

# Get the specific workflow within the list of subscriptions on the specific list.
$WF = $sub.EnumerateSubscriptionsByList($list.ID) | Where-Object {$_.Name -eq "Sample13Workflow"}

# Get a Workflow instance in order to perform my commands.
$wfis=$wfm.GetWorkflowInstanceService()

Foreach($item in $items){
     $wfinstances =  $wfis.EnumerateInstancesForListItem($list.ID, $item.ID);
     foreach($instance in $wfInstances)
     {
         if($instance.status -eq "Suspended")
         {            
             write-host $item.ID "-" $item.Title "is" $instance.status
	     #--$wfis.ResumeWorkflow($instance);            
             #--Write-Host "Resumed"
         }
     }
}
