/**
 * @class Ext.app.avp.SiteSelector
 * @extends Ext.app.common.ComboBox
 * 创建地点选择框。
 */
Ext.ns('Ext.app.avp');
Ext.app.avp.SiteSelector = Ext.extend(Ext.app.common.ComboBox, {
	width: 360,
	valueField: 'key',
	displayField: 'name',
   
	constructor: function(config){
		Ext.app.avp.SiteSelector.superclass.constructor.call(this, config);
        Ext.apply(this, config);
    },

	initComponent : function(){
		var me = this;
		this.store = new Ext.data.JsonStore({
			root: 'data',
			totalProperty: 'total',
			idProperty: 'key',
			remoteSort: false,

			fields: [
					{name: 'key'},
					{name: 'name'}
					],
			
			proxy: new Ext.data.HttpProxy({
				url: window.webRoot + 'Confs/Type/Site'
			})
		});
		
		this.store.on('load', function(store, recs) {
			store.insert(0, new Ext.data.Record({
				id: 0,
				key: '*',
				name: '*'
			}));
			me.setDefaultValue(this.defaultValue);
		});

		this.store.load();

		Ext.app.avp.SiteSelector.superclass.initComponent.call(this);
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
		return 'SiteSelector';
	}
});
