import { LightningElement, api, track } from 'lwc';
import FORM_FACTOR from '@salesforce/client/formFactor';

export default class FilterResults extends LightningElement {
	@api config;
	@api objectApiName;
	@api fields;
	@api records;
	@api nameFieldRedirectPath;

	loading = false;

	// * GETTERS
	get isMobile() {
		return FORM_FACTOR === 'Small';
	}
	get isDesktop() {
		return FORM_FACTOR === 'Large' || FORM_FACTOR === 'Medium';
	}

	get showDatatable() {
		return this.isDesktop && this.recordsToDisplay ? true : false;
	}
	get showRecordTiles() {
		return this.isMobile && this.recordsToDisplay ? true : false;
	}

	// * GETTERS
	get recordsToDisplay() {
		this.loading = true;
		let result = [];

		if (this.records !== undefined && this.records.length > 0) {
			this.records.forEach((record) => {
				let recordData = [];
				let arrayOfFields = Object.values(this.fields);
				arrayOfFields.forEach((field) => {
					let value;
					if (!field.fieldApiName.includes('.')) {
						value = record[field.fieldApiName];
					} else {
						const tempArray = field.fieldApiName.split('.');
						value = record[tempArray[0]][tempArray[1]];
					}
					recordData.push({
						label: field.fieldLabel,
						type: field.fieldType,
						value: value,
						isNameField: field.fieldApiName === 'Name' ? true : false,
					});
				});
				result.push({
					key: record.Id,
					details: recordData,
				});
			});
		}
		this.loading = false;
		return result.length > 0 ? result : null;
	}

	get isLoading() {
		return this.loading;
	}

	get noRecordsMessage() {
		return this.config.noRecordsMessage;
	}
}
