// * LWC STANDARD IMPORTS
import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import FORM_FACTOR from '@salesforce/client/formFactor';
import { SendRecordsEvent } from './event';

// * APEX IMPORTS
// TODO: import searchObject from '@salesforce/apex/AdvancedSearchFiltersController.searchObject';

// * CUSTOM LABELS
// TODO: import errorTitle from '@salesforce/label/c.PCCommunity_Error_Title';

export default class EtplFilter extends LightningElement {
	@api config;

	loading = false;
	isExpandedAdvancedFilters = false;

	filterOptions = {};
	keyword;

	searchObject() {
		this.loading = true;
		searchObject({
			qualifiedObjApiName: 'LaunchpadCo__Training_Program__c',
			filterOptionsMap: this.filterOptions,
		})
			.then((result) => {
				this.dispatchEvent(
					new SendRecordsEvent({
						records: result,
					})
				);
			})
			.catch((error) => {
				this.showNotification(this.label.errorTitle, error.body.message, 'error');
				console.error('error', error);
			})
			.finally(() => {
				this.loading = false;
			});
	}

	// * HANDLERS
	handleClickSearch() {
		this.loading = true;
		this.searchObject();
	}
	handleChangeKeyword(event) {
		this.keyword = event.target.value;
		this.filterOptions = { ...this.filterOptions, keyword: [this.keyword] };
	}

	handleClearFilters() {
		this.clearKeyword();
		this.clearAdvancedFilters();
	}

	handleAdditionalFiltersClick() {
		this.isExpandedAdvancedFilters = !this.isExpandedAdvancedFilters;
	}

	handleOperatorSelected(event) {
		let fieldApiName = event.detail.fieldApiName;
		let operator = event.detail.operator;

		// If a filter has been applied, we only want to change the operator, which we are intentionally making the first item of the array
		if (this.filterOptions[fieldApiName] && this.filterOptions[fieldApiName].length > 0) {
			this.filterOptions[fieldApiName][0] = operator;
		} else {
			// If the array has only one item, we can reset it to the operator
			this.filterOptions[fieldApiName] = [operator];
		}
	}

	// * Method purpose: fire handleClickSearch when the 'Enter' key is pressed
	handleEnterKey(event) {
		let enterKeyPressed = event.keyCode === 13 ? true : false;
		if (enterKeyPressed) {
			this.handleClickSearch();
		}
	}

	handleChangeInput(event) {
		let fieldName = event.detail.fieldName;
		let value = event.detail.value;
		let inputValue = value[0];
		let appliedFilter;
		let operator = this.filterOptions[fieldName][0]; // Operator is always the 0th element

		if (inputValue == '') {
			appliedFilter = {
				[fieldName]: [operator],
			};
		}
		// If the value is null, we need to remove the key/value pair from the advanced filters array
		else if (inputValue !== null && inputValue !== undefined) {
			appliedFilter = {
				[fieldName]: [operator, ...value],
			};
		}

		this.filterOptions = { ...this.filterOptions, ...appliedFilter };
	}

	// * Adds picklist values from advancedSearchFilters
	handleApplyFilter(event) {
		let appliedFilter = {
			[event.detail.fieldName]: event.detail.selectedValues,
		};
		this.filterOptions = { ...this.filterOptions, ...appliedFilter };
	}

	// * PRIVATE METHODS
	// # DISPLAYS A TOAST NOTIFICATION
	showNotification(title, message, variant) {
		const evt = new ShowToastEvent({
			title,
			message,
			variant,
		});
		this.dispatchEvent(evt);
	}
	clearAdvancedFilters() {
		this.refs.advancedSearchFilters.clearFilters();
		this.resetFilterOptions();
	}

	clearKeyword() {
		this.refs.keyword.value = '';
		this.keyword = '';
		this.filterOptions.keyword = '';
	}

	removeFromFilterOptions(fieldName) {
		delete this.filterOptions[fieldName];
	}

	resetFilterOptions() {
		for (const key in this.filterOptions) {
			if (Object.hasOwnProperty.call(this.filterOptions, key)) {
				let operator = this.filterOptions[key][0]; // The operator is always the first element of the array
				this.filterOptions[key] = [operator];
			}
		}
	}

	// * GETTERS

	get fieldSetFields() {
		return Object.keys(this.filterOptions);
	}

	get isLoading() {
		return this.loading;
	}

	get isMobile() {
		return FORM_FACTOR === 'Small';
	}

	get isDesktop() {
		return FORM_FACTOR === 'Medium' || FORM_FACTOR === 'Large';
	}

	get buttonOrder() {
		return this.isMobile ? 'order-1' : '';
	}
	get label() {
		return { errorTitle: errorTitle };
	}
}
