/**
 * @class Ext.app.qa.DateTypeField
 * @extends Ext.form.CompositeField
 * 创建时间范围方式选择框。
 */
Ext.ns('Ext.app.rec');

Ext.app.rec.DateTypeField = Ext.extend(Ext.form.CompositeField, {
	fieldLabel: '',
	msgTarget: 'side',
	anchor: '-20',

    constructor: function(config){
		this.items = new Array();

		this.items.push(new Ext.form.Radio({
			boxLabel: '按录音时间查询',
			name: 'dateType',
			value: 'RecordTime',
			checked: true,
			listeners: {
				'check' : function(obj, checked) {
				}
			}
		}));
		this.items.push({
		   width: 30,
		   xtype: 'displayfield',
		   value: '&nbsp;&nbsp;'
		});
		this.items.push(new Ext.form.Radio({
			boxLabel: '按质检时间查询',
			name: 'dateType',
			value: 'QATime',
			listeners: {
				'check' : function(obj, checked) {
				}
			}
		}));

		Ext.app.rec.DateTypeField.superclass.constructor.call(this, config);
        Ext.apply(this, config);
    },
	
	getKey: function() {
		var keys = new Array();
		keys.push('dateType');
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
		return 'DateTypeField';
	}
});
