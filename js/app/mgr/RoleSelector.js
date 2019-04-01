/**
 * @class Ext.app.mgr.RoleSelector
 * @extends RoleSelector
 * 创建角色选择框。
 */
Ext.ns('Ext.app.mgr');
Ext.app.mgr.RoleSelector = Ext.extend(Ext.app.common.ComboBox, {
	width: 200,
	valueField: 'id',
	displayField: 'name',
   
	constructor: function(config){
		Ext.app.mgr.RoleSelector.superclass.constructor.call(this, config);
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
				url: window.webRoot + 'Roles'
			})
		}),

		this.store.load();

		Ext.app.mgr.RoleSelector.superclass.initComponent.call(this);
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
		return 'RoleSelector';
	}
});
