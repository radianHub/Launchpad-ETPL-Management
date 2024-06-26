import { LightningElement, api, track, wire } from 'lwc';
import FORM_FACTOR from '@salesforce/client/formFactor';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { loadStyle } from 'lightning/platformResourceLoader';

import getSearchFilterFieldsByObjAPIName from '@salesforce/apex/AdvancedSearchFiltersController.getSearchFilterFieldsByObjAPIName';

// * CUSTOM LABELS
import errorTitle from '@salesforce/label/c.ETPLCommunity_Error_Title';

// * CUSTOM MODALS
import selectFilterValues from 'c/selectFilterValues';

// * CUSTOM RESOURCES
// TODO: import css from '@salesforce/resourceUrl/MasterAuraStyleSheet';

// * CUSTOM EVENTS
import { ApplyFilterEvent, SendFieldsEvent } from './event.js';

export default class AdvancedSearchFilters extends LightningElement {
	//* Public properties
	@api objectApiName;
	@api fieldSetApiName;
	@api filterOptionsMap; // Used only when run from a saved search record
	@api filterOperatorLabelMap; // Used only when run from a saved search record

	// * Tracked properties
	@track wiredFields;
	@track fields;

	// * Reactive properties
	loading = false;

	// * LIFECYCLE METHODS
	connectedCallback() {
		loadStyle(this, css);
	}

	// * APEX
	// # WIRE METHODS
	@wire(getSearchFilterFieldsByObjAPIName, {
		objectApiName: '$objectApiName',
		fieldSetApiName: '$fieldSetApiName',
	})
	wiredGetSearchFilterFieldsByObjAPIName(result) {
		this.loading = true;
		this.wiredFields = result;
		const { data, error } = result;
		if (data) {
			this.fields = data.map((field) => {
				let isPicklist = field.fieldType === 'PICKLIST' || field.fieldType === 'MULTIPICKLIST' ? true : false;
				let notPicklist = !isPicklist;
				let truncatedLabel =
					field.fieldLabel.length > 30 ? field.fieldLabel.substring(0, 30) + '...' : field.fieldLabel;
				return {
					...field,
					type: field.fieldType,
					isPicklist: isPicklist,
					notPicklist: notPicklist,
					truncatedBtnLabel: truncatedLabel,
					selectedValues: [],
				};
			});

			this.dispatchEvent(
				new SendFieldsEvent({
					fields: this.fields,
				})
			);
			this.loading = false;
		} else if (error) {
			this.showNotification(this.label.errorTitle, error.body.message, 'error');
			console.log('error', error.body.message, 'error');
			this.loading = false;
		}
	}

	// * HANDLERS
	handleClickPicklist(event) {
		// Open the picklist select modal
		let name = event.target.dataset.name;
		let title = event.target.dataset.title;
		let type = event.target.dataset.type;
		let selectedValues = event.target.dataset.selected.split(',');
		let filter = {
			fieldName: name,
			title: title,
			values: [],
			selectedValues: selectedValues,
			type: type,
		};
		this.picklistModal(filter);
	}

	// * PUBLIC METHODS
	@api clearFilters() {
		// Clear the filters (selectedValues = []) and set isFilterApplied to false for each field
		if (this.fields) {
			this.fields.forEach((field) => {
				field.selectedValues = [];
				field.isFilterApplied = false;
			});
		}
		this.clearChildInputComponents();
	}

	// * PRIVATE METHODS

	@api clearChildInputComponents() {
		let inputChildComponents = this.getChildInputComponents();
		if (inputChildComponents) {
			inputChildComponents.forEach((input) => {
				input.clearInput();
			});
		}
	}

	getChildInputComponents() {
		return this.template.querySelectorAll('c-input');
	}

	// * OPENS THE DOCUMENT EDIT MODAL
	async picklistModal(filter) {
		const r = await selectFilterValues
			.open({
				size: 'medium',
				filter: filter,
				buttonLabel: 'Apply Filter',
				objectApiName: this.objectApiName,
			})
			.then((result) => {
				let index = 0;
				// Update the fields array of field objects to reflect the newly selected values
				let isFilterApplied;
				this.fields.forEach((field) => {
					if (field.fieldApiName === result.fieldName) {
						const selectedValues = result?.selectedValues;
						isFilterApplied = selectedValues && selectedValues?.length > 1 ? true : false; // If length is 1, only the operator is present

						this.fields[index] = {
							...field,
							isFilterApplied: isFilterApplied,
							selectedValues: result.selectedValues,
						};
					}
					index++;
				});
				this.dispatchEvent(
					new ApplyFilterEvent({
						selectedValues: result.selectedValues,
						fieldName: result.fieldName,
					})
				);
			})
			.catch((err) => {
				console.log(err);
			})
			.finally(() => {
				this.fields = [...this.fields];
			});
	}

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

	get isMobile() {
		return FORM_FACTOR === 'Small';
	}

	get buttonCSS() {
		return this.isMobile
			? 'mobile button-icon-pair flex-gap-5 clamp padding-bottom-15'
			: 'button-icon-pair flex-gap-15 filter-input-min-width clamp align-self-end';
	}

	get isLoading() {
		return this.loading;
	}

	get label() {
		return {
			errorTitle: errorTitle,
		};
	}

	get finalFields() {
		if (this.filterOptionsMap && this.fields) {
			this.fields = this.fields.map((field) => {
				const fieldApiName = field.fieldApiName;
				if (
					Object.keys(this.filterOptionsMap).includes(fieldApiName) &&
					this.filterOptionsMap[fieldApiName].length > 1
				) {
					field.selectedValues = this.filterOptionsMap[fieldApiName];
					field.isFilterApplied = true;
				}
				return field;
			});
		}
		return this.fields;
	}
}
