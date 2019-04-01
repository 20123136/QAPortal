/**
 * @class Ext.app.common.NumberField
 * @extends Ext.ux.SpinnerField
 * 创建文本输入框。
 */
Ext.ns('Ext.app.common');

Ext.app.common.NumberField = Ext.extend(Ext.ux.form.SpinnerField, {
	defaultValue: '',
	
	setDefaultValue: function() {
		this.value = this.defaultValue;
	},

	constructor: function(config){
        Ext.app.common.NumberField.superclass.constructor.call(this, config);
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
		return 'TextField';
	}
});
