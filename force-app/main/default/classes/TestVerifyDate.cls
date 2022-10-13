@IsTest
public class TestVerifyDate {
    
    
    @IsTest public static void CheckDatesTest (){
        
        //Condição 1 - Data 2 dentro de 30 da data 1
        Date date1 = Date.today();
        Date date2 = date1.addDays(20);
        Date result = VerifyDate.CheckDates(Date.today(), date2);       
        System.assertEquals(date2, result, 'A data de retorno não corresponde ao esperado');
        
        //Condição 2 - Data 2 maior que 30 da data 1
        date1 = Date.today();
        date2 = date1.addDays(40);
        result = VerifyDate.CheckDates(Date.today(), date2);
        Integer totalDays = Date.daysInMonth(date1.year(), date1.month());
		Date lastDay = Date.newInstance(date1.year(), date1.month(), totalDays);
        System.assertEquals(lastDay, result, 'A data de retorno não corresponde ao esperado 2');
        
        //Condição 3 - Data 1 maior que data 2
        date1 = Date.today();
        date1.addDays(5);
        result = VerifyDate.CheckDates(date1, Date.today());
        totalDays = Date.daysInMonth(date1.year(), date1.month());
		lastDay = Date.newInstance(date1.year(), date1.month(), totalDays);
        System.assertEquals(Date.today(), result, 'A data de retorno não corresponde ao esperado 3');
 
    }       
}