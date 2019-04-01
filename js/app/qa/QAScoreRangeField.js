/**
 * @class Ext.app.qa.QAScoreRangeField
 * @extends Ext.form.CompositeField
 * 创建质检分数范围选择框。
 */
Ext.ns('Ext.app.rec');

Ext.app.qa.QAScoreRangeField = Ext.extend(Ext.form.CompositeField, {
	fieldLabel: '分数',
	msgTarget: 'side',
	anchor: '-20',

    constructor: function(config){
		this.items = new Array();
		this.items.push(new Ext.app.common.NumberField({
			name: 'minQAScore',
			defaultValue: 0,
			width: 200
		}));
		this.items.push({
			   width: 30,
			   xtype: 'displayfield',
			   value: '&nbsp;&nbsp;---'
		});
		this.items.push(new Ext.app.common.NumberField({
			name: 'maxQAScore',
			defaultValue: 100,
			width: 200
		}));

		Ext.app.qa.QAScoreRangeField.superclass.constructor.call(this, config);
        Ext.apply(this, config);
    },
	
	getKey: function() {
		var keys = new Array();
		keys.push(this.items.items[0].getKey());
		keys.push(this.items.items[2].getKey());
		return keys;
	},
	
	getVal: function() {
		var vals = new Array();
		vals.push(this.items.items[0].getVal());
		vals.push(this.items.items[2].getVal());
		return vals;
	},
	
	getRawVal: function() {
		var vals = new Array();
		vals.push(this.items.items[0].getRawVal());
		vals.push(this.items.items[2].getRawVal());
		return vals;
	},
	
	getTxt: function() {
		var vals = new Array();
		vals.push(this.items.items[0].getTxt());
		vals.push(this.items.items[2].getTxt());
		return vals;
	},

	getUXType: function() {
		return 'QAScoreRangeField';
	}
});
