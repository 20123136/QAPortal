/**
 * @class Ext.app.qa.QACaseTypeSelectorWindow
 * @extends Ext.app.common.Window
 * 列表。
 */
Ext.ns('Ext.app.qa');
Ext.app.qa.QACaseTypeSelectorWindow = Ext.extend(Ext.app.common.Window, {
	name: 'qaCaseTypeWin',
	closeAction:'hide',
	title: '选择案例类型',
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
		this.items = [new Ext.app.qa.QACaseTypeSelectorGrid()];
		Ext.app.qa.QACaseTypeSelectorWindow.superclass.initComponent.call(this);
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
		return 'QACaseTypeSelectorWindow';
	}
});
