public class AccountController {
    
    public List<Account> insertAccounts (List<Account> accountsToInsert){
        insert accountsToInsert;
        return accountsToInsert;
    }
    
    public List<Account> getAllAccounts (){
        List<Account> accounts = [SELECT Name, Phone, Rating, Site FROM Account];
        return accounts;
    }
      
    
    public static void updateAvgCaseResolutionDays(List<Id> accountId){
        //Criando um map para segurar os valores 'Avg_Case_Resolution_Days__c' e os Ids
        Map<Id, Decimal> avgCaseResolution = new Map<Id, Decimal>();        
        Integer totalDays = 0, totalCases = 0;
        
        //Requisitando os valores da database SOQL
        List<Case> caseList = [SELECT AccountId, CreatedDate, ClosedDate FROM Case WHERE IsClosed=true AND AccountId IN: accountId];
        
        //Iterando sobre todos os Ids recebidos de entrada do metodo
        for (Id accId : accountId){
            //iterando sobre cada "Objeto Case" do respectivo Id
            for (Case cs : caseList){
                if (accId == cs.AccountId){
                    // increase number of cases
                	totalCases++;
               		// get duration in days and add it to totalDays
                	totalDays += cs.CreatedDate.date().daysBetween(cs.ClosedDate.date());
                }
            }
            //Caso o Id não tenha nenhum caso, terminará essa iteração
            if(totalCases==0){
                //avgCaseResolution.put(accId, 0);
                continue;
            }            

            //adiciona o Id com o numero medio de casos ao Map
            avgCaseResolution.put(accId, (totalDays/totalCases)*-1);
            //Zerando as variáveis de controle
            totalDays = 0;
            totalCases = 0;
        }
        //Criando uma lista para enviar um SOQL de atualização do Objeto Account
    	List<Account> acc = new List<Account>();
        //Iterando sobre cada Id do Map preenchido anteriormente
        for (Id key : avgCaseResolution.keySet()){            
            acc.add(new Account(Id=key, Avg_Case_Resolution_Days__c = avgCaseResolution.get(key)));
        }
        update acc;   
    }     
    
    
    public void printAllAccounts (){
        List<Account> accounts = getAllAccounts ();
        for (Account acc : accounts){
            System.debug('Name: '+acc.Name+ ', Phone: '+acc.Phone+', Rating: '+acc.Rating+', Website: '+acc.Site);            
        }
    }
    
    public Integer accountSize(){
        List<Account> accounts = getAllAccounts ();
        return accounts.size();
    }

}