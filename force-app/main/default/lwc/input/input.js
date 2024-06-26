import { LightningElement, api, track } from 'lwc';
import { ChangeInputEvent } from './event.js';

import FORM_FACTOR from '@salesforce/client/formFactor';

export default class input extends LightningElement {
	@api field;
	@track appliedFilter;
	@api filterOptionsMap;

	@track fieldInput;
	regex = /^\d{2}[:]\d{2}[:]\d{2}[.]\d{3}[Z]$/;

	// * HANDLERS
	// Captures input data. If checkbox, uses the checked property
	// Otherwise, uses the value property
	handleBlur(event) {
		let eventValue = event.target.value ? event.target.value : event.target.checked;
		// If the value is the same as the existing field input, no additional processing is needed
		if (eventValue === this.fieldInput) {
			return;
		} else {
			this.setFieldInputValue(event);
		}
	}

	handleChangeCheckbox(event) {
		this.handleBlur(event);
	}

	// * PRIVATE METHODS
	setFieldInputValue(event) {
		if (this.field.fieldType === 'BOOLEAN') {
			this.fieldInput = event.target.checked;
		} else {
			this.fieldInput = event.target.value;
		}
		this.dispatchChangeInputEvent();
	}

	@api clearInput() {
		if (this.isCheckbox) {
			this.fieldInput = false;
		} else {
			this.fieldInput = null;
		}
	}

	dispatchChangeInputEvent() {
		let inputArray = [this.fieldInput];

		this.dispatchEvent(
			new ChangeInputEvent({
				fieldName: this.field.fieldApiName,
				value: inputArray,
			})
		);
	}

	// * GETTERS
	get dynamicFieldInput() {
		if (this.filterOptionsMap) {
			const fieldValueArray = this.filterOptionsMap[this.field.fieldApiName];
			const emptyValue = this.isCheckbox ? false : [];
			let fieldValue =
				fieldValueArray && fieldValueArray.length > 1
					? this.filterOptionsMap[this.field.fieldApiName][1]
					: emptyValue;
			this.fieldInput = fieldValue;
		}
		return this.fieldInput;
	}
	get isText() {
		return (
			this.field !== undefined &&
			(this.field.type === 'STRING' ||
				this.field.type === 'TEXTAREA' ||
				this.field.type === 'PICKLIST' ||
				this.field.type === 'MULTIPICKLIST') &&
			this.time === null
		);
	}

	get isDate() {
		return this.field !== undefined && this.field.type === 'DATE';
	}

	get isDateTime() {
		return this.field !== undefined && this.field.type === 'DATETIME';
	}

	get isDecimal() {
		return this.field !== undefined && this.field.type === 'DOUBLE';
	}

	get isCurrency() {
		return this.field !== undefined && this.field.type === 'CURRENCY';
	}

	get isPercent() {
		return this.field !== undefined && this.field.type === 'PERCENT';
	}

	get isTime() {
		return (
			this.field !== undefined &&
			(this.field.type === 'TIME' || (this.field.type === 'STRING' && !!this.field?.value?.match(this.regex)))
		);
	}

	get time() {
		if (
			this.field.value !== undefined &&
			this.field.value !== null &&
			this.field.type === 'STRING' &&
			!!this.field.value.match(this.regex)
		) {
			var thisTime = this.field.value.split(':');
			var suffix = thisTime[0] >= 12 ? 'PM' : 'AM';
			var hour = thisTime[0] > 12 ? parseInt(thisTime[0] - 12) : parseInt(thisTime[0]);
			var min = thisTime[1];
			var newTime = hour + ':' + min + ' ' + suffix;

			return newTime;
		}
		return null;
	}

	get isUrl() {
		return this.field !== undefined && this.field.type === 'URL';
	}

	get isPhone() {
		return this.field !== undefined && this.field.type === 'PHONE';
	}

	get isEmail() {
		return this.field !== undefined && this.field.type === 'EMAIL';
	}

	get isCheckbox() {
		return this.field !== undefined && this.field.type === 'BOOLEAN';
	}

	get variant() {
		return FORM_FACTOR === 'Small' ? 'label-hidden' : 'label-hidden';
	}

	get placeholder() {
		return FORM_FACTOR === 'Small' ? '' : this.field.fieldLabel;
	}
}
