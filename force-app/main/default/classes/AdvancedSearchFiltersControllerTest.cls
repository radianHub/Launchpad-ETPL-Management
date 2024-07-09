@isTest
private class AdvancedSearchFiltersControllerTest {
	@isTest
	private static void getObjFieldMap() {
		System.runAs(getAdminUser()) {
			createNonSetupObjectRecords();
			Test.startTest();
			Map<String, Schema.SObjectField> jobObjFieldMap = AdvancedSearchFiltersController.getObjFieldMap(
				'Launchpad__Job__c'
			);
			Test.stopTest();

			// * ASSERTION
			// Assert that a query no longer returns the document
			Boolean isEmptyJobObjFieldMap = jobObjFieldMap.values().isEmpty();
			Assert.areEqual(
				false,
				isEmptyJobObjFieldMap,
				'Expected the map of fields to return a value but was empty.'
			);
		}
	}
	@isTest
	private static void getFieldSetList() {
		System.runAs(getAdminUser()) {
			createNonSetupObjectRecords();
			Map<String, List<String>> filterOptionsMap = new Map<String, List<String>>();
			filterOptionsMap.put('Launchpad__City__c', new List<String>{ 'Test City' });
			filterOptionsMap.put(
				'Launchpad__Skill_Level__c',
				new List<String>{ 'IN', 'Entry Level', 'Mid Level', 'Experienced' }
			);
			Test.startTest();
			Set<String> filterOptionsMapKeys = AdvancedSearchFiltersController.getFieldSetList(filterOptionsMap);
			Test.stopTest();

			// * ASSERTION
			// Assert that a query no longer returns the document
			Boolean isEmptyFilterOptionsMapKeys = filterOptionsMapKeys.isEmpty();
			Assert.areEqual(false, isEmptyFilterOptionsMapKeys, 'Expected the key set to be populated but was empty.');
		}
	}
	@isTest
	private static void generateWhereClauseFilterStringLikeOperator() {
		System.runAs(getAdminUser()) {
			createNonSetupObjectRecords();
			Schema.DisplayType type = Schema.SObjectType.Launchpad__Job__c.fields.Name.getType();
			List<String> searchValues = new List<String>{ 'LIKE', 'Test Name' };

			Test.startTest();
			String actualWhereClause = AdvancedSearchFiltersController.generateWhereClauseFilter(
				type,
				searchValues,
				'Name'
			);
			Test.stopTest();

			// * ASSERTION
			// Assert that the where clause was or was not formulated correctly
			String expectedWhereClause = 'Name LIKE \'%Test Name%\'';

			Assert.areEqual(
				expectedWhereClause,
				actualWhereClause,
				'Expected the where clause to be Name LIKE \'%Test Name%\' but was ' + actualWhereClause
			);
		}
	}
	@isTest
	private static void generateWhereClauseFilterStringEqualsOperator() {
		System.runAs(getAdminUser()) {
			createNonSetupObjectRecords();
			Schema.DisplayType type = Schema.SObjectType.Launchpad__Job__c.fields.Name.getType();
			List<String> searchValues = new List<String>{ '=', 'Test Name' };

			Test.startTest();
			String actualWhereClause = AdvancedSearchFiltersController.generateWhereClauseFilter(
				type,
				searchValues,
				'Name'
			);
			Test.stopTest();

			// * ASSERTION
			// Assert that the where clause was or was not formulated correctly
			String expectedWhereClause = 'Name = \'Test Name\'';

			Assert.areEqual(
				expectedWhereClause,
				actualWhereClause,
				'Expected the where clause to be Name = \'Test Name\' but was ' + actualWhereClause
			);
		}
	}
	@isTest
	private static void generateWhereClauseFilterCurrencyEqualsOperator() {
		System.runAs(getAdminUser()) {
			createNonSetupObjectRecords();
			Schema.DisplayType type = Schema.SObjectType.Launchpad__Job__c.fields.Launchpad__Hourly_Wage_Maximum__c.getType();
			List<String> searchValues = new List<String>{ '=', '12345' };

			Test.startTest();
			String actualWhereClause = AdvancedSearchFiltersController.generateWhereClauseFilter(
				type,
				searchValues,
				'Launchpad__Hourly_Wage_Maximum__c'
			);
			Test.stopTest();

			// * ASSERTION
			// Assert that the where clause was or was not formulated correctly
			String expectedWhereClause = 'Launchpad__Hourly_Wage_Maximum__c = 12345';

			Assert.areEqual(
				expectedWhereClause,
				actualWhereClause,
				'Expected the where clause to be Launchpad__Hourly_Wage_Maximum__c = 12345 but was ' + actualWhereClause
			);
		}
	}
	@isTest
	private static void generateWhereClauseFilterMultipicklist() {
		System.runAs(getAdminUser()) {
			createNonSetupObjectRecords();
			Schema.DisplayType type = Schema.SObjectType.Launchpad__Job__c.fields.Launchpad__Benefits_Offered__c.getType();
			List<String> searchValues = new List<String>{ 'INCLUDES', 'Health', 'Dental', 'Vision' };

			Test.startTest();
			String actualWhereClause = AdvancedSearchFiltersController.generateWhereClauseFilter(
				type,
				searchValues,
				'Launchpad__Benefits_Offered__c'
			);
			Test.stopTest();

			// * ASSERTION
			// Assert that the where clause was or was not formulated correctly
			String expectedWhereClause = 'Launchpad__Benefits_Offered__c INCLUDES (\'Health\',\'Dental\',\'Vision\')';

			Assert.areEqual(
				expectedWhereClause,
				actualWhereClause,
				'Expected the where clause to be Launchpad__Benefits_Offered__c INCLUDES (\'Health\', \'Dental\', \'Vision\') but was ' +
				actualWhereClause
			);
		}
	}
	@isTest
	private static void generateWhereClauseFilterPicklist() {
		System.runAs(getAdminUser()) {
			createNonSetupObjectRecords();
			Schema.DisplayType type = Schema.SObjectType.Launchpad__Job__c.fields.Launchpad__Hourly_Wage_Option__c.getType();
			List<String> searchValues = new List<String>{ 'IN', '$10+', '$15+', '$25+' };

			Test.startTest();
			String actualWhereClause = AdvancedSearchFiltersController.generateWhereClauseFilter(
				type,
				searchValues,
				'Launchpad__Hourly_Wage_Option__c'
			);
			Test.stopTest();

			// * ASSERTION
			// Assert that the where clause was or was not formulated correctly
			String expectedWhereClause = 'Launchpad__Hourly_Wage_Option__c IN (\'$10+\',\'$15+\',\'$25+\')';

			Assert.areEqual(
				expectedWhereClause,
				actualWhereClause,
				'Expected the where clause to be Launchpad__Hourly_Wage_Option__c IN (\'$10+\', \'$15+\', \'$25+\') but was ' +
				actualWhereClause
			);
		}
	}
	@isTest
	private static void generateWhereClauseFilterUnsupportedType() {
		System.runAs(getAdminUser()) {
			createNonSetupObjectRecords();
			Schema.DisplayType type = Schema.SObjectType.Launchpad__Job__c.fields.Launchpad__Geo_Location__c.getType();
			List<String> searchValues = new List<String>{ '=', '1.0000' };

			Test.startTest();
			try {
				String actualWhereClause = AdvancedSearchFiltersController.generateWhereClauseFilter(
					type,
					searchValues,
					'Launchpad__Geo_Location__c'
				);
			} catch (Exception e) {
				Boolean exceptionThrown = e.getMessage() != null ? true : false;
				// * ASSERTION
				// Assert that an exception was thrown when an unsupported field type is used
				Assert.isTrue(exceptionThrown, 'Expected an exception to be thrown but was not.');
			}
			Test.stopTest();
		}
	}

	@isTest
	private static void generateSoslQuery() {
		System.runAs(getAdminUser()) {
			createNonSetupObjectRecords();
			Map<String, List<String>> filterOptionsMap = new Map<String, List<String>>();
			filterOptionsMap.put('keyword', new List<String>{ 'test keyword' });
			Set<String> objFieldsFromFieldSet = new Set<String>{ 'Launchpad__City__c', 'Launchpad__Skill_Level__c' };

			Test.startTest();
			String actualSoslQueryString = AdvancedSearchFiltersController.generateSoslQuery(
				'Launchpad__Job__c',
				filterOptionsMap,
				objFieldsFromFieldSet
			);
			Test.stopTest();

			// * ASSERTION
			// Assert that the where clause was or was not formulated correctly
			String expectedSoslQueryString = 'FIND {*test keyword*} IN ALL FIELDS RETURNING Launchpad__Job__c(Launchpad__City__c, Launchpad__Skill_Level__c)';

			Assert.areEqual(
				expectedSoslQueryString,
				actualSoslQueryString,
				'Expected the where clause to be FIND {*test keyword*} IN ALL FIELDS RETURNING Launchpad__Job__c(Launchpad__City__c, Launchpad__Skill_Level__c) but was ' +
				actualSoslQueryString
			);
		}
	}
	@isTest
	private static void generateSoslQueryNullKeyword() {
		System.runAs(getAdminUser()) {
			createNonSetupObjectRecords();
			Map<String, List<String>> filterOptionsMap = new Map<String, List<String>>();
			filterOptionsMap.put('keyword', null);
			Set<String> objFieldsFromFieldSet = new Set<String>{ 'Launchpad__City__c', 'Launchpad__Skill_Level__c' };

			Test.startTest();
			String actualSoslQueryString = AdvancedSearchFiltersController.generateSoslQuery(
				'Launchpad__Job__c',
				filterOptionsMap,
				objFieldsFromFieldSet
			);
			Test.stopTest();

			// * ASSERTION
			// Assert that the where clause was or was not formulated correctly
			String expectedSoslQueryString = null;

			Assert.areEqual(
				expectedSoslQueryString,
				actualSoslQueryString,
				'Expected the where clause to be NULL but was ' + actualSoslQueryString
			);
		}
	}
	@isTest
	private static void getSearchFilterFieldsByObjAPIName() {
		System.runAs(getAdminUser()) {
			createNonSetupObjectRecords();

			Test.startTest();
			List<ETPLCommunityHelper.FieldWrapper> fields = AdvancedSearchFiltersController.getSearchFilterFieldsByObjAPIName(
				'LaunchpadCo__Training_Program__c',
				'LaunchpadCo__ETPL_Search'
			);
			Test.stopTest();

			// * ASSERTION
			// Assert that the where clause was or was not formulated correctly
			Boolean fieldsAreNotEmpty = !fields.isEmpty() ? true : false;

			Assert.isTrue(fieldsAreNotEmpty, 'Expected the field list to be populated but was empty.');
		}
	}
	@isTest
	private static void getSearchFilterFieldsByObjAPINameFieldSetDoesNotExist() {
		System.runAs(getAdminUser()) {
			createNonSetupObjectRecords();

			Test.startTest();
			try {
				List<ETPLCommunityHelper.FieldWrapper> fields = AdvancedSearchFiltersController.getSearchFilterFieldsByObjAPIName(
					'Launchpad__Job__c',
					'Launchpad__FieldSetThatDoesNotExist'
				);
			} catch (Exception e) {
				Boolean exceptionThrown = e.getMessage() != null ? true : false;
				// * ASSERTION
				// Assert that an exception was thrown when an unsupported field type is used
				Assert.isTrue(exceptionThrown, 'Expected an exception to be thrown but was not.');
			}
			Test.stopTest();
		}
	}

	@isTest
	private static void searchObject() {
		System.runAs(getAdminUser()) {
			createNonSetupObjectRecords();

			Map<String, List<String>> filterOptionsMap = new Map<String, List<String>>();
			filterOptionsMap.put('Name', new List<String>{ 'Test City' });
			filterOptionsMap.put(
				'Launchpad__Skill_Level__c',
				new List<String>{ 'IN', 'Entry Level', 'Mid Level', 'Experienced' }
			);
			filterOptionsMap.put('keyword', new List<String>{ 'test keyword' });

			Test.startTest();
			List<SObject> jobs = AdvancedSearchFiltersController.searchObject('Launchpad__Job__c', filterOptionsMap);
			Test.stopTest();

			// * ASSERTION
			// Assert that the
			Boolean jobsListIsEmpty = jobs.isEmpty() ? true : false;

			Assert.isTrue(jobsListIsEmpty, 'Expected the jobs list to be empty but was populated.');
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
	private static User getCommunityUser() {
		return [
			SELECT Id
			FROM User
			WHERE FirstName = 'test12ni' AND LastName = 'test12ni'
			LIMIT 1
		];
	}

	private static User prepareUser(String profId, String firstName, String lastName) {
		User tempUser = (User) new SObjectBuilder(User.SObjectType)
			.put(User.FirstName, firstName)
			.put(User.LastName, lastName)
			.put(User.Email, firstName + '@' + lastName + '.com')
			.put(User.Username, firstName + '@' + lastName + '.com')
			.put(User.Alias, 'test@12')
			.put(User.CommunityNickname, firstName)
			.put(User.TimeZoneSidKey, 'America/Los_Angeles')
			.put(User.LocaleSidKey, 'en_US')
			.put(User.EmailEncodingKey, 'ISO-8859-1')
			.put(User.ProfileId, profId)
			.put(User.LanguageLocaleKey, 'en_US')
			.put(User.IsActive, true)
			.build()
			.getRecord();

		return tempUser;
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
