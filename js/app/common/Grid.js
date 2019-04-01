/**
 * @class Ext.app.common.Grid
 * @extends Ext.grid.GridPanel
 * 列表。
 */
Ext.ns('Ext.app.common');
Ext.app.common.Grid = Ext.extend(Ext.grid.GridPanel, {
	border: false,
	stripeRows : true,
	loadMask: true,
	viewConfig: {
		forceFit:true
	},
	
	constructor: function(config){
		Ext.app.common.Grid.superclass.constructor.call(this, config);
        Ext.apply(this, config);
    },
	
	initComponent : function(){
		if(this.showPaging) {
			this.bbar = new Ext.PagingToolbar({
				plugins: [new Ext.ui.plugins.ComboPageSize({ addToItem: false, prefixText: '每页', postfixText: '条'})],
				pageSize: 25,
				store: this.store,
				displayInfo: true,
				displayMsg: '当前显示第 <font color="blue">{0}</font> 到 <font color="blue">{1}</font> 条记录， 共 <font color="blue">{2}</font> 条记录',
				emptyMsg: "无记录"
			});
		}

		Ext.app.common.Grid.superclass.initComponent.call(this);
	}
});
