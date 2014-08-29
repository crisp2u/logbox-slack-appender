component  extends="coldbox.system.logging.AbstractAppender" displayname="SlackAppender" output="false"{
	
	public SlackAppender function init(required  name, properties="#StructNew()#", layout="", levelMin="0", levelMax="4")
	 output="false"{

		// Init supertype

			super.init(argumentCollection=arguments);
			
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
	}

	public function logMessage(required any logEvent hint="The logging event") {
		var loge = arguments.logEvent;
		var payload = "";
		
		var message = {"text" = "", "channel"="", "attachments" = []};
		var attachment = {};
		var fields = [];
		var field = {};

		message.text = loge.getMessage();
		message.channel = getProperty("channel");

		attachment = {
			"fallback" = "", 
			"color" = "##D00000", 
			"text" = "", 
			"pretext" = "", 
			"fields" = []
		};

		//Application name field

		field = {
			"title"="Name", 
			"value"="#getApplicationMetadata().name#", 
			"short"= true
		};

		ArrayAppend(attachment.fields, field);


		//Add attachement to message attachements
		ArrayAppend(message.attachments, attachment);

		
		payload = SerializeJSON(message);

		//Send payload to Slack 
		var httpService = new http();

		try{
			httpService.setUrl(getProperty("webhookURL"));
			httpService.setMethod("post");
			httpService.addParam(type="body", value="#payload#");
			httpService.addParam(type="header", name="Content-Type", value="application/json");
			httpService.addParam(type="header", name="Accept", value="application/json");
			var result = httpService.send().getPrefix();
			
			if(!(result.statuscode contains "201")){
				throw("There was a problem sending payload to Slack. Status code: " & result.statuscode, "SlackAppender.HTTP_SEND_ERROR" );
			}
		}catch(any e){
			$log("ERROR","Error sending message to slack.com from appender #getName()#. #e.message# #e.detail# #e.stacktrace#");
		} 
	}
}