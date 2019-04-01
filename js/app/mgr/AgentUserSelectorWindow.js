/**
 * @class Ext.app.mgr.AgentUserSelectorWindow
 * @extends Ext.app.common.Window
 * 列表。
 */
Ext.ns('Ext.app.mgr');
Ext.app.mgr.AgentUserSelectorWindow = Ext.extend(Ext.app.common.Window, {
	name: 'agentUserWin',
	closeAction:'hide',
	title: '选择座席',
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
				this.ownerCt.ownerCt.justClose = true;
				this.ownerCt.ownerCt.hide();
			}
		}
	],
	
	initComponent : function(){
		this.items = [new Ext.app.mgr.AgentUserSelectorGrid({
			showPaging: false
		})];
		Ext.app.mgr.AgentUserSelectorWindow.superclass.initComponent.call(this);
	},
	
	reset: function() {
		this.find('name', 'agentUserSelector')[0].reset();
	},
	
	clearData: function() {
		this.find('name', 'agentUserSelector')[0].clearData();
	},

	getKey: function() {
		return this.name ? this.name : 'agentUserWin';
	},

	getVal: function() {
		return this.find('name', 'agentUserSelector')[0].getVal();
	},

	setVal: function(data) {
		this.find('name', 'agentUserSelector')[0].setVal(data);
	},

	getRawVal: function() {
		return this.find('name', 'agentUserSelector')[0].getRawVal();;
	},

	getTxt: function() {
		return this.title;
	},

	getUXType: function() {
		return 'AgentUserSelectorWindow';
	}
});
