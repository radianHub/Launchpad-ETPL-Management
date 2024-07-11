@isTest
private class ETPLHomePageControllerTest {
	@isTest
	private static void getHomePageTileInfo() {
		System.runAs(getAdminUser()) {
			Test.startTest();
			List<LaunchpadCo__ETPL_HomePage__mdt> homePageTilesMetadata = ETPLHomePageController.getHomePageTileInfo();
			Test.stopTest();

			// * ASSERTION
			// Assert that a query no longer returns the document
			Boolean isEmptyHomePageTilesMetadata = homePageTilesMetadata.isEmpty();
			Assert.areEqual(
				false,
				isEmptyHomePageTilesMetadata,
				'Expected the homePageTilesMetadata to be populated but was empty.'
			);
		}
	}

	@testSetup
	private static void setupTestData() {
		createSetupObjectRecords();
	}

	// * Helper Methods
	private static void createSetupObjectRecords() {
		// Create a role for the owner
		UserRole ownerRole = new UserRole(Name = 'Owner Role');
		insert ownerRole;

		User adminUser = createAdminUser(ownerRole);

		PermissionSetAssignment psa = new PermissionSetAssignment(
			AssigneeId = adminUser.Id,
			PermissionSetId = [SELECT Id FROM PermissionSet WHERE Name = 'Launchpad_Admin_Permission_Set' LIMIT 1]
			.Id
		);
		insert psa;
	}

	private static User getAdminUser() {
		return [
			SELECT Id
			FROM User
			WHERE Profile.Name LIKE 'System Administrator' AND Email = 'admin@example.com'
			LIMIT 1
		];
	}

	private static User createAdminUser(UserRole ownerRole) {
		User adminUser = (User) new SObjectBuilder(User.SObjectType)
			.put(User.FirstName, 'Admin')
			.put(User.LastName, 'User')
			.put(User.Email, 'admin@example.com')
			.put(User.Username, 'Admin' + Math.random() * 100 + '@lp.com')
			.put(User.Alias, 'admin')
			.put(User.CommunityNickname, 'admin')
			.put(User.TimeZoneSidKey, 'America/Los_Angeles')
			.put(User.LocaleSidKey, 'en_US')
			.put(User.EmailEncodingKey, 'UTF-8')
			.put(User.ProfileId, [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id)
			.put(User.LanguageLocaleKey, 'en_US')
			.put(User.IsActive, true)
			.put(User.UserRoleId, ownerRole.Id)
			.create()
			.getRecord();

		return adminUser;
	}
}
