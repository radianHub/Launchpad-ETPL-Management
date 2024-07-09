public with sharing class DisplayType {
	public Boolean isAddress = false;
	public Boolean isCurrency = false;
	public Boolean isBoolean = false;
	public Boolean isDate = false;
	public Boolean isDateTime = false;
	public Boolean isDouble = false;
	public Boolean isEmail = false;
	public Boolean isEncryptedString = false;
	public Boolean isId = false;
	public Boolean isInteger = false;
	public Boolean isLocation = false;
	public Boolean isMultipicklist = false;
	public Boolean isPercent = false;
	public Boolean isPhone = false;
	public Boolean isPicklist = false;
	public Boolean isSObject = false;
	public Boolean isString = false;
	public Boolean isTextArea = false;
	public Boolean isTime = false;
	public Boolean isUrl = false;

	// Constructor to set all DisplayType enums as per field describe
	public DisplayType(Schema.DescribeFieldResult fieldResult) {
		Schema.DisplayType type = fieldResult.getType();
		switch on type {
			when ADDRESS {
				this.isAddress = true;
			}
			when BOOLEAN {
				this.isBoolean = true;
			}
			when CURRENCY {
				this.isCurrency = true;
			}
			when DATE {
				this.isDate = true;
			}
			when DATETIME {
				this.isDateTime = true;
			}
			when DOUBLE {
				this.isDouble = true;
			}
			when EMAIL {
				this.isEmail = true;
			}
			when ENCRYPTEDSTRING {
				this.isEncryptedString = true;
			}
			when ID {
				this.isId = true;
			}
			when INTEGER {
				this.isInteger = true;
			}
			when LOCATION {
				this.isLocation = true;
			}
			when MULTIPICKLIST {
				this.isMultipicklist = true;
			}
			when PERCENT {
				this.isPercent = true;
			}
			when PHONE {
				this.isPhone = true;
			}
			when PICKLIST {
				this.isPicklist = true;
			}
			when SOBJECT {
				this.isSObject = true;
			}
			when STRING {
				this.isString = true;
			}
			when TEXTAREA {
				this.isTextArea = true;
			}
			when TIME {
				this.isTime = true;
			}
			when URL {
				this.isUrl = true;
			}
			when else {
				throw new DisplayTypeException(type + ' is not a supported display type.');
			}
		}
	}

	public class DisplayTypeException extends Exception {
	}
}
