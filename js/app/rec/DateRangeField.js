/**
 * @class Ext.ux.DateRangeField
 * @extends Ext.form.CompositeField
 * 创建时间范围选择框。
 */
Ext.ns('Ext.app.rec');

Ext.app.rec.DateRangeField = Ext.extend(Ext.form.CompositeField, {
	fieldLabel: '开始时间',
	msgTarget: 'side',
	anchor: '-20',
	beginTimeFieldName: 'beginTime',
	endTimeFieldName: 'endTime',

    constructor: function(config){
		var me = this;
		this.items = new Array();
		this.items.push(new Ext.app.rec.BeginTimeField({
			name: (config.beginTimeFieldName ? config.beginTimeFieldName : me.beginTimeFieldName)
		}));
		this.items.push({
			   width: 30,
			   xtype: 'displayfield',
			   value: '&nbsp;&nbsp;---'
			});
		this.items.push(new Ext.app.rec.EndTimeField({
			name: (config.endTimeFieldName ? config.endTimeFieldName : me.endTimeFieldName)
		}));

		Ext.app.rec.DateRangeField.superclass.constructor.call(this, config);
        Ext.apply(this, config);
    },
	
	getKey: function() {
		var keys = new Array();
		keys.push(this.items.items[0].getKey());
		keys.push(this.items.items[2].getKey());
		return keys;
	},
	
	getVal: function() {
		var vals = new Array();
		vals.push(this.items.items[0].getVal());
		vals.push(this.items.items[2].getVal());
		return vals;
	},
	
	getRawVal: function() {
		var vals = new Array();
		vals.push(this.items.items[0].getRawVal());
		vals.push(this.items.items[2].getRawVal());
		return vals;
	},
	
	getTxt: function() {
		var vals = new Array();
		vals.push(this.items.items[0].getTxt());
		vals.push(this.items.items[2].getTxt());
		return vals;
	},

	getUXType: function() {
		return 'DateRangeField';
	}
});
