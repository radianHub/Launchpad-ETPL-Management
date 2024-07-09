public inherited sharing class ETPLCommunityHelper {
	public static List<FieldWrapper> getFieldsByObjectAndFieldSet(String objectName, String fieldSetName) {
		List<FieldWrapper> fieldWrapperList = new List<FieldWrapper>();
		List<Schema.FieldSetMember> fieldSetMembers = getFieldSet(objectName, fieldSetName)?.getFields();
		if (fieldSetMembers == null) {
			throw new ETPLCommunityHelperException(
				'Could not find Field Set called ' + '\'' + fieldSetName + '\' on object ' + objectName + '.'
			);
		}
		for (Schema.FieldSetMember fmo : fieldSetMembers) {
			fieldWrapperList.add(new FieldWrapper(fmo.getFieldPath(), fmo.getLabel(), String.valueOf(fmo.getType()), fmo.getRequired()));
		}

		return fieldWrapperList;
	}

	public static Schema.FieldSet getFieldSet(String objectName, String fieldSetName) {
		Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe();
		Schema.SObjectType sObjectTypeObj = globalDescribeMap?.get(ObjectName);
		if (sObjectTypeObj == null) {
			throw new ETPLCommunityHelperException('Could not find object called ' + '\'' + objectName + '\'.');
		}
		Schema.DescribeSObjectResult describeSObjectResultObj = sObjectTypeObj?.getDescribe();

		return describeSObjectResultObj?.FieldSets?.getMap()?.get(fieldSetName);
	}

	public static List<Option> fetchPicklistValues(Schema.DescribeFieldResult fieldResult) {
		List<Option> values = new List<Option>();
		for (Schema.PicklistEntry f : fieldResult.getPicklistValues()) {
			values.add(new Option(f.getLabel(), f.getValue()));
		}
		return values;
	}

	public inherited sharing class FieldWrapper {
		@AuraEnabled
		public String fieldApiName;
		@AuraEnabled
		public String fieldLabel;
		@AuraEnabled
		public String fieldType;
		@AuraEnabled
		public Boolean required;
		@AuraEnabled
		public Boolean isReadOnly;
		@AuraEnabled
		public Integer fieldScreenSize;
		@AuraEnabled
		public Boolean isOverrideHelpText;
		@AuraEnabled
		public String customHelpText;

		public FieldWrapper(String fieldApiName, String fieldLabel, String fieldType, Boolean required) {
			this.fieldApiName = fieldApiName;
			this.fieldLabel = fieldLabel;
			this.fieldType = fieldType;
			this.required = required;
			this.isReadOnly = isReadOnly;
			this.fieldScreenSize = fieldScreenSize;
			this.isOverrideHelpText = isOverrideHelpText;
			this.customHelpText = customHelpText;
		}
	}

	public inherited sharing class Option {
		@AuraEnabled
		public String label;

		@AuraEnabled
		public String value;

		public Option(String label, String value) {
			this.label = label;
			this.value = value;
		}
	}

	public static Schema.DescribeSObjectResult getSObjSchema(String sObj) {
		Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe();
		Schema.SObjectType sObjectTypeObj = globalDescribeMap.get(sObj);
		return sObjectTypeObj.getDescribe();
	}

	/***************************************************
	 * @DESCRIPTION : GETS PICKLIST VALUES FOR A FIELD *
	 * @AUTHOR RADIANHUB DEVELOPER | 06/26/2024        *
	 * @RETURN List<Option>                            *
	 ***************************************************/
	public static List<Option> getPicklistValues(Schema.DescribeFieldResult fieldResult) {
		List<Option> values = new List<Option>();
		for (Schema.PicklistEntry f : fieldResult.getPicklistValues()) {
			values.add(new Option(f.getLabel(), f.getValue()));
		}
		return values;
	}

	@AuraEnabled
	public static List<ETPLCommunityHelper.Option> getPicklistValuesFromObjFieldApiName(String objName, String field) {
		try {
			Schema.DescribeFieldResult dfr = Schema.getGlobalDescribe()
				.get(objName)
				.getDescribe()
				.fields.getMap()
				.get(field)
				.getDescribe();
			return fetchPicklistValues(dfr);
		} catch (Exception e) {
			System.debug('Exception: ' + e.getMessage() + ' @ ' + e.getStackTraceString());
			throw new AuraHandledException(e.getMessage());
		}
	}
	public class ETPLCommunityHelperException extends exception {
	}
}
