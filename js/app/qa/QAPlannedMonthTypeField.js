/**
 * @class Ext.app.qa.QAPlannedMonthTypeField
 * @extends Ext.form.CompositeField
 * 创建质检计划完成时间类型选择框。
 */
Ext.ns('Ext.app.rec');

Ext.app.rec.QAPlannedMonthTypeField = Ext.extend(Ext.form.RadioGroup, {
	fieldLabel: '',
	msgTarget: 'side',
	anchor: '-20',
	name: 'plannedMonthType',
	columns: 5,

    constructor: function(config){
		this.items = new Array();

		var d = new Date();
		
		var s;
		this.items.push(new Ext.form.Radio({
			boxLabel: '本月',
			name: 'monthType',
			value: 'M0',
			checked: true
		}));
		
		d.setMonth(d.getMonth() + 1);
		s = formatDateTime(d).substring(0,7);
		this.items.push(new Ext.form.Radio({
			boxLabel: '下月',
			name: 'monthType',
			value: 'M1'
		}));
		d.setMonth(d.getMonth() + 1);
		s = formatDateTime(d).substring(0,7);
		this.items.push(new Ext.form.Radio({
			boxLabel: s,
			name: 'monthType',
			value: 'M2'
		}));
		d.setMonth(d.getMonth() + 1);
		s = formatDateTime(d).substring(0,7);
		this.items.push(new Ext.form.Radio({
			boxLabel: s,
			name: 'monthType',
			value: 'M3'
		}));

		Ext.app.rec.QAPlannedMonthTypeField.superclass.constructor.call(this, config);
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
		return 'QAPlannedMonthTypeField';
	}
});
