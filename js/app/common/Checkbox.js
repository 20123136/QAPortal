/**
 * @class Ext.app.common.Checkbox
 * @extends Ext.form.Checkbox
 * 创建文本输入框。
 */
Ext.ns('Ext.app.common');
Ext.app.common.Checkbox = Ext.extend(Ext.form.Checkbox, {

	constructor: function(config){
        Ext.app.common.Checkbox.superclass.constructor.call(this, config);
        Ext.apply(this, config);
    },
	
	getKey: function() {
		return this.name;
	},
	
	getVal: function() {
		return this.getValue() ? this.value : '';
	},
	
	getRawVal: function() {
		return this.boxLabel;
	},
	
	getTxt: function() {
		return this.boxLabel;
	},

	getUXType: function() {
		return 'Checkbox';
	}
});
