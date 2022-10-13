@isTest
public class FitnessTest {
    
    @isTest
    public static void calculateBMITest(){
        
        //Criando uma instancia da classe em teste
        Fitness treinoTest = new Fitness();
        
        Decimal referencia = 25.1023913330690976350905007266482;             
        System.assert(referencia == treinoTest.calculateBMI(76 , 1.74), 'O valor de BMI não correnponde ao esperado');                
    }
    @isTest
    public static void calculateBMITestNegative(){
        
        //Criando uma instancia da classe em teste
        Fitness treinoTest = new Fitness();
        
        Decimal referencia = 25.1023913330690976350905007266482;             
        System.assert(0 == treinoTest.calculateBMI(-76 , 1.74), 'O valor de BMI não correnponde ao esperado');                
    }
    @isTest
    public static void calculatePaceTest(){
        
        Fitness treinoTest = new Fitness();
        
        Decimal referencia = 9.375;             
        System.assert(referencia == treinoTest.calculatePace(12.5 , 80), 'O valor de PACE não correnponde ao esperado');          
        
    }
    
    @isTest
    public static void calculatePaceTestNegative(){
        
        Fitness treinoTest = new Fitness();
        
                    
        System.assert(0 == treinoTest.calculatePace(-12.5 , 80), 'O valor de PACE não correnponde ao esperado');          
        
    }
    
    
    

}