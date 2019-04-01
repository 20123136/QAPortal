/**
 * @class Ext.app.common.TextField
 * @extends Ext.form.TextField
 * 创建文本输入框。
 */
Ext.app.common.TextField = Ext.extend(Ext.form.TextField, {
	defaultValue: '',
	
	setDefaultValue: function() {
		this.value = this.defaultValue;
	},

	constructor: function(config){
        Ext.app.common.TextField.superclass.constructor.call(this, config);
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
