public class Fitness {
    
    public Decimal calculateBMI (Decimal bodyWeight, Decimal bodyHeight){
        if (bodyWeight <= 0 || bodyHeight <= 0){
            return 0;
        }
        
        return bodyWeight / (bodyHeight*bodyHeight);
    }
    
    //Pace formula (km/m) = distance(KM)/time(minutes)
    //Depois converter Km/h
    public Decimal calculatePace (Decimal distance, Decimal tempo){
        if (distance <= 0 || tempo <= 0){
            return 0;
        }
        return  (distance*60)/ tempo;
    }

}