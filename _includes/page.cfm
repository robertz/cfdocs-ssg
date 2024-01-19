<cfoutput>
	<cfif find("<h1", prc.content)>
		<!--- <cfset request.title = trim(reReplace(variables.data, ".*<h1[^>]+><a[^>]+>([^<]+)<.+", "\1", "ONE"))> --->
	<cfelse>
		<!--- <cfset request.title = encodeForHTML(url.name) & " Guide"> --->
	</cfif>	
	<br><br>
	<div class="container">
		<cfoutput>
			<a href="https://github.com/foundeo/cfdocs##" rel="nofollow" class="label label-danger">Edit</a>
			<!--- #autoLink(variables.data,"",true)# --->
   #prc.content#
		</cfoutput>
	</div>
</cfoutput>