@isTest
private class TestSchPurgeEvents {

    @isTest
    static void tester(){
 
        Event_Organizer__c organizer = new Event_Organizer__c(Name='Honest Organiztion ABC',
        Email__c='thehonestorgn@gmail.com',
        Phone__c='12345566');
        insert organizer;

        List<EventPro__c> events = new List<EventPro__c>();
        for (Integer i = 0; i < 200; i++) {
            events.add(new EventPro__c (Organizer__c = organizer.id,
            Name__c='Christmas Day' +String.valueOf(i),
            Start_DateTime__c= Datetime.now().addMonths(-3),
            End_DateTime__c=Datetime.now().addMonths(-3).addDays(1),
            Max_Seats__c = 10,
            Live__c=false
            ));
        }
        insert events;

        Test.startTest();
        SchPurgeEvents obj = new SchPurgeEvents();
        obj.execute(null);
        Test.stopTest();


      Integer eventCount = [SELECT COUNT() FROM EventPro__c];
      System.assertEquals(0, eventCount);
    }

   
}
