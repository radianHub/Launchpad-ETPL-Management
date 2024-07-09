export const SEND_RECORDS = 'sendrecords';

export class SendRecordsEvent extends CustomEvent {
	constructor(detail) {
		super(SEND_RECORDS, {
			detail,
			cancelable: true,
			bubbles: true,
			composed: true,
		});
	}
}