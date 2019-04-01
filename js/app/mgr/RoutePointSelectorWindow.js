/**
 * @class Ext.app.mgr.RoutePointSelectorWindow
 * @extends Ext.app.common.Window
 * 列表。
 */
Ext.ns('Ext.app.mgr');
Ext.app.mgr.RoutePointSelectorWindow = Ext.extend(Ext.app.common.Window, {
	name: 'rpWin',
	closeAction:'hide',
	title: '选择路由点',
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
			new Ext.app.mgr.RoutePointSelectorGrid({
				name: 'rpSelector'
			})
		];
		Ext.app.mgr.RoutePointSelectorWindow.superclass.initComponent.call(this);
	},
	
	reset: function() {
		this.find('name', 'rpSelector')[0].reset();
	},
	
	clearData: function() {
		this.find('name', 'rpSelector')[0].clearData();
	},

	getKey: function() {
		return this.name ? this.name : 'rpWin';
	},

	getVal: function() {
		return this.find('name', 'rpSelector')[0].getVal();
	},

	setVal: function(data) {
		this.find('name', 'rpSelector')[0].setVal(data);
	},

	getRawVal: function() {
		return this.find('name', 'rpSelector')[0].getRawVal();;
	},

	getTxt: function() {
		return this.title;
	},

	getUXType: function() {
		return 'RoutePointSelectorWindow';
	}
});
