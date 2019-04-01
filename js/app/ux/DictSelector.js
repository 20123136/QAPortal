/**
 * @class Ext.app.ux.DictSelector
 * @extends Ext.form.ComboBox
 * 创建数据字典选择框。
 */
Ext.ns('Ext.app.ux');

Ext.app.ux.DictSelector = Ext.extend(Ext.form.ComboBox, {
	width: 200,
	valueField: 'value',
	displayField: 'name',
	typeAhead: true,
	forceSelection: true,
	editable: false,
	mode: 'local',
	triggerAction: 'all',
	selectOnFocus:true,
	showEmpty: false,
	
	setDefaultValue: function(defaultValue) {
		if(defaultValue) {
			if(defaultValue == 'default') {
				if(this.store.getCount() > 0) {
					var rec = this.store.getAt(0);
					this.setValue(rec.data.value);
				}
			} else {
				this.setValue(defaultValue);
			}
		}
	},

	constructor: function(config){
		Ext.app.ux.DictSelector.superclass.constructor.call(this, config);
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
					{name: 'value'}
					],
			
			proxy: new Ext.data.HttpProxy({
				url: window.webRoot + 'Dicts/Type/' + this.dictType
			})
		}),

		this.store.on('load', function(store, recs) {
			if(me.showEmpty) {
				store.insert(0, new Ext.data.Record({
					id: 0,
					name: '全部',
					value: ''
				}));
			}
			me.setDefaultValue(this.defaultValue);
		});

		this.store.load();

		Ext.app.ux.DictSelector.superclass.initComponent.call(this);
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
		return 'DictSelector';
	}
});
