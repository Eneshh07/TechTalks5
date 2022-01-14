
@isTest
private class TestEventSpeakerHandler {
   
    @TestSetup
    private static void setUpData(){

        Event_Organizer__c eo = new Event_Organizer__c(Name='Honest Organiztion ABC',
                                                      Email__c='thehonestorgn@gmail.com',
                                                      Phone__c='12345566');
                
                                insert eo;


        EventPro__c e = new EventPro__c(Name__c='Christmas Day',Organizer__c=eo.id,Max_Seats__c=12,
                                     Start_DateTime__c=Datetime.now().addDays(3),End_DateTime__c=Datetime.now().addDays(15),Live__c=true);
                                    insert e;
                                    
                    
         Speaker__c s = new Speaker__c(Name='Jane Doe',Email__c='janedoe@gmail.com',Phone__c='62352653453');
         
                                    insert s;

         Event_Speaker__c es = new Event_Speaker__c(EventPro__c=e.id,Speaker__c=s.id);
         
         insert es;
                                                     
        
    }

   @isTest 
   private static void postiveTest(){

    Event_Speaker__c es1 = [Select EventPro__c,Speaker__c from Event_Speaker__c limit 1];
    Test.startTest();
    Event_Speaker__c es2 = new Event_Speaker__c(EventPro__c=es1.EventPro__c,Speaker__c=es1.Speaker__c);
    try{
        insert es2;
    } catch(Exception e){

    }
    Test.stopTest();
    integer esCount = [select count() from Event_Speaker__c];
    system.assertEquals(1,esCount);
   }

   @isTest
   private static void negativeTest(){
       Event_Speaker__c es = [select id from Event_Speaker__c];
       delete es;
       EventPro__c e = [select id from EventPro__c limit 1];
       Speaker__c s = [select id from Speaker__c limit 1];
       Test.startTest();
       insert new Event_Speaker__c(EventPro__c=e.id,Speaker__c=s.id);
       Test.stopTest();
       integer esCount=[select count() from Event_Speaker__c];
       system.assertEquals(1,esCount);
   }

}
