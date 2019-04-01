/**
 * @class Ext.app.common.Radio
 * @extends Ext.form.Radio
 * 创建文本输入框。
 */
Ext.ns('Ext.app.common');
Ext.app.common.Radio = Ext.extend(Ext.form.Radio, {

	constructor: function(config){
        Ext.app.common.Radio.superclass.constructor.call(this, config);
        Ext.apply(this, config);
    },
	
	getKey: function() {
		return this.getValue() ? this.name : '';
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
		return 'Radio';
	}
});
