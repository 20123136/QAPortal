/**
 * @class Ext.app.qa.ReportTypeField
 * @extends Ext.form.CompositeField
 * 创建报表类型方式选择框。
 */
Ext.ns('Ext.app.rec');

Ext.app.rec.ReportTypeField = Ext.extend(Ext.form.CompositeField, {
	fieldLabel: '报表类型',
	msgTarget: 'side',
	anchor: '-20',

    constructor: function(config){
		this.items = new Array();

		this.items.push(new Ext.form.Radio({
			boxLabel: '分时报表',
			name: 'reportType',
			value: 'Hour',
			listeners: {
				'check' : function(obj, checked) {
				}
			}
		}));
		this.items.push({
		   width: 20,
		   xtype: 'displayfield',
		   value: '&nbsp;&nbsp;'
		});
		this.items.push(new Ext.form.Radio({
			boxLabel: '日报表',
			name: 'reportType',
			value: 'Day',
			checked: true,
			listeners: {
				'check' : function(obj, checked) {
				}
			}
		}));
		this.items.push({
			   width: 20,
			   xtype: 'displayfield',
			   value: '&nbsp;&nbsp;'
			});
		this.items.push(new Ext.form.Radio({
			boxLabel: '周报表',
			name: 'reportType',
			value: 'Week',
			listeners: {
				'check' : function(obj, checked) {
				}
			}
		}));
		this.items.push({
			   width: 20,
			   xtype: 'displayfield',
			   value: '&nbsp;&nbsp;'
			});
		this.items.push(new Ext.form.Radio({
			boxLabel: '月报表',
			name: 'reportType',
			value: 'Month',
			listeners: {
				'check' : function(obj, checked) {
				}
			}
		}));

		Ext.app.rec.ReportTypeField.superclass.constructor.call(this, config);
        Ext.apply(this, config);
    },
	
	getKey: function() {
		var keys = new Array();
		keys.push('reportType');
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
		if(this.items.items[6].getValue()) {
			vals.push(this.items.items[6].value);
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
		if(this.items.items[6].getValue()) {
			return this.items.items[6].boxLabel;
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
		if(this.items.items[6].getValue()) {
			return this.items.items[6].boxLabel;
		}
	},

	getUXType: function() {
		return 'ReportTypeField';
	}
});
