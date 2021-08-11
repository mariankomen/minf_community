public without sharing class InterviewsAvailabilityController{
	@AuraEnabled
	public static HRAvailability getCreatedHRAvailability(String hraId){
		try{
			return new HRAvailability([SELECT Id, Name, CreatedDate, Start_Date__c, End_Date__c, Interview_Duration__c, Interviewer_s_Available__c, Candidate_Interviews__c
			                           FROM Hiring_Manager_Availability__c
			                           WHERE Id = :hraId
			                           LIMIT 1]);
		} Catch (Exception e){
			system.debug(e.getMessage());
			throw new AuraHandledException(e.getMessage());
		}
	}

	public class HRAvailability{
		@AuraEnabled
		public Date currentDate;
		@AuraEnabled
		public Hiring_Manager_Availability__c hra;
		public HRAvailability(Hiring_Manager_Availability__c hra){
			this.hra = hra;
			DateTime myDateTime = this.hra.Start_Date__c;
			this.currentDate = myDateTime.date();
		}
	}

	@AuraEnabled
	public static UserDetails getUserAccountId(){
		try{
			User portalUser = [SELECT id, AccountId, TimeZoneSidKey
			                   FROM User
			                   WHERE Id = :UserInfo.getUserId()];
			UserDetails ud = new UserDetails();

			ud.accountId = portalUser.AccountId;
			TimeZone tz = UserInfo.getTimeZone();
			Integer offset = tz.getOffset(system.now());
			ud.offset = offset;
			ud.timeZoneSidKey = portalUser.TimeZoneSidKey;
			return ud;


		} Catch (Exception e){
			return null;
		}
	}

	public class UserDetails{
		@AuraEnabled
		public String accountId;
		@AuraEnabled
		public Integer offset;
		@AuraEnabled
		public String timeZoneSidKey;
		public UserDetails(){
		}
	}

	@AuraEnabled
	public static void deletejob(Id jobId){

		dataBase.DeleteResult result = dataBase.delete(jobId);
	}

	@AuraEnabled
	public static void deleteInterviewAvailability(Id hraId){

		dataBase.DeleteResult result = dataBase.delete(hraId);

		if (result.isSuccess()){

		} else{
			String error = '';
			for (Database.Error err : result.getErrors()){

				System.debug('The following error has occurred.');

				System.debug(err.getStatusCode()+': ' + err.getMessage());
				error = error + err.getMessage()+'. hraId' + hraId;
				System.debug('Account fields that affected this error: ' + err.getFields());

			}
			throw new AuraHandledException(hraId);
		}
	}

    @AuraEnabled
	public static Decimal getMinimumInterviewHours(){
        Interview_Availability__c aval = Interview_Availability__c.getInstance();
        return aval.Number_of_hours__c;
    }

    @AuraEnabled
	public static Integer getMinimumInterviewDays(){
        Interview_Availability__c aval = Interview_Availability__c.getInstance();
        return (integer)aval.Number_of_days__c;
    }

	@AuraEnabled
	public static Integer getMaxAmountOfDays(){
        Interview_Availability__c aval = Interview_Availability__c.getInstance();
        return (integer)aval.Max_Number_Of_Days__c;
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
		Time generalAmountOfTime;
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


    @TestVisible private static Time GetElapsedTime(Time startTime, Time endTime)
    {
        if(startTime == null || endTime == null)
            return Time.newInstance(0, 0, 0, 0);
    
        Integer elapsedHours = endTime.hour() - startTime.hour();
        Integer elapsedMinutes = endTime.minute() - startTime.minute();
        Integer elapsedSeconds = endTime.second() - startTime.second();
        Integer elapsedMiliseconds = endTime.millisecond() - startTime.millisecond();
        return Time.newInstance(elapsedHours, elapsedMinutes, elapsedSeconds, elapsedMiliseconds);
    }

    @TestVisible private static Time GetGeneralTime(Time startTime, Time endTime)
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
	public static Calendar initCalendar(){

		Calendar calendar = new Calendar();
		buildCalendar(calendar);

		return calendar;
	}

    @AuraEnabled
	public static void sentEmail(String createdJobId){

		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		String[] toAddresses = new String[]{'support@mindfieldjobs.com'};
		// String[] toAddresses = new String[]{'testsalesforce840@gmail.com'};
		// support@mindfieldgroup.com
        mail.setToAddresses(toAddresses);
        mail.setSenderDisplayName('Salesforce Support');
		mail.setSubject('New Job Created Without Sufficient Interview Availability');
		mail.setUseSignature(false);
        mail.setPlainTextBody('Job has been created');
		Interview_Availability__c aval = Interview_Availability__c.getInstance();
		Integer daysAmount = (Integer)aval.Number_of_days__c;
        Decimal hour = aval.Number_of_hours__c ;
		List<SFDC_Job__c> job = [select id, name, Location_Store_Name__c , Location_Store_Province_State__c  from SFDC_Job__c where id = :createdJobId];
		String body = 'Please follow up with the appropriate HM for Job ID '+job[0].name+' at '+job[0].Location_Store_Name__c+' to review Mindfield Scheduler best practices and why meeting our availability requirements is key to receiving fast delivery. <br/> Region: '+job[0].Location_Store_Province_State__c+'';
        mail.setHtmlBody(body);
		Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
		if (results[0].success) {
			System.debug('The email was sent successfully.');
			// SFDC_Job__c job = [select id from SFDC_Job__c where id = :createdJobId];
			// job.Insufficient_Availability_Email_Sent_On__c = true;
			// update job;
		} else {
			System.debug('The email failed to send: ' + results[0].errors[0].message);
		}

	}

	@AuraEnabled
	public static String getUserLanguage(){
		User currentUser = [select id, HM_Portal_Language__c from User where id =:UserInfo.getUserId()];
		return currentUser.HM_Portal_Language__c;

	}

	public static void buildmonth(Date startOfMonth, Calendar calendar, integer stack, List<Holiday> holidays){
		User portalUser = [SELECT id, AccountId
		                   FROM User
		                   WHERE Id = :UserInfo.getUserId()];
		List<Hiring_Manager_Availability__c> HRAvailability = new List<Hiring_Manager_Availability__c>([SELECT Id, Name, CreatedDate, Start_Date__c, End_Date__c, Interview_Duration__c, Interviewer_s_Available__c, Candidate_Interviews__c
		                                                                                                FROM Hiring_Manager_Availability__c
		                                                                                                WHERE Hiring_Managers_Store__c = :portalUser.AccountId AND (Start_Date__c = NEXT_N_DAYS:370 OR Start_Date__c = LAST_N_DAYS:1)
		                                                                                                ORDER BY Start_Date__c]);
		Map<Date, List<Hiring_Manager_Availability__c>> DayHRAvailability = new Map<Date, List<Hiring_Manager_Availability__c>>();
		system.debug(HRAvailability.size());
		for (Hiring_Manager_Availability__c hra : HRAvailability){
			if (DayHRAvailability.containsKey(hra.Start_Date__c.date())){
				List<Hiring_Manager_Availability__c> hraList = DayHRAvailability.get(hra.Start_Date__c.date());
				hraList.add(hra);
				DayHRAvailability.put(hra.Start_Date__c.date(), hraList);
			} else{
				DayHRAvailability.put(hra.Start_Date__c.date(), new List<Hiring_Manager_Availability__c>{hra});
			}
		}

		if (stack < 12){
			Date endOfMonth = startOfMonth.addMonths(1).addDays(-1);
			Month m = new Month();
			m.monthName = (userInfo.getLanguage() == 'fr' ? monthNameMapFr.get(startOfMonth.month()) : monthNameMap.get(startOfMonth.month()))+' ' + String.valueOf(startOfMonth.year());
			Date weekStart = startOfMonth.toStartofWeek();


			for (integer w = 0; w <= Date.daysInMonth(startOfMonth.year(), startOfMonth.month()) / 7; w++){

				Week week = new Week();
				for (Integer i = 0; i < 7; i++){

					Day day = new Day();
					day.disabled = (weekStart.month() != startOfMonth.month() ? true : false);
					day.sdate = weekStart;

					if (DayHRAvailability.containsKey(day.sdate)){
						day.HRAvailability = DayHRAvailability.get(day.sdate);
					} else{
						day.HRAvailability = new List<Hiring_Manager_Availability__c>();
					}
					day.dateN = weekStart.day();

					if (day.sdate == System.today()){
						day.isToday = true;
					} else{
						day.isToday = false;
					}

					day.inActive = (startOfMonth.month() == System.today().month() && day.sdate < System.today() ? true : false);


					if (!isWorkingDay(day.sdate, holidays)){
						day.holiday = true;
					} else{
						day.holiday = false;
					}
					week.days.add(day);
					weekStart = weekStart.addDays(1);


					if (endOfMonth == weekStart.addDays(-1)){
						break;
					}

				}

				m.weeks.add(week);


			}

			if (weekStart.month() == endOfMonth.month()){
				Week week = new Week();
				for (Integer i = 0; i < 7; i++){

					Day day = new Day();
					day.disabled = (weekStart.month() != startOfMonth.month() ? true : false);
					day.sdate = weekStart;

					if (DayHRAvailability.containsKey(day.sdate)){
						day.HRAvailability = DayHRAvailability.get(day.sdate);
					} else{
						day.HRAvailability = new List<Hiring_Manager_Availability__c>();
					}
					day.dateN = weekStart.day();

					if (day.sdate == System.today()){
						day.isToday = true;
					} else{
						day.isToday = false;
					}

					day.inActive = (startOfMonth.month() == System.today().month() && day.sdate < System.today() ? true : false);


					if (!isWorkingDay(day.sdate, holidays)){
						day.holiday = true;
					} else{
						day.holiday = false;
					}
					week.days.add(day);
					weekStart = weekStart.addDays(1);


					if (endOfMonth == weekStart.addDays(-1)){
						break;
					}

				}

				m.weeks.add(week);

			}


			calendar.months.add(m);
			stack = stack + 1;
			buildmonth(endOfMonth.addDays(1), calendar, stack, holidays);
		}
	}

	public static void buildCalendar(Calendar calendar){
		List<Holiday> holidays = new List<Holiday>([select id, ActivityDate
		                                            from Holiday]);
		//BusinessHours stdBusinessHours = [select id from Businesshours where isDefault = true];
		Date todayy = System.today();
		Date startOfMonth = todayy.toStartOfMonth();
		buildmonth(startOfMonth, calendar, 0, holidays);
	}

	public class Calendar{
		@AuraEnabled
		public List<Month> months;

		public Calendar(){
			this.months = new List<Month>();
		}
	}

	public class Month{
		@AuraEnabled
		public String monthName;
		@AuraEnabled
		public List<Week> weeks;

		public Month(){
			this.weeks = new List<Week>();
		}
	}

	public class Week{
		@AuraEnabled
		public List<Day> days;

		public Week(){
			this.days = new List<Day>();
		}
	}

	public class Day{
		@AuraEnabled
		public Integer dateN;
		@AuraEnabled
		public Date sdate;
		@AuraEnabled
		public Boolean holiday;
		@AuraEnabled
		public Boolean isToday;
		@AuraEnabled
		public Boolean disabled;
		@AuraEnabled
		public Boolean inActive;
		@AuraEnabled
		public List<sObject> HRAvailability;
	}

	public static Boolean isHoliday(Date checkDate, BusinessHours stdBusinessHours){
		if(stdBusinessHours.id != null){
			Date outDate = (BusinessHours.add(stdBusinessHours.id, checkDate, 1)).date();
			System.debug('>>>>>>>OUTDATE:>>>>>' + outDate);
			if (checkDate == outDate){
				return false;
			} else{
				return true;
			}
		} else {
			return false;
		}

	}

	public static boolean isWorkingDay(Date currentDate, List<Holiday> holidays){

		Date weekStart = currentDate.toStartofWeek();
		for (Holiday hDay : holidays){

			if (currentDate.daysBetween(hDay.ActivityDate) == 0)
				return false;
		}
		if (weekStart.daysBetween(currentDate) == 0 || weekStart.daysBetween(currentDate) == 6)
			return false;
		else
			return true;
	}

	@AuraEnabled
	public static string getStaticUrl(){
		return CustomSettingsDataForChecking.getCustomSett();
	}
	@AuraEnabled
	public static void setStaticUrl(String url){
		CustomSettingsDataForChecking.setCustomSett(url);
	}

	public static Map<Integer, String> monthNameMap = new Map<Integer, String>{1 => 'January', 2 => 'February', 3 => 'March', 4 => 'April', 5 => 'May', 6 => 'June', 7 => 'July', 8 => 'August', 9 => 'September', 10 => 'October', 11 => 'November', 12 => 'December'};
	public static Map<Integer, String> monthNameMapFr = new Map<Integer, String>{1 => 'Janvier ', 2 => 'Février ', 3 => 'Mars', 4 => 'Avril', 5 => 'Mai', 6 => 'Juin', 7 => 'Juillet', 8 => 'Aout', 9 => 'Septembre', 10 => 'Octobre', 11 => 'Novembre', 12 => 'Décembre'};
}