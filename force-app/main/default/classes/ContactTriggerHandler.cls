public with sharing class ContactTriggerHandler extends TriggerHandler{
    private static Boolean isTriggerExecuted = false;
    
    public override void afterUpdate() {
        if(isTriggerExecuted) {
            return;
        }
        isTriggerExecuted = true;
        List<Contact> contactsToUpdate = new List<Contact>();
        for (Contact cont : (List<Contact>)Trigger.new) {
            if(cont.DummyJSON_Id__c != null && Integer.valueOf(cont.DummyJSON_Id__c) > 100) {
                Contact con = new Contact(Id = cont.Id);
                DummyJSONCallout.postCreateDummyJSONUser(cont.Id);
                contactsToUpdate.add(con);
            }
        }
        if(!contactsToUpdate.isEmpty()) {
            update contactsToUpdate;
        }
    }

    public override void afterInsert() {
        if(isTriggerExecuted) {
            return;
        }
        isTriggerExecuted = true;
        List<Contact> contactsToUpdate = new List<Contact>();
        for (Contact cont : (List<Contact>)Trigger.new) {
            if(cont.DummyJSON_Id__c == null) {
                Contact con = new Contact(Id = cont.Id);
                con.DummyJSON_Id__c = String.valueOf(Math.round(Math.random() * 100));
                contactsToUpdate.add(con);
            }
            if(cont.DummyJSON_Id__c != null && Integer.valueOf(cont.DummyJSON_Id__c) <= 100) {
                DummyJSONCallout.getDummyJSONUserFromId(cont.DummyJSON_Id__c);
            }
        }
        if(!contactsToUpdate.isEmpty()) {
            update contactsToUpdate;
        }
    }

    public static void resetTriggerState() {
        isTriggerExecuted = false;
    }
}