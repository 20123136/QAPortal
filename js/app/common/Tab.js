/**
 * @class Ext.app.common.Tab
 * @extends Ext.TabPanel
 * 列表。
 */
Ext.ns('Ext.app.common');
Ext.app.common.Tab = Ext.extend(Ext.TabPanel, {
	enableTabScroll:true,
	deferredRender: false,
	defaults: {autoScroll:true},
	activeTab: 0,
	plugins: new Ext.ux.TabCloseMenu({
		closeTabText: '关闭当前页签',
		closeOtherTabsText: '关闭其它页签',
		closeAllTabsText: '关闭所有页签'
	}),
   
	constructor: function(config){
		Ext.app.common.Tab.superclass.constructor.call(this, config);
        Ext.apply(this, config);
    },
	
	initComponent : function(){
		Ext.app.common.Tab.superclass.initComponent.call(this);
	}
});
