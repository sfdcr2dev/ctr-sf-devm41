global abstract class WebserviceExtend {
	global static dto_response parse(String json) {
		return (dto_response) System.JSON.deserialize(json, dto_response.class);
	}

	global virtual class Description {
		global Boolean success {
			get {
				return success != null ? success : false;
			}
			set;
		}
		// global String statuscode {
		// 	get {
		// 		return String.isNotEmpty(statuscode) ? statuscode : '';
		// 	}
		// 	set;
		// }
		global String message {
			get {
				return String.isNotEmpty(message) ? message : '';
			}
			set;
		}
		global String linkurl { get; set; }
	}

	global class Result {
		global List<sObject> data { get; set; }
	}

	global virtual class dto_response {
		global Description description { get; set; }
		// global Result result { get; set; }

		global dto_response() {
			this.description = new Description();
		}

		global String parseToJSON() {
			return (String) System.JSON.serialize(this);
		}
	}

	global static String getErrorMessageException(Exception e) {
		return String.format('{0}\r\n{1}', new List<String>{ e.getMessage(), e.getStackTraceString() });
	}

	global static String getErrorMessageException(DmlException e) {
		return String.format('{0}', new List<Object>{ e.getDmlMessage(0) });
	}
}