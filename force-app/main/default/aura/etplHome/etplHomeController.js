({
	doInit: function (component, event, helper) {
		const config = {
			header: component.get('v.header'),
			headerColor: component.get('v.headerColor'),
			subheaderColor: component.get('v.subheaderColor'),
			description: component.get('v.description'),
		};

		component.set('v.config', config);
	},
});
