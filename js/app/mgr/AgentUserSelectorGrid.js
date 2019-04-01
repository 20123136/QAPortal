/**
 * @class Ext.app.mgr.AgentUserSelectorGrid
 * @extends Ext.app.common.Grid
 * 座席列表。
 */
Ext.ns('Ext.app.mgr');

Ext.app.mgr.AgentUserSelectorGrid = Ext.extend(Ext.app.common.Grid, {
	name: 'agentUserSelector',
	autoScroll: true,
	border: false,
	stripeRows : true,
	loadMask: true,
	viewConfig: {
		forceFit:true
	},
	height: 365,
	width: '100%',
	
	constructor: function(config){
		Ext.app.mgr.AgentUserSelectorGrid.superclass.constructor.call(this, config);
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

		this.showPaging = false;

		this.columns = [
			sm,
			{
				header   : '编号',
				width    : .2,
				sortable : true,
				dataIndex: 'no'
			},
			{
				header   : '名称',
				width    : .2,
				sortable : true,
				dataIndex: 'name'
			},
			{
				header   : '部门',
				width    : .2,
				sortable : true,
				dataIndex: 'deptName'
			}
		];

		this.selModel = sm;

		var toolbar = new Ext.Toolbar({
			width: '100%'
		});
		
		toolbar.add('编号:&nbsp;&nbsp;');
		toolbar.add(
			new Ext.form.TextField({
				name: 'txtAgentNo',
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
				name: 'txtUserName',
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
		toolbar.add('部门:&nbsp;&nbsp;');
		toolbar.add(
			new Ext.app.ux.DepartmentSelector({
				fieldLabel: '部门',
				name: 'cmbDeptId',
				hiddenName: 'deptId'
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
							obj.ownerCt.find('name', 'txtAgentNo')[0].setValue('');   
							obj.ownerCt.find('name', 'txtUserName')[0].setValue('');   
							obj.ownerCt.find('name', 'cmbDeptId')[0].setValue('');   
							obj.ownerCt.ownerCt.getStore().load({params:{start:0}});
						}
					}
			})
		);

		this.tbar = toolbar;

		this.store = new Ext.data.JsonStore({
			root: 'data',
			totalProperty: 'total',
			remoteSort: false,

			fields: [
			   {name: 'name'},
			   {name: 'no'},
			   {name: 'deptName'},
			   {name: 'status'}
			],
			
			proxy: new Ext.data.HttpProxy({
				url: window.webRoot + '/User/PrivilegeKey/AGENT_FLAG'
			})
		});

		this.store.on('beforeload', function(obj) {
			obj.removeAll();
			var no = me.getTopToolbar().find('name', 'txtAgentNo')[0].getValue(); 
			var name = me.getTopToolbar().find('name', 'txtUserName')[0].getValue(); 
			var deptId = me.getTopToolbar().find('name', 'cmbDeptId')[0].getValue(); 
			obj.baseParams = {'no': no, 'name': name, 'deptId': deptId, 'status': 0, 'start':0, 'limit': 500};
		});

		this.store.on('load', function(obj) {
			var recs = new Array();
			Ext.each(me.val, function(val) {
				var idx = obj.find('no', val);
				var rec = obj.getAt(idx);
				if(rec) {
					recs.push(rec);
				}
			});
			me.getSelectionModel().selectRecords(recs);
		});

		Ext.app.mgr.AgentUserSelectorGrid.superclass.initComponent.call(this);
	},

	reset: function() {
		this.getTopToolbar().find('name', 'txtAgentNo')[0].setValue('');   
		this.getTopToolbar().find('name', 'txtUserName')[0].setValue('');   
		this.getTopToolbar().find('name', 'cmbDeptId')[0].setValue('');
		this.getStore().load({params:{start:0}});
		this.getSelectionModel().clearSelections();
	},

	clearData: function() {
		this.getSelectionModel().clearSelections();
	},

	getKey: function() {
		return this.name ? this.name : 'agentUserSelector';
	},

	getVal: function() {
		var nos = new Array();
		Ext.each(this.getSelectionModel().getSelections(), function(rec) {
			nos.push(rec.get('no'));
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
		return 'AgentUserSelectorGrid';
	}
});
