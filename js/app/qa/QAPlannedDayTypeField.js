/**
 * @class Ext.app.qa.QAPlannedDayTypeField
 * @extends Ext.form.CompositeField
 * 创建质检计划完成时间类型选择框。
 */
Ext.ns('Ext.app.rec');

Ext.app.rec.QAPlannedDayTypeField = Ext.extend(Ext.form.RadioGroup, {
	fieldLabel: '',
	msgTarget: 'side',
	anchor: '-20',
	name: 'plannedDayType',
	columns: 5,

    constructor: function(config){
		this.items = new Array();

		var d = new Date();
		var s = formatDateTime(d).substring(0,10);
		this.items.push(new Ext.form.Radio({
			boxLabel: '今日',
			name: 'dayType',
			value: 'D0',
			checked: true
		}));
		d.setTime(d.getTime() + 24*60*60*1000);
		s = formatDateTime(d).substring(0,10);
		this.items.push(new Ext.form.Radio({
			boxLabel: '明日',
			name: 'dayType',
			value: 'D1'
		}));
		d.setTime(d.getTime() + 24*60*60*1000);
		s = formatDateTime(d).substring(0,10);
		this.items.push(new Ext.form.Radio({
			boxLabel: s,
			name: 'dayType',
			value: 'D2'
		}));
		d.setTime(d.getTime() + 24*60*60*1000);
		s = formatDateTime(d).substring(0,10);
		this.items.push(new Ext.form.Radio({
			boxLabel: s,
			name: 'dayType',
			value: 'D3'
		}));
		d.setTime(d.getTime() + 24*60*60*1000);
		s = formatDateTime(d).substring(0,10);
		this.items.push(new Ext.form.Radio({
			boxLabel: s,
			name: 'dayType',
			value: 'D4'
		}));
		d.setTime(d.getTime() + 24*60*60*1000);
		s = formatDateTime(d).substring(0,10);
		this.items.push(new Ext.form.Radio({
			boxLabel: s,
			name: 'dayType',
			value: 'D5'
		}));
		d.setTime(d.getTime() + 24*60*60*1000);
		s = formatDateTime(d).substring(0,10);
		this.items.push(new Ext.form.Radio({
			boxLabel: s,
			name: 'dayType',
			value: 'D6'
		}));

		Ext.app.rec.QAPlannedDayTypeField.superclass.constructor.call(this, config);
        Ext.apply(this, config);
    },
	
	getKey: function() {
		var keys = new Array();
		keys.push(this.name);
		return keys;
	},
	
	getVal: function() {
		var vals = new Array();
		Ext.each(this.items.items, function(item) {
			if(item.getValue()) {
				vals.push(item.value);
			}
		});
		return vals;
	},
	
	getRawVal: function() {
		var val = '';
		Ext.each(this.items.items, function(item) {
			if(item.getValue()) {
				val = item.boxLabel;
			}
		});
		return val;
	},
	
	getTxt: function() {
		var val = '';
		Ext.each(this.items.items, function(item) {
			if(item.getValue()) {
				val = item.boxLabel;
			}
		});
		return val;
	},

	getUXType: function() {
		return 'QAPlannedDayTypeField';
	}
});
