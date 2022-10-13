public class StringArrayTest {
    
    public static List<String> generateStringArray(Integer numberOfStrings){
        
        List<String> str = new List<String>();
        for (Integer i = 0; i < numberOfStrings; i++){
            str.add('Test '+i);
        }        
    	return str;
    }
}