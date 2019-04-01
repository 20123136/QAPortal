/**
 * @class Ext.app.mgr.MenuGrid
 * @extends Ext.app.common.Grid
 * 菜单列表（只支持两级菜单）。
 */
Ext.ns('Ext.app.mgr');

Ext.app.mgr.MenuSelectorGrid = Ext.extend(Ext.app.common.Grid, {
	title: '菜单列表',
	iconCls: 'tablebtn',
	autoScroll: true,
	border: false,
	stripeRows : true,
	loadMask: true,
	viewConfig: {
		forceFit:true
	},
   
	showPaging: false,
	
	constructor: function(config){
		Ext.app.mgr.MenuSelectorGrid.superclass.constructor.call(this, config);
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
				header   : '一级菜单',
				width    : .2,
				sortable : true,
				dataIndex: 'fatherName',
				renderer : function(v, p, record, rowIndex){
					if(record.get('fatherId') != '0') {
						return '';
					} else {
						return '<b>' + record.get('name') + '</b>'
					}
				}
			},
			{
				header   : '二级菜单',
				width    : .2,
				sortable : true,
				dataIndex: 'name',
				renderer : function(v, p, record, rowIndex){
					if(record.get('fatherId') == '0') {
						return '';
					} else {
						return v
					}
				}
			},
			{
				header   : '说明',
				width    : .6,
				sortable : true,
				dataIndex: 'desc'
			}
		];
		
		this.selModel = sm;

		this.on('rowclick', function(grid, rowIndex, e) {
			var rec = grid.getStore().getAt(rowIndex);

			if(grid.getSelectionModel().isSelected(rowIndex)) {
				//当前行被选中
				var fatherId = rec.get('fatherId');
				if(fatherId != '0') {
					//当前行是二级菜单，则需要自动选中其所属的一级菜单
					var recs = new Array();
					grid.getStore().each(function(rec2){
						if(fatherId == rec2.get('id')) {
							recs.push(rec2);
						}
					});
					grid.getSelectionModel().selectRecords(recs, true);
				} else if(fatherId == '0') {
					//当前行是一级菜单，则自动选中其下的所有二级菜单
					var recs = new Array();
					grid.getStore().each(function(rec2){
						if(rec.get('id') == rec2.get('fatherId')) {
							recs.push(rec2);
						}
					});
					grid.getSelectionModel().selectRecords(recs, true);
				}
			} else {
				//当前行被取消选中
				var fatherId = rec.get('fatherId');
				if(fatherId != '0') {
					//当前行是二级菜单，则检查是否所属的一级菜单下已经没有被选中的记录
					var rowid = 0;
					var hasSelected = false;
					var idx = 0;
					grid.getStore().each(function(rec2){
						if(fatherId == rec2.get('id')) {
							rowid = idx;
						}
						if(fatherId == rec2.get('fatherId') && grid.getSelectionModel().isSelected(idx)) {
							hasSelected = true;
						}
						idx++;
					});
					if(!hasSelected) {
						grid.getSelectionModel().deselectRow(rowid);
					}
				} else if(fatherId == '0') {
					//当前行是一级菜单，则自动取消选中其下的所有二级菜单
					var idx = 0;
					grid.getStore().each(function(rec2){
						if(rec.get('id') == rec2.get('fatherId')) {
							grid.getSelectionModel().deselectRow(idx);
						}
						idx++;
					});
				}
			}
		});
		Ext.app.mgr.MenuSelectorGrid.superclass.initComponent.call(this);
	},

	reset: function() {
		this.getSelectionModel().clearSelections();
	},

	getKey: function() {
		return this.name ? this.name : 'menu';
	},
	
	getVal: function() {
		var ids = new Array();
		Ext.each(this.getSelectionModel().getSelections(), function(rec) {
			ids.push(rec.get('id'));
		});
		return ids;
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
	//	console.info(this.getView().getRows());
	//	this.getSelectionModel().selectRecords(data);
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
