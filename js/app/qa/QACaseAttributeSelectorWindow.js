/**
 * @class Ext.app.qa.QACaseAttributeSelectorWindow
 * @extends Ext.app.common.Window
 * 列表。
 */
Ext.ns('Ext.app.qa');
Ext.app.qa.QACaseAttributeSelectorWindow = Ext.extend(Ext.app.common.Window, {
	name: 'qaCaseAttributeWin',
	closeAction:'hide',
	title: '选择案例属性',
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
		this.items = [new Ext.app.qa.QACaseAttributeSelectorGrid()];
		Ext.app.qa.QACaseAttributeSelectorWindow.superclass.initComponent.call(this);
	},
	
	reset: function() {
		this.find('name', 'qaCaseAttributeSelector')[0].reset();
	},
	
	clearData: function() {
		this.find('name', 'qaCaseAttributeSelector')[0].clearData();
	},

	getKey: function() {
		return this.name ? this.name : 'qaCaseAttributeWin';
	},

	getVal: function() {
		return this.find('name', 'qaCaseAttributeSelector')[0].getVal();
	},

	setVal: function(data) {
		this.find('name', 'qaCaseAttributeSelector')[0].setVal(data);
	},

	getRawVal: function() {
		return this.find('name', 'qaCaseAttributeSelector')[0].getRawVal();;
	},

	getTxt: function() {
		return this.title;
	},

	getUXType: function() {
		return 'QACaseAttributeSelectorWindow';
	}
});
