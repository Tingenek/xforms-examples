/* MQTT XForms Demo
 * @tingenek 2014
 * For llamas everywhere.
 */

var client;

/* Functions called by XForm triggers
 * 
 */

function mqttstart(host,port,clientId,initialTopic) {	
	client = new Messaging.Client(host, Number(port), clientId);

	var options = {
		     timeout: 30,
		     onSuccess:onConnect,
		     onFailure:onFailure 
		 };
    client.connect(options);
};

function mqttstop() {
	   client.disconnect();
};

/* Utility Functions
 * 
 */

/* Call an event on an XForm */
function call_xform_event(xfevent,xfpayload) {
	var model=document.getElementById("modelid")
	   XsltForms_xmlevents.dispatch(model,xfevent, null, null, null, null,xfpayload);
}

/* Callbacks called by MQTT
 * 
 */

function onConnect() {
	alert('Connected');
	call_xform_event("mqtt_set_status",{status:  "connected"});
};

function onFailure() {
	alert('Failed');
};
