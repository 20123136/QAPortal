/**
 * @class Ext.app.qa.ScheduleTypeField
 * @extends Ext.form.CompositeField
 * 创建时间范围方式选择框。
 */
Ext.ns('Ext.app.qa');

Ext.app.qa.ScheduleTypeField = Ext.extend(Ext.form.CompositeField, {
	fieldLabel: '计划类型',
	msgTarget: 'side',
	anchor: '-20',

    constructor: function(config){
		this.items = new Array();

		this.items.push(new Ext.form.Radio({
			boxLabel: '每日',
			name: 'scheduleType',
			value: '2',
			checked: true
		}));
		this.items.push({
		   width: 30,
		   xtype: 'displayfield',
		   value: '&nbsp;&nbsp;'
		});
		this.items.push(new Ext.form.Radio({
			boxLabel: '每周',
			name: 'scheduleType',
			value: '3'
		}));
		this.items.push({
		   width: 30,
		   xtype: 'displayfield',
		   value: '&nbsp;&nbsp;'
		});
		this.items.push(new Ext.form.Radio({
			boxLabel: '每月',
			name: 'scheduleType',
			value: '4'
		}));

		Ext.app.qa.ScheduleTypeField.superclass.constructor.call(this, config);
        Ext.apply(this, config);
    },
	
	getKey: function() {
		var keys = new Array();
		keys.push('scheduleType');
		return keys;
	},
	
	getVal: function() {
		var vals = new Array();
		if(this.items.items[0].getValue()) {
			vals.push(this.items.items[0].value);
		}
		if(this.items.items[2].getValue()) {
			vals.push(this.items.items[2].value);
		}
		if(this.items.items[4].getValue()) {
			vals.push(this.items.items[4].value);
		}
		return vals;
	},
	
	getRawVal: function() {
		if(this.items.items[0].getValue()) {
			return this.items.items[0].boxLabel;
		}
		if(this.items.items[2].getValue()) {
			return this.items.items[2].boxLabel;
		}
		if(this.items.items[4].getValue()) {
			return this.items.items[4].boxLabel;
		}
	},
	
	getTxt: function() {
		if(this.items.items[0].getValue()) {
			return this.items.items[0].boxLabel;
		}
		if(this.items.items[2].getValue()) {
			return this.items.items[2].boxLabel;
		}
		if(this.items.items[4].getValue()) {
			return this.items.items[4].boxLabel;
		}
	},

	getUXType: function() {
		return 'ScheduleTypeField';
	}
});
