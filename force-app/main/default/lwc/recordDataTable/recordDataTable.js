import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class RecordDataTable extends NavigationMixin(LightningElement) {
	@api objectApiName;
	@api fieldSetFields;
	@api records;
	@api nameFieldRedirectPath;

	// * HANDLERS
	handleClickRecordName(event) {
		let recordId = event.target.dataset.key;
		this.navigateToRecordPage(recordId);
	}

	// * PRIVATE FUNCTIONS
	navigateToRecordPage(recordId) {
		this[NavigationMixin.Navigate]({
			type: 'standard__recordPage',
			attributes: {
				recordId: recordId,
				objectApiName: '$objectApiName',
				actionName: 'view',
			},
		});
	}

	// * GETTERS
	get returnedRecords() {
		return [...this.records];
	}

	get fields() {
		let fieldsArray = [];
		for (const key in this.fieldSetFields) {
			if (Object.hasOwnProperty.call(this.fieldSetFields, key)) {
				const element = this.fieldSetFields[key];
				fieldsArray = [...fieldsArray, element];
			}
		}
		return fieldsArray;
	}
}
