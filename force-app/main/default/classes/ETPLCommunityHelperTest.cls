@isTest
private class ETPLCommunityHelperTest {

	@isTest
	private static void getPicklistValues() {
		System.runAs(getAdminUser()) {
			createNonSetupObjectRecords();
			Schema.DescribeFieldResult contactActiveFieldResult = Schema.sObjectType.Contact.fields.Launchpad__Active__c;

			Test.startTest();
			List<ETPLCommunityHelper.Option> picklistOptions = ETPLCommunityHelper.getPicklistValues(
				contactActiveFieldResult
			);
			Test.stopTest();

			// * ASSERTION
			// Assert that picklist options were returned
			Boolean picklistOptionsReturned = !picklistOptions.isEmpty() ? true : false;
			Assert.areEqual(
				true,
				picklistOptionsReturned,
				'Expected picklist options to be returned but returned an empty list.'
			);
		}
	}
	@isTest
	private static void getPicklistValuesFromObjFieldApiName() {
		System.runAs(getAdminUser()) {
			createNonSetupObjectRecords();

			Test.startTest();
			List<ETPLCommunityHelper.Option> picklistOptions = ETPLCommunityHelper.getPicklistValuesFromObjFieldApiName(
				'Contact',
				'Launchpad__Active__c'
			);
			Test.stopTest();

			// * ASSERTION
			// Assert that field properties were returned
			Boolean picklistOptionsReturned = !picklistOptions.isEmpty() ? true : false;
			Assert.areEqual(
				true,
				picklistOptionsReturned,
				'Expected picklist options to be returned but returned an empty list.'
			);
		}
	}
	@isTest
	private static void getSObjSchema() {
		System.runAs(getAdminUser()) {
			createNonSetupObjectRecords();

			Test.startTest();
			Schema.DescribeSObjectResult sObjSchema = ETPLCommunityHelper.getSObjSchema('Contact');
			Test.stopTest();

			// * ASSERTION
			// Assert that field properties were returned
			Boolean sObjSchemaReturned = sObjSchema != null ? true : false;
			Assert.areEqual(
				true,
				sObjSchemaReturned,
				'Expected DescribeSObjectResult to be returned but returned an empty list.'
			);
		}
	}

	@isTest
	private static void getPicklistValuesFromObjFieldApiName_NoObjectWithName() {
		System.runAs(getAdminUser()) {
			createNonSetupObjectRecords();
			try {
				Test.startTest();
				List<ETPLCommunityHelper.Option> picklistOptions = ETPLCommunityHelper.getPicklistValuesFromObjFieldApiName(
					'Non-Existent Object',
					'Launchpad__Active__c'
				);
				Test.stopTest();
			} catch (Exception e) {
				// ASSERTIONS
				// Verify that CRUD/FLS error is thrown when no access is present
				Boolean exceptionThrown = e.getMessage() != null ? true : false;
				System.assertEquals(true, exceptionThrown, 'The expected exception was not thrown.');
			}
		}
	}
	@isTest
	private static void getFieldsByObjectAndFieldSet() {
		System.runAs(getAdminUser()) {
			createNonSetupObjectRecords();

			Test.startTest();
			List<ETPLCommunityHelper.FieldWrapper> fields = ETPLCommunityHelper.getFieldsByObjectAndFieldSet(
				'LaunchpadCo__Training_Program__c',
				'LaunchpadCo__ETPL_Search'
			);
			Test.stopTest();

			// * ASSERTION
			// Assert that field properties were returned
			Boolean fieldsReturned = !fields.isEmpty() ? true : false;
			Assert.areEqual(true, fieldsReturned, 'Expected fields to be returned but returned an empty list.');
		}
	}

	@testSetup
	private static void setupTestData() {
		createSetupObjectRecords();
	}

	private static void createNonSetupObjectRecords() {
		// Insert an account for contacts to reference
		Account acc = new Account(
			Name = 'TestAccount',
			ShippingStreet = 'Test',
			ShippingCity = 'Test',
			ShippingState = 'Test',
			ShippingCountry = 'Test',
			ShippingPostalCode = '302022',
			RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
				.get('Employer')
				.getRecordTypeId(),
			OwnerId = [SELECT Id FROM User WHERE UserRoleId != NULL LIMIT 1]
			.Id
		);
		insert acc;

		Contact con = new Contact(
			FirstName = 'Test Contact',
			LastName = 'Test Contact Match',
			AccountId = acc.Id,
			Email = 'testmatch@gmail.com',
			RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
				.get('Job_Seeker')
				.getRecordTypeId(),
                LaunchpadCo__Date_of_Last_SSI_SSDI_Benefit__c = Date.today()
		);
		insert con;

		Launchpad__Document__c doc = new Launchpad__Document__c(
			Launchpad__Title__c = 'Test Document',
			Launchpad__Date__c = Date.today(),
			Launchpad__Type__c = 'Resume',
			Launchpad__Available_In_Community__c = 'Yes',
			Launchpad__Contact__c = con.Id
		);
		insert doc;

		// Create an active read only user, representing a user without access
		User adminUser = [SELECT Id, UserRoleId FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];

		System.runAs(adminUser) {
			Account acct = new Account(
				Name = 'Test',
				ShippingCity = 'sdw',
				ShippingState = 'sdds',
				ShippingCountry = 'sdfsd',
				ShippingPostalCode = '12321',
				website = 'www://test.com',
				BillingCity = 'sdw',
				BillingState = 'sdds',
				BillingCountry = 'sdfsd',
				BillingPostalCode = '12321',
				OwnerId = [SELECT Id FROM User WHERE UserRole.Name != NULL LIMIT 1]
				.Id,
				RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
					.get('Employer')
					.getRecordTypeId()
			);
			insert acct;

			Contact con2 = new Contact(
				AccountId = acct.Id,
				firstname = 'test',
				lastname = 'test',
				email = 'test@test.com',
				BirthDate = system.today() - 100,
				OtherStreet = 'test',
				OtherState = 'test',
				OtherPostalCode = '302022',
				OtherCity = 'test',
				MailingStreet = 'test',
				MailingState = 'test',
				MailingPostalCode = '302022',
				MailingCity = 'test',
				Launchpad__Created_via_Community_Self_Registration__c = false,
				Launchpad__Wage_Desired__c = 20,
				RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
					.get('Job_Seeker')
					.getRecordTypeId(),
                LaunchpadCo__Date_of_Last_SSI_SSDI_Benefit__c = Date.today()
			);
			insert con2;

			Id userLicenseId = [SELECT Id FROM UserLicense WHERE name LIKE '%Customer Community%' LIMIT 1].id;
			User tempUser = prepareUser(
				[SELECT Id FROM Profile WHERE UserLicenseId = :userLicenseId LIMIT 1].Id,
				'test12ni',
				'test12ni'
			);
			tempUser.ContactId = con2.Id;
			insert tempUser;
		}
	}

	// * Helper Methods
	private static void createSetupObjectRecords() {
		// Create a role for the owner
		UserRole ownerRole = new UserRole(Name = 'Owner Role');
		insert ownerRole;

		User adminUser = new User();
		adminUser.FirstName = 'Admin ';
		adminUser.LastName = 'User';
		adminUser.Email = 'admin@example.com';
		adminUser.Username = 'Admin' + Math.random() * 100 + '@lp.com';
		adminUser.Alias = 'admin';
		adminUser.CommunityNickname = 'admin';
		adminUser.TimeZoneSidKey = 'America/Los_Angeles';
		adminUser.LocaleSidKey = 'en_US';
		adminUser.EmailEncodingKey = 'UTF-8';
		adminUser.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id;
		adminUser.LanguageLocaleKey = 'en_US';
		adminUser.IsActive = true;
		adminUser.UserRoleId = ownerRole.Id;

		insert adminUser;

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

	private static User prepareUser(String profId, String firstName, String lastName) {
		User tempUser = new User(
			FirstName = firstName,
			LastName = lastName,
			email = firstName + '@' + lastName + '.com',
			Username = firstName + '@' + lastName + '.com',
			EmailEncodingKey = 'ISO-8859-1',
			Alias = 'test@12',
			TimeZoneSidKey = 'America/Los_Angeles',
			LocaleSidKey = 'en_US',
			LanguageLocaleKey = 'en_US',
			ProfileId = profId,
			CommunityNickname = firstName,
			IsActive = true
		);
		return tempUser;
	}
}
