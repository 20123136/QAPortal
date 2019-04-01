/**
 * @class Ext.app.common.ColmunField
 * @extends Ext.form.Checkbox
 * 创建字段选择框。
 */
Ext.ns('Ext.app.common');

Ext.app.common.ColmunField = Ext.extend(Ext.form.Checkbox, {
	boxLabel: '',
	checked: true,
	disabled: false,
	sortable: true,
	totalable: false,
	avgable: false,
	hidden: false,

	constructor: function(config){
        Ext.app.common.ColmunField.superclass.constructor.call(this, config);
        Ext.apply(this, config);
    },
	
	getKey: function() {
		return this.name;
	},
	
	getVal: function() {
		return this.value;
	},
	
	getRawVal: function() {
		return this.boxLabel;
	},
	
	getTxt: function() {
		return this.boxLabel;
	},

	getUXType: function() {
		return 'ColmunField';
	}
});
