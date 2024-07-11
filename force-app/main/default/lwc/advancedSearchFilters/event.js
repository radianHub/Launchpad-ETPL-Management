export const APPLY_FILTER = 'applyfilter';
export const SEND_FIELDS = 'sendfields';

export class ApplyFilterEvent extends CustomEvent {
	constructor(detail) {
		super(APPLY_FILTER, {
			detail,
			cancelable: true,
			bubbles: true,
			composed: true,
		});
	}
}
export class SendFieldsEvent extends CustomEvent {
	constructor(detail) {
		super(SEND_FIELDS, {
			detail,
			cancelable: true,
			bubbles: true,
			composed: true,
		});
	}
}
