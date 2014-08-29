/**
* This tests the BDD functionality in TestBox. This is CF10+, Railo4+
*/
component extends="coldbox.system.testing.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		props={webhookURL = "https://slack.com/services/hooks/incoming-webhook?token=<TOKEN_HERE>",
					channel = "##general"};
		
		slackAppender = getMockBox().createMock(className="slackapp.SlackAppender");
		slackAppender.init('MySlackAppender', props);

		variables.logEvent = getMockBox().createMock(className="coldbox.system.logging.LogEvent");
        variables.logEvent.init("This is my awesome Slack Appender Test", 5, StructNew(), "UnitTest");
	}

	function afterAll(){
	}


/*********************************** BDD SUITES ***********************************/

	function run(){
		describe( "Send Slack payload", function(){
			 beforeEach(function() {
		        variables.logEvent.setSeverity(3);
				
				slackAppender.logMessage(variables.logEvent);
		     });
			it("just to be, for now", function() {

		     });
		});
	}

}