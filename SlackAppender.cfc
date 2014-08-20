<cfcomponent extends="coldbox.system.logging.AbstractAppender" output="false">

	<cffunction name="init" access="public" output="false" returntype="SlackAppender">
		<cfargument name="name" 		required="true" hint="The unique name for this appender."/>
		<cfargument name="properties" 	required="false" default="#structnew()#" hint="A map of configuration properties for the appender"/>
		<cfargument name="layout" 		required="false" default="" hint="The layout class to use in this appender for custom message rendering."/>
		<cfargument name="levelMin"  	required="false" default="0" hint="The default log level for this appender, by default it is 0. Optional. ex: LogBox.logLevels.WARN"/>
		<cfargument name="levelMax"  	required="false" default="4" hint="The default log level for this appender, by default it is 5. Optional. ex: LogBox.logLevels.WARN"/>
		<cfscript>
			// Init supertype
			super.init(argumentCollection=arguments);
			
			// valid columns
			instance.columns = "id,severity,category,logdate,appendername,message,extrainfo";
			// UUID generator
			instance.uuid = createobject("java", "java.util.UUID");
			// Verify properties
			if( NOT propertyExists('webhookURL') ){ 
				$throw(message="No webhookURL property defined",type="SlackAppender.InvalidProperty"); 
			}
			//defaults
			if( NOT propertyExists('channel') ){
				setProperty("channel",'');
			}			
			if( NOT propertyExists('username') ){
				setProperty("username",'');
			}
			return this;
		</cfscript>
	</cffunction>
	<!--- Log Message --->
	<cffunction name="logMessage" access="public" output="false" returntype="void" hint="Write an entry into the logger.">
		<!--- ************************************************************* --->
		<cfargument name="logEvent" type="any" required="true" hint="The logging event"/>
		<!--- ************************************************************* --->
		<cfscript>
			var loge = arguments.logEvent;
			var payload = StructNew();
			var entry = "";
		</cfscript>
		<cftry>
			<cfsavecontent variable="entry">
			<cfoutput>
			<p>TimeStamp: #loge.getTimeStamp()#</p>
			<p>Severity: #loge.getSeverity()#</p>
			<p>Category: #loge.getCategory()#</p>
			<hr/>
			<p>#loge.getMessage()#</p>
			<hr/>
			<p>Extra Info Dump:</p>
			<cfdump var="#loge.getExtraInfo()#" format="text" >
			</cfoutput>
			</cfsavecontent>
			<cfset payload["text"] = entry>
			<cfif getProperty("channel") neq "">
				<cfset payload["channel"] = getProperty("channel")> 
			</cfif> 
			<cfhttp url="#getProperty("webhookURL")#" method="post" throwonerror="true" multiparttype="" result="slackres">
				<cfhttpparam type="body" value="#SerializeJSON(payload)#">
			</cfhttp>
			<cfset $log("DEBUG","slack appender response #slackres#")>
			<cfcatch>
				<cfset $log("ERROR","Error sending message to slack.com from appender #getName()#. #cfcatch.message# #cfcatch.detail# #cfcatch.stacktrace#")>
			</cfcatch>			
		</cftry>		
	</cffunction>

</cfcomponent>