public with sharing class SalesForceConnect {
    
public static String getCaseFromSF(){
String token = '00D4L000000rqqY!AQ4AQBIp10w7F_XcQLAJqzmxmdXXq2dSAacPTDR8PrJlWq7Wpix6lAYzEa53SNVopeu_G4g4o4BlxcZ1WtnD4VuFDb1yankT';
Http http = new Http();
HttpRequest request = new HttpRequest();
request.setEndpoint('https://d4l000000rqqyuaq-dev-ed.my.salesforce.com/services/apexrest/Cases');

request.setHeader('Authorization','Bearer ' + token);
request.setMethod('GET');
HttpResponse response = http.send(request);

if(response.getStatusCode() == 200) {
    System.debug('Response body ' + response.getBody());
    return response.getBody();

}else{
    return 'Bad Response body: ' +response.getBody();
}
}
}


// OAuth Error
// We can't authorize you because of an OAuth error. For more information, contact your Salesforce administrator.

// OAUTH_APPROVAL_ERROR_GENERIC : An unexpected error has occured during authentication. Please try again.

//   ////////////////////////////////////////



//STEP2 
// public with sharing class SalesForceConnect {
    
//     public static String getCaseFromSF(){

//     Http http = new Http();
//     HttpRequest request = new HttpRequest();
//     request.setEndpoint('callout:OrgBCreds/services/apexrest/Cases');
    
//     request.setHeader('Authorization','Bearer ' + token);
//     request.setMethod('GET');
//     HttpResponse response = http.send(request);
    
//     if(response.getStatusCode() == 200) {
//         System.debug('Response body ' + response.getBody());
//         return response.getBody();
    
//     }else{
//         return 'Bad Response body: ' +response.getBody();
//     }
//     }
//     }


//     SalesForceConnect.getCaseFromSF();