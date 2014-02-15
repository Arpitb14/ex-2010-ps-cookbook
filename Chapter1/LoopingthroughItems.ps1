#example 1:

foreach ($mailbox in Get-Mailbox) {$mailbox.Name}

Get-Mailbox | ForEach-Object {$_.Name}

Get-Mailbox | %{$_.Name}

#example 2:

Get-MailboxDatabase -Status | %{
  $DBName = $_.Name
  $whiteSpace = $_.AvailableNewMailboxSpace.ToBytes() /1mb
  "The $DBName database has $whiteSpace MB of total white space"
}
