public class CTPersonController {
    
    public static String getToken (String mobileNumber){
        
        Blob targetBlob = Blob.valueOf(mobileNumber);
		Blob hash = Crypto.generateDigest('MD5', targetBlob);
        
        //Convertendo para hexadecimal type String
        String tokenNumber = EncodingUtil.convertToHex(hash);
        return tokenNumber;        
    }

    /**
     * Pesquisa todos registro e ordena por resultado mais recente
     * @return List<Person__c>
     */
    public static List<Person__c> getRecentHealthChanges (){

        List<Person__c> recentChanges = [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, 
                                            Token__c FROM Person__c ORDER BY Status_Update_Date__c DESC NULLS LAST LIMIT 100];
        return recentChanges;
    }

    /**
     * Procura Person pelo nome, token ou telefone mobile
     * @return List<Person__c>
     */
    public static List<Person__c> searchPeople (String searchTerm){

        searchTerm = searchTerm + '%';
        List<Person__c> searchList = new List<Person__c>();

        try{
           searchList = [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c FROM Person__c 
                            WHERE Name LIKE :searchTerm OR Mobile__c LIKE :searchTerm 
                                OR Token__c LIKE :searchTerm ORDER BY Status_Update_Date__c DESC NULLS LAST];
        }
        catch(Exception ex){
            System.debug('Nenhuma resultado para o termo pesquisado');
            return null;
        }
        return searchList;
    }   
    
    /**
     * Procura Person pelo Id
     * @return Person__c
     */
    public static Person__c getPersonById (String personId){
        
        List<Person__c> personById = [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c
                                     FROM Person__c WHERE Id =:personId];
        
        //Verifica se a lista não está vazia ou resultados vazios                            
        if (personById != null && personById.size() > 0){
            //Retornar o primeiro resultado
            return personById[0];
        }                             
        return null;        
    }

    public static Map<String, Integer> getHealthStatusCount (){
        Map<String, Integer> peopleStatusMap = new Map<String, Integer>();
        for (AggregateResult result : [SELECT Health_Status__c, COUNT(Id) countId FROM Person__c GROUP BY Health_Status__c] ){
            peopleStatusMap.put(String.valueOf(result.get('Health_Status__c')), Integer.valueof(result.get('countId')));            
        }
        return peopleStatusMap;
    }
}