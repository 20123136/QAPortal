/**
 * @class Ext.app.mgr.OBGroupSelector
 * @extends OBGroupSelector
 * 创建数据源选择框。
 */
Ext.ns('Ext.app.mgr');
Ext.app.mgr.SkillGroupSelector = Ext.extend(Ext.app.common.ComboBox, {
	fieldLabel: '技能组',
	name: 'groupid',
	valueField: 'id',
	displayField: 'name',
	typeAhead: true,
	forceSelection: true, 
	editable: false,
	mode: 'local',
	triggerAction: 'all',
	selectOnFocus:true,
	
	setDefaultValue: function() {
		if(!this.defaultValue) {
			if(this.store.getCount() > 0) {
				var rec = this.store.getAt(0);
				this.setValue(rec.data.value);
			}
		} else {
			this.setValue(defaultValue);
		}
	},
   
	constructor: function(config){
		Ext.app.mgr.SkillGroupSelector.superclass.constructor.call(this, config);
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
					{name: 'id'}
					],
			
			proxy: new Ext.data.HttpProxy({
				url: window.webRoot + 'OBGroups'//换成技能组接口
			})
		}),

		this.store.on('load', function(store, recs) {
			me.setDefaultValue();
		});

		this.store.load();

		Ext.app.mgr.SkillGroupSelector.superclass.initComponent.call(this);
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
		return 'SkillGroupSelector';
	}
});
