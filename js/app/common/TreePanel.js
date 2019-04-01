/**
 * @class Ext.app.common.TreePanel
 * @extends Ext.tree.TreePanel
 * 列表。
 */
Ext.ns('Ext.app.common');
Ext.app.common.TreePanel = Ext.extend(Ext.tree.TreePanel, {
	split: true,
	autoScroll: true,
	border: false,
	rootVisible: false,
	lines: false,
	useArrows: true,
	root: new Ext.tree.AsyncTreeNode(),

	constructor: function(config){
		Ext.app.common.TreePanel.superclass.constructor.call(this, config);
        Ext.apply(this, config);
    },
	
	initComponent : function(){
		Ext.app.common.TreePanel.superclass.initComponent.call(this);
	}
});
