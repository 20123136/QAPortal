/**
 * @class Ext.app.mgr.RoutePointSelectorGrid
 * @extends Ext.app.common.Grid
 * 技能组列表。
 */
Ext.ns('Ext.app.mgr');

Ext.app.mgr.RoutePointSelectorGrid = Ext.extend(Ext.app.common.Grid, {
	name: 'rpSelector',
	autoScroll: true,
	border: false,
	stripeRows : true,
	loadMask: true,
	viewConfig: {
		forceFit:true
	},
	height: 365,
	width: '100%',

	showPaging: false,

	constructor: function(config){
		Ext.app.mgr.RoutePointSelectorGrid.superclass.constructor.call(this, config);
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
				} else {
					var isSelected = this.isSelected(rowIndex);
					if(isSelected){
						this.deselectRow(rowIndex);
					} else if (!isSelected || this.getCount() > 1){
						this.selectRow(rowIndex, true);
						view.focusRow(rowIndex);
					}
				}
			}
		});

		sm.grid = this;

		this.showPaging = true;

		this.columns = [
			sm,
			{
				header   : '号码',
				width    : .2,
				sortable : true,
				dataIndex: 'name'
			},
			{
				header   : '名称',
				width    : .2,
				sortable : true,
				dataIndex: 'description'
			}
		];

		this.selModel = sm;

		var toolbar = new Ext.Toolbar({
			width: '100%'
		});
		
		toolbar.add('号码:&nbsp;&nbsp;');
		toolbar.add(
			new Ext.form.TextField({
				name: 'txtRoutePointNo',
				width: 120,
				enableKeyEvents: true,
				listeners: 
					{'keypress': function(obj, e) {
							if (e.getKey() == e.ENTER) { 
								obj.ownerCt.find('name', 'btnSearch')[0].fireEvent('click', obj);   
							}   
						}
					}
			})
		);
		toolbar.add('-');
		toolbar.add('名称:&nbsp;&nbsp;');
		toolbar.add(
			new Ext.form.TextField({
				name: 'txtRoutePointName',
				width: 120,
				enableKeyEvents: true,
				listeners: 
					{'keypress': function(obj, e) {
							if (e.getKey() == e.ENTER) { 
								obj.ownerCt.find('name', 'btnSearch')[0].fireEvent('click', obj);   
							}   
						}
					}
			})
		);
		toolbar.add('-');
		toolbar.add(
			new Ext.Toolbar.Button({
				name: 'btnSearch',
				iconCls: 'searchbtn',
				text: '查询',
				listeners: 
					{'click': function(obj, e) {
							obj.ownerCt.ownerCt.getStore().load({params:{start:0}});
						}
					}
			})
		);
		toolbar.add('-');
		toolbar.add(
			new Ext.Toolbar.Button({
				name: 'btnListAll',
				iconCls: 'gridbtn',
				text: '显示全部',
				listeners: 
					{'click': function(obj, e) {
							obj.ownerCt.find('name', 'txtRoutePointNo')[0].setValue('');   
							obj.ownerCt.find('name', 'txtRoutePointName')[0].setValue('');   
							obj.ownerCt.ownerCt.getStore().load({params:{start:0}});
						}
					}
			})
		);

		this.tbar = toolbar;

		this.store = new Ext.data.JsonStore({
			root: 'data',
			totalProperty: 'totalCount',
			remoteSort: false,

			fields: [
			   {name: 'id'},
			   {name: 'name'},
			   {name: 'description'},
			   {name: 'status'}
			],
			
			proxy: new Ext.data.HttpProxy({
				url: window.webRoot + 'data/route.json'
			})
		});

		this.store.on('beforeload', function(obj) {
			var name = me.getTopToolbar().find('name', 'txtRoutePointNo')[0].getValue(); 
			var desc = me.getTopToolbar().find('name', 'txtRoutePointName')[0].getValue(); 
			obj.removeAll();
			obj.baseParams = {'name': name, 'description': desc, 'status': 0};
		});

		Ext.app.mgr.RoutePointSelectorGrid.superclass.initComponent.call(this);
	},

	reset: function() {
		this.getTopToolbar().find('name', 'txtRoutePointNo')[0].setValue('');   
		this.getTopToolbar().find('name', 'txtRoutePointName')[0].setValue('');   
		this.getStore().load({params:{start:0}});
		this.getSelectionModel().clearSelections();
	},

	clearData: function() {
		this.getSelectionModel().clearSelections();
	},

	getKey: function() {
		return this.name ? this.name : 'rpSelector';
	},

	getVal: function() {
		var nos = new Array();
		Ext.each(this.getSelectionModel().getSelections(), function(rec) {
			nos.push(rec.get('name'));
		});
		return nos;
	},

	setVal: function(data) {
		var grid = this;
		if(this.rendered) {
			var recs = new Array();
			Ext.each(data, function(val) {
				var idx = grid.getStore().find('name', val);
				var rec = grid.getStore().getAt(idx);
				if(rec) {
					recs.push(rec);
				}
			});
			grid.getSelectionModel().selectRecords(recs);
		}
	},

	getRawVal: function() {
		var names = new Array();
		Ext.each(this.getSelectionModel().getSelections(), function(rec) {
			names.push(rec.get('description'));
		});
		return names;
	},

	getTxt: function() {
		return this.fieldLabel;
	},

	getUXType: function() {
		return 'RoutePointSelectorGrid';
	}
});
