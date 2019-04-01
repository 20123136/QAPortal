/**
 * @class Ext.app.qa.QAStatusSelectorWindow
 * @extends Ext.app.common.Window
 * 列表。
 */
Ext.ns('Ext.app.qa');
Ext.app.qa.QAStatusSelectorWindow = Ext.extend(Ext.app.common.Window, {
	name: 'qaStatusWin',
	closeAction:'hide',
	title: '选择质检状态',
	iconCls: 'dictbtn',
	roleId: '',
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
		this.items = [new Ext.app.qa.QAStatusSelectorGrid()];
		Ext.app.qa.QAStatusSelectorWindow.superclass.initComponent.call(this);
	},
	
	reset: function() {
		this.find('name', 'qaStatusSelector')[0].reset();
	},
	
	clearData: function() {
		this.find('name', 'qaStatusSelector')[0].clearData();
	},

	getKey: function() {
		return this.name ? this.name : 'qaStatusWin';
	},

	getVal: function() {
		return this.find('name', 'qaStatusSelector')[0].getVal();
	},

	setVal: function(data) {
		this.find('name', 'qaStatusSelector')[0].setVal(data);
	},

	getRawVal: function() {
		return this.find('name', 'qaStatusSelector')[0].getRawVal();;
	},

	getTxt: function() {
		return this.title;
	},

	getUXType: function() {
		return 'QAStatusSelectorWindow';
	}
});
