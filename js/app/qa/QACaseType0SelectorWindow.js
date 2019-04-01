/**
 * @class Ext.app.qa.QACaseType0SelectorWindow
 * @extends Ext.app.common.Window
 * 列表。
 */
Ext.ns('Ext.app.qa');
Ext.app.qa.QACaseType0SelectorWindow = Ext.extend(Ext.app.common.Window, {
	name: 'qaCaseTypeWin',
	closeAction:'hide',
	title: '选择案例大类',
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
		this.items = [new Ext.app.qa.QACaseType0SelectorGrid()];
		Ext.app.qa.QACaseType0SelectorWindow.superclass.initComponent.call(this);
	},

	setGroupTypeId: function(groupTypeId) {
		this.items.items[0].groupTypeId = groupTypeId;
	},
	
	reset: function() {
		this.find('name', 'qaCaseTypeSelector')[0].reset();
	},
	
	clearData: function() {
		this.find('name', 'qaCaseTypeSelector')[0].clearData();
	},

	getKey: function() {
		return this.name ? this.name : 'qaCaseTypeWin';
	},

	getVal: function() {
		return this.find('name', 'qaCaseTypeSelector')[0].getVal();
	},

	setVal: function(data) {
		this.find('name', 'qaCaseTypeSelector')[0].setVal(data);
	},

	getRawVal: function() {
		return this.find('name', 'qaCaseTypeSelector')[0].getRawVal();;
	},

	getTxt: function() {
		return this.title;
	},

	getUXType: function() {
		return 'QACaseType0SelectorWindow';
	}
});
