/**
 * @class Ext.app.avp.SkillSelector
 * @extends Ext.app.common.ComboBox
 * 创建技能选择框。
 */
Ext.ns('Ext.app.avp');
Ext.app.avp.SkillSelector = Ext.extend(Ext.app.common.ComboBox, {
	width: 360,
	valueField: 'key',
	displayField: 'name',
   
	constructor: function(config){
		Ext.app.avp.SkillSelector.superclass.constructor.call(this, config);
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
				url: window.webRoot + 'Conf/Skills'
			})
		});
		
		this.store.load();

		Ext.app.avp.SkillSelector.superclass.initComponent.call(this);
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
		return 'SkillSelector';
	}
});
