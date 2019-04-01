/**
 * @class Ext.app.rec.BeginTimeField
 * @extends Ext.app.common.DateTime
 * 开始时间
 */
Ext.ns('Ext.app.rec');

Ext.app.rec.EndTimeField = Ext.extend(Ext.app.common.DateTime, {

	constructor: function(config){
		Ext.app.rec.EndTimeField.superclass.constructor.call(this, config);
        Ext.apply(this, config);
    },

	initComponent : function(){
		
		this.fieldLabel = '结束时间';
		
		this.name = this.name ? this.name : 'endTime';

		var curdate = new Date();
		curdate.setHours(23);
		curdate.setMinutes(59);
		curdate.setSeconds(59);
		this.setValue(curdate);

		Ext.app.rec.EndTimeField.superclass.initComponent.call(this);
	},

	getUXType: function() {
		return 'EndTimeField';
	}
});
