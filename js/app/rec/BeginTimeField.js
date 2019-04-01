/**
 * @class Ext.app.rec.BeginTimeField
 * @extends Ext.app.common.DateTime
 * 开始时间
 */
Ext.ns('Ext.app.rec');

Ext.app.rec.BeginTimeField = Ext.extend(Ext.app.common.DateTime, {

	constructor: function(config){
		Ext.app.rec.BeginTimeField.superclass.constructor.call(this, config);
        Ext.apply(this, config);
    },

	initComponent : function(){
		
		this.fieldLabel = '开始时间';

		this.name = this.name ? this.name : 'beginTime';

		var curdate = new Date();
		curdate.setHours(0);
		curdate.setMinutes(0);
		curdate.setSeconds(0);
		this.setValue(curdate);

		Ext.app.rec.BeginTimeField.superclass.initComponent.call(this);
	},

	getUXType: function() {
		return 'BeginTimeField';
	}
});
