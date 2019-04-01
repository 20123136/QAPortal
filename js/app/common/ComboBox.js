/**
 * @class Ext.app.common.ComboBox
 * @extends Ext.form.ComboBox
 * 创建文本输入框。
 */
Ext.ns('Ext.app.common');
Ext.app.common.ComboBox = Ext.extend(Ext.form.ComboBox, {
	defaultValue: '',
	typeAhead: true,
	forceSelection: true,
	editable: false,
	mode: 'local',
	triggerAction: 'all',
	selectOnFocus:true,
		
	setDefaultValue: function() {
		if(this.defaultValue) {
			this.setValue(this.defaultValue);
		}
	},

	constructor: function(config){
        Ext.app.common.ComboBox.superclass.constructor.call(this, config);
        Ext.apply(this, config);
		this.setDefaultValue();
    },
	
	getKey: function() {
		return this.name;
	},
	
	getVal: function() {
		return this.getValue();
	},
	
	getRawVal: function() {
		return this.getValue();
	},
	
	getTxt: function() {
		return this.fieldLabel;
	},

	getUXType: function() {
		return 'ComboBox';
	}
});
