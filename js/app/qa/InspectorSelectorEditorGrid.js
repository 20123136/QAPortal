/**
 * @class Ext.app.qa.InspectorSelectorEditorGrid
 * @extends Ext.app.common.Grid
 * 座席列表。
 */
Ext.ns('Ext.app.qa');

Ext.app.qa.InspectorSelectorEditorGrid = Ext.extend(Ext.app.common.EditorGrid, {
	name: 'inspectorSelector',
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

	roleId: '',

	showmode: 'Select',
	
	clicksToEdit: 1,

	constructor: function(config){
		Ext.app.qa.InspectorSelectorEditorGrid.superclass.constructor.call(this, config);
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

		if(this.showmode == 'AssignView') {
			this.columns.push({
				header   : '分配数量',
				width    : .2,
				sortable : true,
				dataIndex: 'assignNum'
			});
		}

		if(this.showmode == 'AssignEdit') {
			this.columns.push({
				header   : '分配数量',
				width    : .2,
				sortable : true,
				dataIndex: 'assignNum',
				editor: new Ext.form.NumberField({
					allowBlank: false,
					allowNegative: false,
					maxValue: 300
				})
			});
			
			this.on('beforeedit', function(obj) {
				var sm = obj.grid.getSelectionModel();
				if(!sm.isSelected(obj.row)) {
					sm.selectRow(obj.row, true);
				}
			});
			
			this.on('afteredit', function(obj) {
				obj.record.set('byMan', true);
			});
		}

		this.selModel = sm;

		var toolbar = new Ext.Toolbar({
			width: '100%'
		});
		
		toolbar.add('编号:&nbsp;&nbsp;');
		toolbar.add(
			new Ext.form.TextField({
				name: 'txtUserNo',
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
							obj.ownerCt.find('name', 'txtUserNo')[0].setValue('');   
							obj.ownerCt.find('name', 'txtUserName')[0].setValue('');   
							obj.ownerCt.find('name', 'cmbDeptId')[0].setValue('');   
							obj.ownerCt.ownerCt.getStore().load({params:{start:0}});
						}
					}
			})
		);

		this.tbar = toolbar;

		if(this.showmode == 'AssignEdit' || this.showmode == 'AssignView') {
			var strHtml = '<table width=700 border="0" cellpadding="0" cellspacing="0">' + 
							'<tr>' +
							'<td width=100% align=right>可分配数量（<span id=spanQASampleCount' + me.id + ' style="color:#66CC00;">0</span>）/已分配数量（<span id=spanQASampleSelectedCount' + me.id + ' style="color:#CC3333;">0</span>）</td>' + 
							'</tr>' +
						   '</table>';

			this.bbar = new Ext.Toolbar({
				items: [
					new Ext.form.Label({
						html: strHtml
					})
				]
			})
		}

		this.getSelectionModel().on('selectionchange', function(obj) {
			if(me.showmode == 'AssignView') {
				//如果当前行没有被选中则清空assingNum
				me.reloadSelectedNumAvg();
			} else if(me.showmode == 'AssignEdit') {
				me.reloadSelectedNumManual();
			}
		});

		this.getSelectionModel().on('rowselect', function(obj, idx, rec) {
		});

		this.getSelectionModel().on('rowdeselect', function(obj, idx, rec) {
		});

		this.store = new Ext.data.JsonStore({
			root: 'data',
			totalProperty: 'totalCount',
			remoteSort: false,

			fields: [
			   {name: 'id'},
			   {name: 'name'},
			   {name: 'no'},
			   {name: 'deptName'},
			   {name: 'assignNum'},
			   {name: 'status'}
			],
			
			proxy: new Ext.data.HttpProxy({
				url: window.webRoot + 'User/PrivilegeKey/' + me.privilegeKey
			})
		});

		this.store.on('beforeload', function(obj) {
			obj.removeAll();
			var no = me.getTopToolbar().find('name', 'txtUserNo')[0].getValue(); 
			var name = me.getTopToolbar().find('name', 'txtUserName')[0].getValue(); 
			var deptId = me.getTopToolbar().find('name', 'cmbDeptId')[0].getValue(); 
			obj.baseParams = {'no': no, 'name': name, 'deptId': deptId, 'status': 0};
		});

		this.store.on('load', function(obj) {
			var recs = new Array();
			var tmp;
			var selectedTotal = 0;
			Ext.each(me.val, function(val) {
				tmp = val.split(':');
				var idx = obj.find('id', tmp[0]);
				var rec = obj.getAt(idx);
				if(rec) {
					rec.set('assignNum', parseInt(tmp[1]));
					rec.set('byMan', true);
					recs.push(rec);
					selectedTotal += parseInt(tmp[1]);
				}
			});
			me.getSelectionModel().selectRecords(recs);
			Ext.getDom('spanQASampleCount'+me.id).innerHTML = me.sampleCount;
			Ext.getDom('spanQASampleSelectedCount'+me.id).innerHTML = selectedTotal;
		});

		Ext.app.qa.InspectorSelectorEditorGrid.superclass.initComponent.call(this);
	},

	reset: function() {
		this.getTopToolbar().find('name', 'txtUserNo')[0].setValue('');   
		this.getTopToolbar().find('name', 'txtUserName')[0].setValue('');   
		this.getTopToolbar().find('name', 'cmbDeptId')[0].setValue('');
		this.getStore().load({params:{start:0}});
		this.getSelectionModel().clearSelections();
	},

	clearData: function() {
		this.getSelectionModel().clearSelections();
	},

	getKey: function() {
		return this.name ? this.name : 'inspectorSelector';
	},

	getVal: function() {
		var nos = new Array();
		Ext.each(this.getSelectionModel().getSelections(), function(rec) {
			nos.push(rec.get('id') + ':' + rec.get('assignNum'));
		});
		return nos;
	},

	setVal: function(data) {
		this.val = data;
	},

	setSampleCount: function(sampleCount) {
		this.sampleCount = sampleCount;
	},

	getRawVal: function() {
		var names = new Array();
		Ext.each(this.getSelectionModel().getSelections(), function(rec) {
			names.push(rec.get('name') + ':' + rec.get('assignNum'));
		});
		return names;
	},

	getTxt: function() {
		return this.fieldLabel;
	},

	getUXType: function() {
		return 'InspectorSelectorEditorGrid';
	},

	reloadSelectedNumAvg : function() {
		//平均分配
		var me = this;
		var total = this.sampleCount;
		var count = this.getSelectionModel().getCount();
		var selectedTotal = 0;
		var assignCount = 0;
		var left = 0;
		if(count > 0) {
			assignCount = parseInt(total/count);
			left = total - assignCount * count;
			Ext.each(this.getSelectionModel().getSelections(), function(rec) {
				count--;
				if(count > 0) {
					if(count <= left) {
						rec.set('assignNum', assignCount + 1);
						selectedTotal = selectedTotal + assignCount + 1;
					} else {
						rec.set('assignNum', assignCount);
						selectedTotal = selectedTotal + assignCount;
					}
				} else {
					rec.set('assignNum', total - selectedTotal);
					selectedTotal = total;
				}
			});
			Ext.getDom('spanQASampleSelectedCount'+me.id).innerHTML = total;
		} else {
			Ext.getDom('spanQASampleSelectedCount'+me.id).innerHTML = 0;
		}
	},

	reloadSelectedNumManual : function() {
		//指定分配
		var me = this;
		var total = this.sampleCount;
		var count = this.getSelectionModel().getCount();
		var selectedTotal = 0;
		var assignCount = 0;
		var left = 0;

		//先计算已经手动分配的总数
		var manualTotal = 0;
		var autoCount = 0;
		if(count > 0) {
			Ext.each(this.getSelectionModel().getSelections(), function(rec) {
				if(!rec.get('assignNum')) {
					rec.set('assignNum', 0);
				}
				manualTotal += rec.get('assignNum') ? rec.get('assignNum') : 0;
			});
			Ext.getDom('spanQASampleSelectedCount' + me.id).innerHTML = manualTotal + selectedTotal;
		} else {
			Ext.getDom('spanQASampleSelectedCount' + me.id).innerHTML = 0;
		}
	}
});
