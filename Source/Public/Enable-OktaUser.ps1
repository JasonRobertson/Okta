function Enable-OktaUser {
  [CmdletBinding(DefaultParameterSetName='UserID')]
  param (
    # Identity is used to fetch a user by id, login, or login shortname if the short name is unambiguous
    [parameter(ParameterSetName='UserID')]
    [string]$Identity,
    [switch]$SendEmail
  )
  if ((Invoke-OktaAPI -EndPoint users/$identity).status -eq 'PROVISIONED') {
    Write-Warning "$identity is already activated"
  }
  else {
    $oktaAPI          = [hashtable]::new()
    $oktaAPI.Method   = 'POST'
    $oktaAPI.Endpoint = switch ($SendEmail) {
      true  {"users/$identity/lifecycle/activate?sendEmail=true"}
      false {"users/$identity/lifecycle/activate?sendEmail=false"}
    }
    try {
      Invoke-OktaAPI @oktaAPI
      Write-Host "Successfully activated $identity"
    }
    catch {
      Write-Error $PSItem.Exception.Message
    }
  }
}