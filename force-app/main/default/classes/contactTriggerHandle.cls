public class contactTriggerHandle {
    public static Boolean firtInsertion = true;
    
    public static void afterInsertHandle (List<Contact> contactRecords){        
        
        if (firtInsertion){
            Map<Id, Integer> accActiveMap = new Map<Id, Integer>();
            for(AggregateResult agr : [SELECT AccountId, COUNT(Id) total FROM Contact WHERE Active__c=true GROUP BY AccountId ]){
                accActiveMap.put(String.valueOf(agr.get('AccountId')), Integer.valueOf(agr.get('total')));
            }
            
            //fazer list para atualizar o campo Active_Contacts__c em todas as contas
        }
               
        
        
        /*//Map para guardar os Ids das contas com o numero de contatos ativos (recem adicionados)      
        Map<Id, Integer> activeContactsMap = new Map<Id, Integer>();
        Integer countActive = 0;
        
        Set<Id> accIds = new Set<Id>();
        for (Contact cont: contactRecords){
            accIds.add(cont.AccountId);
        }
        
        //Map para guardar os valores anteriores das contas
        Map<Id, Integer> existingAccMap = new Map<Id, Integer>();        
        //Populando o Map com os valores
        for (Account acc : [SELECT Id, Active_Contacts__c FROM Account WHERE Id IN:accIds]){
            	existingAccMap.put(acc.Id, (Integer)acc.Active_Contacts__c);        
        }
        
        //Iterando sob os contatos adicionados e populando o Map
        for(Contact contacts : contactRecords){
            //Verificando se já existe o Ids da conta atual no Map
            if (!activeContactsMap.containsKey(contacts.AccountId) ){
                activeContactsMap.put(contacts.AccountId, 0);
            }
            if (contacts.Active__c==true ){
                countActive = activeContactsMap.get(contacts.AccountId) + 1;
                activeContactsMap.put(contacts.AccountId, countActive);
            }
            /*else if (contacts.Active__c==false){
                countActive = activeContactsMap.get(contacts.AccountId) - 1;
                activeContactsMap.put(contacts.AccountId, countActive);
            }
        }

        
        //Criando uma lista para atualização das contas
        List<Account> accToInsert = new List<Account>();
        //Interando sobre cada key do Set montado com os registros inseridos
        for (Id accId : activeContactsMap.keySet()){
            if (existingAccMap.get(accId) != null){
            	accToInsert.add(new Account(Id=accId, Active_Contacts__c=existingAccMap.get(accId)+activeContactsMap.get(accId)));   
            }
            else{
                accToInsert.add(new Account(Id=accId, Active_Contacts__c=activeContactsMap.get(accId)));
            }
        }
        update accToInsert;*/
    }
    
    public static void afterUpdateHandle (List<Contact> contactRecords, Map<Id, Contact> oldRecordsMap){
    	//Criando um Set para armazenar os AccountIds que serão solicitados na chamada SOQL
        Set<Id> accIds = new Set<Id>();
        //Populando o Set com os Ids das contas
        for (Contact cc : contactRecords){
            accIds.add(cc.AccountId);
        }
                
        //Fazendo a requisição das contas com os Ids filtrados e armazenando em um Map
        Map<Id, Integer> accRecordsMap = new Map<Id, Integer>();
        for (Account acc : [SELECT Id, Active_Contacts__c FROM Account WHERE Id IN:accIds]){
            accRecordsMap.put(acc.Id, (Integer)acc.Active_Contacts__c);
        }
        
        //Montando um Map para armazenar os Ids das contas com os valores de Active_Contacts__c
        Map<Id, Integer> activeContactMap = new Map<Id, Integer>();
        
        //Para cada registro atualizado 
        for (Contact cont : contactRecords){
            //Se o campo Active__c foi alterado e estive como true, então executa
            if((cont.Active__c != oldRecordsMap.get(cont.Id).Active__c) && cont.Active__c==true){                
                if (!activeContactMap.containsKey(cont.Id)){
                    activeContactMap.put(cont.Id, accRecordsMap.get(cont.AccountId));
                }                    
                activeContactMap.put(cont.Id, activeContactMap.get(cont.Id)+1);                    
            }
            //Se o campo Active__c foi alterado e estive como false, então executa
            else if((cont.Active__c != oldRecordsMap.get(cont.Id).Active__c) && cont.Active__c==false){
                if (!activeContactMap.containsKey(cont.Id)){
                    activeContactMap.put(cont.Id, accRecordsMap.get(cont.AccountId));
                }                    
                //activeContactMap.put(cont.Id, activeContactMap.get(cont.Id)-1);
            }
        }
        List<Account> accToUpdate = new List<Account>();
        //Montando a lista para enviar o DML
        for (Id accId : activeContactMap.keySet()){
			accToUpdate.add(new Account(Id=accId, Active_Contacts__c=activeContactMap.get(accId)));
        }
        update accToUpdate;           
    }    
}