component extends="coldbox.system.logging.AbstractAppender" displayname="SlackAppender" output="false"{
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
			variables.slackService = new SlackService(getProperty("webhookURL"));
			return this;
	}

	public function logMessage(required any logEvent hint="The logging event") {
		var loge = arguments.logEvent;
		var payload = "";
		var message = new SlackMessage(loge.getMessage(), getProperty("channel"));
		var attachment = new SlackAttachment();
		attachment.addField(title="Severity",value=logEvent.getSeverity(), short=true);
		attachment.addField(title="Category",value=loge.getCategory(), short=true);
		message.addAttachment(attachment);

		try{
			if( Len(loge.getExtraInfoAsString()) ){
				var extraInfo = new SlackAttachment();
				extraInfo.addField(title="Extra Info",value=loge.getExtraInfoAsString());
				message.addAttachment(extraInfo);
			}

			variables.slackService.notify(message);
			
		}catch(any e){
			$log("ERROR","Error sending message to slack.com from appender #getName()#. #e.message# #e.detail# #e.stacktrace#");
		}
	}
}