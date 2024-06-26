public with sharing class ETPLHomePageController {
	@AuraEnabled(cacheable=true)
	public static List<LaunchpadCo__ETPL_HomePage__mdt> getHomePageTileInfo() {
		return [
			SELECT
				Id,
				LaunchpadCo__Active__c,
				LaunchpadCo__Details__c,
				DeveloperName,
				LaunchpadCo__Header__c,
				LaunchpadCo__Image_URL__c,
				Label,
				Language,
				MasterLabel,
				LaunchpadCo__Order__c,
				QualifiedApiName,
				LaunchpadCo__Redirect_URL__c,
				LaunchpadCo__Row__c,
				LaunchpadCo__Open_in_New_Tab__c
			FROM LaunchpadCo__ETPL_HomePage__mdt
			WHERE LaunchpadCo__Active__c = 'Yes'
			WITH USER_MODE
			ORDER BY LaunchpadCo__Row__c ASC, LaunchpadCo__Order__c ASC
		];
	}
}
