/**
 * @class Ext.app.common.Window
 * @extends Ext.Window
 * 列表。
 */
Ext.ns('Ext.app.common');
Ext.app.common.Window = Ext.extend(Ext.Window, {
	modal: true,
	plain: true,
	buttons: [
		{
			text: '保&nbsp;存',
			handler: function() {
				this.ownerCt.hide();
			}
		},{
			text: '取&nbsp;消',
			handler: function() {
				this.ownerCt.hide();
			}
		}
	],
	
	initComponent : function(){
		Ext.app.common.Window.superclass.initComponent.call(this);
	}
});
