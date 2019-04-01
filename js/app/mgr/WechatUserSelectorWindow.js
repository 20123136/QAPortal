/**
 * @class Ext.app.mgr.AgentUserSelectorWindow
 * @extends Ext.app.common.Window
 * 列表。
 */
Ext.ns('Ext.app.mgr');
Ext.app.mgr.WechatUserSelectorWindow = Ext.extend(Ext.app.common.Window, {
	name: 'wechatUserWin',
	closeAction:'hide',
	title: '选择微信用户',
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
		this.items = [new Ext.app.mgr.WechatUserSelectorGrid({
			showPaging: false
		})];
		Ext.app.mgr.WechatUserSelectorWindow.superclass.initComponent.call(this);
	},
	
	reset: function() {
		this.find('name', 'wechatUserSelector')[0].reset();
	},
	
	clearData: function() {
		this.find('name', 'wechatUserSelector')[0].clearData();
	},

	getKey: function() {
		return this.name ? this.name : 'wechatUserWin';
	},

	getVal: function() {
		return this.find('name', 'wechatUserSelector')[0].getVal();
	},

	setVal: function(data) {
		this.find('name', 'wechatUserSelector')[0].setVal(data);
	},

	getRawVal: function() {
		return this.find('name', 'wechatUserSelector')[0].getRawVal();;
	},

	getTxt: function() {
		return this.title;
	},

	getUXType: function() {
		return 'WechatUserSelectorWindow';
	}
});
