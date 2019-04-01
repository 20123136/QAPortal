/**
 * @class Ext.app.qa.QACaseTypeSelectorGrid
 * @extends Ext.app.common.Grid
 * 质检案例类型列表。
 */
Ext.ns('Ext.app.qa');

Ext.app.qa.QACaseTypeSelectorGrid = Ext.extend(Ext.app.common.Grid, {
	name: 'qaCaseTypeSelector',
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
		Ext.app.qa.QACaseTypeSelectorGrid.superclass.constructor.call(this, config);
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

		this.columns = [
			sm,
			{
				header   : '名称',
				width    : .3,
				sortable : true,
				dataIndex: 'name'
			},
			{
				header   : '描述',
				width    : .7,
				sortable : true,
				dataIndex: 'description'
			}
		];

		this.selModel = sm;

		this.store = new Ext.data.JsonStore({
			root: 'data',
			totalProperty: 'total',
			remoteSort: false,

			fields: [
			   {name: 'id'},
			   {name: 'name'},
			   {name: 'description'},
			   {name: 'value'},
			   {name: 'fatherId'},
			   {name: 'groupTypeId'},
			   {name: 'status'}
			],
			
			proxy: new Ext.data.HttpProxy({
				url: window.webRoot + 'QAItemGroup/CaseTypes'
			})
		});

		this.store.on('load', function(obj) {

			obj.each(function(record){
				if(record.get('groupTypeId') != me.groupTypeId) {
					obj.remove(record);
				}
				if(record.get('fatherId') == '0') {
					obj.remove(record);
				}
			});

			var recs = new Array();
			Ext.each(me.val, function(val) {
				var idx = obj.find('id', val);
				var rec = obj.getAt(idx);
				if(rec) {
					recs.push(rec);
				}
			});
			me.getSelectionModel().selectRecords(recs);
		});
    
		this.store.setDefaultSort('fatherId', 'asc');

		Ext.app.qa.QACaseTypeSelectorGrid.superclass.initComponent.call(this);
	},

	reset: function() {
		this.getStore().load();
		this.getSelectionModel().clearSelections();
	},

	clearData: function() {
		this.getSelectionModel().clearSelections();
	},

	getKey: function() {
		return this.name ? this.name : 'qaCaseTypeSelector';
	},

	getVal: function() {
		var nos = new Array();
		Ext.each(this.getSelectionModel().getSelections(), function(rec) {
			nos.push(rec.get('id'));
		});
		return nos;
	},

	setVal: function(data) {
		this.val = data;
	},

	getRawVal: function() {
		var names = new Array();
		Ext.each(this.getSelectionModel().getSelections(), function(rec) {
			names.push(rec.get('name'));
		});
		return names;
	},

	getTxt: function() {
		return this.fieldLabel;
	},

	getUXType: function() {
		return 'QACaseTypeSelectorGrid';
	}
});
