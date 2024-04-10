@isTest
public class THOR_ReplicatedSAP_WorkClearanceTest {
	// @Testsetup
    // public static void setupData()
    // {
	// 	Work_Clearance__c wc = new Work_Clearance__c();
	// 	wc.Sign_off_Flag_Formula__c = true;
	// 	wc.Extend_Time_Flag_Formula__c = true;
	// 	wc.Extend_Date__c = System.today();
	// 	wc.Extend_Time__c = System.now();
	// 	wc.Authorized_Date_UI__c = System.today();
	// 	wc.Authorized_Time_UI__c = System.now();
	// 	wc.Check_Date_UI__c = System.today();
	// 	wc.Check_Time_UI__c = System.now();
		
	// 	insert wc;
	// }
	
	
	
	
	@IsTest
	static void testWebService() {
		Test.startTest();
		THOR_ReplicatedSAP_WorkClearance.dto_response dto = new THOR_ReplicatedSAP_WorkClearance.dto_response();
		//List<String> recordIds = dto.recordIds;
		//Map<Integer, String> errors = dto.errors;

		String uuidTxt = Uuid.randomUUID();
		RestRequest req = new RestRequest();
		req.httpMethod = 'POST';
		req.requestUri = '/services/apexrest/api/replicated/sap/workclearance';
		req.requestBody = Blob.valueof(
			JSON.serialize(
				new Map<String, OBject>{
					'gateway_id' => uuidTxt,
					'body' => '{\"WCLIST\":[{\"FUNCLOC\":\"01-QRA-001-ANL\",\"WCNUM\":\"900441287\",\"WCFORM\":\"\",\"MAINWC\":\"\",\"NOTFNUM\":\"\",\"ORDERNUM\":\"\",\"NOTIFDESC\":\"PH OF SOUR WATER V-101\",\"PPLANT\":\"1200\",\"SYSSTATUS\":\"CRTE\",\"USERSTATUS\":\"\",\"BSCSTART\":\"\",\"AUTHDATE\":\"2020-01-01\",\"EXTENDNO\":\"\",\"PRIORITY\":\"\",\"REQUESTER\":\"\",\"AREA\":\"TOC1\",\"UNIT\":\"\",\"PROBLEM\":\"\",\"WORK\":\"\",\"WBS\":\"\",\"TOPSUP\":\"1777\",\"TOPTEL\":\"\",\"APPLICANT\":\"A-550002\",\"APPTEL\":\"\",\"BEARER1\":\"\",\"BEARER2\":\"\",\"BEARER3\":\"\",\"BEARER4\":\"\",\"WRONG1\":\"TEST1\",\"WRONG2\":\"\",\"WRONG3\":\"\",\"WRONG4\":\"\",\"WRONG5\":\"\",\"WRONG6\":\"\",\"CAUSE1\":\"TEST1\",\"CAUSE2\":\"\",\"CAUSE3\":\"\",\"CAUSE4\":\"\",\"CAUSE5\":\"\",\"CAUSE6\":\"\",\"PREVENT1\":\"TEST1\",\"PREVENT2\":\"\",\"PREVENT3\":\"\",\"PREVENT4\":\"\",\"PREVENT5\":\"\",\"PREVENT6\":\"\",\"AUTH_SIGN\":\"\",\"AUTH_INDCT\":\"\",\"PERNR_AUTH\":\"\",\"AUTH_TIME\":\"02:17:01\",\"EXTENDFLAG\":\"\",\"EXT_TIM_TO\":\"02:17:01\",\"PERNR_EXT\":\"\",\"PERNR_EXTAUTH\":\"\",\"SIGNFLAG\":\"\",\"PERNR_BEARER\":\"\",\"PERNR_SIGNOFF\":\"\",\"PERNR_SIGNOFF_INDC\":\"\",\"PERMIT1\":\"\",\"PERMIT2\":\"\",\"PERMIT3\":\"\",\"PERNR_EXTAUTH_INDC\":\"\",\"REDPRESS\":\"\",\"BLKGLQU\":\"\",\"BLKVALV\":\"\",\"BLKSPBL\":\"\",\"VNTILAT\":\"\",\"STPMACH\":\"\",\"SPPRTCT\":\"\",\"SPPRTCT1\":\"\",\"SPPRTCT2\":\"\",\"SPPRTCT3\":\"\",\"TAGOUT\":\"\",\"ISOELCT\":\"\",\"ISOBRAK\":\"\",\"LCKRCU\":\"\",\"SFTPER\":\"\",\"OPSTBY\":\"\",\"FWSTBY\":\"\",\"ZZFLM_GAS\":\"\",\"ZZFLG_AMT\":\"\",\"ZZOXYGEN\":\"\",\"ZZOXYGEN_AMT\":\"\",\"ZZTOX_GAS\":\"\",\"ZZTOX_AMT\":\"\",\"ZZTOX_PPM\":\"\",\"ZZPERNR_GAS\":\"\",\"ZZCHK_DAT\":\"2020-01-01\",\"ZZCHK_TIM\":\"02:17:01\",\"EXT_DATE\":\"2020-01-01\",\"EXT_TIM\":\"02:17:01\",\"STXT\":\"test 01 07.04.2022\"}]}'
				}
			)
		);
		RestContext.request = req;

		RestResponse res = new RestResponse();
		res.responseBody = Blob.valueOf(JSON.serialize(new Map<String, String>{ 'jobUid' => uuidTxt }));
		RestContext.response = res;

		THOR_ReplicatedSAPWebServices.httpPostWebservice();
		Test.stopTest();
	}
	@IsTest
	static void testWebServiceCatch() {
		Test.startTest();
		THOR_ReplicatedSAP_WorkClearance.dto_response dto = new THOR_ReplicatedSAP_WorkClearance.dto_response();
		//List<String> recordIds = dto.recordIds;
		//Map<Integer, String> errors = dto.errors;

		String uuidTxt = Uuid.randomUUID();
		RestRequest req = new RestRequest();
		req.httpMethod = 'POST';
		req.requestUri = '/services/apexrest/api/replicated/sap/workclearance';
		req.requestBody = Blob.valueof(
			JSON.serialize(
				new Map<String, OBject>{
					'gateway_id' => uuidTxt,
					'body' => '{\"WCLIST\":[{\"FUNCLOC\":\"01-QRA-001-ANL\",\"WCNUM\":\"900441287\",\"WCFORM\":\"\",\"MAINWC\":\"\",\"NOTFNUM\":\"\",\"ORDERNUM\":\"\",\"NOTIFDESC\":\"PH OF SOUR WATER V-101\",\"PPLANT\":\"1200\",\"SYSSTATUS\":\"CRTE\",\"USERSTATUS\":\"\",\"BSCSTART\":\"\",\"AUTHDATE\":\"20200101\",\"EXTENDNO\":\"\",\"PRIORITY\":\"\",\"REQUESTER\":\"\",\"AREA\":\"TOC1\",\"UNIT\":\"\",\"PROBLEM\":\"\",\"WORK\":\"\",\"WBS\":\"\",\"TOPSUP\":\"1777\",\"TOPTEL\":\"\",\"APPLICANT\":\"A-550002\",\"APPTEL\":\"\",\"BEARER1\":\"\",\"BEARER2\":\"\",\"BEARER3\":\"\",\"BEARER4\":\"\",\"WRONG1\":\"TEST1\",\"WRONG2\":\"\",\"WRONG3\":\"\",\"WRONG4\":\"\",\"WRONG5\":\"\",\"WRONG6\":\"\",\"CAUSE1\":\"TEST1\",\"CAUSE2\":\"\",\"CAUSE3\":\"\",\"CAUSE4\":\"\",\"CAUSE5\":\"\",\"CAUSE6\":\"\",\"PREVENT1\":\"TEST1\",\"PREVENT2\":\"\",\"PREVENT3\":\"\",\"PREVENT4\":\"\",\"PREVENT5\":\"\",\"PREVENT6\":\"\",\"AUTH_SIGN\":\"\",\"AUTH_INDCT\":\"\",\"PERNR_AUTH\":\"\",\"AUTH_TIME\":\"021701\",\"EXTENDFLAG\":\"\",\"EXT_TIM_TO\":\"02:17:01\",\"PERNR_EXT\":\"\",\"PERNR_EXTAUTH\":\"\",\"SIGNFLAG\":\"\",\"PERNR_BEARER\":\"\",\"PERNR_SIGNOFF\":\"\",\"PERNR_SIGNOFF_INDC\":\"\",\"PERMIT1\":\"\",\"PERMIT2\":\"\",\"PERMIT3\":\"\",\"PERNR_EXTAUTH_INDC\":\"\",\"REDPRESS\":\"\",\"BLKGLQU\":\"\",\"BLKVALV\":\"\",\"BLKSPBL\":\"\",\"VNTILAT\":\"\",\"STPMACH\":\"\",\"SPPRTCT\":\"\",\"SPPRTCT1\":\"\",\"SPPRTCT2\":\"\",\"SPPRTCT3\":\"\",\"TAGOUT\":\"\",\"ISOELCT\":\"\",\"ISOBRAK\":\"\",\"LCKRCU\":\"\",\"SFTPER\":\"\",\"OPSTBY\":\"\",\"FWSTBY\":\"\",\"ZZFLM_GAS\":\"\",\"ZZFLG_AMT\":\"\",\"ZZOXYGEN\":\"\",\"ZZOXYGEN_AMT\":\"\",\"ZZTOX_GAS\":\"\",\"ZZTOX_AMT\":\"\",\"ZZTOX_PPM\":\"\",\"ZZPERNR_GAS\":\"\",\"ZZCHK_DAT\":\"20200101\",\"ZZCHK_TIM\":\"021701\",\"EXT_DATE\":\"20200101\",\"EXT_TIM\":\"021701\",\"STXT\":\"test 01 07.04.2022\"}]}'
				}
			)
		);
		RestContext.request = req;

		RestResponse res = new RestResponse();
		res.responseBody = Blob.valueOf(JSON.serialize(new Map<String, String>{ 'jobUid' => uuidTxt }));
		RestContext.response = res;

		THOR_ReplicatedSAPWebServices.httpPostWebservice();
		Test.stopTest();
	}

	@IsTest
	static void testWebServiceBatch() {
		Test.startTest();
		THOR_ReplicatedSAP_WorkClearance.dto_response dto = new THOR_ReplicatedSAP_WorkClearance.dto_response();
		//List<String> recordIds = dto.recordIds;
		//Map<Integer, String> errors = dto.errors;

		String uuidTxt = Uuid.randomUUID();
		RestRequest req = new RestRequest();
		req.httpMethod = 'POST';
		req.requestUri = '/services/apexrest/api/replicated/sap/workclearance';
		req.requestBody = Blob.valueof(
			JSON.serialize(
				new Map<String, OBject>{
					'gateway_id' => uuidTxt,
					'body' => '{\"WCLIST\":[{\"FUNCLOC\":\"01-QRA-001-ANL\",\"WCNUM\":\"900441287\",\"WCFORM\":\"\",\"MAINWC\":\"\",\"NOTFNUM\":\"\",\"ORDERNUM\":\"\",\"NOTIFDESC\":\"PH OF SOUR WATER V-101\",\"PPLANT\":\"1200\",\"SYSSTATUS\":\"CRTE\",\"USERSTATUS\":\"\",\"BSCSTART\":\"\",\"AUTHDATE\":\"2020-01-01\",\"EXTENDNO\":\"\",\"PRIORITY\":\"\",\"REQUESTER\":\"\",\"AREA\":\"TOC1\",\"UNIT\":\"\",\"PROBLEM\":\"\",\"WORK\":\"\",\"WBS\":\"\",\"TOPSUP\":\"1777\",\"TOPTEL\":\"\",\"APPLICANT\":\"A-550002\",\"APPTEL\":\"\",\"BEARER1\":\"\",\"BEARER2\":\"\",\"BEARER3\":\"\",\"BEARER4\":\"\",\"WRONG1\":\"TEST1\",\"WRONG2\":\"\",\"WRONG3\":\"\",\"WRONG4\":\"\",\"WRONG5\":\"\",\"WRONG6\":\"\",\"CAUSE1\":\"TEST1\",\"CAUSE2\":\"\",\"CAUSE3\":\"\",\"CAUSE4\":\"\",\"CAUSE5\":\"\",\"CAUSE6\":\"\",\"PREVENT1\":\"TEST1\",\"PREVENT2\":\"\",\"PREVENT3\":\"\",\"PREVENT4\":\"\",\"PREVENT5\":\"\",\"PREVENT6\":\"\",\"AUTH_SIGN\":\"\",\"AUTH_INDCT\":\"\",\"PERNR_AUTH\":\"\",\"AUTH_TIME\":\"02:17:01\",\"EXTENDFLAG\":\"\",\"EXT_TIM_TO\":\"\",\"PERNR_EXT\":\"\",\"PERNR_EXTAUTH\":\"\",\"SIGNFLAG\":\"\",\"PERNR_BEARER\":\"\",\"PERNR_SIGNOFF\":\"\",\"PERNR_SIGNOFF_INDC\":\"\",\"PERMIT1\":\"\",\"PERMIT2\":\"\",\"PERMIT3\":\"\",\"PERNR_EXTAUTH_INDC\":\"\",\"REDPRESS\":\"\",\"BLKGLQU\":\"\",\"BLKVALV\":\"\",\"BLKSPBL\":\"\",\"VNTILAT\":\"\",\"STPMACH\":\"\",\"SPPRTCT\":\"\",\"SPPRTCT1\":\"\",\"SPPRTCT2\":\"\",\"SPPRTCT3\":\"\",\"TAGOUT\":\"\",\"ISOELCT\":\"\",\"ISOBRAK\":\"\",\"LCKRCU\":\"\",\"SFTPER\":\"\",\"OPSTBY\":\"\",\"FWSTBY\":\"\",\"ZZFLM_GAS\":\"\",\"ZZFLG_AMT\":\"\",\"ZZOXYGEN\":\"\",\"ZZOXYGEN_AMT\":\"\",\"ZZTOX_GAS\":\"\",\"ZZTOX_AMT\":\"\",\"ZZTOX_PPM\":\"\",\"ZZPERNR_GAS\":\"\",\"ZZCHK_DAT\":\"\",\"ZZCHK_TIM\":\"\",\"EXT_DATE\":\"\",\"EXT_TIM\":\"\",\"STXT\":\"test 01 07.04.2022\"},{\"FUNCLOC\":\"01-QRA-001-ANL\",\"WCNUM\":\"900441288\",\"WCFORM\":\"\",\"MAINWC\":\"\",\"NOTFNUM\":\"\",\"ORDERNUM\":\"\",\"NOTIFDESC\":\"PH OF SOUR WATER V-101\",\"PPLANT\":\"1200\",\"SYSSTATUS\":\"CRTE\",\"USERSTATUS\":\"\",\"BSCSTART\":\"\",\"AUTHDATE\":\"\",\"EXTENDNO\":\"\",\"PRIORITY\":\"\",\"REQUESTER\":\"\",\"AREA\":\"TOC1\",\"UNIT\":\"\",\"PROBLEM\":\"\",\"WORK\":\"\",\"WBS\":\"\",\"TOPSUP\":\"1777\",\"TOPTEL\":\"\",\"APPLICANT\":\"A-550002\",\"APPTEL\":\"\",\"BEARER1\":\"\",\"BEARER2\":\"\",\"BEARER3\":\"\",\"BEARER4\":\"\",\"WRONG1\":\"TEST1\",\"WRONG2\":\"\",\"WRONG3\":\"\",\"WRONG4\":\"\",\"WRONG5\":\"\",\"WRONG6\":\"\",\"CAUSE1\":\"TEST1\",\"CAUSE2\":\"\",\"CAUSE3\":\"\",\"CAUSE4\":\"\",\"CAUSE5\":\"\",\"CAUSE6\":\"\",\"PREVENT1\":\"TEST1\",\"PREVENT2\":\"\",\"PREVENT3\":\"\",\"PREVENT4\":\"\",\"PREVENT5\":\"\",\"PREVENT6\":\"\",\"AUTH_SIGN\":\"\",\"AUTH_INDCT\":\"\",\"PERNR_AUTH\":\"\",\"AUTH_TIME\":\"\",\"EXTENDFLAG\":\"\",\"EXT_TIM_TO\":\"\",\"PERNR_EXT\":\"\",\"PERNR_EXTAUTH\":\"\",\"SIGNFLAG\":\"\",\"PERNR_BEARER\":\"\",\"PERNR_SIGNOFF\":\"\",\"PERNR_SIGNOFF_INDC\":\"\",\"PERMIT1\":\"\",\"PERMIT2\":\"\",\"PERMIT3\":\"\",\"PERNR_EXTAUTH_INDC\":\"\",\"REDPRESS\":\"\",\"BLKGLQU\":\"\",\"BLKVALV\":\"\",\"BLKSPBL\":\"\",\"VNTILAT\":\"\",\"STPMACH\":\"\",\"SPPRTCT\":\"\",\"SPPRTCT1\":\"\",\"SPPRTCT2\":\"\",\"SPPRTCT3\":\"\",\"TAGOUT\":\"\",\"ISOELCT\":\"\",\"ISOBRAK\":\"\",\"LCKRCU\":\"\",\"SFTPER\":\"\",\"OPSTBY\":\"\",\"FWSTBY\":\"\",\"ZZFLM_GAS\":\"\",\"ZZFLG_AMT\":\"\",\"ZZOXYGEN\":\"\",\"ZZOXYGEN_AMT\":\"\",\"ZZTOX_GAS\":\"\",\"ZZTOX_AMT\":\"\",\"ZZTOX_PPM\":\"\",\"ZZPERNR_GAS\":\"\",\"ZZCHK_DAT\":\"\",\"ZZCHK_TIM\":\"\",\"EXT_DATE\":\"\",\"EXT_TIM\":\"\",\"STXT\":\"test 01 07.04.2022\"},{\"FUNCLOC\":\"01-QRA-001-ANL\",\"WCNUM\":\"900441289\",\"WCFORM\":\"\",\"MAINWC\":\"\",\"NOTFNUM\":\"\",\"ORDERNUM\":\"\",\"NOTIFDESC\":\"PH OF SOUR WATER V-101\",\"PPLANT\":\"1200\",\"SYSSTATUS\":\"CRTE\",\"USERSTATUS\":\"\",\"BSCSTART\":\"\",\"AUTHDATE\":\"\",\"EXTENDNO\":\"\",\"PRIORITY\":\"\",\"REQUESTER\":\"\",\"AREA\":\"TOC1\",\"UNIT\":\"\",\"PROBLEM\":\"\",\"WORK\":\"\",\"WBS\":\"\",\"TOPSUP\":\"1777\",\"TOPTEL\":\"\",\"APPLICANT\":\"A-550002\",\"APPTEL\":\"\",\"BEARER1\":\"\",\"BEARER2\":\"\",\"BEARER3\":\"\",\"BEARER4\":\"\",\"WRONG1\":\"TEST1\",\"WRONG2\":\"\",\"WRONG3\":\"\",\"WRONG4\":\"\",\"WRONG5\":\"\",\"WRONG6\":\"\",\"CAUSE1\":\"TEST1\",\"CAUSE2\":\"\",\"CAUSE3\":\"\",\"CAUSE4\":\"\",\"CAUSE5\":\"\",\"CAUSE6\":\"\",\"PREVENT1\":\"TEST1\",\"PREVENT2\":\"\",\"PREVENT3\":\"\",\"PREVENT4\":\"\",\"PREVENT5\":\"\",\"PREVENT6\":\"\",\"AUTH_SIGN\":\"\",\"AUTH_INDCT\":\"\",\"PERNR_AUTH\":\"\",\"AUTH_TIME\":\"\",\"EXTENDFLAG\":\"\",\"EXT_TIM_TO\":\"\",\"PERNR_EXT\":\"\",\"PERNR_EXTAUTH\":\"\",\"SIGNFLAG\":\"\",\"PERNR_BEARER\":\"\",\"PERNR_SIGNOFF\":\"\",\"PERNR_SIGNOFF_INDC\":\"\",\"PERMIT1\":\"\",\"PERMIT2\":\"\",\"PERMIT3\":\"\",\"PERNR_EXTAUTH_INDC\":\"\",\"REDPRESS\":\"\",\"BLKGLQU\":\"\",\"BLKVALV\":\"\",\"BLKSPBL\":\"\",\"VNTILAT\":\"\",\"STPMACH\":\"\",\"SPPRTCT\":\"\",\"SPPRTCT1\":\"\",\"SPPRTCT2\":\"\",\"SPPRTCT3\":\"\",\"TAGOUT\":\"\",\"ISOELCT\":\"\",\"ISOBRAK\":\"\",\"LCKRCU\":\"\",\"SFTPER\":\"\",\"OPSTBY\":\"\",\"FWSTBY\":\"\",\"ZZFLM_GAS\":\"\",\"ZZFLG_AMT\":\"\",\"ZZOXYGEN\":\"\",\"ZZOXYGEN_AMT\":\"\",\"ZZTOX_GAS\":\"\",\"ZZTOX_AMT\":\"\",\"ZZTOX_PPM\":\"\",\"ZZPERNR_GAS\":\"\",\"ZZCHK_DAT\":\"\",\"ZZCHK_TIM\":\"\",\"EXT_DATE\":\"\",\"EXT_TIM\":\"\",\"STXT\":\"test 01 07.04.2022\"},{\"FUNCLOC\":\"01-QRA-001-ANL\",\"WCNUM\":\"900441290\",\"WCFORM\":\"\",\"MAINWC\":\"\",\"NOTFNUM\":\"\",\"ORDERNUM\":\"\",\"NOTIFDESC\":\"PH OF SOUR WATER V-101\",\"PPLANT\":\"1200\",\"SYSSTATUS\":\"CRTE\",\"USERSTATUS\":\"\",\"BSCSTART\":\"\",\"AUTHDATE\":\"\",\"EXTENDNO\":\"\",\"PRIORITY\":\"\",\"REQUESTER\":\"\",\"AREA\":\"TOC1\",\"UNIT\":\"\",\"PROBLEM\":\"\",\"WORK\":\"\",\"WBS\":\"\",\"TOPSUP\":\"1777\",\"TOPTEL\":\"\",\"APPLICANT\":\"A-550002\",\"APPTEL\":\"\",\"BEARER1\":\"\",\"BEARER2\":\"\",\"BEARER3\":\"\",\"BEARER4\":\"\",\"WRONG1\":\"TEST1\",\"WRONG2\":\"\",\"WRONG3\":\"\",\"WRONG4\":\"\",\"WRONG5\":\"\",\"WRONG6\":\"\",\"CAUSE1\":\"TEST1\",\"CAUSE2\":\"\",\"CAUSE3\":\"\",\"CAUSE4\":\"\",\"CAUSE5\":\"\",\"CAUSE6\":\"\",\"PREVENT1\":\"TEST1\",\"PREVENT2\":\"\",\"PREVENT3\":\"\",\"PREVENT4\":\"\",\"PREVENT5\":\"\",\"PREVENT6\":\"\",\"AUTH_SIGN\":\"\",\"AUTH_INDCT\":\"\",\"PERNR_AUTH\":\"\",\"AUTH_TIME\":\"\",\"EXTENDFLAG\":\"\",\"EXT_TIM_TO\":\"\",\"PERNR_EXT\":\"\",\"PERNR_EXTAUTH\":\"\",\"SIGNFLAG\":\"\",\"PERNR_BEARER\":\"\",\"PERNR_SIGNOFF\":\"\",\"PERNR_SIGNOFF_INDC\":\"\",\"PERMIT1\":\"\",\"PERMIT2\":\"\",\"PERMIT3\":\"\",\"PERNR_EXTAUTH_INDC\":\"\",\"REDPRESS\":\"\",\"BLKGLQU\":\"\",\"BLKVALV\":\"\",\"BLKSPBL\":\"\",\"VNTILAT\":\"\",\"STPMACH\":\"\",\"SPPRTCT\":\"\",\"SPPRTCT1\":\"\",\"SPPRTCT2\":\"\",\"SPPRTCT3\":\"\",\"TAGOUT\":\"\",\"ISOELCT\":\"\",\"ISOBRAK\":\"\",\"LCKRCU\":\"\",\"SFTPER\":\"\",\"OPSTBY\":\"\",\"FWSTBY\":\"\",\"ZZFLM_GAS\":\"\",\"ZZFLG_AMT\":\"\",\"ZZOXYGEN\":\"\",\"ZZOXYGEN_AMT\":\"\",\"ZZTOX_GAS\":\"\",\"ZZTOX_AMT\":\"\",\"ZZTOX_PPM\":\"\",\"ZZPERNR_GAS\":\"\",\"ZZCHK_DAT\":\"\",\"ZZCHK_TIM\":\"\",\"EXT_DATE\":\"\",\"EXT_TIM\":\"\",\"STXT\":\"test 01 07.04.2022\"},{\"FUNCLOC\":\"01-QRA-001-ANL\",\"WCNUM\":\"900441291\",\"WCFORM\":\"\",\"MAINWC\":\"\",\"NOTFNUM\":\"\",\"ORDERNUM\":\"\",\"NOTIFDESC\":\"PH OF SOUR WATER V-101\",\"PPLANT\":\"1200\",\"SYSSTATUS\":\"CRTE\",\"USERSTATUS\":\"\",\"BSCSTART\":\"\",\"AUTHDATE\":\"\",\"EXTENDNO\":\"\",\"PRIORITY\":\"\",\"REQUESTER\":\"\",\"AREA\":\"TOC1\",\"UNIT\":\"\",\"PROBLEM\":\"\",\"WORK\":\"\",\"WBS\":\"\",\"TOPSUP\":\"1777\",\"TOPTEL\":\"\",\"APPLICANT\":\"A-550002\",\"APPTEL\":\"\",\"BEARER1\":\"\",\"BEARER2\":\"\",\"BEARER3\":\"\",\"BEARER4\":\"\",\"WRONG1\":\"TEST1\",\"WRONG2\":\"\",\"WRONG3\":\"\",\"WRONG4\":\"\",\"WRONG5\":\"\",\"WRONG6\":\"\",\"CAUSE1\":\"TEST1\",\"CAUSE2\":\"\",\"CAUSE3\":\"\",\"CAUSE4\":\"\",\"CAUSE5\":\"\",\"CAUSE6\":\"\",\"PREVENT1\":\"TEST1\",\"PREVENT2\":\"\",\"PREVENT3\":\"\",\"PREVENT4\":\"\",\"PREVENT5\":\"\",\"PREVENT6\":\"\",\"AUTH_SIGN\":\"\",\"AUTH_INDCT\":\"\",\"PERNR_AUTH\":\"\",\"AUTH_TIME\":\"\",\"EXTENDFLAG\":\"\",\"EXT_TIM_TO\":\"\",\"PERNR_EXT\":\"\",\"PERNR_EXTAUTH\":\"\",\"SIGNFLAG\":\"\",\"PERNR_BEARER\":\"\",\"PERNR_SIGNOFF\":\"\",\"PERNR_SIGNOFF_INDC\":\"\",\"PERMIT1\":\"\",\"PERMIT2\":\"\",\"PERMIT3\":\"\",\"PERNR_EXTAUTH_INDC\":\"\",\"REDPRESS\":\"\",\"BLKGLQU\":\"\",\"BLKVALV\":\"\",\"BLKSPBL\":\"\",\"VNTILAT\":\"\",\"STPMACH\":\"\",\"SPPRTCT\":\"\",\"SPPRTCT1\":\"\",\"SPPRTCT2\":\"\",\"SPPRTCT3\":\"\",\"TAGOUT\":\"\",\"ISOELCT\":\"\",\"ISOBRAK\":\"\",\"LCKRCU\":\"\",\"SFTPER\":\"\",\"OPSTBY\":\"\",\"FWSTBY\":\"\",\"ZZFLM_GAS\":\"\",\"ZZFLG_AMT\":\"\",\"ZZOXYGEN\":\"\",\"ZZOXYGEN_AMT\":\"\",\"ZZTOX_GAS\":\"\",\"ZZTOX_AMT\":\"\",\"ZZTOX_PPM\":\"\",\"ZZPERNR_GAS\":\"\",\"ZZCHK_DAT\":\"\",\"ZZCHK_TIM\":\"\",\"EXT_DATE\":\"\",\"EXT_TIM\":\"\",\"STXT\":\"test 01 07.04.2022\"}]}'
				}
			)
		);
		RestContext.request = req;

		RestResponse res = new RestResponse();
		res.responseBody = Blob.valueOf(JSON.serialize(new Map<String, String>{ 'jobUid' => uuidTxt }));
		RestContext.response = res;

		THOR_ReplicatedSAPWebServices.httpPostWebservice();
		Test.stopTest();
	}
}