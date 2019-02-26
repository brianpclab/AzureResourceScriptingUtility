<#
https://docs.microsoft.com/en-us/azure/architecture/best-practices/naming-conventions
#>

<#
		Summary - Basic menu class that will allow the developer to create simple menus from a [System.Collections.Generic.List[System.Collections.Hashtable]]		
#>
class BaseMenu {

	<# Start Hidden Properties #>

	[string] hidden $MenuTitle 

	<# End Hidden Properties #>

	<# Start Public Properties #>

    [System.Collections.Generic.List[System.Collections.Hashtable]] $MenuItems

	[System.Collections.Hashtable] $SelectedMenuItem ;
	<# End Public Properties #>

	<# Start Constructors #>
	<#
	Initilizes the menu title and the MenuItems properties
	#>
	BaseMenu(
		[string]$title)
	{
		$this.Initilization($title);
	}
	<#
	Initilizes the menu title and sets MenuItems properties from the passed in Hashtable
	#>
	BaseMenu(
		[string]$title,
	    [System.Collections.Generic.List[System.Collections.Hashtable]] $items)
	{
		$this.MenuTitle = $title ;
		$this.MenuItems =  $items
	}
	<#
	Initilizes the menu title property
	Initilizes the MenuItems property and creates count List elements that are all initilized to null.
	This is usually used when you are populating the menu items from a CLI call that returns a collection of items
	    that you wish to populate into the MenuItems 
	#>
	BaseMenu(
		[string]$title,
	    [int] $count)
	{
		$this.Initilization($title);
		for($i = 0; i -lt $count;$i++) {
		
		}
	}
	<# End Constructors #>

	<# Start Hidden Methods #>
	 hidden [void] Initilization([string]$title) { 
		$this.MenuTitle = $title ;
		$this.MenuItems =  New-Object -TypeName 'System.Collections.Generic.List[System.Collections.Hashtable]'
	}
	<# End Hidden Methods #>

	<# Start Public Methods #>
	[System.Collections.Hashtable] DisplayMenu ([string] $readHostPrompt,[string] $invalidSelectionFormatString) {
		[System.Collections.Hashtable] $returnValue = $null;
		Write-Host;
		$this.SelectedMenuItem  = $null ;
		$displayText = [String]::Format("================ {0} ================",$this.MenuTitle);
		Write-Host $displayText
		[int]$index = 0;
		foreach ($menuItem in $this.MenuItems)
		{
			$index++;
			$text = "Press $($index) for " + $menuItem.DisplayName;
			Write-Host $text;
		}
		[bool]$menuDoLoopExit = $false ;
		$start =  1;
		$end =  $index ;
		do {

			 $input = Read-Host $readHostPrompt
			if ($input -eq 'Q') {
				exit;
			}
			if ($input -ge $start.ToString() -and $input -le $end.ToString()) {
				$index = [Int32]::Parse($input)  - 1;
				$this.SelectedMenuItem  = $this.MenuItems[$index] ; 
				$menuDoLoopExit = $true;
			}
			else {
				$displayText = [String]::Format($invalidSelectionFormatString,$input);
				Write-Host $displayText ;
			}

		}
		until ($menuDoLoopExit);
		return $this.SelectedMenuItem ;
	}
	<# End Public Methods #>
}
class NamingConventionPatterns {

	[System.Collections.Generic.List[System.Collections.Hashtable]] $Departments ;
	[System.Collections.Generic.List[System.Collections.Hashtable]] $Environments ;
	hidden static [String] ResourceGroup = "rg";
	hidden static [String] AzureSqlServer = "sql";
	hidden static [String] ApplicationGateway "agw";
	hidden static [String] FailoverGroup = "fg";
	hidden static [String] StorageAccount = "sa";
	hidden static [String] AppServicePlan = "sp";
	hidden static [String] WebAppService = "app";
	hidden static [String] KeyVault = "kv";
	hidden static [String] VNet = "vn";
	hidden static [String] Subnet = "sbn";
	hidden [String] ResourceGroup = "rg";
	<# End Public Properties #>

	<# Start Constructors #>
	<#
	Initilizes the menu title and the MenuItems properties
	#>
	NamingConventionPatterns(
		[string]$title)
	{
		this.InitilizeDepartments() ;
	}

	hidden [void] InitilizeDepartments() {
	    $this.Departments =  New-Object -TypeName 'System.Collections.Generic.List[System.Collections.Hashtable]'
		$this.Departments.Add(@{DisplayName="SocialGaming",affix = "sg" });
		$this.Departments.Add(@{DisplayName="IT",affix = "it" });	
	}
	hidden [void] InitilizeEnvironments() {
	    $this.Environments =  New-Object -TypeName 'System.Collections.Generic.List[System.Collections.Hashtable]'
		$this.Environments.Add(@{DisplayName="Development",affix = "dev" });
		$this.Environments.Add(@{DisplayName="Production",affix = "prod" });	
		$this.Environments.Add(@{DisplayName="QA",affix = "qa" });	
	}
}

<# 
	Menu choices for InsTech Products 
#>
	[BaseMenu] $Global:productsMenu = [BaseMenu]::new("InsTech Product") ;
	$Global:productsMenu.MenuItems.Add(@{ Index = 1; DisplayName = "FSE"; selectedProduct="fse"}) ;
	$Global:productsMenu.MenuItems.Add(@{ Index = 2; DisplayName = "FL"; selectedProduct="fl"}) ;
	$Global:productsMenu.MenuItems.Add(@{ Index = 3; DisplayName = "FLI"; selectedProduct="fli"}) ;

<# 
	Menu choices for Azure Regions 
#>
	$azureLocationsJson=  az account list-locations 
	$azureLocations = [Newtonsoft.Json.JsonConvert]::DeserializeObject($azureLocationsJson) 
	[int] $indexLocation = 0;
	[String] $displayName ;
    $regions =  New-Object -TypeName 'System.Collections.Generic.List[System.Collections.Hashtable]' 
	$regions.Add($null) ;
	$regions.Add($null) ;
	$regions.Add($null) ;
	$regions.Add($null) ;
	$regions.Add($null) ;
	$regions.Add($null) ;
	$regions.Add($null) ;
	$regions.Add($null) ;

	foreach($azureLocation in $azureLocations) {
		$displayName= $azureLocation.displayName.ToString() ;
		switch($displayName) {
			"East US" {
			    $hashTable = @{ Index = 1; DisplayName = $displayName; selectedRegion="eu";selectedRegionLocation = $azureLocation.name.ToString()}
				$regions[0] = $hashTable ;
				break ;
			}
			"East US 2" {
			    $hashTable = @{ Index = 2; DisplayName = $displayName; selectedRegion="eu2";selectedRegionLocation = $azureLocation.name.ToString()}
				$regions[1] = $hashTable ;
				break ;			
			}
			"Central US" {
			    $hashTable = @{ Index = 3; DisplayName = $displayName; selectedRegion="cu";selectedRegionLocation = $azureLocation.name.ToString()}
				$regions[2] = $hashTable ;
				break ;			
			}
			"North Central US" {
			    $hashTable = @{ Index = 4; DisplayName = $displayName; selectedRegion="ncu";selectedRegionLocation = $azureLocation.name.ToString()}
				$regions[3] = $hashTable ;
				break ;			
			}
			"South Central US" {
			    $hashTable = @{ Index = 5; DisplayName = $displayName; selectedRegion="scu";selectedRegionLocation = $azureLocation.name.ToString()}
				$regions[4] = $hashTable ;
				break ;			
			}
			"West Central US" {
			    $hashTable = @{ Index = 6; DisplayName = $displayName; selectedRegion="wcu";selectedRegionLocation = $azureLocation.name.ToString()}
				$regions[5] = $hashTable ;
				break ;			
			}
			"West US" {
			    $hashTable = @{ Index = 7; DisplayName = $displayName; selectedRegion="wu";selectedRegionLocation = $azureLocation.name.ToString()}
				$regions[6] = $hashTable ;
				break ;			
			}
			"West US 2" {
			    $hashTable = @{ Index = 8; DisplayName = $displayName; selectedRegion="wu2";selectedRegionLocation = $azureLocation.name.ToString()}
				$regions[7] = $hashTable ;
				break ;			
			}
		}
	}

	[BaseMenu] $Global:regionsMenuProduction = [BaseMenu]::new("Azure Windows Regions",$regions) ;
	[BaseMenu] $Global:regionsMenuDisasterRecovery = [BaseMenu]::new("Azure Windows Regions",$regions) ;

	[BaseMenu] $Global:environmentsMenuProduction = [BaseMenu]::new("Instech Production Environments") ;
	[BaseMenu] $Global:environmentsMenuDisasterRecovery = [BaseMenu]::new("Instech Disaster Recovery Environments") ;

	$hashTable = @{ Index = 1; DisplayName = "Production"; selectedEnvironment = "prod" ;applicationGatewayCapacity = 2; vnetAddressPrefix = "10.1.0.0/16"; vnetSubnetAddressPrefix = "10.1.0.0/28" ;webAppCapacity = 2; appServiceSKU="S2"; redisVmSize="C4";redisSku="Standard";gatewayCapacity=2}
	$Global:environmentsMenuProduction.MenuItems.Add($hashTable) 
	$Global:environmentsMenuDisasterRecovery.MenuItems.Add($hashTable) 
	$hashTable = @{ Index = 2; DisplayName = "Disaster Recovery"; selectedEnvironment = "dr" ;applicationGatewayCapacity = 1; vnetAddressPrefix = "10.2.0.0/16"; vnetSubnetAddressPrefix = "10.2.0.0/28" ;webAppCapacity = 1; appServiceSKU="S2"; redisVmSize="C0";redisSku="Standard";gatewayCapacity=1}
	$Global:environmentsMenuProduction.MenuItems.Add($hashTable) ;		
	$Global:environmentsMenuDisasterRecovery.MenuItems.Add($hashTable) 
	$hashTable = @{ Index = 3; DisplayName = "Test"; selectedEnvironment = "test" ;applicationGatewayCapacity = 1; vnetAddressPrefix = "10.0.0.0/16"; vnetSubnetAddressPrefix = "10.0.0.0/28" ;webAppCapacity = 1; appServiceSKU="B1"; redisVmSize="C0";redisSku="Basic";gatewayCapacity=1}
	$Global:environmentsMenuProduction.MenuItems.Add($hashTable) ;		
	$Global:environmentsMenuDisasterRecovery.MenuItems.Add($hashTable) 

<# 
	Generic Menu display function
#>	
function Show-Menu {
     param (
		 [String] $Title,
           $MenuItems
     )	
	Write-Host;
	Write-Host "================ $Title ================"
	foreach ($menuItem in $MenuItems)
	{
		$text = "Press " + $menuItem["Index"] + " for " + $menuItem["DisplayName"];
		Write-Host $text;
	}
}
<# 
	Function to prompt for the Instech Product
#>	
function Select-Product {		
	$selectedMenu = $Global:productsMenu.DisplayMenu("Please select an InsTech product or Press 'Q' to quit.","(0) was not a valid InsTech product selection") ;
	$Global:selectedProduct = $selectedMenu.selectedProduct;
}
<# 
	Function to prompt for the Azure Region
#>	
function Select-Region {	
	$menuItem = $Global:regionsMenuProduction.DisplayMenu("Please select the Azure region for the Production Web Application or Press 'Q' to quit.","{0} was not a valid Azure region selection") ;
	$Global:selectedRegionName = $menuItem.DisplayName; 
	$Global:selectedRegion = $menuItem.selectedRegion; 
	$Global:selectedRegionLocation = $menuItem.selectedRegionLocation; 
}
<# 
	Function to prompt for the Azure Region
#>	
function Select-DisasterRecoveryRegion {	
	$menuItem = $Global:regionsMenuDisasterRecovery.DisplayMenu("Please select the Azure region for the Disaster Recovery Web Application or Press 'Q' to quit.","{0} was not a valid Azure region selection") ;
	$Global:selectedDiasterRecoveryRegion = $menuItem.selectedRegion; 
}
<# 
	Function to prompt for the Environment
#>	
function Select-Environment {	
	$menuItem = $Global:environmentsMenuProduction.DisplayMenu("Please select the Production InsTech environment or Press 'Q' to quit.","{0} was not a valid InsTech environment selection") ;
	$Global:selectedProductionEnvironment = $menuItem.selectedEnvironment;
}
function Select-EnvironmentDiasterRecovery {
	$menuItem = $Global:environmentsMenuDisasterRecovery.DisplayMenu("Please select the Disaster Recovery InsTech environment or Press 'Q' to quit.","{0} was not a valid InsTech environment selection") ;
	$Global:selectedDiasterRecoveryEnvironment = $menuItem.selectedEnvironment;	
}
<# 
	Function to prompt for the Carrier Abbreviation
#>
function Select-CarrierAbbreviation {	
	[bool]$menuDoLoopExit = $false ;
	Write-Host;
	do {

		$input = Read-Host "Please enter a 3 character carrier abbreviation or Press 'Q' to quit."
		if ($input -eq 'Q') {
			exit;
		}
		if ($input.Length -eq 3 -and [System.Text.RegularExpressions.Regex]::IsMatch($input, "^[A-Z][A-Z][A-Z]$",[System.Text.RegularExpressions.RegexOptions]::IgnoreCase)) {
			 $Global:carrierAbbreviation = $input.ToLower() ;
			$menuDoLoopExit = $true;
			return ;
		}
		Write-Host "$($input) is not a valid carrier abbreviation";

	}
	until ($menuDoLoopExit)
}
<# 
	Function to prompt for the Azure Subscription.  This function is only called if your login 
	allows your access to multiple subscriptions.
#>
function Select-AzureSubscription {
     param (
		 [String] $Title,
           $subscriptions
     )	
    $availSubscriptions =  New-Object -TypeName 'System.Collections.Generic.List[System.Collections.Hashtable]'
	[int] $index = 0;

	foreach($sub in $subscriptions) {
		$index++;
		#$tuple = New-Object -TypeName 'System.ValueTuple[String,String]' -ArgumentList $index.ToString(),$sub.name
		$hashTable = @{ Index = $index; DisplayName = $sub.name; Subscription=$sub};
		$availSubscriptions.Add($hashTable) ;
	}
	[BaseMenu] $Global:azureSubscriptionsMenu = [BaseMenu]::new($Title,$availSubscriptions) ;
	$menuItem = $Global:azureSubscriptionsMenu.DisplayMenu("Please select an Azure Subscription or Press 'Q' to quit.","{0} was not a valid Subscription selection") ;
	$Global:azureSubscription = $menuItem.Subscription ; 
}

<#
Class JsonUtility
#>
class JsonUtility {

	static [Object] Deserialize([String] $jsonString, [bool] $displayJson) {
		$JsonObject = $null ;
		try {
				$JsonObject = [Newtonsoft.Json.JsonConvert]::DeserializeObject($JsonString) 
				if($displayJson) {
					Write-Host $([Newtonsoft.Json.Linq.JToken]::Parse($JsonString).ToString([Newtonsoft.Json.Formatting]::Indented));
				}
		}
		catch {
			Write-Host $displayJson
			exit ;		
		}
    	return $JsonObject;
	}
}
exit ;
cls

    $ErrorActionPreference = 'Stop';
	$Global:azureSubscription= $null;
	$HOST.UI.RawUI.ForegroundColor = "Gray"

	$Global:test = [NamingConventionPatterns]::New() ;

	$selectedMenu = $Global:productsMenu.DisplayMenu("Please select an InsTech product or Press 'Q' to quit.","(0) was not a valid InsTech product selection") ;
	$Global:selectedProduct = $selectedMenu.selectedProduct;

	exit ;
	Write-Host "NOTE!! Please install the Azure CLI prior to running this script."
	Write-Host "    See https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest"
	Write-Host "    If your PowerShell session is not logged into Azure perform the command az login"

	Write-Host "Please wait querying all available subscriptions:"
	$subscriptionsJson = az account list --all
	$subscriptions = [Newtonsoft.Json.JsonConvert]::DeserializeObject($subscriptionsJson)
	$Global:azureSubscription = $subscriptions[0] ;
	if ($subscriptions.Length -gt 1) {
		Select-AzureSubscription -Title "Select from the available Azure Subscriptions." -$subscriptions $subscriptions
	}
	Write-Host "The current Azure subscription used for this script is below:"
	Write-Host $Global:azureSubscription.ToString() -ForegroundColor Green
	Write-Host;

	[string] $Global:selectedProduct = ""
	[string] $Global:selectedRegion = ""
	[string] $Global:selectedRegionName = ""
	[string] $Global:selectedProductionEnvironment = ""
	[string] $Global:selectedDiasterRecoveryEnvironment = ""
	[string] $Global:selectedDiasterRecoveryRegion = ""
	[string] $Global:carrierAbbreviation= ""
	[string] $Global:selectedRegionLocation = ""
#note that the Select-Environment function was modified to set this value to 2 for production environments
	[int]    $Global:applicationGatewayCapacity = 0;
	[string] $Global:vnetAddressPrefix = ""
	[string] $Global:vnetSubnetAddressPrefix= ""
	[bool]   $Global:createApplicationInsights= $false
	[int]    $Global:webAppCapacity = 0;
	[string] $Global:appServiceSKU= ""
	[string] $Global:redisVmSize= ""
	[string] $Global:redisSku= ""
	[string] $Global:gatewayCapacity= ""
	[string] $sqlADGroupName = "SQLUsers" ;

	Select-Product
	Select-Region
	Select-DisasterRecoveryRegion
	Select-Environment
	Select-EnvironmentDiasterRecovery
	Select-CarrierAbbreviation


	$resourceGroupNamePrimary = "$($Global:selectedProduct)-$($Global:carrierAbbreviation)-$($Global:selectedProductionEnvironment)-$($Global:selectedRegion)-rg";
	$resourceGroupNameDisasterRecovery = "$($Global:selectedProduct)-$($Global:carrierAbbreviation)-$($Global:selectedDiasterRecoveryEnvironment)-$($Global:selectedDiasterRecoveryRegion)-rg";

	$webApplicationNamePrimary = "$($Global:selectedProduct)-$($Global:carrierAbbreviation)-$($Global:selectedProductionEnvironment)-$($Global:selectedRegion)-app";
	$webApplicationNameDisasterRecovery = "$($Global:selectedProduct)-$($Global:carrierAbbreviation)-$($Global:selectedDiasterRecoveryEnvironment)-$($Global:selectedDiasterRecoveryRegion)-app";


	$input = Read-Host "Press Enter to create the managed Identity resources for web applications '$($webApplicationNamePrimary)' and '$($webApplicationNameDisasterRecovery)' or Press 'Q' to quit."
	if ($input -eq 'Q') {
		exit;
	}

	Write-Host;
	$currentTime = [DateTime]::Now.ToString("T")
	Write-Host "Creating Active Directory Group '$($sqlADGroupName)' StartTime $($currentTime)"


	[string]$adGroupTest = az ad group show --group  "$($sqlADGroupName)" --subscription $Global:azureSubscription.id.ToString()

	if ([String]::IsNullOrEmpty($adGroupTest)) {
		$HOST.UI.RawUI.ForegroundColor = "Gray"

		$activeDirectoryGroupJson = az ad group create --display-name "$($sqlADGroupName)" --mail-nickname 'NotSet' --subscription $Global:azureSubscription.id.ToString()
		[JsonUtility]::Deserialize($activeDirectoryGroupJson,$true) > $null;
		$currentTime = [DateTime]::Now.ToString("T")
		Write-Host "Creating Active Directory Group '$($sqlADGroupName)' EndTime $($currentTime)"


		$currentTime = [DateTime]::Now.ToString("T")
		Write-Host "Getting managed identity for web application '$($webApplicationNamePrimary)' StartTime $($currentTime)"
	}

	$webAppManagedIdentityProductionJson = az webapp identity show --name "$($webApplicationNamePrimary)"  --resource-group "$($resourceGroupNamePrimary)" --subscription $Global:azureSubscription.id.ToString() 
	$webAppManagedIdentityProduction = [JsonUtility]::Deserialize($webAppManagedIdentityProductionJson,$true) ;

	$currentTime = [DateTime]::Now.ToString("T")
	Write-Host "Getting managed identity for web application '$($webApplicationNameDisasterRecovery)' StartTime $($currentTime)"

	$webAppManagedIdentityDiasterRecoveryJson = az webapp identity show --name "$($webApplicationNameDisasterRecovery)"  --resource-group "$($resourceGroupNameDisasterRecovery)" --subscription $Global:azureSubscription.id.ToString() 
	$webAppManagedIdentityDiasterRecovery = [JsonUtility]::Deserialize($webAppManagedIdentityDiasterRecoveryJson,$true) ;

	#Write-Host $webAppManagedIdentityProduction.principalId.ToString()
	$currentTime = [DateTime]::Now.ToString("T")
	Write-Host "Adding managed identity for web application '$($webApplicationNamePrimary)' to active directory group '$($sqlADGroupName)' StartTime $($currentTime)"

	$activeDirectoryGroupAddJson = az ad group member add --group "$($sqlADGroupName)" --member-id "$($webAppManagedIdentityProduction.principalId.ToString())" --subscription $Global:azureSubscription.id.ToString() 
	[JsonUtility]::Deserialize($activeDirectoryGroupAddJson,$false) > $null  ;

	$currentTime = [DateTime]::Now.ToString("T")
	Write-Host "Adding managed identity for web application '$($webApplicationNameDisasterRecovery)' to active directory group '$($sqlADGroupName)' StartTime $($currentTime)"

	$activeDirectoryGroupAddJson = az ad group member add --group "$($sqlADGroupName)" --member-id "$($webAppManagedIdentityDiasterRecovery.principalId.ToString())" --subscription $Global:azureSubscription.id.ToString() 
	[JsonUtility]::Deserialize($activeDirectoryGroupAddJson,$false) > $null  ;

Write-Host "Script Complete."