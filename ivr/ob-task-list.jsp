<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
	response.setHeader("Pragma","No-cache");
	response.setHeader("Cache-Control","no-cache");
	response.setHeader("Expires","0");

	request.setCharacterEncoding("UTF-8");	
	String webRoot = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<html> 
<head>  
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>外拨任务管理</title>
  
    <link rel="stylesheet" type="text/css" href="../css/ext-all-notheme.css" />
    <link rel="stylesheet" type="text/css" href="../css/xtheme-gray.css" />
    <link rel="stylesheet" type="text/css" href="../ux/css/MultiSelect.css" />
    <link rel="stylesheet" type="text/css" href="../css/DateTimePicker.css" />

    <link rel="stylesheet" type="text/css" href="../css/icon.css" />
    <link rel="stylesheet" type="text/css" href="../css/common.css" />
 
    <script type="text/javascript" src="../js/ext-base.js"></script>
    <script type="text/javascript" src="../js/ext-all.js"></script>
    <script type="text/javascript" src="../js/ext-lang-zh_CN.js"></script>
    <script type="text/javascript" src="../js/ext-ui-combo-pagesize.js"></script>
    <script type="text/javascript" src="../ux/ColumnHeaderGroup.js"></script>
    <script type="text/javascript" src="../js/app/common/ComboBox.js"></script>
    <script type="text/javascript" src="../js/app/mgr/OBGroupSelector.js"></script>
    <script type="text/javascript" src="../js/app/mgr/SkillGroupSelector.js"></script>
    <script type="text/javascript" src="../js/app/mgr/RoleSelector.js"></script>
    <script type="text/javascript" src="../ux/MultiSelect.js"></script>
    <script type="text/javascript" src="../ux/ItemSelector.js"></script>
    <script type="text/javascript" src="../js/func.js"></script>
    <script type="text/javascript" src="../js/app/rec/Excel.js"></script>
    <script type="text/javascript" src="../ux/DateTimeField.js"></script>
	<script >
		var webRoot = '<%=webRoot%>';
	</script>
    <script type="text/javascript">
	var curId = 0;
	var win;
	var pagesize = 25;
	var grid;
	var userForm, tenantForm ;
	var actiontype = "";

	var fields = [
				   {name: 'id'},
				   {name: 'name'},
				   {name: 'desc'},
				   {
						name : 'beginTime', 
						convert: function(value, record) {
							return record.beginTimeStr;
						}
					},
				   {name: 'beginTimeStr'},
				   {name: 'endTime'},
				   {
						name : 'endTime', 
						convert: function(value, record) {
							return record.endTimeStr;
						}
					},
				   {name: 'endTimeStr'},
				   {name: 'nameListGroup'},
				   {name: 'nameListGroupId'},
				   {name: 'skillId'},
				   {name: 'menuNode'},
				   {name: 'maxPcalls'},
 				   {name: 'maxTryTimes'},
				   {name: 'status'},
				   {
						name : 'statusName',
						convert: function(value, record) {
							if(record.status == '0') {
								return "<font color=green>正常</font>";
							} else if(record.status == '1') {
								return "<font color=gray>异常</font>";
							}
						}
					}
				];

	Ext.onReady(function(){
		var store = new Ext.data.JsonStore({
			root: 'data',
			totalProperty: 'total',
			idProperty: 'id',
			remoteSort: false,

			fields: fields,
			
			proxy: new Ext.data.HttpProxy({
				url: window.webRoot + 'OBTasks'
			})

		}); 
    
 
		var toolbar = new Ext.Toolbar({
			width: '100%'
		});
		
		toolbar.addButton(new Ext.Toolbar.Button({
			id: 'btnReflash',
			text: '刷新',
			iconCls: 'refreshbtn',
			listeners: {
				'click': function(obj, e) {
					store.reload(store.lastOptions);
				}
		      }
		  })
	    );
	    toolbar.addSeparator();
	
		//START添加用户功能工具条button
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnAdd',
				text: '添加',
				iconCls: 'useraddbtn',
				listeners: {
					'click': function(obj, e) {
						actiontype = "add";
						win.setTitle("添加外拨任务");
						win.setIconClass("addbtn");
						userForm.form.reset();
						win.show(this);
					}
				}
			})
		);
		toolbar.addSeparator();
		//END添加用户功能工具条button
		
		//START编辑用户功能工具条button
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnEdit',
				text: '编辑',
				disabled: true,
				iconCls: 'usereditbtn',
				listeners: {
					'click': function(obj, e) {
						var rec = grid.getSelectionModel().getSelected();
						if(!rec) {
							Ext.Msg.alert('编辑外拨任务', '请选择要修改的外拨任务！');
						} else {
							actiontype = "edit";
							win.setTitle("编辑外拨任务");
							win.setIconClass("editbtn");
							userForm.form.reset();
							userForm.form.setValues(rec.data);
							win.show(this);
						}
					}
				}
			})
		);
		toolbar.addSeparator();
		//END编辑用户功能工具条button
		
		//START启用用户功能工具条button
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnEnable',
				text: '启用',
				disabled: true,
				iconCls: 'enablebtn',
				listeners: {
					'click': function(obj, e) {
						var rec = grid.getSelectionModel().getSelected();
						if(!rec) {
							Ext.Msg.alert('启用外拨任务', '请选择要启用的外拨任务！');
						} else {
							Ext.Msg.show({
								title:'启用外拨任务?',
								msg: '请再次确实是否要启用选中的外拨任务?',
								buttons: Ext.Msg.YESNOCANCEL,
								fn: function(btn, text) {
									if(btn == "yes") {
										var ids = new Array();
										Ext.each(grid.getSelectionModel().getSelections(), function(rec) {
											ids.push(rec.get('id'));
										});
										Ext.Ajax.request({
											url: window.webRoot + 'OBTask/enable',
											method: 'POST',
											params: {
												_method: 'PUT',
												id: ids
											},
											success: function(response,options) {
												var respText = Ext.util.JSON.decode(response.responseText);
												if(respText.code != 'OK') {
													Ext.Msg.alert('启用失败', respText.message + "（" + respText.code + "）");
												} else {
													var pgbar = grid.getBottomToolbar();
													var activePage = Math.ceil((pgbar.cursor + pgbar.pageSize) / pgbar.pageSize);
													var start = (activePage - 1) * pgbar.pageSize;
													store.load({params:{start:start, limit:pagesize}});
												}
											},
											failure: function() {
												Ext.Msg.alert('启用失败', '启用外拨任务失败！');
											}
										});
									}
								},
								icon: Ext.MessageBox.QUESTION
							});
						}
					}
				}
			})
		);
		toolbar.addSeparator();
		//END启用用户功能工具条button
		
		//START停用用户功能工具条button
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnDisable',
				text: '停用',
				disabled: true,
				iconCls: 'disablebtn',
				listeners: {
					'click': function(obj, e) {
						var rec = grid.getSelectionModel().getSelected();
						if(!rec) {
							Ext.Msg.alert('停用外拨任务', '请选择要停用的外拨任务！');
						} else {
							Ext.Msg.show({
								title:'停用外拨任务?',
								msg: '请再次确实是否要停用选中的外拨任务?',
								buttons: Ext.Msg.YESNOCANCEL,
								fn: function(btn, text) {
									if(btn == "yes") {
										var ids = new Array();
										Ext.each(grid.getSelectionModel().getSelections(), function(rec) {
											ids.push(rec.get('id'));
										});
										Ext.Ajax.request({
											url: window.webRoot + 'OBTask/disable',
											method: 'POST',
											params: {
												_method: 'PUT',
												id: ids
											},
											success: function(response,options) {
												var respText = Ext.util.JSON.decode(response.responseText);
												if(respText.code != 'OK') {
													Ext.Msg.alert('停用失败', respText.message + "（" + respText.code + "）");
												} else {
													var pgbar = grid.getBottomToolbar();
													var activePage = Math.ceil((pgbar.cursor + pgbar.pageSize) / pgbar.pageSize);
													var start = (activePage - 1) * pgbar.pageSize;
													store.load({params:{start:start, limit:pagesize}});
												}
											},
											failure: function() {
												Ext.Msg.alert('停用失败', '停用外拨任务失败！');
											}
										});
									}
								},
								icon: Ext.MessageBox.QUESTION
							});
						}
					}
				}
			})
		);
		toolbar.addSeparator();
		//END停用用户功能工具条button
		
		
		/** Start 查看明细详情 */
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnViewDetail',
				text: '明细详情',
				disabled: true,
				iconCls: 'commentbtn',
			//	disabled: true,
				listeners: {
					'click': function(obj, e) {
						var rec = grid.getSelectionModel().getSelected();
						var taskNo=rec.get('id');
                        var name=rec.get('name');
						parent.tabs.add({
							title: '查看任务明细',
							iconCls: 'commentsbtn',
							margins:'0 0 0 0',
							autoScroll:true,
							autoWidth:true,
							html:'<iframe src="ob-task-detail-list.jsp?taskNo=' + taskNo + '&taskName=' + name + '" border=0 width="100%" height="100%" frameborder="no" scrolling="auto"></iframe>'
						}).show();
						
					}
				}
			})
		);
		toolbar.addSeparator();
		/** End 查看明细详情 */
		
		//START删除用户功能工具条button
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnDelete',
				text: '删除',
				disabled: true,
				iconCls: 'qaassign',
				listeners: {
					'click': function(obj, e) {
						var rec = grid.getSelectionModel().getSelected();
						if(!rec) {
							Ext.Msg.alert('删除外拨任务', '请选择要删除的外拨任务！');
						} else {
							Ext.Msg.show({
								title:'删除外拨任务?',
								msg: '请再次确实是否要将选中的外拨任务删除?',
								buttons: Ext.Msg.YESNOCANCEL,
								fn: function(btn, text) {
									if(btn == "yes") {
										var ids = new Array();
										Ext.each(grid.getSelectionModel().getSelections(), function(rec) {
											ids.push(rec.get('id'));
										});
										Ext.Ajax.request({
											url: window.webRoot + 'OBTask',
											method: 'POST',
											params: {
												_method: 'DELETE',
												id: ids
											},
											success: function(response,options) {
												var respText = Ext.util.JSON.decode(response.responseText);
												if(respText.code != 'OK') {
													Ext.Msg.alert('删除失败', respText.message + "（" + respText.code + "）");
												} else {
													var pgbar = grid.getBottomToolbar();
													var activePage = Math.ceil((pgbar.cursor + pgbar.pageSize) / pgbar.pageSize);
													var start = (activePage - 1) * pgbar.pageSize;
													store.load({params:{start:start, limit:pagesize}});
												}
											},
											failure: function(response,options) {
												Ext.Msg.alert('删除失败', '删除外拨任务失败！');
											}
										});
									}
								},
								icon: Ext.MessageBox.QUESTION
							});						
						}
					}
				}
			})
		);
		toolbar.addSeparator();
		//END删除用户功能工具条button
		
	/** Start 汇总标题 */
		var groupColsObj =  [
			{header: '&nbsp;', colspan: 1, align: 'center'},
			{header: '任务描述', colspan: 4, align: 'center'},
			{header: '任务情况', colspan: 4, align: 'center'}
			
		]
		var sm = new Ext.grid.CheckboxSelectionModel();

		grid = new Ext.grid.GridPanel({
            region: 'center',
			iconCls: 'gridbtn',
			tbar: toolbar,
			plugins: new Ext.ux.grid.ColumnHeaderGroup({
				rows: [groupColsObj]
		    }),
			store: store,
			border: false,
			selModel: sm,
			columns: [
				sm,
				
				{
					header   : '外拨任务名称', 
					width    : 60, 
					sortable : true, 
					dataIndex: 'name'
				},
				{
					header   : '描述', 
					width    : 80, 
					sortable : true, 
					dataIndex: 'desc'
				},
				{
					header   : '名单库组别', 
					width    : 60, 
					sortable : true, 
					dataIndex: 'nameListGroup'
				},
				{
					header   : '技能组', 
					width    : 60, 
					sortable : true, 
					dataIndex: 'skillName'
				},
				{
					header   : '菜单节点', 
					width    : 60, 
					sortable : true, 
					dataIndex: 'menuNode'
				},
				{
					header   : '开始执行时间', 
					width    : 80, 
					sortable : true, 
					dataIndex: 'beginTimeStr'
				},
				{
					header   : '执行结束时间', 
					width    : 80, 
					sortable : true, 
					dataIndex: 'endTimeStr'
				},
 				
				{
					header   : '最大并发外拨量', 
					width    : 40, 
					sortable : true, 
					dataIndex: 'maxPcalls'
				},
				{
					header   : '最大尝试次数', 
					width    : 40, 
					sortable : true, 
					dataIndex: 'maxTryTimes'
				}, 
				{
					header   : '状态', 
					width    : 30, 
					sortable : true, 
					dataIndex: 'statusName'
				}
			],
			stripeRows: true,
			height: 600,
			bodyStyle:'width:100%',
			autoWidth:true,
			viewConfig: {forceFit:true}, 
			loadMask: true,

			bbar: new Ext.PagingToolbar({
                plugins: [new Ext.ui.plugins.ComboPageSize({ addToItem: false, prefixText: '每页', postfixText: '条'})],
				pageSize: pagesize,
				store: store,
				displayInfo: true,
				displayMsg: '当前显示第 <font color="blue">{0}</font> 到 <font color="blue">{1}</font> 条记录， 共 <font color="blue">{2}</font> 条记录',
				emptyMsg: "无记录"
			})
		});
/* console.log(grid.colModel.config[1].header);
console.log(grid.colModel.config.length); */

		/** 列表双击操作 Start */
			grid.addListener('rowdblclick', function(obj, e) {
							Ext.getCmp('btnEdit').fireEvent('click'); 
						});
/*
			grid.addListener('rowdblclick', function(obj, e) {
							Ext.getCmp('btnAssignRole').fireEvent('click'); 
						});    
			grid.addListener('rowdblclick', function(obj, e) {
							Ext.getCmp('btnDelete').fireEvent('click'); 
						});    
			grid.addListener('rowdblclick', function(obj, e) {
							Ext.getCmp('btnAdd').fireEvent('click'); 
						});
*/
		/** 列表双击操作 End */
		
		/** 列表右键点击菜单 Start */
		var rightClick = new Ext.menu.Menu();
			rightClick.add({
				id: 'menuAddUser',
				text : '添加',
				iconCls : 'useraddbtn',
				handler : function(obj, e) {
						Ext.getCmp('btnAdd').fireEvent('click'); 
					}
			});
			rightClick.add({
				id: 'menuAddEdit',
				text : '编辑',
				iconCls : 'usereditbtn',
				handler : function(obj, e) {
						Ext.getCmp('btnEdit').fireEvent('click'); 
					}
			});
			rightClick.add({
				id: 'menuEnable',
				text : '启用',
				iconCls : 'enablebtn',
				handler : function(obj, e) {
						Ext.getCmp('btnEnable').fireEvent('click'); 
					}
			});
			rightClick.add({
				id: 'menuDisable',
				text : '停用',
				iconCls : 'disablebtn',
				handler : function(obj, e) {
						Ext.getCmp('btnDisable').fireEvent('click'); 
					}
			});
			rightClick.add({
				id: 'menuDetail',
				text : '明细详情',
				iconCls : 'commentbtn',
				handler : function(obj, e) {
						Ext.getCmp('btnViewDetail').fireEvent('click'); 
					}
			});
			rightClick.add({
				id: 'menuDelete',
				text : '删除',
				iconCls : 'userdelbtn',
				handler : function(obj, e) {
						Ext.getCmp('btnDelete').fireEvent('click'); 
					}
			});


		grid.addListener('rowcontextmenu', function(client, rowIndex, e) {
			e.preventDefault();
            rightClick.showAt(e.getXY());
		});
		/** 列表右键点击菜单 End */	  

		
		grid.on('rowclick', function(grid, rowIndex, e) {
			var rec = grid.getSelectionModel().getSelected();
			try {
				Ext.getCmp('btnEdit').setDisabled(false);
				Ext.getCmp('btnDelete').setDisabled(false);
				Ext.getCmp('btnViewDetail').setDisabled(false);
				if(rec.get('status') == '0') {
					Ext.getCmp('btnEnable').setDisabled(true);
					Ext.getCmp('btnDisable').setDisabled(false);
					Ext.getCmp('menuEnable').setDisabled(true);
					Ext.getCmp('menuDisable').setDisabled(false);
					Ext.getCmp('menuDelete').setDisabled(true);
				} else if(rec.get('status') == '1') {
					Ext.getCmp('btnEnable').setDisabled(false);
					Ext.getCmp('btnDisable').setDisabled(true);
					Ext.getCmp('menuEnable').setDisabled(false);
					Ext.getCmp('menuDisable').setDisabled(true);
					Ext.getCmp('menuDelete').setDisabled(false);
				}
			} catch (e)	{
			}
		});
		
		store.load({params:{start:0, limit:pagesize}});


		 userForm = new Ext.FormPanel({
			labelWidth: 80,
			frame:true,
			width: 400,
			height:600,
			defaults: {width: 230},
			defaultType: 'textfield',

			reader: new Ext.data.JsonReader({root:'data'},fields),

			items: [{
					fieldLabel: '外拨任务名称',
					name: 'name',
					allowBlank:false
				},{
					fieldLabel: 'ID',
					name: 'id',
					hidden:true
				},{
					fieldLabel: '描述',
					name: 'desc'
				},
				new Ext.app.mgr.OBGroupSelector({
					id: 'cmbOBGroup',
					hiddenName : 'nameListGroupId',
					name: 'nameListGroupId'
				
				}),
				new Ext.app.mgr.SkillGroupSelector({
					id: 'cmbSkillGroup',
					hiddenName : 'skillId',
					name: 'skillId'
				
				}),
				{
					fieldLabel: '菜单节点',
					name: 'menuNode'
				},
				{
					xtype: 'datetimefield',
					fieldLabel: '开始执行时间',
					name: 'beginTime',
					value: '',
					format: 'Y-m-d H:i:s'				
				},{
					xtype: 'datetimefield',
					fieldLabel: '最后执行时间',
					name: 'endTime',
					value: '',
					format: 'Y-m-d H:i:s'				
				},
				{
					fieldLabel: '最大并发外拨量',
					name: 'maxPcalls'
				},
				{
					fieldLabel: '最大尝试次数',
					name: 'maxTryTimes'
				}
				],

			buttons: [{
				text: '保&nbsp;存',
				handler: function() {
					if(userForm.form.isValid()) {
						if(actiontype == "add") {
							userForm.form.submit({
								url: window.webRoot + 'OBTask',
								method: 'POST',
								params: {
									_method: 'POST'
								},
								success: function(form, action) {
									Ext.Msg.alert('保存成功', '添加用户成功！');
									var pgbar = grid.getBottomToolbar();
									var activePage = Math.ceil((pgbar.cursor + pgbar.pageSize) / pgbar.pageSize);
									var start = (activePage - 1) * pgbar.pageSize;
									store.load({params:{start:start, limit:pagesize}});
									win.hide();
								},
								failure: function(form, action) {
									switch (action.failureType) {
										case Ext.form.Action.CLIENT_INVALID:
											Ext.Msg.alert('保存失败', '数据字段格式错误！');
											break;
										case Ext.form.Action.CONNECT_FAILURE:
											Ext.Msg.alert('保存失败', '连接异常！');
											break;
										case Ext.form.Action.SERVER_INVALID:
										   Ext.Msg.alert('保存失败', action.result.message);
									}
								},
								waitMsg: '数据保存中，请稍候...'
							});
						}
						if(actiontype == "edit") {
							var vals = userForm.form.getValues();
							userForm.form.submit({
								url: window.webRoot + 'OBTask/' + vals.id,
								method: 'POST',
								params: {
									_method: 'PUT'
								},
								success: function(form, action) {
									Ext.Msg.alert('修改成功', '修改用户成功！');
									var pgbar = grid.getBottomToolbar();
									var activePage = Math.ceil((pgbar.cursor + pgbar.pageSize) / pgbar.pageSize);
									var start = (activePage - 1) * pgbar.pageSize;
									store.load({params:{start:start, limit:pagesize}});
									win.hide();
								},
								failure: function(form, action) {
									switch (action.failureType) {
										case Ext.form.Action.CLIENT_INVALID:
											Ext.Msg.alert('保存失败', '数据字段格式错误！');
											break;
										case Ext.form.Action.CONNECT_FAILURE:
											Ext.Msg.alert('保存失败', '连接异常！');
											break;
										case Ext.form.Action.SERVER_INVALID:
										   Ext.Msg.alert('保存失败', action.result.message);
									}
								},
								waitMsg: '数据保存中，请稍候...'
							});
						}
					} else {
						Ext.Msg.alert('提示', '请填写完整在提交！');
					}
				}
			},{
				text: '取&nbsp;消',
				handler: function() {
					win.hide();
				}
			}]
		});
 
			/** 查询 Start */
			var panel_query = new Ext.Panel({
	            layout: 'border',
				region: 'center', 
				autoScroll:false,
				iconCls: 'searchbtn',
				border: false,
				items: grid
			});
	 
/* 			store.on('beforeload', function(loader, node) {
				var no = Ext.getCmp('qryUserNo').getValue();
				var name = Ext.getCmp('qryUserName').getValue();
				var roleId = Ext.getCmp('qryRole').getValue();
				var deptId = Ext.getCmp('qryDept').getValue();
				store.baseParams = {no:no, name:name, roleId:roleId, deptId: deptId};
			}); */

			/** 查询 End */


		win = new Ext.Window({
			applyTo:'adduser-win',
			layout:'fit',
			width: 350,
			height:350,
			closeAction:'hide',
			modal: true,
			plain: true,
			title: "添加外拨任务",
			iconCls: "useraddbtn",
			items: [userForm]
		});

		
         var viewport = new Ext.Viewport({
            layout: 'border',
			autoHeight: true,
			border: false,
            items: [panel_query]
		}); 	
//		infotab.collapse(true);
	});	
	</script>
 
</head>
<body>
	<div id="adduser-win" class="x-hidden"></div>
	<div id="assign-role-win" class="x-hidden"></div>
	<div id="assign-agent-win" class="x-hidden"></div>
	<div id="addcontact-win" class="x-hidden"></div>
	<div id="upload-win" class="x-hidden"></div>
</body>
</html>
