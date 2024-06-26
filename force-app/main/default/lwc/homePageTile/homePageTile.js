import { LightningElement, api } from 'lwc';

export default class pcHomePageTile extends LightningElement {
	@api tile;

	get imageStyle() {
		return 'background-image: url("' + this.tile.Launchpad__Image_URL__c + '");';
	}

	get target() {
		return this.tile.Launchpad__Open_in_New_Tab__c ? '_blank' : '_self';
	}
}
