/**
 * @class Ext.app.mgr.AgentUserSelectorWindow
 * @extends Ext.app.common.Window
 * 列表。
 */
Ext.ns('Ext.app.mgr');
Ext.app.mgr.WechatTempSelectorWindow = Ext.extend(Ext.app.common.Window, {
	name: 'wechatTempWin',
	closeAction:'hide',
	title: '选择微信模版',
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
		this.items = [new Ext.app.mgr.WechatTempSelectorGrid({
			showPaging: false
		})];
		Ext.app.mgr.WechatTempSelectorWindow.superclass.initComponent.call(this);
	},
	
	reset: function() {
		this.find('name', 'wechatTempSelector')[0].reset();
	},
	
	clearData: function() {
		this.find('name', 'wechatTempSelector')[0].clearData();
	},

	getKey: function() {
		return this.name ? this.name : 'wechatTempWin';
	},

	getVal: function() {
		return this.find('name', 'wechatTempSelector')[0].getVal();
	},

	setVal: function(data) {
		this.find('name', 'wechatTempSelector')[0].setVal(data);
	},

	getRawVal: function() {
		return this.find('name', 'wechatTempSelector')[0].getRawVal();;
	},

	getTxt: function() {
		return this.title;
	},

	getUXType: function() {
		return 'WechatTempSelectorWindow';
	}
});
