/**
 * @class Ext.app.qa.DateRangeTypeField
 * @extends Ext.form.CompositeField
 * 创建时间范围方式选择框。
 */
Ext.ns('Ext.app.rec');

Ext.app.rec.DateRangeTypeField = Ext.extend(Ext.form.CompositeField, {
	fieldLabel: '时间范围',
	msgTarget: 'side',
	anchor: '-20',

    constructor: function(config){
		this.items = new Array();

		this.items.push(new Ext.form.Radio({
			boxLabel: '指定时段',
			name: 'dateRangeType',
			value: 'Absolute',
			checked: true,
			listeners: {
				'check' : function(obj, checked) {
					if(checked) {
						var fieldSet = Ext.getCmp(Ext.fly(obj.ownerCt.id).parent().parent().parent().parent().parent().id);
						fieldSet.find('name', 'absoluteTimeType')[0].show();
						fieldSet.find('name', 'relativeTimeType')[0].hide();
					}
				}
			}
		}));
		this.items.push({
		   width: 30,
		   xtype: 'displayfield',
		   value: '&nbsp;&nbsp;'
		});
		this.items.push(new Ext.form.Radio({
			boxLabel: '相对时段',
			name: 'dateRangeType',
			value: 'Relative',
			listeners: {
				'check' : function(obj, checked) {
					if(checked) {
						var fieldSet = Ext.getCmp(Ext.fly(obj.ownerCt.id).parent().parent().parent().parent().parent().id);
						fieldSet.find('name', 'absoluteTimeType')[0].hide();
						fieldSet.find('name', 'relativeTimeType')[0].show();
					}
				}
			}
		}));

		Ext.app.rec.DateRangeTypeField.superclass.constructor.call(this, config);
        Ext.apply(this, config);
    },
	
	getKey: function() {
		var keys = new Array();
		keys.push('dateRangeType');
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
		return vals;
	},
	
	getRawVal: function() {
		if(this.items.items[0].getValue()) {
			return this.items.items[0].boxLabel;
		}
		if(this.items.items[2].getValue()) {
			return this.items.items[2].boxLabel;
		}
	},
	
	getTxt: function() {
		if(this.items.items[0].getValue()) {
			return this.items.items[0].boxLabel;
		}
		if(this.items.items[2].getValue()) {
			return this.items.items[2].boxLabel;
		}
	},

	getUXType: function() {
		return 'DateRangeTypeField';
	}
});
