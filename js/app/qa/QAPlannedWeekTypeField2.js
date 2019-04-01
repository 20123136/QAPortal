/**
 * @class Ext.app.qa.QAPlannedWeekTypeField2
 * @extends Ext.form.CompositeField
 * 创建质检计划完成时间类型选择框。
 */
Ext.ns('Ext.app.rec');

Ext.app.rec.QAPlannedWeekTypeField2 = Ext.extend(Ext.form.RadioGroup, {
	fieldLabel: '',
	msgTarget: 'side',
	anchor: '-20',
	name: 'plannedWeekType',
	columns: 5,

    constructor: function(config){
		this.items = new Array();

		var d = new Date();
		
		this.items.push(new Ext.form.Radio({
			boxLabel: '当周',
			name: 'weekType',
			value: 'W0',
			checked: true
		}));
		
		this.items.push(new Ext.form.Radio({
			boxLabel: '第2周',
			name: 'weekType',
			value: 'W1'
		}));
		this.items.push(new Ext.form.Radio({
			boxLabel: '第3周',
			name: 'weekType',
			value: 'W2'
		}));
		this.items.push(new Ext.form.Radio({
			boxLabel: '第4周',
			name: 'weekType',
			value: 'W3'
		}));

		Ext.app.rec.QAPlannedWeekTypeField2.superclass.constructor.call(this, config);
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
		return 'QAPlannedWeekTypeField2';
	}
});
