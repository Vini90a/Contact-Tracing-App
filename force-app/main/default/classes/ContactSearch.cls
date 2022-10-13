public class ContactSearch {
    
    public static List<Contact> searchForContacts (String param1, String param2){
        
        List<Contact> accs = [SELECT Id, Name FROM Contact WHERE Name = :param1 AND MailingPostalCode = :param2];
        return accs;
        
    }

}