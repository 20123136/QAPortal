/**
 * @class Ext.app.ux.TenantSelector
 * @extends Ext.form.ComboBox
 * 创建命名空间选择框。
 */
Ext.ns('Ext.app.ux');
Ext.app.ux.NamespaceSelector = Ext.extend(Ext.form.ComboBox, {
	width: 200,
	valueField: 'id',
	displayField: 'name',
	typeAhead: true,
	forceSelection: true,
	editable: false,
	mode: 'local',
	triggerAction: 'all',
	selectOnFocus:true,
	
	setDefaultValue: function(defaultValue) {
		if(defaultValue) {
			if(defaultValue == 'default') {
				if(this.store.getCount() > 0) {
					var rec = this.store.getAt(0);
					this.setValue(rec.data.id);
				}
			} else {
				this.setValue(defaultValue);
			}
		}
	},
   
	constructor: function(config){
		Ext.app.ux.NamespaceSelector.superclass.constructor.call(this, config);
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
				url: window.webRoot + 'rest/namespaces'
			})
		}),
		this.store.on('load', function(store, recs) {
			me.setDefaultValue(this.defaultValue);
		});

		this.store.load();

		Ext.app.ux.NamespaceSelector.superclass.initComponent.call(this);
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
		return 'NamespaceSelector';
	}
});
