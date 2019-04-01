/**
 * @class Ext.app.common.DateTime
 * @extends Cls.form.DateTimeField
 * 列表。
 */
Ext.ns('Ext.app.common');

Ext.app.common.DateTime = Ext.extend(Cls.form.DateTimeField, {
	emptyText: 'YYYY-MM-DD HH:mm:SS',
	width: 200,
	format: 'Y-m-d H:i:s',			

    constructor: function(config){
        Ext.app.common.DateTime.superclass.constructor.call(this, config);
        Ext.apply(this, config);
    },
	
	getKey: function() {
		return this.name;
	},
	
	getVal: function() {
		return this.getRawValue();
	},
	
	getRawVal: function() {
		return this.getRawValue();
	},
	
	getTxt: function() {
		return this.fieldLabel;
	},

	getUXType: function() {
		return 'DateTime';
	}
});
