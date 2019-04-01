/**
 * @class Ext.app.qa.QAPlannedWeekTypeField
 * @extends Ext.form.CompositeField
 * 创建质检计划完成时间类型选择框。
 */
Ext.ns('Ext.app.rec');

Ext.app.rec.QAPlannedWeekTypeField = Ext.extend(Ext.form.RadioGroup, {
	fieldLabel: '',
	msgTarget: 'side',
	anchor: '-20',
	name: 'plannedWeekType',
	columns: 5,

    constructor: function(config){
		this.items = new Array();

		var d = new Date();
		
		var s1, s2, s;
		this.items.push(new Ext.form.Radio({
			boxLabel: '本周',
			name: 'weekType',
			value: 'W0',
			checked: true
		}));
		
		if(d.getDay() > 0) {
			d.setTime(d.getTime() - (d.getDay() - 1)*24*60*60*1000);
		} else {
			d.setTime(d.getTime() - 6*24*60*60*1000);
		}
		s1 = formatDateTime(d).substring(5,10);
		d.setTime(d.getTime() + 6*24*60*60*1000);
		s2 = formatDateTime(d).substring(5,10);
		this.items.push(new Ext.form.Radio({
			boxLabel: '下一周',
			name: 'weekType',
			value: 'W1'
		}));
		d.setTime(d.getTime() + 1*24*60*60*1000);
		s1 = formatDateTime(d).substring(5,10);
		d.setTime(d.getTime() + 6*24*60*60*1000);
		s2 = formatDateTime(d).substring(5,10);
		this.items.push(new Ext.form.Radio({
			boxLabel: s1 + '/' + s2,
			name: 'weekType',
			value: 'W2'
		}));
		d.setTime(d.getTime() + 1*24*60*60*1000);
		s1 = formatDateTime(d).substring(5,10);
		d.setTime(d.getTime() + 6*24*60*60*1000);
		s2 = formatDateTime(d).substring(5,10);
		this.items.push(new Ext.form.Radio({
			boxLabel: s1 + '/' + s2,
			name: 'weekType',
			value: 'W3'
		}));

		Ext.app.rec.QAPlannedWeekTypeField.superclass.constructor.call(this, config);
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
		return 'QAPlannedWeekTypeField';
	}
});
