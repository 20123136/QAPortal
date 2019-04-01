/**
 * @class Ext.app.rec.CallTimeRangeField
 * @extends Ext.form.CompositeField
 * 创建呼叫时长范围选择框。
 */
Ext.ns('Ext.app.rec');

Ext.app.rec.CallTimeRangeField = Ext.extend(Ext.form.CompositeField, {
	fieldLabel: '通话时长(秒)',
	msgTarget: 'side',
	anchor: '-20',

    constructor: function(config){
		this.items = new Array();
		this.items.push(new Ext.app.common.NumberField({
			name: 'minCallTime',
			defaultValue: 0,
			width: 200
		}));
		this.items.push({
			   width: 30,
			   xtype: 'displayfield',
			   value: '&nbsp;&nbsp;---'
		});
		this.items.push(new Ext.app.common.NumberField({
			name: 'maxCallTime',
			defaultValue: 9999,
			width: 200
		}));

		Ext.app.rec.CallTimeRangeField.superclass.constructor.call(this, config);
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
		return 'CallTimeRangeField';
	}
});
