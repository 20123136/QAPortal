/**
 * @class Ext.app.mgr.PrivilegeTab
 * @extends Ext.app.common.Grid
 * 菜单列表（只支持两级菜单）。
 */
Ext.ns('Ext.app.mgr');

Ext.app.mgr.PrivilegeTab = Ext.extend(Ext.app.common.Tab, {
	constructor: function(config){
		Ext.app.mgr.PrivilegeTab.superclass.constructor.call(this, config);
        Ext.apply(this, config);
    },

	initComponent : function(){
		
		this.items = [
			new Ext.app.mgr.MenuSelectorGrid({
				height: 390,
				store: pri_menu_store
			}),
			new Ext.app.mgr.PrivilegeFunctionSelectorGrid({
				height: 390,
				store: pri_func_store
			}),
			new Ext.app.mgr.PrivilegeDepartmentSelectorPanel()
		];

		Ext.app.mgr.PrivilegeTab.superclass.initComponent.call(this);
	},

	reset: function() {
		for(var i=0; i < this.items.length; i++) {
			this.items.items[i].reset();
		}
		if(this.items.length > 0) this.setActiveTab(0);
	},

	getKey: function() {
		return this.name;
	},
	
	getVal: function() {
		var val = new Array();
		var obj;
		for(var i=0; i < this.items.length; i++) {
//			var key = this.items.items[i].getKey();
//			val[key] = this.items.items[i].getVal();
//			val.push(this.items.items[i].getVal())
		}
		//菜单权限
		obj = this.items.items[0].getVal();
		for(var j=0; j < obj.length; j++) {
			val.push('MENU:' + obj[j]);
		}
		//功能权限
		obj = this.items.items[1].getVal();
		for(var j=0; j < obj.length; j++) {
			val.push('FUNC:' + obj[j]);
		}
		//数据权限（部门）
		obj = this.items.items[2].getVal();
		for(var j=0; j < obj.length; j++) {
			val.push('DATA:DATA_DEPT:' + obj[j]);
		}

		console.log("value:" + val);
		return val;
	},
	
	setVal: function(data) {
		for(var i=0; i < this.items.length; i++) {
			this.items.items[i].setVal(data);
		}
	},
	
	getRawVal: function() {
		return this.getRawValue();
	},
	
	getTxt: function() {
		return this.fieldLabel;
	},

	getUXType: function() {
		return 'MenuSelectorGrid';
	}
});
