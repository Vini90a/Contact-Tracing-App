/**
 * CTLocationTracingController
 * Classe principal de controle do objeto Location_Tracing__c
 * @author ViniAlves
 */
public with sharing class CTLocationTracingController {

    /**
     * 
     * @return List<Location_Tracing__c>
     */
    public static List<Location_Tracing__c> getVisitors (String locationId){
        return [SELECT Id, Person__c, Location__c, Visit_Date__c, Person__r.Token__c , Person__r.Health_Status__c  
                FROM Location_Tracing__c
                WHERE Location__c=:locationId 
                ORDER BY Visit_Date__c DESC];
    }

    /**
     * 
     * @return List<Location_Tracing__c>
     */
    public static List<Location_Tracing__c> getLocationsByPersonIds (Set<id> personIds){
        return [SELECT Id, Person__c, Location__c
                FROM Location_Tracing__c
                WHERE Person__c IN:personIds AND Visit_Date__c = LAST_N_DAYS:10]; 
    }

    /**
     * 
     * @return List<Location_Tracing__c>
     */
    public static List<Location_Tracing__c> getLocationsByLocationIds (Set<id> locationIds){
        return [SELECT Id, Person__c, Location__c 
                FROM Location_Tracing__c
                WHERE Person__c IN:locationIds AND Visit_Date__c = LAST_N_DAYS:10 AND Person__r.Health_Status__c = 'Green'
                ORDER BY Visit_Date__c DESC ];
    }
    /** 
     * Metodo que retorna uma lista dos registros duplicados
     * @return List<Location_Tracing__c>
     */
    public static List<Location_Tracing__c> checkDuplicates (List<Location_Tracing__c> locationTraces){
        
        Set<Id> locationIds = new Set<Id>();
        Set<Id> personIds = new Set<Id>();

        //Criando um Map para guardar os valores de Location e Person da query 
        Map<Id, Set<Id>> mapExistingRecords = new  Map<Id, Set<Id>>();

        //Adicionando os valores dos Ids de location e Person dentro dos Sets 
        for (Location_Tracing__c traces : locationTraces) {
            locationIds.add(traces.Location__c);
            personIds.add(traces.Person__c);           
        }
        
        //Requisição para o banco de dados para obter os registros
        List<Location_Tracing__c> records = [SELECT Id, Person__c, Location__c 
                                                FROM Location_Tracing__c
                                                WHERE Person__c IN:personIds AND Location__c IN:locationIds];

        //Lista para retornar os contatos duplicados
        List<Location_Tracing__c> duplicateRecords = new List<Location_Tracing__c>();                                         
        
        //Verificar se existe algum registro dentro da lista
        if (records.size() > 0){
            for (Location_Tracing__c traces : records) {
                if (!mapExistingRecords.containsKey(traces.Location__c)){
                    mapExistingRecords.put(traces.Location__c, new Set<Id>());
                }
                //adicionando o registro atual no set usando a key atual
                //Primeiro acessando o valor do SET e depois adicionando o valor novo
                mapExistingRecords.get(traces.Location__c).add(traces.Person__c);
            }
            //Procurar pelos registros duplicados
            for (Location_Tracing__c traces : locationTraces) {
                //Checando se existe o Location__C na key do Map
                if (mapExistingRecords.containsKey(traces.Location__c)) {
                    //Checando se o Id do Person__c contém dentro do Set OBS.: Da pra colocar tudo dentro de um if só
                    if (mapExistingRecords.get(traces.Location__c).contains(traces.Person__c)) {
                        duplicateRecords.add(traces);
                    }
                    
                }
            }
            
        } 
        return duplicateRecords;   
    }

}