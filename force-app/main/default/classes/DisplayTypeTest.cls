@isTest
private class DisplayTypeTest {
	@isTest
	private static void displayTypeAddress() {
		Schema.DescribeFieldResult addressFieldResult = Schema.SObjectType.Account.fields.BillingAddress;

		Test.startTest();
		DisplayType displayType = new DisplayType(addressFieldResult);
		Test.stopTest();

		Assert.isTrue(
			displayType.isAddress,
			'Expected display type to be ADDRESS but was ' + addressFieldResult.getType()
		);
	}
	@isTest
	private static void displayTypeBoolean() {
		Schema.DescribeFieldResult booleanFieldResult = Schema.SObjectType.Account.fields.Launchpad__Active__c;

		Test.startTest();
		DisplayType displayType = new DisplayType(booleanFieldResult);
		Test.stopTest();

		Assert.isTrue(
			displayType.isBoolean,
			'Expected display type to be BOOLEAN but was ' + booleanFieldResult.getType()
		);
	}
	@isTest
	private static void displayTypeCurrency() {
		Schema.DescribeFieldResult currencyFieldResult = Schema.SObjectType.Launchpad__Job__c.fields.Launchpad__Hourly_Wage_Maximum__c;

		Test.startTest();
		DisplayType displayType = new DisplayType(currencyFieldResult);
		Test.stopTest();

		Assert.isTrue(
			displayType.isCurrency,
			'Expected display type to be CURRENCY but was ' + currencyFieldResult.getType()
		);
	}
	@isTest
	private static void displayTypeDate() {
		Schema.DescribeFieldResult dateFieldResult = Schema.SObjectType.Launchpad__Applicant_Tracking__c.fields.Launchpad__Start_Date__c;

		Test.startTest();
		DisplayType displayType = new DisplayType(dateFieldResult);
		Test.stopTest();

		Assert.isTrue(displayType.isDate, 'Expected display type to be DATE but was ' + dateFieldResult.getType());
	}
	@isTest
	private static void displayTypeDateTime() {
		Schema.DescribeFieldResult dateTimeFieldResult = Schema.SObjectType.Launchpad__Job__c.fields.Launchpad__Geo_Service_Updated__c;

		Test.startTest();
		DisplayType displayType = new DisplayType(dateTimeFieldResult);
		Test.stopTest();

		Assert.isTrue(
			displayType.isDateTime,
			'Expected display type to be DATETIME but was ' + dateTimeFieldResult.getType()
		);
	}
	@isTest
	private static void displayTypeDouble() {
		Schema.DescribeFieldResult doubleFieldResult = Schema.SObjectType.Launchpad__Job__c.fields.Launchpad__Number_of_Total_Hires__c;

		Test.startTest();
		DisplayType displayType = new DisplayType(doubleFieldResult);
		Test.stopTest();

		Assert.isTrue(
			displayType.isDouble,
			'Expected display type to be DOUBLE but was ' + doubleFieldResult.getType()
		);
	}
	@isTest
	private static void displayTypeEmail() {
		Schema.DescribeFieldResult emailFieldResult = Schema.SObjectType.Contact.fields.Launchpad__Other_Email__c;

		Test.startTest();
		DisplayType displayType = new DisplayType(emailFieldResult);
		Test.stopTest();

		Assert.isTrue(displayType.isEmail, 'Expected display type to be EMAIL but was ' + emailFieldResult.getType());
	}

	@isTest
	private static void displayTypeLocation() {
		Schema.DescribeFieldResult locationFieldResult = Schema.SObjectType.Launchpad__Job__c.fields.Launchpad__Geo_Location__c;

		Test.startTest();
		DisplayType displayType = new DisplayType(locationFieldResult);
		Test.stopTest();

		Assert.isTrue(
			displayType.isLocation,
			'Expected display type to be LOCATION but was ' + locationFieldResult.getType()
		);
	}

	@isTest
	private static void displayTypeMultipicklist() {
		Schema.DescribeFieldResult multipicklistFieldResult = Schema.SObjectType.Launchpad__Job__c.fields.Launchpad__Benefits_Offered__c;

		Test.startTest();
		DisplayType displayType = new DisplayType(multipicklistFieldResult);
		Test.stopTest();

		Assert.isTrue(
			displayType.isMultipicklist,
			'Expected display type to be MULTIPICKLIST but was ' + multipicklistFieldResult.getType()
		);
	}

	@isTest
	private static void displayTypePercent() {
		Schema.DescribeFieldResult percentFieldResult = Schema.SObjectType.Launchpad__Match__c.fields.Launchpad__Match_Criteria__c;

		Test.startTest();
		DisplayType displayType = new DisplayType(percentFieldResult);
		Test.stopTest();

		Assert.isTrue(
			displayType.isPercent,
			'Expected display type to be PERCENT but was ' + percentFieldResult.getType()
		);
	}
	@isTest
	private static void displayTypePhone() {
		Schema.DescribeFieldResult phoneFieldResult = Schema.SObjectType.Contact.fields.Launchpad__Work_Phone__c;

		Test.startTest();
		DisplayType displayType = new DisplayType(phoneFieldResult);
		Test.stopTest();

		Assert.isTrue(displayType.isPhone, 'Expected display type to be PHONE but was ' + phoneFieldResult.getType());
	}
	@isTest
	private static void displayTypePicklist() {
		Schema.DescribeFieldResult picklistFieldResult = Schema.SObjectType.Account.fields.Launchpad__Business_Type__c;

		Test.startTest();
		DisplayType displayType = new DisplayType(picklistFieldResult);
		Test.stopTest();

		Assert.isTrue(
			displayType.isPicklist,
			'Expected display type to be PICKLIST but was ' + picklistFieldResult.getType()
		);
	}
	@isTest
	private static void displayTypeString() {
		Schema.DescribeFieldResult stringFieldResult = Schema.SObjectType.Launchpad__Job__c.fields.Name;

		Test.startTest();
		DisplayType displayType = new DisplayType(stringFieldResult);
		Test.stopTest();

		Assert.isTrue(
			displayType.isString,
			'Expected display type to be STRING but was ' + stringFieldResult.getType()
		);
	}
	@isTest
	private static void displayTypeTextArea() {
		Schema.DescribeFieldResult textAreaFieldResult = Schema.SObjectType.Launchpad__Job__c.fields.Launchpad__Geo_Message__c;

		Test.startTest();
		DisplayType displayType = new DisplayType(textAreaFieldResult);
		Test.stopTest();

		Assert.isTrue(
			displayType.isTextArea,
			'Expected display type to be TEXTAREA but was ' + textAreaFieldResult.getType()
		);
	}
	@isTest
	private static void displayTypeTime() {
		Schema.DescribeFieldResult timeFieldResult = Schema.SObjectType.Launchpad__Event__c.fields.Launchpad__Start_Time__c;

		Test.startTest();
		DisplayType displayType = new DisplayType(timeFieldResult);
		Test.stopTest();

		Assert.isTrue(displayType.isTime, 'Expected display type to be Time but was ' + timeFieldResult.getType());
	}
	@isTest
	private static void displayTypeUrl() {
		Schema.DescribeFieldResult urlFieldResult = Schema.SObjectType.Launchpad__Event__c.fields.Launchpad__Video_URL__c;

		Test.startTest();
		DisplayType displayType = new DisplayType(urlFieldResult);
		Test.stopTest();

		Assert.isTrue(displayType.isUrl, 'Expected display type to be Url but was ' + urlFieldResult.getType());
	}
	@isTest
	private static void displayTypeUnsupportedFieldType() {
		Schema.DescribeFieldResult unsupportedFieldResult = Schema.SObjectType.Launchpad__Event__c.fields.RecordTypeId;

		Test.startTest();
		try {
			DisplayType displayType = new DisplayType(unsupportedFieldResult);
		} catch (Exception e) {
			Assert.isTrue(
				e.getMessage() != null,
				'Expected an error to be thrown for unsupported field type ' +
					unsupportedFieldResult.getType() +
					' but no error was thrown.'
			);
		}
		Test.stopTest();
	}
}
