component  displayname="SlackAttachment" output="false" accessors="true"   
{
	property name="fallback" type="string" default="";
	property name="color" type="string" default="";
	property name="text" type="string" default="";
	property name="pretext" type="string" default="";
	property name="fields" type="array" ;

	//Init
	public SlackAttachment function init(string fallback = "", string color = "##D00000",  array fields = [],  string text = "", string pretext = ""){
		variables.fallback = arguments.fallback;
		variables.color = arguments.color;
		variables.text = arguments.text;
		variables.pretex = arguments.pretext;
		variables.fields = arguments.fields;
		return this;
	}

	/*
		addField	
	*/
	public function addField(required string title, required string  value, string short = false){
		ArrayAppend(variables.fields, {"title" = arguments.title, "value" = arguments.value, "short" = arguments.short});
	}
}
