import { LightningElement, api } from 'lwc';
import { OperatorSelectedEvent } from './event.js';

export default class FilterBadges extends LightningElement {
	@api fieldApiName;
	@api fieldType;
	@api disabled;
	@api filterOperatorLabelMap;

	passedInOperatorLabel;

	operatorStringArray = ['Equals', 'Not equals', 'Less than', 'Less or equal', 'Greater than', 'Greater or equal'];

	operatorMap = {
		Equals: '=',
		'Not equals': '!=',
		'Less than': '<',
		'Less or equal': '<=',
		'Greater than': '>',
		'Greater or equal': '>=',
		LIKE: 'LIKE',
	};

	selectedOperatorIndex = 0;

	// * LIFECYCLE METHODS
	connectedCallback() {
		this.setOperatorStringArray();
		this.passFieldWithOperatorToParent();
		this.setPassedInOperatorLabel();
		this.setOperatorIndex();
	}

	setPassedInOperatorLabel() {
		if (this.filterOperatorLabelMap) {
			this.passedInOperatorLabel = this.filterOperatorLabelMap[this.fieldApiName];
		}
	}

	setOperatorIndex() {
		if (this.passedInOperatorLabel) {
			switch (this.passedInOperatorLabel) {
				case 'Equal to':
					const isEqualTo = (element) => element === 'Equals';
					this.selectedOperatorIndex = this.operatorStringArray.findIndex(isEqualTo);
					break;
				case 'Not equal to':
					const isNotEqualTo = (element) => element === 'Not equals';
					this.selectedOperatorIndex = this.operatorStringArray.findIndex(isNotEqualTo);
					break;
				case ('Before', 'Less than'):
					const isLessThan = (element) => element === 'Less than';
					this.selectedOperatorIndex = this.operatorStringArray.findIndex(isLessThan);
					break;
				case ('On or before', 'Less or equal'):
					const isLessOrEqual = (element) => element === 'Less or equal';
					this.selectedOperatorIndex = this.operatorStringArray.findIndex(isLessOrEqual);
					break;
				case ('After', 'Greater than'):
					const isGreaterThan = (element) => element === 'Greater than';
					this.selectedOperatorIndex = this.operatorStringArray.findIndex(isGreaterThan);
					break;
				case ('On or after', 'Greater or equal'):
					const isGreaterOrEqual = (element) => element === 'Greater or equal';
					this.selectedOperatorIndex = this.operatorStringArray.findIndex(isGreaterOrEqual);
					break;
				case 'Fuzzy Match':
					const isLike = (element) => element === 'LIKE';
					this.selectedOperatorIndex = this.operatorStringArray.findIndex(isLike);
					break;
				default:
					break;
			}
		}
	}

	// * HANDLERS
	handleClickBadge(event) {
		if (this.disabled) {
			return;
		}
		if (this.operatorStringArray.length > this.selectedOperatorIndex + 1) {
			this.selectedOperatorIndex++;
		} else {
			this.selectedOperatorIndex = 0;
		}
		this.passFieldWithOperatorToParent();
	}

	// * PRIVATE FUNCTIONS
	setOperatorStringArray() {
		if (this.fieldType === 'BOOLEAN' || this.fieldType === 'ID' || this.fieldType === 'PHONE') {
			this.operatorStringArray = ['Equals'];
		} else if (
			this.fieldType === 'CURRENCY' ||
			this.fieldType === 'DATE' ||
			this.fieldType === 'DATETIME' ||
			this.fieldType === 'DOUBLE' ||
			this.fieldType === 'INTEGER' ||
			this.fieldType === 'PERCENT' ||
			this.fieldType === 'TIME'
		) {
			this.operatorStringArray = [
				'Equals',
				'Not equals',
				'Less than',
				'Less or equal',
				'Greater than',
				'Greater or equal',
			];
		} else if (
			this.fieldType === 'EMAIL' ||
			this.fieldType === 'ENCRYPTEDSTRING' ||
			this.fieldType === 'STRING' ||
			this.fieldType === 'TEXTAREA' ||
			this.fieldType === 'URL'
		) {
			this.operatorStringArray = ['Equals', 'LIKE'];
		} else {
			console.log(`Field Type ${this.fieldType} is not supported.`);
		}
	}
	passFieldWithOperatorToParent() {
		let fieldWithOperator = {
			fieldApiName: this.fieldApiName,
			operator: this.operator,
			operatorLabel: this.operatorLabel,
		};
		this.dispatchEvent(new OperatorSelectedEvent(fieldWithOperator));
	}

	// * GETTERS
	get selectedOperator() {
		return this.operatorStringArray[this.selectedOperatorIndex];
	}

	get isEquals() {
		return this.selectedOperator === 'Equals';
	}
	get equalsLabel() {
		return 'Equal to';
	}
	get isNotEquals() {
		return this.selectedOperator === 'Not equals';
	}
	get notEqualsLabel() {
		return 'Not equal to';
	}
	get isLessThan() {
		return this.selectedOperator === 'Less than';
	}
	get lessThanLabel() {
		return this.fieldType === 'DATE' || this.fieldType === 'DATETIME' || this.fieldType === 'TIME'
			? 'Before'
			: 'Less than';
	}
	get isLessOrEqual() {
		return this.selectedOperator === 'Less or equal';
	}
	get lessOrEqualLabel() {
		return this.fieldType === 'DATE' || this.fieldType === 'DATETIME' || this.fieldType === 'TIME'
			? 'On or before'
			: 'Less or equal to';
	}
	get isGreaterThan() {
		return this.selectedOperator === 'Greater than';
	}
	get greaterThanLabel() {
		return this.fieldType === 'DATE' || this.fieldType === 'DATETIME' || this.fieldType === 'TIME'
			? 'After'
			: 'Greater than';
	}
	get isGreaterOrEqual() {
		return this.selectedOperator === 'Greater or equal';
	}
	get greaterOrEqualLabel() {
		return this.fieldType === 'DATE' || this.fieldType === 'DATETIME' || this.fieldType === 'TIME'
			? 'On or after'
			: 'Greater or equal to';
	}
	get isLike() {
		return this.selectedOperator === 'LIKE';
	}
	get likeLabel() {
		return 'Fuzzy Match';
	}

	// Gets the operator to be passed up through the component hierarchy
	get operator() {
		return this.operatorMap[this.selectedOperator];
	}
	// Gets the operator to be passed up through the component hierarchy
	get operatorLabel() {
		let label = '';
		switch (this.selectedOperator) {
			case 'Equals':
				label = this.equalsLabel;
				break;
			case 'Not equals':
				label = this.notEqualsLabel;
				break;
			case 'Less than':
				label = this.lessThanLabel;
				break;
			case 'Less or equal':
				label = this.lessOrEqualLabel;
				break;
			case 'Greater than':
				label = this.greaterThanLabel;
				break;
			case 'Greater or equal':
				label = this.greaterOrEqualLabel;
				break;
			case 'LIKE':
				label = this.likeLabel;
				break;
			default:
				break;
		}
		return label;
	}
}
