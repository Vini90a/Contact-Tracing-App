/**
 * CTPeopleTracingController
 * Classe principal de controle do objeto People_Tracing__c
 * @author ViniAlves
 */
public with sharing class CTPeopleTracingController {
    /**
     * 
     * @return List<People_Tracing__c>
     */
    public static List<People_Tracing__c> getTraces (String recordId){
        return [SELECT Id, Name, Contact_Date__c, Contact_Type__c, Person_1__c, Person_2__c 
                FROM People_Tracing__c
                WHERE Person_1__c = :recordId OR Person_2__c =:recordId
                ORDER BY Contact_Date__c DESC];
}
    /**
     * 
     * @return List<People_Tracing__c>
     */
    public static List<People_Tracing__c> checkDuplicates (List<People_Tracing__c> peopleTraces){
        //Criando Sets para armazenar os ids das pessoas e ser possivel fazer a query
        Set<Id> PersonId = new Set<Id>();
        //duvida?? talvez colocar todos ids em um set só

        //colocando todos Ids dentro do SET para fazer a requisição dos registros
        for (People_Tracing__c traces : peopleTraces) {
            PersonId.add(traces.Person_1__c);
            PersonId.add(traces.Person_2__c);
        }

        List<People_Tracing__c> records = [SELECT Id, Name, Contact_Date__c, Contact_Type__c, Person_1__c, Person_2__c 
                                            FROM People_Tracing__c
                                            WHERE Person_1__c IN :PersonId OR Person_2__c IN:PersonId];

        //Lista dos registros duplicados para retornar
        List<People_Tracing__c> duplicateRecords = new List<People_Tracing__c>();

        //Se existir algum registro, irá executar
        if (records != null && records.size() > 0) {
                    
            Map<Id, Set<Id>> mapExistingRecords = new  Map<Id, Set<Id>>();

            //Loop para popular o Map dos registros
            for (People_Tracing__c traces : records) {
                if (!mapExistingRecords.containsKey(traces.Person_1__c)) {
                    mapExistingRecords.put(traces.Person_1__c, new  Set<Id>());
                }
                //Acessando o Set através da key atual e adicionando o Id de Person_2__c ao set
                mapExistingRecords.get(traces.Person_1__c).add(traces.Person_2__c);

                //construindo o map para person 2 também
                if (!mapExistingRecords.containsKey(traces.Person_2__c)) {
                    mapExistingRecords.put(traces.Person_2__c, new  Set<Id>());
                }
                //Acessando o Set através da key atual e adicionando o Id de Person_1__c ao set
                mapExistingRecords.get(traces.Person_2__c).add(traces.Person_1__c);                            
            }

            //Loop para verificar se algum registro está duplicado
            for (People_Tracing__c traces : peopleTraces) {
                if ((mapExistingRecords.containsKey(traces.Person_1__c) && mapExistingRecords.get(traces.Person_1__c).contains(traces.Person_2__c))
                    ||
                    (mapExistingRecords.containsKey(traces.Person_2__c) && mapExistingRecords.get(traces.Person_2__c).contains(traces.Person_1__c))) {
                    
                        duplicateRecords.add(traces);
                }                
            }            
        }
        return duplicateRecords;
    }
}