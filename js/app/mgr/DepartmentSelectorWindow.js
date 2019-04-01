/**
 * @class Ext.app.mgr.DepartmentSelectorWindow
 * @extends Ext.app.common.Window
 * 部门列表。
 */
Ext.ns('Ext.app.mgr');
Ext.app.mgr.DepartmentSelectorWindow = Ext.extend(Ext.app.common.Window, {
	name: 'deptWin',
	closeAction:'hide',
	title: '选择部门',
	iconCls: 'deptbtn',
	buttons: [
		{
			text: '确&nbsp;定',
			handler: function() {
				this.ownerCt.ownerCt.hide();
			}
		},{
			text: '取&nbsp;消',
			handler: function() {
				this.ownerCt.ownerCt.justClose = true;
				this.ownerCt.ownerCt.hide();
			}
		}
	],
	
	initComponent : function(){
		var me = this;
		this.items = [
			new Ext.app.mgr.DepartmentSelectorTreePanel({
				name: 'deptSelector',
				height: me.height-20,
				title: null,
				iconCls: null
			})
		];
		Ext.app.mgr.DepartmentSelectorWindow.superclass.initComponent.call(this);
	},
	
	reset: function() {
		this.find('name', 'deptSelector')[0].reset();
	},
	
	clearData: function() {
		this.find('name', 'deptSelector')[0].reset();
	},

	getKey: function() {
		return this.name ? this.name : 'deptWin';
	},

	getVal: function() {
		return this.find('name', 'deptSelector')[0].getVal();
	},

	setVal: function(data) {
		this.find('name', 'deptSelector')[0].setVal(data);
	},

	getRawVal: function() {
		return this.find('name', 'deptSelector')[0].getRawVal();;
	},

	getTxt: function() {
		return this.title;
	},

	getUXType: function() {
		return 'DepartmentSelectorWindow';
	}
});
