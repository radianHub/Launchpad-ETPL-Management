@IsTest
public class RequiredFieldsCache {
	public static Map<SObjectField, Object> get(SObjectType sObjectType) {
		return cache.containsKey(sObjectType) ? cache.get(sObjectType) : new Map<SObjectField, Object>();
	}

	public static IFieldProvider getGenericParentProvider(SObjectType sObjectType) {
		if (!genericParentProviders.containsKey(sObjectType))
			genericParentProviders.put(sObjectType, SObjectFactory.provideGenericParent(sObjectType));
		return genericParentProviders.get(sObjectType);
	}
	static Map<SObjectType, IFieldProvider> genericParentProviders = new Map<SObjectType, IFieldProvider>();

	static Map<SObjectType, Map<SObjectField, Object>> cache = new Map<SObjectType, Map<SObjectField, Object>>{
		Account.sObjectType => new Map<SObjectField, Object>{ Account.Name => 'Some Account' },
		AccountContactRole.sObjectType => new Map<SObjectField, Object>{
			AccountContactRole.AccountId => getGenericParentProvider(Account.sObjectType),
			AccountContactRole.ContactId => getGenericParentProvider(Contact.sObjectType)
		},
		Attachment.sObjectType => new Map<SObjectField, Object>{
			Attachment.ParentId => getGenericParentProvider(Account.sObjectType),
			Attachment.Body => Blob.valueOf('body'),
			Attachment.Name => 'Some Attachment'
		},
		Contact.sObjectType => new Map<SObjectField, Object>{
			Contact.LastName => 'Doe',
			Contact.AccountId => getGenericParentProvider(Account.sObjectType)
		},
		ContentVersion.sObjectType => new Map<SObjectField, Object>{
			ContentVersion.Title => 'Some Content',
			ContentVersion.PathOnClient => 'some/path',
			ContentVersion.VersionData => Blob.valueOf('data')
		},
		Document.sObjectType => new Map<SObjectField, Object>{
			Document.FolderId => getGenericParentProvider(User.sObjectType),
			Document.Name => 'Some Document'
		},
		EmailMessage.sObjectType => new Map<SObjectField, Object>{
			EmailMessage.ParentId => getGenericParentProvider(Case.sObjectType)
		},
		EmailTemplate.sObjectType => new Map<SObjectField, Object>{
			EmailTemplate.DeveloperName => SObjectFactory.provideUniqueString('Template'),
			EmailTemplate.FolderId => getGenericParentProvider(User.sObjectType),
			EmailTemplate.TemplateType => 'Text',
			EmailTemplate.Name => 'Some Template'
		},
		SObjectType.FieldPermissions.getSObjectType() => new Map<SObjectField, Object>{
			FieldPermissions.Field => String.valueOf(Opportunity.sObjectType) +
			'.' +
			String.valueOf(Opportunity.Amount),
			FieldPermissions.ParentId => getGenericParentProvider(PermissionSet.sObjectType),
			FieldPermissions.SObjectType => String.valueOf(Opportunity.sObjectType),
			FieldPermissions.PermissionsRead => true
		},
		Launchpad__Job__c.sObjectType => new Map<SObjectField, Object>{
			Launchpad__Job__c.Launchpad__Account__c => getGenericParentProvider(Account.sObjectType)
		},
		Launchpad__Matching__c.sObjectType => new Map<SObjectField, Object>{
			Launchpad__Matching__c.Launchpad__Job_Stages_to_Include__c => 'Identified, Interviewing'
		},
		Note.sObjectType => new Map<SObjectField, Object>{
			Note.ParentId => getGenericParentProvider(Account.sObjectType),
			Note.Title => 'Some Note'
		},

		SObjectType.ObjectPermissions.getSObjectType() => new Map<SObjectField, Object>{
			ObjectPermissions.ParentId => getGenericParentProvider(PermissionSet.sObjectType),
			ObjectPermissions.SObjectType => String.valueOf(Account.sObjectType),
			ObjectPermissions.PermissionsRead => true
		},
		OpportunityContactRole.sObjectType => new Map<SObjectField, Object>{
			OpportunityContactRole.OpportunityId => getGenericParentProvider(Opportunity.sObjectType),
			OpportunityContactRole.ContactId => getGenericParentProvider(Contact.sObjectType)
		},
		OpportunityLineItem.sObjectType => new Map<SObjectField, Object>{
			OpportunityLineItem.OpportunityId => getGenericParentProvider(Opportunity.sObjectType),
			OpportunityLineItem.PricebookEntryId => getGenericParentProvider(PricebookEntry.sObjectType),
			OpportunityLineItem.UnitPrice => 1,
			OpportunityLineItem.Quantity => 1
		},
		PermissionSet.sObjectType => new Map<SObjectField, Object>{
			PermissionSet.Name => SObjectFactory.provideUniqueString('TestPermissions'),
			PermissionSet.Label => SObjectFactory.provideUniqueString('Test Permissions')
		},
		PermissionSetAssignment.sObjectType => new Map<SObjectField, Object>{
			PermissionSetAssignment.PermissionSetId => getGenericParentProvider(PermissionSet.sObjectType),
			PermissionSetAssignment.AssigneeId => getGenericParentProvider(User.sObjectType)
		},
		User.sObjectType => new Map<SObjectField, Object>{
			User.LastName => 'Doe',
			User.LocaleSidKey => 'en_US',
			User.Email => 'jdoe@example.com',
			User.LanguageLocaleKey => 'en_US',
			User.EmailEncodingKey => 'ISO-8859-1',
			User.TimeZoneSidKey => 'America/Denver',
			User.ProfileId => SObjectFactory.provideStandardProfile(),
			User.Alias => SObjectFactory.provideUniqueFixedLengthString('jdoe', 7),
			User.CommunityNickname => SObjectFactory.provideUniqueString('johndoe'),
			User.Username => SObjectFactory.provideUniqueString('1234567890abcxyz@example.com')
		},
		UserRole.sObjectType => new Map<SObjectField, Object>{ UserRole.Name => 'Some Role' }
	};
}