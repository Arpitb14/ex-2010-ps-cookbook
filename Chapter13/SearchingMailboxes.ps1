#example 1:

Add-Type -Path C:\EWS\Microsoft.Exchange.WebServices.dll
$svc = New-Object Microsoft.Exchange.WebServices.Data.ExchangeService
$svc.AutoDiscoverUrl(�administrator@contoso.com�)

$view = New-Object -TypeName `
Microsoft.Exchange.WebServices.Data.ItemView `
-ArgumentList 100

$propertyset = New-Object Microsoft.Exchange.WebServices.Data.PropertySet (
  [Microsoft.Exchange.WebServices.Data.BasePropertySet]::IdOnly,
  [Microsoft.Exchange.WebServices.Data.ItemSchema]::Subject,
  [Microsoft.Exchange.WebServices.Data.ItemSchema]::HasAttachments,
  [Microsoft.Exchange.WebServices.Data.ItemSchema]::DisplayTo,
  [Microsoft.Exchange.WebServices.Data.ItemSchema]::DisplayCc,
  [Microsoft.Exchange.WebServices.Data.ItemSchema]::DateTimeSent,
  [Microsoft.Exchange.WebServices.Data.ItemSchema]::DateTimeReceived
)

$view.PropertySet = $propertyset

$query = �Subject:sales�

$items = $svc.FindItems("Inbox",$query,$view)

$items | Foreach-Object{
  New-Object PSObject -Property @{
    Id = $_.Id.ToString()
    Subject = $_.Subject
    To = $_.DisplayTo
    Cc = $_.DisplayCc
    HasAttachments = [bool]$_.HasAttachments
    Sent = $_.DateTimeSent
    Received = $_.DateTimeReceived
  }
}


#example 2:

Param($query,$mailbox)

Add-Type -Path C:\EWS\Microsoft.Exchange.WebServices.dll
$svc = New-Object Microsoft.Exchange.WebServices.Data.ExchangeService

$id = New-Object -TypeName `
Microsoft.Exchange.WebServices.Data.ImpersonatedUserId `
-ArgumentList "SmtpAddress",$mailbox

$svc.ImpersonatedUserId = $id
$svc.AutoDiscoverUrl($mailbox)

$view = New-Object -TypeName `
Microsoft.Exchange.WebServices.Data.ItemView `
-ArgumentList 100

$propertyset = New-Object Microsoft.Exchange.WebServices.Data.PropertySet (
  [Microsoft.Exchange.WebServices.Data.BasePropertySet]::IdOnly,
  [Microsoft.Exchange.WebServices.Data.ItemSchema]::Subject,
  [Microsoft.Exchange.WebServices.Data.ItemSchema]::HasAttachments,
  [Microsoft.Exchange.WebServices.Data.ItemSchema]::DisplayTo,
  [Microsoft.Exchange.WebServices.Data.ItemSchema]::DisplayCc,
  [Microsoft.Exchange.WebServices.Data.ItemSchema]::DateTimeSent,
  [Microsoft.Exchange.WebServices.Data.ItemSchema]::DateTimeReceived
)

$view.PropertySet = $propertyset

$items = $svc.FindItems("Inbox",$query,$view)

$items | Foreach-Object{
  $emailProps = New-Object -TypeName `
  Microsoft.Exchange.WebServices.Data.PropertySet(
    [Microsoft.Exchange.WebServices.Data.BasePropertySet]::IdOnly,
    [Microsoft.Exchange.WebServices.Data.ItemSchema]::Body
  )

  $emailProps.RequestedBodyType = "Text"
  $email = [Microsoft.Exchange.WebServices.Data.EmailMessage]::Bind(
    $svc, $_.Id, $emailProps
  )
  
  New-Object PSObject -Property @{
    Id = $_.Id.ToString()
    Subject = $_.Subject
    To = $_.DisplayTo
    Cc = $_.DisplayCc
    HasAttachments = [bool]$_.HasAttachments
    Sent = $_.DateTimeSent
    Received = $_.DateTimeReceived
    Body = $email.Body
  }
}

