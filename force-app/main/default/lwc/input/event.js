export const CHANGE_FILTERS = 'changefilters';
export const CHANGE_INPUT = 'changeinput';

export class ChangeFiltersEvent extends CustomEvent {
	constructor(detail) {
		super(CHANGE_FILTERS, {
			detail,
			cancelable: true,
			bubbles: true,
			composed: true,
		});
	}
}
export class ChangeInputEvent extends CustomEvent {
	constructor(detail) {
		super(CHANGE_INPUT, {
			detail,
			cancelable: true,
			bubbles: true,
			composed: true,
		});
	}
}
