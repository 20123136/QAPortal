/**
 * @class Ext.app.common.Grid
 * @extends Ext.grid.GridPanel
 * 列表。
 */
Ext.ns('Ext.app.common');
Ext.app.common.NoPagingGrid = Ext.extend(Ext.grid.GridPanel, {
	border: false,
	stripeRows : true,
	loadMask: true,
	viewConfig: {
		forceFit:true
	},
	
	showPaging: true,

	constructor: function(config){
		Ext.app.common.NoPagingGrid.superclass.constructor.call(this, config);
        Ext.apply(this, config);
    },
	
	initComponent : function(){
		Ext.app.common.NoPagingGrid.superclass.initComponent.call(this);
	}
});
