/**
 * @class Ext.app.ux.NumberSelector
 * @extends Ext.form.ComboBox
 * 创建数据选择框。
 */
Ext.ns('Ext.app.ux');
Ext.app.ux.NumberSelector = Ext.extend(Ext.form.ComboBox, {
	width: 200,
	valueField: 'value',
	displayField: 'name',
	typeAhead: true,
	forceSelection: true,
	editable: false,
	mode: 'local',
	triggerAction: 'all',
	selectOnFocus:true,
	min: 1,
	max: 10,
	
	setDefaultValue: function() {
		if(this.defaultValue) {
			this.setValue(defaultValue);
		}
	},
   
	constructor: function(config){
		Ext.app.ux.DictSelector.superclass.constructor.call(this, config);
        Ext.apply(this, config);
    },

	initComponent : function(){
		var me = this;
		var data = new Array();
		for(var i=me.min; i<me.max; i++) {
			data.push(i);
		}

        var store = new Ext.data.SimpleStore({
            fields: ['val'],  
            data : data  
        });  

		Ext.app.ux.NumberSelector.superclass.initComponent.call(this);
	},
	
	getKey: function() {
		return this.name;
	},
	
	getVal: function() {
		return this.getValue();
	},
	
	getRawVal: function() {
		return this.getRawValue();
	},
	
	getTxt: function() {
		return this.fieldLabel;
	},

	getUXType: function() {
		return 'NumberSelector';
	}
});
