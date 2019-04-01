/**
 * @class Ext.app.mgr.PrivilegeFunctionSelectorGrid
 * @extends Ext.app.common.Grid
 * 菜单列表（只支持两级菜单）。
 */
Ext.ns('Ext.app.mgr');

Ext.app.mgr.PrivilegeFunctionSelectorGrid = Ext.extend(Ext.app.common.Grid, {
	title: '功能列表',
	iconCls: 'keybtn',
	autoScroll: true,
	border: false,
	stripeRows : true,
	loadMask: true,
	viewConfig: {
		forceFit:true
	},
   
	showPaging: false,
   
	constructor: function(config){
		Ext.app.mgr.PrivilegeFunctionSelectorGrid.superclass.constructor.call(this, config);
        Ext.apply(this, config);
    },

	initComponent : function(){
		var me = this;
		
		var sm = new Ext.grid.CheckboxSelectionModel({
			handleMouseDown : function(g, rowIndex, e){   
				if(e.button !== 0 || this.isLocked()){   
					return;   
				}   
				var view = this.grid.getView();   
				if(e.shiftKey && !this.singleSelect && this.last !== false){   
					var last = this.last;   
					this.selectRange(last, rowIndex, e.ctrlKey);   
					this.last = last; // reset the last   
					view.focusRow(rowIndex);   
				}else{   
					var isSelected = this.isSelected(rowIndex);   
				if(isSelected){   
					this.deselectRow(rowIndex);   
				}else if(!isSelected || this.getCount() > 1){   
					this.selectRow(rowIndex, true);   
					view.focusRow(rowIndex);   
					}   
				}   
			} 
		});

		sm.grid = this;

		this.columns = [
			sm,
			{
				header   : '名称',
				width    : .2,
				sortable : true,
				dataIndex: 'name'
			},
			{
				header   : '分类',
				width    : .2,
				sortable : true,
				dataIndex: 'fatherName'
			},
			{
				header   : '说明',
				width    : .6,
				sortable : true,
				dataIndex: 'desc'
			}
		];
		
		this.selModel = sm;

		Ext.app.mgr.PrivilegeFunctionSelectorGrid.superclass.initComponent.call(this);
	},

	reset: function() {
		this.getSelectionModel().clearSelections();
	},

	getKey: function() {
		return this.name ? this.name : 'func';
	},
	
	setVal: function(data) {
		var grid = this;
		if(this.rendered) {
			var recs = new Array();
			Ext.each(data, function(val) {
				var idx = grid.getStore().find('id', val.privilegeId);
				var rec = grid.getStore().getAt(idx);
				if(rec) {
					recs.push(rec);
				}
			});
			grid.getSelectionModel().selectRecords(recs);
		}
	},
	
	getVal: function() {
		var ids = new Array();
		Ext.each(this.getSelectionModel().getSelections(), function(rec) {
			ids.push(rec.get('id'));
		});
		return ids;
	},
	
	getRawVal: function() {
		return this.getRawValue();
	},
	
	getTxt: function() {
		return this.fieldLabel;
	},

	getUXType: function() {
		return 'MenuSelectorGrid';
	}
});
