public with sharing class AdvancedSearchFiltersController {
	// Call ETPLCommunityHelper to getFieldsByObjectAndFieldSet()
	// We want to be able to pass any object and field set name into the method
	// The field set name is passed in from the component's metadata
	@AuraEnabled(cacheable=true)
	public static List<ETPLCommunityHelper.FieldWrapper> getSearchFilterFieldsByObjAPIName(
		String objectApiName,
		String fieldSetApiName
	) {
		try {
			return ETPLCommunityHelper.getFieldsByObjectAndFieldSet(objectApiName, fieldSetApiName);
		} catch (Exception e) {
			System.debug('Exception: ' + e.getMessage() + ' @ ' + e.getStackTraceString());
			throw new AuraHandledException(e.getMessage());
		}
	}

	// Search an object based on filters passed in as a map of field API name to a list of String values
	@AuraEnabled
	public static List<SObject> searchObject(String qualifiedObjApiName, Map<String, List<String>> filterOptionsMap) {
        
		Map<String, Schema.SObjectField> objFields = getObjFieldMap(qualifiedObjApiName);

		String soqlQuery =
			'SELECT Id, {0} FROM ' +
			qualifiedObjApiName +
			' {1} WITH USER_MODE ORDER BY CreatedDate DESC';
		Set<String> objFieldsFromFieldSet = getFieldSetList(filterOptionsMap);

		// Generate the SOSL search query string
		String soslQuery = generateSoslQuery(qualifiedObjApiName, filterOptionsMap, objFieldsFromFieldSet);

		List<String> whereClause = buildSoqlQueryWhereClauseFilters(objFields, filterOptionsMap);
        
		Set<String> clonedObjFieldsFromFieldSet = objFieldsFromFieldSet.clone();
		clonedObjFieldsFromFieldSet.remove('keyword');
		soqlQuery = String.format(
			soqlQuery,
			new List<String>{
				String.join(clonedObjFieldsFromFieldSet, ', '),
				whereClause.isEmpty() ? '' : 'WHERE ' + String.join(whereClause, ' AND ')
			}
		);
        
		List<List<SObject>> searchResults;
		List<SObject> soslQueryResults = new List<SObject>();
     
		if (soslQuery != null) {
            
			searchResults = Search.query(soslQuery);
            
			soslQueryResults = searchResults[0]; // We are only interested in the 0th element of the returned results
		}
		
		// Execute SOQL Query for records
		List<SObject> soqlQueryResults = Database.query(soqlQuery);
		
		List<SObject> comprehensiveResultsList = compileReturnedResults(
			soqlQueryResults,
			soslQueryResults,
			filterOptionsMap
		);
        
		return comprehensiveResultsList;
	}

	// * PRIVATE METHODS

	@TestVisible
	// gets the fieldmap for an object from an object's qualified API name passed as a string
	private static Map<String, Schema.SObjectField> getObjFieldMap(String qualifiedObjApiName) {
		Schema.SObjectType objDescribe = Schema.getGlobalDescribe().get(qualifiedObjApiName);
		Schema.DescribeSObjectResult objDescribeResult = objDescribe.getDescribe();
		return objDescribeResult.fields.getMap();
	}

	@TestVisible
	private static Set<String> getFieldSetList(Map<String, List<String>> filterOptionsMap) {
		return filterOptionsMap.keySet();
	}

	public static List<String> buildSoqlQueryWhereClauseFilters(
		Map<String, Schema.SObjectField> objFields,
		Map<String, List<String>> filterOptionsMap
	) {
		// List to return
		List<String> whereClauseFiltersList = new List<String>();

		// Variables
		Set<String> filterOptionsMapKeySet = filterOptionsMap.keySet().clone(); // We need to make a copy of the set so that the keyword isn't removed
		filterOptionsMapKeySet.remove('keyword'); // We will use the keyword filter in the SOSL search rather than the SOQL query.
		filterOptionsMapKeySet.remove('distance'); // We will use the keyword filter in the SOSL search rather than the SOQL query.
		filterOptionsMapKeySet.remove('wage'); // We will use the keyword filter in the SOSL search rather than the SOQL query.
		filterOptionsMapKeySet.remove('cityOrZipCode'); // We will use the keyword filter in the SOSL search rather than the SOQL query.


		for (String fieldApiName : filterOptionsMapKeySet) {
			Schema.DescribeFieldResult fieldResult = objFields?.get(fieldApiName)?.getDescribe();
			if (fieldResult == null) {
				continue;
			}
			List<String> searchValues = filterOptionsMap.get(fieldApiName);
			// If the searchValues size is 1, it means only an operator is selected and we do not want to search since no input filter was provided.
			// Note that operators are hardcoded for Picklist and Multipicklist since they will ALWAYS be the same
			Schema.DisplayType type = fieldResult.getType();

			switch on type {
				when REFERENCE {
					throw new DisplayType.DisplayTypeException('Reference fields are not currently supported. Please remove any Master-Detail or Lookup fields from the appropriate field from the LaunchpadCo__Training_Program__c object.' );
				}
				when else {
					if (searchValues.size() == 1) {
						continue;
					} else {
						String whereClause = generateWhereClauseFilter(type, searchValues, fieldApiName);
						whereClauseFiltersList.add(whereClause);
					}
				}
			}
		}
		return whereClauseFiltersList;
	}

	@TestVisible
	private static String generateWhereClauseFilter(
		Schema.DisplayType type,
		List<String> searchValues,
		String fieldApiName
	) {
		String operator = searchValues[0];
		String filterValue = searchValues[1];

		searchValues.remove(0); // Remove the operator from the searchValues list so it does not appear in the Multipicklist and Picklist search list
		List<String> escapedSearchValues = new List<String>();

		// For each search value, escape single quotes
		for (String searchValue : searchValues) {
			escapedSearchValues.add(String.escapeSingleQuotes(searchValue));
		}

		switch on type {
			when BOOLEAN, CURRENCY, DATE, DATETIME, DOUBLE, INTEGER, PERCENT, PHONE {
				return fieldApiName + ' ' + operator + ' ' + filterValue;
			}
			when TIME {
				return fieldApiName + ' ' + operator + ' ' + filterValue + 'Z';
			}
			when EMAIL, ENCRYPTEDSTRING, ID, STRING, TEXTAREA, URL {
				if (operator == 'LIKE') {
					String escapedFilterValue = String.escapeSingleQuotes(filterValue);
					return fieldApiName + ' ' + operator + ' ' + '\'%' + escapedFilterValue + '%\'';
				} else {
					return fieldApiName + ' ' + operator + ' ' + '\'' + filterValue + '\'';
				}
			}
			when MULTIPICKLIST {
				return fieldApiName + ' INCLUDES (\'' + String.join(escapedSearchValues, '\',\'') + '\')';
			}
			when PICKLIST {
				return fieldApiName + ' IN (\'' + String.join(escapedSearchValues, '\',\'') + '\')';
			}
			when else {
				System.debug('REFERENCE NOT SUPPORTED');
				throw new DisplayType.DisplayTypeException(type + ' is not a supported display type.');
			}
		}
	}

	@TestVisible
	private static String generateSoslQuery(
		String qualifiedObjectApiName,
		Map<String, List<String>> filterOptionsMap,
		Set<String> objFieldsFromFieldSet
	) {
		Set<String> clonedObjFieldsFromFieldSet = objFieldsFromFieldSet.clone();
		clonedObjFieldsFromFieldSet.remove('keyword');
		String keyword = filterOptionsMap?.get('keyword')?.get(0);
		if (keyword == '' || keyword == null) {
			return null;
		}
		String joinedFieldsFromFieldSet = String.join(clonedObjFieldsFromFieldSet, ', ');
		String searchQuery =
			'FIND {*' +
			String.escapeSingleQuotes(keyword) +
			'*} IN ALL FIELDS RETURNING ' +
			qualifiedObjectApiName +
			'(' +
			joinedFieldsFromFieldSet +
			')';
		return searchQuery;
	}

	@TestVisible
	private static List<SObject> compileReturnedResults(
		List<SObject> soqlQueryResults,
		List<SObject> soslQueryResults,
		Map<String, List<String>> filterOptionsMap
	) {
		List<SObject> dedupedResults = new List<SObject>();

		String keyword = filterOptionsMap?.get('keyword')?.get(0);
		if (keyword == '' || keyword == null) {
			return soqlQueryResults;
		} else {
			// If the sosl query was not executed, return the SOQL-queried list

			// Else return only deduped results that are in both lists
			for (SObject record : soqlQueryResults) {
				if (soslQueryResults.contains(record) && !dedupedResults.contains(record)) {
					dedupedResults.add(record);
				}
			}
		}

		return dedupedResults;
	}
}