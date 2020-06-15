/// Installer for the container release of PythonGateway
Class src.Installer
{

XData Install [ XMLNamespace = INSTALLER ]
{
<Manifest>
  <Var Name="pwd" Value="SYS"/> 
  <User Username="SuperUser" ChangePassword="0" PasswordVar="pwd" Roles="%All" Enabled="1"/>
  <Default Name="NAMESPACE" Value="USER"/>
  <Default Name="DBNAME" Value="${NAMESPACE}"/>
  <Default Name="RESOURCE" Value="%DB_${DBNAME}" /> 
  <Namespace Name="${NAMESPACE}" Ensemble="1">

    <Import File="/usr/irissys/csp/user/guide.csp"/>
    <Import File="/usr/irissys/csp/user/trainingLog.csp"/>

	<CSPApplication Url="/csp/${Namespace}" Directory="${CSPDIR}${Namespace}" AutoCompile="1" />
        
    <Log Level="1" Text="Enabling OS level Authentication"/>
    <Invoke Class="od.Installer" Method="OSAuth" CheckStatus="true"/>
    
	<Log Level="1" Text="Enabling Analytics"/>
	<Invoke Class="od.Installer" Method="EnableAnalytics" CheckStatus="true">
      <Arg Value="/csp/user/"/>
    </Invoke>

  </Namespace>
</Manifest>
}

ClassMethod Setup(ByRef pVars, pLogLevel As %Integer = 3, pInstaller As %Installer.Installer, pLogger As %Installer.AbstractLogger) As %Status [ CodeMode = objectgenerator, Internal ]
{
  Quit ##class(%Installer.Manifest).%Generate(%compiledclass, %code, "Install")
}

/// Enable OS Authentication
ClassMethod OSAuth() As %Status
{
	new $namespace
	set $namespace = "%SYS"
	set sc = ##Class(Security.System).Get($$$SystemSecurityName,.properties)
	quit:$$$ISERR(sc) sc
	
	set autheEnabled = properties("AutheEnabled")
	quit:'$data(autheEnabled) $$$ERROR($$$PropertyDoesNotExist, "AutheEnabled")
	set properties("AutheEnabled") = $ZBOOLEAN(+autheEnabled, $$$AutheOS, 7)
	set sc = ##Class(Security.System).Modify($$$SystemSecurityName, .properties) 
	
	quit sc
}

ClassMethod EnableAnalytics(pCSPName As %String, url As %String) As %Status
{
  new $namespace
  znspace "%SYS"
  set props("DeepSeeEnabled")=1
  do ##class(Security.Applications).Modify(pCSPName,.props)
  quit $$$OK
}

}
