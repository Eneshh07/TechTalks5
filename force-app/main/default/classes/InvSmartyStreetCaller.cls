public with sharing class InvSmartyStreetCaller {
  @InvocableMethod(label='Call SmartyStreet' description='Makes callout to SmartyStreet API')
public static void makeCallout(List<ID> locationIds) {
  run(locationIds[0]);
}

@future(callout=true)
public static void run(Id locId){
  try {
      SmartyStreetCredentials__c apiCreds = SmartyStreetCredentials__c.getOrgDefaults();
      Location_Address_Book__c loc = [SELECT Street__c, State__c,City__c, Postal_Code__c FROM Location_Address_Book__c WHERE Id =: locId WITH SECURITY_ENFORCED];
system.debug(loc);
// request.setEndpoint('callout:SmartyStreet/street-address?auth-id=2e5ae414-6020-9629-5c79-b8d87b2b2002&auth-token=IDbhjVo7dk3cBV0Z1ZH2&street=16404%20Aventura%20Ave&city=Pflugerville&state=TX&zipcode=78600');
      String path ='street-address?' 
  + 'auth-id=' + apiCreds.AutId__c
  + '&auth-token=' + apiCreds.AuthToken__c
  +'&street=' + EncodingUtil.urlEncode(loc.Street__c,'UTF-8')
  +'&city='+loc.City__c
  + '&state=' + loc.State__c
  + '&zipcode=' + loc.Postal_Code__c;

Http http = new Http();
HttpRequest request = new HttpRequest();
request.setEndpoint( 'callout:SmartyStreet/' + path);
request.setMethod('GET');
HttpResponse response = http.send(request);

System.debug('response:' +response.getBody());

Boolean isSuccess = response.getStatusCode() == 200;
update new Location_Address_Book__c(Id = locId,	Verified__c = isSuccess);
  } catch (Exception exc) {
      ErrorLogHelper.createErrorLog('Call SmartyStreet',exc.getMessage());
      
  } 
}
}




// public with sharing class InvSmartyStreetCaller {
//   @InvocableMethod(label='Call SmartyStreet' description='Makes callout to SmartyStreet API')
// public static void makeCallout(List<ID> locationIds) {
//   run(locationIds[0]);
// }

// @future(callout=true)
// public static void run(Id locId){
//   try {

// Http http = new Http();
// HttpRequest request = new HttpRequest();
// request.setEndpoint('callout:SmartyStreet/street-address?auth-id=2e5ae414-6020-9629-5c79-b8d87b2b2002&auth-token=IDbhjVo7dk3cBV0Z1ZH2&street=16404%20Aventura%20Ave&city=Pflugerville&state=TX&zipcode=78600');
// request.setMethod('GET');
// HttpResponse response = http.send(request);

// System.debug('response:' +response.getBody());

// Boolean isSuccess = response.getStatusCode() == 200;
// update new Location_Address_Book__c(Id = locId,	Verified__c = isSuccess);
//   } catch (Exception exc) {
//       ErrorLogHelper.createErrorLog('Call SmartyStreet',exc.getMessage());
      
//   } 

// }



// }