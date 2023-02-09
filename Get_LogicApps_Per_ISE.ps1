#Connect to your Azure account - this will prompt you for credentials and just needs to be ran once per session - Depends on Az module
Connect-AzAccount
# target subscription
$subscriptioname = '<your subscription name>'
#target resource group
$resourcegroup =  '<your resource group name>'
#target ISE instance
$iseName = '<your ISE name>'
#set Context to your subscription
Get-AzSubscription -SubscriptionName $subscriptioname | Select-AzSubscription 
#Get all Logic Apps in the resource group
Get-AzResource -ResourceGroupName $resourcegroup -ResourceType Microsoft.Logic/workflows -ExpandProperties | ForEach-Object {
    $itemproperties = $_ | Select-Object Name -ExpandProperty Properties
    #Check if the Logic App is using an ISE
    if([bool]$itemproperties.PSObject.Properties['integrationServiceEnvironment'])
    {
        $ise = $itemproperties | Select-Object -ExpandProperty integrationServiceEnvironment
        #Check if the ISE is the one we are looking for
        if ($ise.name -eq $iseName)
        {
            #Add the Logic App to the result
            $result = $result + "{`"id`": `"" + $_.ResourceId + "`"}," + "`n"
        }
    }
}
$result = $result.TrimEnd(",`n")
$result = $result.Replace("`n", "`n`t")
$result = "[`n`t" + $result + "`n]"
$result
