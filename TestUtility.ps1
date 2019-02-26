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

	[void] Add([System.Collections.Hashtable] $hashTable) {
		$this.MenuItems.Add($hashTable) ;
	}
	[void] DisplayMenu ([string] $readHostPrompt,[string] $invalidSelectionFormatString) {
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
				if([String]::IsNullOrEmpty($input)) {
					$input = "CRLF" ;
				}
				$displayText = [String]::Format($invalidSelectionFormatString,$input);
				Write-Host $displayText ;
			}

		}
		until ($menuDoLoopExit);
	}
	<# End Public Methods #>
}
class NamingConventionItems {

	[BaseMenu] $DepartmentMenus ;
	[BaseMenu] $EnvironmentMenus ;
	hidden static [String] $ResourceGroup = "rg";
	hidden static [String] $AzureSqlServer = "sql";
	hidden static [String] $ApplicationGateway = "agw";
	hidden static [String] $FailoverGroup = "fg";
	hidden static [String] $StorageAccount = "sa";
	hidden static [String] $AppServicePlan = "sp";
	hidden static [String] $WebAppService = "app";
	hidden static [String] $KeyVault = "kv";
	hidden static [String] $VNet = "vn";
	hidden static [String] $Subnet = "sbn";
	hidden static [String] $FunctionApp = "func";
	hidden static [String] $VirtualMachine = "vm{0}";

	<# End Public Properties #>

	<# Start Constructors #>
	<#
	Initilizes the menu title and the MenuItems properties
	#>
	NamingConventionItems()
	{
		$this.InitilizeDepartments() ;
		$this.InitilizeEnvironments() ;
	}

	hidden [void] InitilizeDepartments() {
		$this.DepartmentMenus = [BaseMenu]::new("Available Departments") ;
		$this.DepartmentMenus.Add(@{DisplayName="SocialGaming";affix = "sg" });
		$this.DepartmentMenus.Add(@{DisplayName="IT";affix = "it" });	
	}
	hidden [void] InitilizeEnvironments() {
		$this.EnvironmentMenus = [BaseMenu]::new("Available Environments") ;
		$this.EnvironmentMenus.Add(@{DisplayName="Development";affix = "dev" });
		$this.EnvironmentMenus.Add(@{DisplayName="Production";affix = "prod" });	
		$this.EnvironmentMenus.Add(@{DisplayName="QA";affix = "qa" });	
	}
}
cls

    $ErrorActionPreference = 'Stop';
	$Global:azureSubscription= $null;
	$HOST.UI.RawUI.ForegroundColor = "Gray"

	[NamingConventionItems]$menus = [NamingConventionItems]::new() ;

	$menus.DepartmentMenus.DisplayMenu("Please select an department or Press 'Q' to quit.","'{0}' was not a valid department selection") ;
	$menus.EnvironmentMenus.DisplayMenu("Please select an environment or Press 'Q' to quit.","'{0}' was not a valid environment selection") ;
	