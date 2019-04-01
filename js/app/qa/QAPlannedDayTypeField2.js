/**
 * @class Ext.app.qa.QAPlannedDayTypeField2
 * @extends Ext.form.CompositeField
 * 创建质检计划完成时间类型选择框。
 */
Ext.ns('Ext.app.rec');

Ext.app.rec.QAPlannedDayTypeField2 = Ext.extend(Ext.form.RadioGroup, {
	fieldLabel: '',
	msgTarget: 'side',
	anchor: '-20',
	name: 'plannedDayType',
	columns: 5,

    constructor: function(config){
		this.items = new Array();

		this.items.push(new Ext.form.Radio({
			boxLabel: '当日',
			name: 'dayType',
			value: 'D0',
			checked: true
		}));
		this.items.push(new Ext.form.Radio({
			boxLabel: '第2天',
			name: 'dayType',
			value: 'D1'
		}));
		this.items.push(new Ext.form.Radio({
			boxLabel: '第3天',
			name: 'dayType',
			value: 'D2'
		}));
		this.items.push(new Ext.form.Radio({
			boxLabel: '第4天',
			name: 'dayType',
			value: 'D3'
		}));
		this.items.push(new Ext.form.Radio({
			boxLabel: '第5天',
			name: 'dayType',
			value: 'D4'
		}));
		this.items.push(new Ext.form.Radio({
			boxLabel: '第6天',
			name: 'dayType',
			value: 'D5'
		}));
		this.items.push(new Ext.form.Radio({
			boxLabel: '第7天',
			name: 'dayType',
			value: 'D6'
		}));

		Ext.app.rec.QAPlannedDayTypeField2.superclass.constructor.call(this, config);
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
		return 'QAPlannedDayTypeField2';
	}
});
