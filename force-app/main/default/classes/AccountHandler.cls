public class AccountHandler {
    
    public static void insertAccount (Integer numberNewAccounts){
        
        List<Account> addAccounts = new List<Account>();
        
        Integer i = 1;
        while (i <= numberNewAccounts){
            Account acc = new account();
            acc.Name = ' Acme Inc '+ i;
            acc.AccountNumber = 'A000'+i;
            addAccounts.add(acc);
            i++;
        }
        insert addAccounts;
        
        
    }
    public static Account insertNewAccount(String name){
        try{
            Account acc = new Account(Name=name);
            Database.SaveResult srList = Database.insert(acc);
            String accId = (String)srList.getId();
            Account newAccount = [SELECT Name FROM Account WHERE Id=:accId];       
            return newAccount;
            
        }
        catch (DmlException e) {
    		System.debug('A DML exception has occurred: ' +
                e.getMessage());
            return null;
        }
                             
    }
}