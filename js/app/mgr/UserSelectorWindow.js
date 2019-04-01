/**
 * @class Ext.app.mgr.AgentUserSelectorWindow
 * @extends Ext.app.common.Window
 * 列表。
 */
Ext.ns('Ext.app.mgr');
Ext.app.mgr.UserSelectorWindow = Ext.extend(Ext.app.common.Window, {
	name: 'userWin',
	closeAction:'hide',
	title: '选择人员',
	iconCls: 'agentbtn',
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
		this.items = [new Ext.app.mgr.UserSelectorGrid()];
		Ext.app.mgr.AgentUserSelectorWindow.superclass.initComponent.call(this);
	},
	
	reset: function() {
		this.find('name', 'userSelector')[0].reset();
	},
	
	clearData: function() {
		this.find('name', 'userSelector')[0].clearData();
	},

	getKey: function() {
		return this.name ? this.name : 'userWin';
	},

	getVal: function() {
		return this.find('name', 'userSelector')[0].getVal();
	},

	setVal: function(data) {
		this.find('name', 'userSelector')[0].setVal(data);
	},

	getRawVal: function() {
		return this.find('name', 'userSelector')[0].getRawVal();;
	},

	getTxt: function() {
		return this.title;
	},

	getUXType: function() {
		return 'UserSelectorWindow';
	}
});
