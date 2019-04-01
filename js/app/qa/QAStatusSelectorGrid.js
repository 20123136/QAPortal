/**
 * @class Ext.app.qa.QAStatusSelectorGrid
 * @extends Ext.app.common.Grid
 * 座席列表。
 */
Ext.ns('Ext.app.qa');

Ext.app.qa.QAStatusSelectorGrid = Ext.extend(Ext.app.common.Grid, {
	name: 'qaStatusSelector',
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
		Ext.app.qa.QAStatusSelectorGrid.superclass.constructor.call(this, config);
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
				dataIndex: 'desc'
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
			   {name: 'desc'},
			   {name: 'value'},
			   {name: 'typeId'},
			   {name: 'status'}
			],
			
			proxy: new Ext.data.HttpProxy({
				url: window.webRoot + 'Dicts/Type/QA_STATUS'
			})
		});

		this.store.on('load', function(obj) {
			var recs = new Array();
			Ext.each(me.val, function(val) {
				var idx = obj.find('value', val);
				var rec = obj.getAt(idx);
				if(rec) {
					recs.push(rec);
				}
			});
			me.getSelectionModel().selectRecords(recs);
		});

		Ext.app.qa.QAStatusSelectorGrid.superclass.initComponent.call(this);
	},

	reset: function() {
		this.getStore().load();
		this.getSelectionModel().clearSelections();
	},

	clearData: function() {
		this.getSelectionModel().clearSelections();
	},

	getKey: function() {
		return this.name ? this.name : 'qaStatusSelector';
	},

	getVal: function() {
		var nos = new Array();
		Ext.each(this.getSelectionModel().getSelections(), function(rec) {
			nos.push(rec.get('value'));
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
		return 'QAStatusSelectorGrid';
	}
});
