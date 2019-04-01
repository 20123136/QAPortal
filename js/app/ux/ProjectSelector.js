/**
 * @class Ext.app.ux.DictSelector
 * @extends Ext.form.ComboBox
 * 创建数据字典选择框。
 */
Ext.ns('Ext.app.ux');
Ext.app.ux.ProjectSelector = Ext.extend(Ext.form.ComboBox, {
	width: 200,
	valueField: 'id',
	displayField: 'name',
	typeAhead: true,
	forceSelection: true,
	editable: false,
	mode: 'local',
	triggerAction: 'all',
	selectOnFocus:true,
	
	setDefaultValue: function() {
		if(this.defaultValue) {
			this.setValue(defaultValue);
		}
	},
   
	constructor: function(config){
		Ext.app.ux.ProjectSelector.superclass.constructor.call(this, config);
        Ext.apply(this, config);
    },

	initComponent : function(){
		var me = this;
		this.store = new Ext.data.JsonStore({
			root: 'data',
			totalProperty: 'total',
			idProperty: 'id',
			remoteSort: false,

			fields: [
					{name: 'id'},
					{name: 'name'}
					],
			
			proxy: new Ext.data.HttpProxy({
				url: window.webRoot + 'rest/projects'
			})
		}),
		this.store.on('load', function(store, recs) {
			me.setDefaultValue();
		});

		this.store.load();

		Ext.app.ux.ProjectSelector.superclass.initComponent.call(this);
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
		return 'ProjectSelector';
	}
});
