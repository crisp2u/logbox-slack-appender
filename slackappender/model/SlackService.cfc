/**
* SlackService
*/
component {
	property name="webhookURL" type="string" default="";

	SlackService function init(required string webhookURL){
		return this;
	}
	
	public function notify(required SlackMessage message){
		var payload = {
			"text" = arguments.message.getText(), 
			"channel"=arguments.message.getChannel(),
			"icon_emoji" = arguments.message.getEmoji(), 
			"attachments" = arguments.message.getAttachments()
		};

		//Send payload to Slack 
		var httpService = new http();

		httpService.setUrl(getProperty("webhookURL"));
		httpService.setMethod("post");
		httpService.addParam(type="body", value=SerializeJson(payload));
		httpService.addParam(type="header", name="Content-Type", value="application/json");
		httpService.addParam(type="header", name="Accept", value="application/json");
		var result = httpService.send().getPrefix();
		
		if(!(result.statuscode contains "201")){
			throw("There was a problem sending payload to Slack. Status code: " & result.statuscode, "SLACKAPPENDER.HTTP_SEND_ERROR" );
		}
	}
}
