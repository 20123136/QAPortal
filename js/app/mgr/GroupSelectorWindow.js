/**
 * @class Ext.app.mgr.GroupSelectorWindow
 * @extends Ext.app.common.Window
 * 列表。
 */
Ext.ns('Ext.app.mgr');
Ext.app.mgr.GroupSelectorWindow = Ext.extend(Ext.app.common.Window, {
	name: 'groupWin',
	closeAction:'hide',
	title: '选择技能组',
	iconCls: 'skillbtn',
	buttons: [
		{
			text: '确&nbsp;定',
			handler: function() {
				this.ownerCt.ownerCt.hide();
			}
		},{
			text: '取&nbsp;消',
			handler: function() {
				this.ownerCt.ownerCt.clearData();
				this.ownerCt.ownerCt.hide();
			}
		}
	],
	
	initComponent : function(){
		this.items = [
			new Ext.app.mgr.GroupSelectorGrid({
				name: 'groupSelector'
			})
		];
		Ext.app.mgr.GroupSelectorWindow.superclass.initComponent.call(this);
	},
	
	reset: function() {
		this.find('name', 'groupSelector')[0].reset();
	},
	
	clearData: function() {
		this.find('name', 'groupSelector')[0].clearData();
	},

	getKey: function() {
		return this.name ? this.name : 'groupWin';
	},

	getVal: function() {
		return this.find('name', 'groupSelector')[0].getVal();
	},

	setVal: function(data) {
		this.find('name', 'groupSelector')[0].setVal(data);
	},

	getRawVal: function() {
		return this.find('name', 'groupSelector')[0].getRawVal();;
	},

	getTxt: function() {
		return this.title;
	},

	getUXType: function() {
		return 'GroupSelectorWindow';
	}
});
