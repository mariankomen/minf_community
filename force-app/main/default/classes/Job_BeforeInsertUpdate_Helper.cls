public class Job_BeforeInsertUpdate_Helper {

    public STATIC Set<Id> processIds = new Set<Id>();
    
    public static Boolean isFirstTime(List<Sobject> objs){
        for(Sobject obj :objs){
            if(processIds.contains((Id)obj.get('Id'))){
                return false;
            }
            processIds.add((Id)obj.get('Id'));
        }
        return true;
    }
    
}