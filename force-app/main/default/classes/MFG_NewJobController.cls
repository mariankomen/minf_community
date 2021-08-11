public without sharing class MFG_NewJobController{
	@AuraEnabled
	public static String getBannerOfStore(){
		User portalUser = [SELECT id, AccountId, Account.banner_of_store__c
		                   FROM User
		                   WHERE Id = :UserInfo.getUserId()];
		return portalUser != null && portalUser.Account.banner_of_store__c != null && !String.isEmpty(portalUser.Account.banner_of_store__c) ? portalUser.Account.banner_of_store__c : '';
	}

	@AuraEnabled
	public static Boolean  chechInterviewAvailability(){
		Interview_Availability__c aval = Interview_Availability__c.getInstance();
		Integer maxDaysAmount = (Integer)aval.Max_Number_Of_Days__c;
		Integer daysAmount = (Integer)aval.Number_of_days__c;
		User portalUser = [SELECT id, AccountId
		                   FROM User
		                   WHERE Id = :UserInfo.getUserId()];
		Set<Id> accIds = new Set<id>{portalUser.AccountId};
        string queryT = 'SELECT Id,Start_Date__c , MFG_End_Time__c , MFG_Start_Time__c  FROM Hiring_Manager_Availability__c WHERE Hiring_Managers_Store__c IN:accIds AND Start_Date__c>= TODAY and  Start_Date__c <=  NEXT_N_DAYS:' + (Integer)(maxDaysAmount-1)  +' ';
		List<Hiring_Manager_Availability__c> HRAvailabilityy = (List<Hiring_Manager_Availability__c>)Database.query(queryT);
		Time generalAmountOfTime ;
		Long generalMinimumAmountOfTime = (((Decimal)maxDaysAmount/daysAmount)*aval.Number_of_hours__c).round(System.RoundingMode.DOWN);
		Decimal minutesInHour = generalMinimumAmountOfTime - generalMinimumAmountOfTime.intValue();
		Time hoursAmount =Time.newInstance(generalMinimumAmountOfTime.intValue(), (minutesInHour>0) ? (Integer) (minutesInHour*10) : 0 , 0, 0);
		if (HRAvailabilityy.size() > 0){
			for (Hiring_Manager_Availability__c hra : HRAvailabilityy){
                generalAmountOfTime = GetGeneralTime(generalAmountOfTime,  GetElapsedTime(hra.MFG_Start_Time__c, hra.MFG_End_Time__c));
                if(generalAmountOfTime >= hoursAmount){
                    return true;
                }
			}
		}
		return false;
	}

    private static Time GetElapsedTime(Time startTime, Time endTime)
    {
        if(startTime == null || endTime == null)
            return Time.newInstance(0, 0, 0, 0);
    
        Integer elapsedHours = endTime.hour() - startTime.hour();
        Integer elapsedMinutes = endTime.minute() - startTime.minute();
        Integer elapsedSeconds = endTime.second() - startTime.second();
        Integer elapsedMiliseconds = endTime.millisecond() - startTime.millisecond();
        return Time.newInstance(elapsedHours, elapsedMinutes, elapsedSeconds, elapsedMiliseconds);
    }

    private static Time GetGeneralTime(Time startTime, Time endTime)
    {
        if(startTime == null)
            return endTime;
    
        Integer elapsedHours = endTime.hour() + startTime.hour();
        Integer elapsedMinutes = endTime.minute() + startTime.minute();
        Integer elapsedSeconds = endTime.second() + startTime.second();
        Integer elapsedMiliseconds = endTime.millisecond() + startTime.millisecond();
        return Time.newInstance(elapsedHours, elapsedMinutes, elapsedSeconds, elapsedMiliseconds);
    }

	@AuraEnabled
	public static JobForm initJobForm(){
		List<Schema.RecordTypeInfo> infos = Schema.SObjectType.SFDC_Job__c.RecordTypeInfos;
		Id defaultRecordTypeId;
		String fieldSetName;
		for (Schema.RecordTypeInfo info : infos){
			if (info.DefaultRecordTypeMapping){
				defaultRecordTypeId = info.RecordTypeId;
				fieldSetName = info.getDeveloperName();

			}
		}
		if (defaultRecordTypeId != null){
			return new JobForm(fieldSetName, defaultRecordTypeId);
		} else{
			return null;
		}
	}

	public static List<FieldSetMember> readFieldSet(String fieldSetName, String ObjectName){

		Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe();
		Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(ObjectName);
		Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
		Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
		List<FieldSetMember> fields = new List<FieldSetMember>();
		for (Schema.FieldSetMember field : fieldSetObj.getFields()){
			fields.add(new FieldSetMember(field.getDbRequired(), field.getRequired(), field.getFieldPath()));
		}
		return fields;
	}

	public class JobForm{
		@AuraEnabled
		public List<FieldSetMember> fields;
		@AuraEnabled
		public Id defaultRecordTypeId;
		@AuraEnabled
		public String fieldSetName;
		public JobForm(String fieldSetName, Id defaultRecordTypeId){
			this.defaultRecordTypeId = defaultRecordTypeId;
			this.fieldSetName = fieldSetName;
			this.fields = readFieldSet(fieldSetName, 'SFDC_Job__c');
		}
	}

	public class FieldSetMember{
		@AuraEnabled
		public String fieldPath;
		@AuraEnabled
		public Boolean required;
		public FieldSetMember(Boolean dbrequired, Boolean fsrequired, String fieldPath){
			this.fieldPath = fieldPath;
			if (dbrequired){
				this.required = true;
			} else{
				if (fsrequired){
					this.required = true;
				} else{
					this.required = false;
				}
			}
		}
	}

	@AuraEnabled
	public static string getStaticUrl(){
		return CustomSettingsDataForChecking.getCustomSett();
	}
	@AuraEnabled
	public static void setStaticUrl(String url){
		CustomSettingsDataForChecking.setCustomSett(url);
	}
}