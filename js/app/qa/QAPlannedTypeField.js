/**
 * @class Ext.app.qa.QAPlannedTypeField
 * @extends Ext.form.CompositeField
 * 创建质检计划完成时间类型选择框。
 */
Ext.ns('Ext.app.rec');

Ext.app.rec.QAPlannedTypeField = Ext.extend(Ext.form.RadioGroup, {
	fieldLabel: '计划完成时间',
	msgTarget: 'side',
	anchor: '-20',
	name: 'plannedType',
	columns: 5,

    constructor: function(config){
		this.items = new Array();

		this.items.push(new Ext.form.Radio({
			boxLabel: '指定日',
			name: 'plannedType',
			value: 'Day',
			listeners: {
				'check' : function(obj, checked) {
					if(checked) {
						var fieldSet = obj.ownerCt.ownerCt.ownerCt.ownerCt;
						fieldSet.find('name', 'plannedDayType')[0].show();
						fieldSet.find('name', 'plannedWeekType')[0].hide();
						fieldSet.find('name', 'plannedMonthType')[0].hide();
					}
				}
			}
		}));
		this.items.push(new Ext.form.Radio({
			boxLabel: '指定周',
			name: 'plannedType',
			value: 'Week',
			listeners: {
				'check' : function(obj, checked) {
					if(checked) {
						var fieldSet = obj.ownerCt.ownerCt.ownerCt.ownerCt;
						fieldSet.find('name', 'plannedDayType')[0].hide();
						fieldSet.find('name', 'plannedWeekType')[0].show();
						fieldSet.find('name', 'plannedMonthType')[0].hide();
					}
				}
			}
		}));
		this.items.push(new Ext.form.Radio({
			boxLabel: '指定月',
			name: 'plannedType',
			value: 'Month',
			listeners: {
				'check' : function(obj, checked) {
					if(checked) {
						var fieldSet = obj.ownerCt.ownerCt.ownerCt.ownerCt;
						fieldSet.find('name', 'plannedDayType')[0].hide();
						fieldSet.find('name', 'plannedWeekType')[0].hide();
						fieldSet.find('name', 'plannedMonthType')[0].show();
					}
				}
			}
		}));

		Ext.app.rec.QAPlannedTypeField.superclass.constructor.call(this, config);
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
		return 'QAPlannedTypeField';
	}
});
