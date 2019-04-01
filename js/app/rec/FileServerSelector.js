/**
 * @class Ext.app.rec.FileServerSelector
 * @extends FileServerSelector
 * 创建文件服务器选择框。
 */
Ext.ns('Ext.app.rec');
Ext.app.rec.FileServerSelector = Ext.extend(Ext.app.common.ComboBox, {
	width: 200,
	valueField: 'id',
	displayField: 'desc',
   
	constructor: function(config){
		Ext.app.rec.FileServerSelector.superclass.constructor.call(this, config);
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
				   {name: 'name'},
				   {name: 'desc'}
			],
			
			proxy: new Ext.data.HttpProxy({
				url: window.webRoot + 'FilePaths'
			})
		}),

		this.store.on('load', function(store, recs) {
			me.setDefaultValue();
		});

		this.store.load();

		Ext.app.rec.FileServerSelector.superclass.initComponent.call(this);
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
		return 'FileServerSelector';
	}
});
