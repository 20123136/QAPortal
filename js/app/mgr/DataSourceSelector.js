/**
 * @class Ext.app.mgr.DataSourceSelector
 * @extends DataSourceSelector
 * 创建数据源选择框。
 */
Ext.ns('Ext.app.mgr');
Ext.app.mgr.DataSourceSelector = Ext.extend(Ext.app.common.ComboBox, {
	width: 200,
	valueField: 'name',
	displayField: 'description',
   
	constructor: function(config){
		Ext.app.mgr.DataSourceSelector.superclass.constructor.call(this, config);
        Ext.apply(this, config);
    },

	initComponent : function(){
		var me = this;
		this.store = new Ext.data.JsonStore({
			root: 'data',
			totalProperty: 'total',
			idProperty: 'name',
			remoteSort: false,

			fields: [
					{name: 'name'},
					{name: 'description'}
					],
			
			proxy: new Ext.data.HttpProxy({
				url: window.webRoot + 'DataSources'
			})
		}),

		this.store.on('load', function(store, recs) {
			me.setDefaultValue();
		});

		this.store.load();

		Ext.app.mgr.DataSourceSelector.superclass.initComponent.call(this);
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
		return 'DataSourceSelector';
	}
});
