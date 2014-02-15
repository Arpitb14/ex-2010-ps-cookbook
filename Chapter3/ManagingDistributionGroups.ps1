#example 1:

New-DistributionGroup -Name Sales

Get-Mailbox -OrganizationalUnit Sales | 
  Add-DistributionGroupMember -Identity Sales

New-DynamicDistributionGroup -Name Accounting `
-Alias Accounting `
-IncludedRecipients MailboxUsers,MailContacts `
-OrganizationalUnit Accounting `
-ConditionalDepartment accounting,finance `
-RecipientContainer contoso.com

#example 2:

Add-DistributionGroupMember -Identity Sales -Member administrator 



