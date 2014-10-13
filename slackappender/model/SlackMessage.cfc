component  displayname="SlackMessage" output="false" accessors="true"   
{
	property name="text" type="string" default="";
	property name="channel" type="string" default="";
	property name="emoji" type="string" default="";
	property name="attachments" type="array";  

	//Init
	public SlackMessage function init(required string text, string channel =""){
		variables.text = arguments.text;
		variables.channel = arguments.channel;
		variables.emoji = "";
		variables.attachments = [];
		return this;
	}
	
	public function addAttachment(SlackAttachment attachment){
		ArrayAppend(variables.attachments, arguments.attachment);
	}
}