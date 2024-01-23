
<cfscript>
 // executes after all configuration has loaded
 function onBuildReady(){
  collections.global.categories = {};
  for(var cat in collections.global.index.categories){
   if(collections.global.en.keyExists(cat)){
    var thisCat = collections.global.en[cat];
    collections.global.categories[cat] = {};
    collections.global.categories[cat].name = thisCat.name;
    collections.global.categories[cat].items = thisCat.related;
   }
  }
 }

 // executes before templates are generated
 function beforeGenerate(){
  collections.all.each((item) => {
   if(item.permalink.find("/guides") == 1) {
    item.outFile = item.outFile.replace("/guides", "");
    item.permalink = item.permalink.replace("/guides", "");
   }
  });
 }

</cfscript>
 
 <cffunction name="linkTo" output="false">
		<cfargument name="name">
		<cfreturn "/" & URLEncodedFormat(LCase(arguments.name))>
	</cffunction>

	<cffunction name="autoLink" output="false">
		<cfargument name="content">
		<cfargument name="exclude" default="">
		<cfargument name="isMarkdown" default=false>
		<cfset var i = "">
		<cfif NOT len(arguments.exclude) AND structKeyExists(url, "name")>
			<cfset arguments.exclude = url.name>
		</cfif>
		<cfif ReFindNoCase("[^""]https?://", arguments.content)>
			<cfset arguments.content = ReReplaceNoCase(arguments.content, "([^""])(https?://[a-zA-Z0-9._/=&%?##+-]+)", "\1<a href=""\2"">\2</a>", "ALL")>
		</cfif>
		<cfif ReFindNoCase("\bApplication\.cfc\b", arguments.content)>
			<cfset arguments.content = ReReplaceNoCase(arguments.content, "\bApplication\.cfc\b", "<a href=""#linkTo('application-cfc')#"">Application.cfc</a>", "ALL")>
		</cfif>
		<cfloop array="#collections.global.index.tags#" index="i">
			<cfif i IS NOT arguments.exclude>
				<cfset arguments.content = ReReplaceNoCase(arguments.content, "[ ](#i#)([ .!,])", " <a href=""#linkTo(i)#"">\1</a>\2", "all")>
			</cfif>
		</cfloop>
		<cfloop array="#collections.global.index.functions#" index="i">
			<cfif i IS NOT arguments.exclude AND NOT ListFindNoCase("insert,include,now,invoke,array,query,each,second", i)>
				<cfset arguments.content = ReReplaceNoCase(arguments.content, "([ >])(#i#)([< .!,])", "\1<a href=""#linkTo(i)#"">\2</a>\3", "all")>
			</cfif>
		</cfloop>
		<!--- add CFx+ badge --->
		<cfif REFind("CF[0-9.]+\+", arguments.content)>
			<cfset arguments.content = ReReplace(arguments.content, "CF([0-9.]+\+)", "<span class=""label label-acf"" title=""Requires ColdFusion \1"">CF \1</span>", "ALL")>
		</cfif>
		<!--- add Luceex+ badge --->
		<cfif REFind("Lucee[0-9.]+\+", arguments.content)>
			<cfset arguments.content = ReReplace(arguments.content, "Lucee([0-9.]+\+)", "<span class=""label label-lucee"" title=""Requires Lucee \1"">Lucee \1</span>", "ALL")>
		</cfif>
		<!--- replace \n with br tags --->
		<cfif not isMarkdown>
			<cfset arguments.content = Replace(arguments.content, "#Chr(10)#", "<br />", "ALL")>
		</cfif>
		<!--- replace backticks with code tag block --->
		<cfset arguments.content = replace(arguments.content, "&##x60;", "`", "ALL")>
		<cfset arguments.content = ReReplace(arguments.content, "`([^`]+)`", "<code>\1</code>", "ALL")>
		<cfreturn arguments.content>
	</cffunction>

	<cffunction name="findCategory">
		<cfargument name="name"  default="#url.name#">
		<cfscript>
			var cat 		= "all";
			var categories 	= ListToArray(StructKeyList(collections.global.categories));
			var reOrderKeys = "tags,functions,all";
			var key 		= "";
			// move tags and functions to bottom of array (remove all)
			for (key in reOrderKeys){
				if (arrayFind(categories,key)){
					// remove
					arrayDeleteAt(categories,arrayFind(categories,key));
					// add to bottom
					if (compare(key,"all"))
						arrayAppend(categories,key);
				}
			}
			// loop thru categories to return category
			for (key in categories){
				if ( arrayFindNoCase(collections.global.categories[key].items, arguments.name) ){
					cat = key;
					break;
				}
			}
			return cat;
		</cfscript>
	</cffunction>