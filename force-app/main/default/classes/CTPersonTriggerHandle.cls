public with sharing class CTPersonTriggerHandle {
    
    public static void beforeInsertHandle(List<Person__c> newPeopleRecords){                        
        for (Person__c person : newPeopleRecords){
            //Garantindo que ao inserir uma pessoa, o status dela será como 'Green'
            person.Health_Status__c = 'Green';

            //Gerando um token para o registro atual usando o celular como entrada
            person.Token__c = CTPersonController.getToken(person.Mobile__c);

        }
    }

    public static void beforeUpdateHandle(List<Person__c> newPeopleRecords, Map<Id, Person__c> oldPeopleRecords){
        for (Person__c person : newPeopleRecords) {
           if (person.Health_Status__c != oldPeopleRecords.get(person.Id).Health_Status__c) {
                person.Status_Update_Date__c = Date.today();
           }
            
        }
    }
}