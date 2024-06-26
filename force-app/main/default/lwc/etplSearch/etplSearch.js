import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

//TODO: import getSearchFilterFieldsByObjAPIName from '@salesforce/apex/AdvancedSearchFiltersController.getSearchFilterFieldsByObjAPIName';

// * CUSTOM LABELS
//TODO: import errorTitle from '@salesforce/label/c.PCCommunity_Error_Title';

export default class EtplSearch extends LightningElement {
	// * PUBLIC PROPERTIES
	@api header;
	@api headerColor;
	@api description;
	@api filterHeader;
	@api filterSectionHelpText;
	@api primaryFilterFieldSetApiName;
	@api searchInputLabel;
	@api searchBtnLabel;
	@api clearFilterLabel;
	@api enableAdvancedFilters;
	@api advancedFilterFieldSetApiName;
	@api noRecordsMessage;

	@track wiredFields;
	@track fields;
	@track returnedRecords;

	loading = false;

	// * APEX
	// # WIRE METHODS
	// TODO: @wire(getSearchFilterFieldsByObjAPIName, {
	// 	objectApiName: 'LaunchpadCo__Training_Program__c',
	// 	fieldSetApiName: '$primaryFilterFieldSetApiName',
	// })
	// wiredGetSearchFilterFieldsByObjAPIName(result) {
	// 	this.loading = true;
	// 	this.wiredFields = result;
	// 	const { data, error } = result;
	// 	if (data) {
	// 		data.forEach((field) => {
	// 			let isPicklist = field.fieldType === 'PICKLIST' || field.fieldType === 'MULTIPICKLIST' ? true : false;
	// 			let notPicklist = !isPicklist;
	// 			this.fields = {
	// 				...this.fields,
	// 				...{
	// 					[field.fieldApiName]: {
	// 						...field,
	// 						type: field.fieldType,
	// 						isPicklist: isPicklist,
	// 						notPicklist: notPicklist,
	// 					},
	// 				},
	// 			};
	// 		});
	// 		this.loading = false;
	// 	} else if (error) {
	// 		this.showNotification(this.label.errorTitle, error.body.message, 'error');
	// 		console.log('error', error.body.message, 'error');
	// 		this.loading = false;
	// 	}
	// }

	// * HANDLERS
	handleOnSendRecords(event) {
		this.returnedRecords = event.detail.records;
	}

	// * PRIVATE FUNCTIONS
	// # DISPLAYS A TOAST NOTIFICATION
	showNotification(title, message, variant) {
		const evt = new ShowToastEvent({
			title,
			message,
			variant,
		});
		this.dispatchEvent(evt);
	}

	// * GETTERS

	// Store in config variable for easier passing to child component
	get config() {
		return {
			header: this.header,
			headerColor: this.headerColor,
			description: this.description,
			filterHeader: this.filterHeader,
			filterSectionHelpText: this.filterSectionHelpText,
			primaryFilterFieldSetApiName: this.primaryFilterFieldSetApiName,
			searchInputLabel: this.searchInputLabel,
			searchBtnLabel: this.searchBtnLabel,
			clearFilterLabel: this.clearFilterLabel,
			enableAdvancedFilters: this.enableAdvancedFilters,
			advancedFilterFieldSetApiName: this.advancedFilterFieldSetApiName,
			fields: this.fields,
			noRecordsMessage: this.noRecordsMessage,
		};
	}

	get headerCSS() {
		return this.config && this.config.headerColor ? 'color:' + this.config.headerColor : 'color:rgb(84, 105, 141)';
	}

	get isLoading() {
		return this.loading;
	}

	get records() {
		return this.returnedRecords;
	}

	get nameFieldRedirectPath() {
		'training-program/';
	}

	get label() {
		return { errorTitle: errorTitle };
	}
}
