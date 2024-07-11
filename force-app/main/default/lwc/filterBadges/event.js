export const OPERATOR_SELECTED_EVENT_NAME = 'operatorselected';

export class OperatorSelectedEvent extends CustomEvent {
	constructor(detail) {
		super(OPERATOR_SELECTED_EVENT_NAME, {
			detail,
			cancelable: true,
			bubbles: true,
			composed: true,
		});
	}
}
