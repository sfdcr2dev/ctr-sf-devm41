/**
 * ORTLCreateRisk Controller used to create new risk record
 * The data that will be created will have both the default values ​​and the new ones.
 * Default value will fetch data from database, new value will be saved in database.
 * There is a custom unique number instead of the part that is attached to the limit of standard salesforce.
 */
public with sharing class ORTLCreateRiskCtrl {

	/**
	 * fetchUser Method used to look up the logged in user record.
	 * and return object to component for display name's user
	 */
	@AuraEnabled
    public static user fetchUser(){
       	User u = [select id,Name from User where id =: userInfo.getUserId()];
		System.debug('User=>'+u);
    	return u;
    }

	/**
	 * getFunctionLocationDetail Method used to call another method and return
	 */
    @AuraEnabled
	public static Object getFunctionLocationDetail(Id funcLocationId) {
		return retrieveFunctionalLocationById(funcLocationId);
	}

	/**
	 * retrieveFunctionalLocationById Method used to look up record
	 * that related with Tag number from user choosed
	 * and return object to component to diaplay value on fields
	 */
    @AuraEnabled
	public static Object retrieveFunctionalLocationById(String flId) {

		// return [
		// 	SELECT
		// 		TagNo__r.Name,
		// 		APU__c,
		// 		Discipline__c,
		// 		Unit__c,
		// 		PlantSection__c,
		// 		Name,
		// 		RiskInitiator__c,
		// 		RiskInitiator__r.Name,
		// 		OwnerId,
		// 		Owner.Name
		// 	FROM ORTLRisk__c
		// 	WHERE TagNo__c = :flId
		// 	//LIMIT 1
		// 	//WITH SECURITY_ENFORCED
		// ][0];

		Map<String, String> result = new Map<String, String>{ 'APU__c' => '', 'Discipline__c' => '', 'Location__c' => '', 'PlantSection__c' => '', 'Planning_Plant_Text__c' => '' };

		List<Functional_Location__c> fls = [SELECT Id, MainWorkCenter__r.Name, PlantSection__c, Location__c, Planning_Plant_Text__c, Area__c  FROM Functional_Location__c WHERE Id = :flId];
		if (fls.size() > 0) {
			Functional_Location__c fl = fls[0];
			String mwc = fl.MainWorkCenter__r?.Name;
			if (!String.isBlank(mwc)) {
				if (mwc.left(3).equalsIgnoreCase('ENM')) {
					result.put('APU__c', mwc.substring(3, 4));
					result.put('Discipline__c', '');
				} else {
					String[] parts = mwc.split('-');
					result.put('APU__c', fl.Area__c);
					result.put('Discipline__c', (parts.size() > 0) ? parts[0] : '');
				}
			}
			if (fl.Location__c != null) {
				result.put('Unit__c', fl.Location__c);
			}
			if (fl.Planning_Plant_Text__c != null) {
				result.put('Planning_Plant_Text__c', fl.Planning_Plant_Text__c);
			}
			String plntSec = fl.PlantSection__c;
			List<Master_Map__c> master = [SELECT Id, Name, Description__c FROM Master_Map__c WHERE Type__c = 'Plant Section' AND Name = :plntSec];
			if (master.size() > 0) {
				result.put('PlantSection__c', master[0].Description__c);
			}
		}

		return result;
	}

	/**
	 * queryRiskRecords Method used to Find matching records with predetermined name
	 * predetermined name is unique name of each record and specific name is 'RA-YYYY-000'
	 */
	public static List<ORTLRisk__c> queryRiskRecords(){
		// String criteria = 'RA-' + String.valueOf(Date.today().year()) + '-%';
		String criteria = 'RA-' + String.valueOf(DateTime.now().format('YYYY')) + '-%';
		List<ORTLRisk__c> risksAll = [SELECT Id, Name, CreatedDate
									FROM ORTLRisk__c
									WHERE Name LIKE :criteria
									ORDER BY Name DESC LIMIT 1
									];
		return risksAll;
	}

	/**
	 * getAddNewRisk Method used to Find matching records with predetermined name
	 * specific name is 'RA-YYYY-000'
	 * every new year, number will start counting 1 again
	 * This method is called from createRisk Method
	 */
	@AuraEnabled
	public static String getAddNewRisk( List<ORTLRisk__c> risks ) {

		System.debug(risks);
		ORTLRisk__c newRisk = new ORTLRisk__c();

		/** if has record, The specific name will start counting from the lastest record.
		 *  if not, number will start counting 1 again
		 */
		if(risks.size() > 0){
			//Year of the lastest record.
			Integer lastestRiskYear = risks[0].CreatedDate.year();
			//Current Year
			Integer currentYear = Integer.valueof(DateTime.now().format('YYYY'));//Date.today().year();
			//Specific Name of the lastest record.
			List<String> riskNoPart = String.valueOf(risks[0].Name).split('-');
			//Convert the lastest record value to integer
			Integer lastestRunningNumber = Integer.valueOf(riskNopart[riskNopart.size()-1]);
			//Start counting and make specific name to new record
			String runningNumber = String.valueof(lastestRunningNumber + 1);
			newRisk.Name = 'RA-'+currentYear+'-'+runningNumber.leftPad(3, '0');

			System.debug('if : newRisk.Name ' + newRisk.Name);
		}
		else{
			//Current Year
			Integer currentYear = Integer.valueof(DateTime.now().format('YYYY'));//Date.today().year();
			//number start with 1
			String runningNumber = '1';
			//Start counting and make specific name to new record
			newRisk.Name = 'RA-'+currentYear+'-'+runningNumber.leftPad(3, '0');

			System.debug('else : newRisk.Name ' + newRisk.Name);
		}

		return newRisk.Name;
	}

	/**
	 * createRisk Method used to create new parent and child risk
	 * child risk will recieve some field as same as prarent risk
	 * and OwnerId will changed if user choose another owner
	 * the child risk generated number must be checked to ensure that there is no duplicate with the lastest number.
	 * */
	@AuraEnabled
	public static ORTLRisk__c createRisk( ORTLRisk__c risk, List<String> tagNoList) {

		// String criteria = 'RA-' + String.valueOf(Date.today().year()) + '-%';
		String criteria = 'RA-' + String.valueOf(DateTime.now().format('YYYY')) + '-%';

		List<ORTLRisk__c> risksAll = queryRiskRecords();
		risk.Name = getAddNewRisk(risksAll);
		risk.OwnerId = risk.RiskInitiator__c;
        insert risk;

		List<ORTLRisk__c> risksAll2 = queryRiskRecords();
		List<ORTLRisk__c> risks = new List<ORTLRisk__c>();

		Integer currentYear = Integer.valueof(DateTime.now().format('YYYY'));//Date.today().year();
		Integer count = 1;
		/**
		 * the child risk generated number must be checked to ensure that there is no duplicate with the lastest number.
		 */
		for(String tagNo  : tagNoList) {
			String runNo = getAddNewRisk(risksAll2);
			System.debug('createRisk | runNo > '+runNo);

            ORTLRisk__c r1 = new ORTLRisk__c();
			r1.TagNo__c = tagNo;
			/** if true for fist item in list /next item in list will be else condition and generated number */
			if(count == 1){
				r1.Name = runNo;
			}
			else{
				List<String> riskNoPart = String.valueOf(runNo).split('-');
				Integer lastestRunningNumber = Integer.valueOf(riskNopart[riskNopart.size()-1]);
				String runningNumber = String.valueof(lastestRunningNumber + (count-1));
				r1.Name = 'RA-'+currentYear+'-'+runningNumber.leftPad(3, '0');
			}
			r1.RiskStatus__c = risk.RiskStatus__c;
			r1.RiskInitiator__c = risk.RiskInitiator__c;
			r1.InitiativeDate__c = risk.InitiativeDate__c;
            r1.AssessmentType__c = 'PRA (Potential Risk Assessment)';
            r1.OriginalRisk__c = risk.Id;
			r1.IntRiskCons__c = risk.IntRiskCons__c;
			r1.RiskScenario__c = risk.RiskScenario__c;
			/*
			r1.RiskScenarioDes__c = risk.RiskScenarioDes__c;
			r1.EnRiskMgt__c = risk.EnRiskMgt__c;
			r1.DEM__c = risk.DEM__c;
			r1.ApptootherEQP__c = risk.ApptootherEQP__c;
			r1.Causeoffailure__c = risk.Causeoffailure__c;
			*/
			r1.OwnerId = risk.RiskInitiator__c;
			r1.Threat__c = risk.Threat__c;
			r1.IntConsEffect__c = risk.IntConsEffect__c;
			r1.CheckApplicable__c = risk.ApptootherEQP__c;
			r1.IniOtherConsEff__c = risk.IniOtherConsEff__c;

            risks.add(r1);
			count += 1;
        }
        insert risks;
		System.debug('risks > '+risks);

        return risk;
    }
}