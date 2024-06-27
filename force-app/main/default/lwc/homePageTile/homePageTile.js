import { LightningElement, api } from 'lwc';

export default class homePageTile extends LightningElement {
	@api tile;

	get imageStyle() {
		return 'background-image: url("' + this.tile.LaunchpadCo__Image_URL__c + '");';
	}

	get target() {
		return this.tile.LaunchpadCo__Open_in_New_Tab__c ? '_blank' : '_self';
	}
}
