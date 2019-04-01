/**
 * @class Ext.app.qa.QAAssignSampleTypeField
 * @extends Ext.form.CompositeField
 * 创建质检抽样方式范围选择框。
 */
Ext.ns('Ext.app.qa');

Ext.app.qa.QAAssignSampleTypeField = Ext.extend(Ext.form.CompositeField, {
	fieldLabel: '抽样方式',
	msgTarget: 'side',
	anchor: '-20',

    constructor: function(config){
		this.items = new Array();

		this.items.push(new Ext.form.Radio({
			boxLabel: '按抽检数量',
			name: 'sampleType',
			value: 'TotalLimit',
			checked: true,
			listeners: {
				'check' : function(obj, checked) {
					if(checked) {
						obj.ownerCt.find('name', 'totalLimitCount')[0].enable();
						obj.ownerCt.find('name', 'rateLimitCount')[0].disable();
					}
				}
			}
		}));
		this.items.push(new Ext.app.common.NumberField({
			name: 'totalLimitCount',
			defaultValue: 100,
			width: 150
		}));
		this.items.push({
		   width: 30,
		   xtype: 'displayfield',
		   value: '&nbsp;&nbsp;'
		});
		this.items.push(new Ext.form.Radio({
			boxLabel: '按抽检百分比',
			name: 'sampleType',
			value: 'RateLimit',
			listeners: {
				'check' : function(obj, checked) {
					if(checked) {
						obj.ownerCt.find('name', 'totalLimitCount')[0].disable();
						obj.ownerCt.find('name', 'rateLimitCount')[0].enable();
					}
				}
			}
		}));
		this.items.push(new Ext.app.common.NumberField({
			name: 'rateLimitCount',
			defaultValue: 10,
			disabled: true,
			width: 150
		}));
		this.items.push({
		   width: 30,
		   xtype: 'displayfield',
		   value: '%'
		});

		Ext.app.qa.QAAssignSampleTypeField.superclass.constructor.call(this, config);
        Ext.apply(this, config);
    },
	
	getKey: function() {
		var keys = new Array();
		keys.push('sampleType');
		keys.push('limitCount');
		return keys;
	},
	
	getVal: function() {
		var vals = new Array();
		if(this.items.items[0].getValue()) {
			vals.push(this.items.items[0].value);
			vals.push(this.items.items[1].getValue());
		}
		if(this.items.items[3].getValue()) {
			vals.push(this.items.items[3].value);
			vals.push(this.items.items[4].getValue());
		}
		return vals;
	},
	
	getRawVal: function() {
		if(this.items.items[0].getValue()) {
			return this.items.items[0].boxLabel + '(' + this.items.items[1].getValue() + ')';
		}
		if(this.items.items[3].getValue()) {
			return this.items.items[3].boxLabel + '(' + this.items.items[4].getValue() + '%)';
		}
	},
	
	getTxt: function() {
		if(this.items.items[0].getValue()) {
			return this.items.items[0].boxLabel + '(' + this.items.items[1].getValue() + ')';
		}
		if(this.items.items[3].getValue()) {
			return this.items.items[3].boxLabel + '(' + this.items.items[4].getValue() + ')';
		}
	},

	getUXType: function() {
		return 'QAAssignSampleTypeField';
	}
});
