import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

export default class RecordTile extends NavigationMixin(LightningElement) {
	@api record;
	@api config;
	@api fields;
	@api nameFieldRedirectPath;
	@api objectApiName;

	@track data = [];
	loading = false;

	connectedCallback() {
		let recordFields = Object.values(this.record)[1];
		let index = 0;
		recordFields.forEach((field) => {
			let value;
			value = field.value;
			this.data.push({
				label: field.label,
				type: field.type,
				value: value,
				isNameField: field.isNameField,
			});
			index++;
		});
	}

	// * HANDLERS
	handleClickRecordName() {
		this.navigateToRecordPage();
	}

	// * PRIVATE FUNCTIONS
	showNotification(title, message, variant) {
		const evt = new ShowToastEvent({
			title,
			message,
			variant,
		});
		this.dispatchEvent(evt);
	}

	navigateToRecordPage() {
		this[NavigationMixin.Navigate]({
			type: 'standard__recordPage',
			attributes: {
				recordId: this.recordId,
				objectApiName: '$objectApiName',
				actionName: 'view',
			},
		});
	}
	// * GETTERS
	get title() {
		return this.data.length > 0 ? this.data[0].value : 'No data here!';
	}

	get details() {
		return this.data !== undefined && this.data.length > 1 ? this.data.slice(1) : [];
	}

	get recordId() {
		return this.record.key;
	}

	get isLoading() {
		return this.loading;
	}
}
