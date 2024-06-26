import { api, track, wire } from 'lwc';

import { ApplyFilterEvent } from './event.js';
import LightningModal from 'lightning/modal';
import FORM_FACTOR from '@salesforce/client/formFactor';

// TODO: import getPicklistValuesFromObjFieldApiName from '@salesforce/apex/PCCommunityHelper.getPicklistValuesFromObjFieldApiName';

export default class selectFilterValues extends LightningModal {
	@api filter;
	@api buttonLabel;
	@api objectApiName;

	@track processedFilter = {};

	loading;

	connectedCallback() {
		this.setupPicklistValues();
	}

	renderedCallback() {
		this.getCheckedInputs();
	}

	// * PRIVATE METHODS

	setupPicklistValues() {
		if (this.filterFieldApiName && this.objApiName) {
			this.processedFilter = {
				...this.filter,
				selectedValues: this.filter.selectedValues,
			};
			if (this.filterFieldApiName) {
				this.getPicklistValues();
			}
		} else {
			this.processedFilter = {
				...this.filter,
			};
		}
	}

	getPicklistValues() {
		this.loading = true;
		getPicklistValuesFromObjFieldApiName({
			objName: this.objApiName,
			field: this.filterFieldApiName,
		})
			.then((result) => {
				this.processedFilter = {
					...this.processedFilter,
					values: result,
				};
			})
			.catch((error) => {
				console.error('error', JSON.stringify(error));
			})
			.finally(() => {
				this.loading = false;
			});
	}

	getCheckedInputs() {
		[...this.template.querySelectorAll('lightning-input')].forEach((input) => {
			input.checked = this.finalFilter.selectedValues.find((value) => value === input.name);
		});
	}
	filterForCheckedInputComponents() {
		return [...this.template.querySelectorAll('lightning-input')].filter((input) => input.checked);
	}

	fireApplyFilterEvent(selectedValues, fieldName) {
		this.dispatchEvent(
			new ApplyFilterEvent({
				selectedValues,
				fieldName: fieldName,
			})
		);
	}
	populateSelectedValues() {
		const inputs = this.filterForCheckedInputComponents();
		let selectedValues = [];
		inputs.forEach((element) => {
			selectedValues.push(element.name);
		});

		// If the type is picklist, unshift the IN operator
		switch (this.filter.type) {
			case 'PICKLIST':
				selectedValues.unshift('IN');
				break;
			case 'MULTIPICKLIST':
				selectedValues.unshift('INCLUDES');
				break;
			default:
				break;
		}
		return selectedValues;
	}

	// * HANDLERS

	handleApplyFilters() {
		const selectedValues = this.populateSelectedValues();

		this.fireApplyFilterEvent(selectedValues, this.finalFilter.fieldName);

		this.close({ selectedValues: selectedValues, fieldName: this.finalFilter.fieldName });
	}

	// * GETTERS

	// * CHECKS FORM FACTOR AND SETS HEADER PADDING DEPENDING OF MOBILE OR DESKTOP
	get headerPadding() {
		return this.isDesktop ? 'around-medium' : 'horizontal-medium';
	}

	// * GETS DEVICE TYPE
	get isDesktop() {
		return FORM_FACTOR === 'Large';
	}

	// * GETS DEVICE TYPE
	get isMobile() {
		return FORM_FACTOR === 'Small';
	}

	get finalFilter() {
		return { ...this.processedFilter };
	}

	get objApiName() {
		return this.objectApiName;
	}

	get filterFieldApiName() {
		return this.filter.fieldName;
	}

	get rowCSS() {
		return this.isDesktop ? 'slds-size_1-of-6' : 'slds-size_1-of-1 slds-var-p-around_small';
	}

	get isLoading() {
		return this.loading;
	}
}
