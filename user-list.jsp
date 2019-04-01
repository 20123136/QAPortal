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
    <title>用户管理</title>
  
    <link rel="stylesheet" type="text/css" href="../css/ext-all-notheme.css" />
    <link rel="stylesheet" type="text/css" href="../css/xtheme-gray.css" />
	<link rel="stylesheet" type="text/css" href="../ux/fileuploadfield/css/fileuploadfield.css"/>
    <link rel="stylesheet" type="text/css" href="../ux/css/MultiSelect.css" />

	<style type=text/css>
        /* style rows on mouseover */
        .x-grid3-row-over .x-grid3-cell-inner {
            font-weight: bold;
        }

        .titletext {
            font-weight: bold;
        }
		.addbtn {
			background-image:url("../images/icons/fam/user_add.png");
		}
		.editbtn {
			background-image:url("../images/icons/fam/user_edit.png");
		}
		.delbtn {
			background-image:url("../images/icons/fam/user_delete.png");
		}
		.pwdbtn {
			background-image:url("../images/default/dd/changePwd.gif");
		}
		.assignbtn {
			background-image:url("../images/icons/fam/connect.png");
		}
		.searchbtn {
			background-image:url("../images/default/dd/qry.gif");
		}
		.gridbtn {
			background-image:url("../images/icons/fam/user.png");
		}
		.enablebtn {
			background-image:url("../images/icons/fam/accept.png");
		}
		.disablebtn {
			background-image:url("../images/icons/fam/delete.png");
		}
		.contactaddbtn {
			background-image:url("../images/icons/fam/telephone_add.png");
		}
		.contacteditbtn {
			background-image:url("../images/icons/fam/telephone_edit.png");
		}
		.contactdelbtn {
			background-image:url("../images/icons/fam/telephone_delete.png");
		}
		.contactupbtn {
			background-image:url("../images/icons/fam/arrow_up.png");
		}
		.contactdownbtn {
			background-image:url("../images/icons/fam/arrow_down.png");
		}
		.importbtn {
			background-image:url("../images/icons/fam/database_save.png");
		}
		.exportbtn {
			background-image:url("../images/icons/fam/database_go.png");
		}
		.uploadbtn {
			background-image:url("../images/icons/fam/zoom.png");
		}
    </style>
 
    <script type="text/javascript" src="../js/ext-base.js"></script>
    <script type="text/javascript" src="../js/ext-all.js"></script>
    <script type="text/javascript" src="../js/ext-lang-zh_CN.js"></script>
    <script type="text/javascript" src="../js/app/ux/DictSelector.js"></script>
    <script type="text/javascript" src="../js/app/ux/DepartmentSelector.js"></script>
    <script type="text/javascript" src="../js/ext-ui-combo-pagesize.js"></script>
    <script type="text/javascript" src="../ux/MultiSelect.js"></script>
    <script type="text/javascript" src="../ux/ItemSelector.js"></script>
	<script type="text/javascript" src="../ux/fileuploadfield/FileUploadField.js"></script>
    <script type="text/javascript" src="../js/func.js"></script>
	<script >
		var webRoot = '<%=webRoot%>';
	</script>
    <script type="text/javascript">
	var curId = 0;
	var win, win_assign_tenant, win_assign_role;
	var pagesize = 25;
	var grid;
	var userForm, tenantForm;
	var actiontype = "";

	var fields = [
				   {name: 'id'},
				   {name: 'no'},
				   {name: 'name'},
				   {name: 'loginName'},
				   {name: 'deptId'},
					{
						name : 'deptName', 
						convert: function(value, record) {
							return record.department? record.department.name : '';
						}
					},
				   {name: 'typeId'},
					{
						name : 'typeName', 
						convert: function(value, record) {
							return record.type? record.type.name : '';
						}
					},
					{name: 'status'},
					{
						name : 'statusName',
						convert: function(value, record) {
							if(record.status == 'AVAILABLE') {
								return "<font color=green>已启用</font>";
							} else if(record.status == 'DELETED') {
								return "<font color=gray>已删除</font>";
							} else if(record.status == 'DISABLED') {
								return "<font color=red>已停用</font>";
							}
						}
					}
				];

	Ext.onReady(function(){
		var store = new Ext.data.JsonStore({
			root: 'data',
			totalProperty: 'total',
			idProperty: 'id',
			remoteSort: true,

			fields: fields,
			
			proxy: new Ext.data.HttpProxy({
				url: window.webRoot + 'data/users.json'
			})

		}); 
    
		store.setDefaultSort('id', 'asc');
 
		var toolbar = new Ext.Toolbar({
			width: '100%'
		});
		
		//START添加用户功能工具条button
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnAdd',
				text: '添加用户',
				iconCls: 'addbtn',
				listeners: {
					'click': function(obj, e) {
						actiontype = "add";
						win.setTitle("添加用户");
						win.setIconClass("addbtn");
						userForm.form.reset();
						Ext.getCmp('frmLoginName').setDisabled(false);
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
				text: '编辑用户',
				disabled: true,
				iconCls: 'editbtn',
				listeners: {
					'click': function(obj, e) {
						var rec = grid.getSelectionModel().getSelected();
						if(!rec) {
							Ext.Msg.alert('编辑用户', '请选择要修改的用户！');
						} else {
							actiontype = "edit";
							win.setTitle("编辑用户");
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
				text: '启用用户',
				disabled: true,
				iconCls: 'enablebtn',
				listeners: {
					'click': function(obj, e) {
						var rec = grid.getSelectionModel().getSelected();
						if(!rec) {
							Ext.Msg.alert('启用用户', '请选择要启用的用户！');
						} else {
							Ext.Msg.show({
								title:'启用用户?',
								msg: '请再次确实是否要启用选中的用户?',
								buttons: Ext.Msg.YESNOCANCEL,
								fn: function(btn, text) {
									if(btn == "yes") {
										var ids = new Array();
										Ext.each(grid.getSelectionModel().getSelections(), function(rec) {
											ids.push(rec.get('id'));
										});
										Ext.Ajax.request({
											url: window.webRoot + 'rest/users/enable',
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
												Ext.Msg.alert('启用失败', '启用用户失败！');
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
				text: '停用用户',
				disabled: true,
				iconCls: 'disablebtn',
				listeners: {
					'click': function(obj, e) {
						var rec = grid.getSelectionModel().getSelected();
						if(!rec) {
							Ext.Msg.alert('停用用户', '请选择要停用的用户！');
						} else {
							Ext.Msg.show({
								title:'停用用户?',
								msg: '请再次确实是否要停用选中的用户?',
								buttons: Ext.Msg.YESNOCANCEL,
								fn: function(btn, text) {
									if(btn == "yes") {
										var ids = new Array();
										Ext.each(grid.getSelectionModel().getSelections(), function(rec) {
											ids.push(rec.get('id'));
										});
										Ext.Ajax.request({
											url: window.webRoot + 'rest/users/disable',
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
												Ext.Msg.alert('停用失败', '停用用户失败！');
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
		
		//START删除用户功能工具条button
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnDelete',
				text: '删除用户',
				disabled: true,
				iconCls: 'delbtn',
				listeners: {
					'click': function(obj, e) {
						var rec = grid.getSelectionModel().getSelected();
						if(!rec) {
							Ext.Msg.alert('删除用户', '请选择要删除的用户！');
						} else {
							Ext.Msg.show({
								title:'删除用户?',
								msg: '请再次确实是否要将选中的用户删除?',
								buttons: Ext.Msg.YESNOCANCEL,
								fn: function(btn, text) {
									if(btn == "yes") {
										var ids = new Array();
										Ext.each(grid.getSelectionModel().getSelections(), function(rec) {
											ids.push(rec.get('id'));
										});
										Ext.Ajax.request({
											url: window.webRoot + 'rest/users/',
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
												Ext.Msg.alert('删除失败', '删除用户失败！');
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
		
		//START初始化用户口令功能工具条button
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnResetPwd',
				text: '初始化口令',
				disabled: true,
				iconCls: 'pwdbtn',
				listeners: {
					'click': function(obj, e) {
						var rec = grid.getSelectionModel().getSelected();
						if(!rec) {
							Ext.Msg.alert('重置密码', '请选择需要重置密码的用户！');
						} else {
							Ext.Msg.show({
								title:'重置密码',
								msg: '请再次确实是否要将选中用户的密码重置？',
								buttons: Ext.Msg.YESNOCANCEL,
								fn: function(btn, text) {
									if(btn == "yes") {
										var ids = new Array();
										Ext.each(grid.getSelectionModel().getSelections(), function(rec) {
											ids.push(rec.get('id'));
										});
										Ext.Ajax.request({
											url: window.webRoot + 'rest/users/resetpwd/',
											method: 'POST',
											params: {
												_method: 'PUT',
												id: ids
											},
											success: function(response,options) {
												var respText = Ext.util.JSON.decode(response.responseText);
												if(respText.code != 'OK') {
													Ext.Msg.alert('删除失败', respText.message + "（" + respText.code + "）");
												} else {
													Ext.Msg.alert('重置密码成功', '登录密码已被重置！');
												}
											},
											failure: function(response,options) {
												Ext.Msg.alert('重置密码失败', '重置用户密码失败！');
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
		//END 初始化用户口令功能工具条button
		
		//START分配座席功能工具条button
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnAssignAgent',
				text: '分配座席',
				disabled: true,
				iconCls: 'assignbtn',
				listeners: {
					'click': function(obj, e) {
						win_assign_agent.setTitle("分配座席");
						win_assign_agent.setIconClass("assignbtn");
						var rec = grid.getSelectionModel().getSelected();
						if(grid.getSelectionModel().getCount() == 0) {
							Ext.Msg.alert('分配座席', '请选择要分配座席的用户！');
						} else {
							resFromStore.load();
							resToStore.proxy.setUrl(window.webRoot + 'data/user_agents.json', true);
							resToStore.load();
							win_assign_agent.show(this);
						}
					}
				}
			})
		);
		toolbar.addSeparator();
		//END分配座席功能工具条button
		
		//START分配角色功能工具条button
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnAssignRole',
				text: '分配角色',
				disabled: true,
				iconCls: 'assignbtn',
				listeners: {
					'click': function(obj, e) {
						win_assign_role.setTitle("分配角色");
						win_assign_role.setIconClass("assignbtn");
						var rec = grid.getSelectionModel().getSelected();
						if(!rec) {
							Ext.Msg.alert('分配角色', '请选择要分配角色的用户！');
						} else {
							roleFromStore.load();
							roleToStore.removeAll();
							win_assign_role.show(this);
						}
					}
				}
			})
		);
		toolbar.addSeparator();
		//END分配座席功能工具条button
		
		//START导出功能工具条button
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnExport',
				text: '导出',
				iconCls: 'exportbtn',
				listeners: {
					'click': function(obj, e) {
						var myMask = new Ext.LoadMask(grid.getEl(), {msg:"导出中请等待..."});
						myMask.show();
						var no = Ext.getCmp('qryUserNo').getValue();
						var name = Ext.getCmp('qryUserName').getValue();
						var typeid = Ext.getCmp('qryUserType').getValue();
						var deptid = Ext.getCmp('qryDept').getValue();
						Ext.Ajax.request({
							url: window.webRoot + 'rest/users/export/xls',
							success: function(res) {
								myMask.hide();
								var respText = Ext.decode(res.responseText);   
								if(respText.code != 'OK') {
									Ext.Msg.alert('导出失败', respText.message + "（" + respText.code + "）");
								} else {
									window.location.href = respText.data;
								}
							},
							failure: function(res) {
								myMask.hide();
								var respText = Ext.decode(res.responseText);   
								Ext.Msg.alert('导出失败', respText.message + "（" + respText.code + "）");
							},
							method: 'POST', 
							timeout: 300000,
							params: {no:no, name:name, typeid:typeid, deptid: deptid}
						});
					}
				}
			})
		);
		toolbar.addSeparator();
		//END导出功能工具条button
		
		//START导入功能工具条button
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnImport',
				text: '导入',
				iconCls: 'importbtn',
				listeners: {
					'click': function(obj, e) {
						upform.form.reset();
						uploadwin.show(this);
					}
				}
			})
		);
		toolbar.addSeparator();
		//END导入功能工具条button

		var sm = new Ext.grid.CheckboxSelectionModel();

		grid = new Ext.grid.GridPanel({
            region: 'center',
			iconCls: 'gridbtn',
			tbar: toolbar,
			store: store,
			border: false,
			selModel: sm,
			columns: [
				sm, 
				{
					header   : '用户编号', 
					width    : 80, 
					sortable : true, 
					dataIndex: 'no'
				},
				{
					header   : '姓名', 
					width    : 80, 
					sortable : true, 
					dataIndex: 'name'
				},
				{
					header   : '登录名', 
					width    : 120, 
					sortable : true, 
					dataIndex: 'loginName'
				},
				{
					header   : '部门', 
					width    : 80, 
					sortable : true, 
					dataIndex: 'deptName'
				},
				{
					header   : '类型', 
					width    : 80, 
					sortable : true, 
					dataIndex: 'typeName'
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


		/** 列表双击操作 Start */
			grid.addListener('rowdblclick', function(obj, e) {
							Ext.getCmp('btnEdit').fireEvent('click'); 
						});    
			grid.addListener('rowdblclick', function(obj, e) {
							Ext.getCmp('btnAssignRole').fireEvent('click'); 
						});    
			grid.addListener('rowdblclick', function(obj, e) {
							Ext.getCmp('btnDelete').fireEvent('click'); 
						});    
			grid.addListener('rowdblclick', function(obj, e) {
							Ext.getCmp('btnAdd').fireEvent('click'); 
						});    
		/** 列表双击操作 End */
		
		/** 列表右键点击菜单 Start */
		var rightClick = new Ext.menu.Menu();
			rightClick.add({
				id: 'menuAddUser',
				text : '添加',
				iconCls : 'addbtn',
				handler : function(obj, e) {
						Ext.getCmp('btnAdd').fireEvent('click'); 
					}
			});
			rightClick.add({
				id: 'menuAddEdit',
				text : '编辑',
				iconCls : 'editbtn',
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
				id: 'menuDelete',
				text : '删除',
				iconCls : 'delbtn',
				handler : function(obj, e) {
						Ext.getCmp('btnDelete').fireEvent('click'); 
					}
			});
			rightClick.addSeparator();
			rightClick.add({
				id: 'menuReset',
				text : '初始化口令',
				iconCls : 'pwdbtn',
				handler : function(obj, e) {
						Ext.getCmp('btnResetPwd').fireEvent('click'); 
					}
			});
			rightClick.addSeparator();
			rightClick.add({
				id: 'menuAssignAgent',
				text : '分配座席',
				iconCls : 'assignbtn',
				handler : function(obj, e) {
						Ext.getCmp('btnAssignAgent').fireEvent('click'); 
					}
			});
			rightClick.addSeparator();
			rightClick.add({
				id: 'menuAssignRole',
				text : '分配角色',
				iconCls : 'assignbtn',
				handler : function(obj, e) {
						Ext.getCmp('btnAssignRole').fireEvent('click'); 
					}
			});
			rightClick.add({
				text : '导出',
				iconCls : 'exportbtn',
				handler : function(obj, e) {
						Ext.getCmp('btnExport').fireEvent('click');
					}
			});
			rightClick.add({
				text : '导入',
				iconCls : 'importbtn',
				handler : function(obj, e) {
						Ext.getCmp('btnImport').fireEvent('click');
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
				Ext.getCmp('btnResetPwd').setDisabled(false);
				Ext.getCmp('btnAssignAgent').setDisabled(false);
				Ext.getCmp('btnAssignRole').setDisabled(false);
//				Ext.getCmp('btnAssignResource').setDisabled(false);
				if(rec.get('status') == 'AVAILABLE') {
					Ext.getCmp('btnEnable').setDisabled(true);
					Ext.getCmp('btnDisable').setDisabled(false);
					Ext.getCmp('btnDelete').setDisabled(true);
					Ext.getCmp('menuEnable').setDisabled(true);
					Ext.getCmp('menuDisable').setDisabled(false);
					Ext.getCmp('menuDelete').setDisabled(true);
				} else if(rec.get('status') == 'DELETED') {
					Ext.getCmp('btnEnable').setDisabled(false);
					Ext.getCmp('btnDisable').setDisabled(true);
					Ext.getCmp('btnDelete').setDisabled(true);
					Ext.getCmp('menuEnable').setDisabled(false);
					Ext.getCmp('menuDisable').setDisabled(true);
					Ext.getCmp('menuDelete').setDisabled(true);
				} else if(rec.get('status') == 'DISABLED') {
					Ext.getCmp('btnEnable').setDisabled(false);
					Ext.getCmp('btnDisable').setDisabled(true);
					Ext.getCmp('btnDelete').setDisabled(false);
					Ext.getCmp('menuEnable').setDisabled(false);
					Ext.getCmp('menuDisable').setDisabled(true);
					Ext.getCmp('menuDelete').setDisabled(false);
				}
			} catch (e)	{
			}
		});
		
		store.load({params:{start:0, limit:pagesize}});

//		store_type.load();

		userForm = new Ext.FormPanel({
			labelWidth: 75,
			frame:true,
			width: 350,
			defaults: {width: 230},
			defaultType: 'textfield',

			reader: new Ext.data.JsonReader({root:'data'},fields),

			items: [{
					fieldLabel: '用户编号',
					name: 'no'
				},{
					fieldLabel: 'ID',
					name: 'id',
					hidden:true
				},{
					fieldLabel: '姓名',
					name: 'name',
					allowBlank:false
				},{
					id: 'frmLoginName',
					fieldLabel: '登录名',
					name: 'loginName',
					allowBlank:false
				}, 
				new Ext.app.ux.DepartmentSelector({
					id: 'frmDept',
					fieldLabel: '部门',
					name: 'deptId',
					hiddenName: 'deptId'
				}), 
				new Ext.app.ux.DictSelector({
					dictType: 'USER_TYPE',
					fieldLabel: '类型',
					width: 120,
					name: 'typeId',
					hiddenName: 'typeId'
				})
				],

			buttons: [{
				text: '保&nbsp;存',
				handler: function() {
					if(userForm.form.isValid()) {
						if(actiontype == "add") {
							userForm.form.submit({
								url: window.webRoot + 'rest/user/',
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
								url: window.webRoot + 'rest/user/' + vals.id,
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

		/** 分配座席 Start */
		resFromStore = new Ext.data.JsonStore({
			root: 'data',
			totalProperty: 'total',
			idProperty: 'id',

			fields: ['id','name'],
			proxy: new Ext.data.HttpProxy({
				url: window.webRoot + 'data/agents_avail.json'
			}),

			listeners: 
				{
					'beforeload': function(loader, node) {
						var typeId = Ext.getCmp('qryResType').getValue();
						var name = Ext.getCmp('qryResNo').getValue();
						var userId = grid.getSelectionModel().getSelected().get('id');
						resFromStore.baseParams = {name:name, typeId:typeId, userId:userId};
					}
				}
		});

		resToStore = new Ext.data.JsonStore({
			root: 'data',
			totalProperty: 'total',
			idProperty: 'id',
			autoLoad: false,

			fields: ['id','name'],
			proxy: new Ext.data.HttpProxy({
				url: 'empty.jsp'
			})
		});

		win_assign_agent = new Ext.Window({
			applyTo:'assign-agent-win',
			layout:'column',
			width: 497,
			height:430,
			closeAction:'hide',
			modal: true,
			plain: true,
			title: "分配座席",
			iconCls: "assignbtn",
			tbar:[
				'编号:&nbsp;&nbsp;',
				new Ext.form.TextField({
					id: 'qryResNo',
					width: 120,
					enableKeyEvents: true,
					listeners: 
						{'keypress': function(obj, e) {
								if (e.getKey() == e.ENTER) { 
									Ext.getCmp('btnSearch').fireEvent('click');   
								}   
							}
						}
				}),
				'-',
				'类型:&nbsp;&nbsp;',
				new Ext.app.ux.DictSelector({
					id: 'qryResType',
					dictType: 'AGENT_TYPE',
					fieldLabel: '类型',
					width: 120,
					name: 'typeId',
					hiddenName: 'typeId',
					enableKeyEvents: true,
					listeners: 
						{'keypress': function(obj, e) {
								if (e.getKey() == e.ENTER) { 
									Ext.getCmp('btnSearch').fireEvent('click');   
								}   
							}
						}
				}),
				'-',
				new Ext.Toolbar.Button({
					id: 'btnResSearch',
					iconCls: 'searchbtn',
					text: '查询',
					listeners: 
						{'click': function(obj, e) {
								resFromStore.removeAll();
								resFromStore.load({params:{start:0, limit:pagesize}});
							}
						}
				}),
				'-',
				new Ext.Toolbar.Button({
					iconCls: 'gridbtn',
					text: '显示全部',
					handler: function() {
						Ext.getCmp('qryResNo').setValue('');
						Ext.getCmp('qryResType').setValue('');
						resFromStore.load({params:{start:0, limit:pagesize}});
					}
				})
				],
			items:[
				{
				xtype: 'itemselector',
				name: 'itemselector',
				id: 'resSelector',
				fieldLabel: 'ItemSelector',
				imagePath: '../ux/images/',
				multiselects: [{
					width: 230,
					height: 355,
					store: resFromStore,
					displayField: 'name',
					valueField: 'id'
				},{
					width: 230,
					height: 355,
					store: resToStore,
					displayField: 'name',
					valueField: 'id'
				}]
			}],
			buttons: [
				{
					text: '保&nbsp;存',
					handler: function() {
						var rec = grid.getSelectionModel().getSelected();
						if(rec) {
							var ids = Ext.getCmp('resSelector').getValue().split(',');
							Ext.Ajax.request({
								url: window.webRoot + 'rest/user/' + rec.get('id') + '/agents',
								params: {
									_method: 'PUT',
									agentid: ids
								},
								success: function(response,options) {
									var respText = Ext.util.JSON.decode(response.responseText);
									if(respText.code != 'OK') {
										Ext.Msg.alert('分配座席失败', respText.message + "（" + respText.code + "）");
									} else {
										Ext.Msg.alert('分配座席成功', '座席已分配！');
									}
									win_assign_agent.hide();
								},
								failure: function(response,options) {
									Ext.Msg.alert('分配座席失败', '分配座席失败！');
								}
							});
						} else {
							Ext.Msg.alert('分配座席', '请选择需要分配座席的用户');
						}
					}
				},{
					text: '取&nbsp;消',
					handler: function() {
						win_assign_agent.hide();
					}
			}]

		});
		/** 分配座席 End */

		/** 分配角色 Start */
		roleFromStore = new Ext.data.JsonStore({
			root: 'data',
			totalProperty: 'total',
			idProperty: 'id',

			fields: ['id','name'],
			proxy: new Ext.data.HttpProxy({
				url: window.webRoot + 'data/roles.json'
			}),

			listeners: 
				{'load': function(obj, recs, opts) {
						if(grid.getSelectionModel().getCount() == 1) {
							var rec = grid.getSelectionModel().getSelected();
							Ext.Ajax.request({
								url: window.webRoot + 'data/user_roles.json',
								success: function(response){
									var ids = new Array();
									var val = Ext.util.JSON.decode(response.responseText);
									if(val.code == 'OK'){
										Ext.each(val.data, function(as) {
											ids.push(as.id);
										});
										Ext.getCmp('roleSelector').setValue(ids);
									}
								}
							});
						}
					}
				}
		});

		roleToStore = new Ext.data.ArrayStore({
			data: [],
			fields: ['id','name']
		});

		win_assign_role = new Ext.Window({
			applyTo:'assign-role-win',
			layout:'column',
			width: 497,
			height:420,
			closeAction:'hide',
			modal: true,
			plain: true,
			title: "分配角色",
			iconCls: "dispatchbtn",
			items:[{
				xtype: 'itemselector',
				name: 'itemselector',
				id: 'roleSelector',
				fieldLabel: 'ItemSelector',
				imagePath: '../ux/images/',
				multiselects: [{
					width: 230,
					height: 355,
					store: roleFromStore,
					displayField: 'name',
					valueField: 'id'
				},{
					width: 230,
					height: 355,
					store: roleToStore,
					displayField: 'name',
					valueField: 'id'
				}]
			}],
			buttons: [
				{
					text: '保&nbsp;存',
					handler: function() {
						var rec = grid.getSelectionModel().getSelected();
						if(rec) {
							var roleids = Ext.getCmp('roleSelector').getValue().split(',');
							var ids = new Array();
							Ext.each(grid.getSelectionModel().getSelections(), function(rec) {
								ids.push(rec.get('id'));
							});
							Ext.each(grid.getSelectionModel().getSelections(), function(rec) {
								Ext.Ajax.request({
									url: window.webRoot + 'rest/users/assign/roles',
									params: {
										_method: 'PUT',
										roleid: roleids,
										id: ids
									},
									success: function(response,options) {
										var respText = Ext.util.JSON.decode(response.responseText);
										if(respText.code != 'OK') {
											Ext.Msg.alert('分配角色失败', respText.message + "（" + respText.code + "）");
										} else {
											Ext.Msg.alert('分配角色成功', '角色已分配！');
										}
										win_assign_role.hide();
									},
									failure: function(response,options) {
										Ext.Msg.alert('分配角色失败', '分配角色失败！');
									}
								});
							});
						} else {
							Ext.Msg.alert('分配角色', '请选择需要分配角色的用户');
						}
					}
				},{
					text: '取&nbsp;消',
					handler: function() {
						win_assign_role.hide();
					}
			}]

		});
		/** 分配角色 End */
 
		/** 用户已分配的座席 Start */
		var store_user_agent = new Ext.data.JsonStore({
			root: 'data',
			totalProperty: 'total',
			remoteSort: false,

			fields: [
					   {name: 'name'},
					   {name: 'description'},
					   {name: 'id'}
					]
			,
			
			url: 'empty.jsp'
		});
    
		store_user_agent.setDefaultSort('id', 'asc');

		var agentGrid = new Ext.grid.GridPanel({
			store: store_user_agent,
			border: false,
			viewConfig: {forceFit:true}, 
			loadMask: true,
			autoHeight:true,
			columns: [
				{
					header   : '编号', 
					width: .5,
					dataIndex: 'name'
				}, {
					header   : '名称', 
					width: .5,
					dataIndex: 'description'
				}
			]
		});
		/** 用户已分配的座席 End */

		/** 用户已分配的角色 Start */
		var store_user_role = new Ext.data.JsonStore({
			root: 'data',
			totalProperty: 'total',
			remoteSort: false,
			idProperty: 'id',

			fields: [
					   {name: 'id'},
					   {name: 'name'},
					   {name: 'description'}
					]
			,
			
			url: 'empty.jsp'
		});
    
		store_user_role.setDefaultSort('name', 'asc');

		var listview_roles = new Ext.grid.GridPanel({
			store: store_user_role,
			border: false,
			viewConfig: {forceFit:true}, 
			loadMask: true,
			autoHeight:true,
			columns: [
				{
				header   : '名称', 
				width	: .5,
				dataIndex: 'name'
				},
				{
				header   : '描述', 
				width	: .5,
				dataIndex: 'description'
				}
			]
		});
		/** 用户已分配的角色 End */
		
		var infotab = new Ext.TabPanel({
			collapsible: true,
			region: 'south',
			collapseMode:'mini',
			activeTab: 0, 
			height: 200,
			border: false,
			items: [
			{
				title: '已分配的座席',
				autoScroll: true,
				items: [agentGrid]
			}, {
				title: '拥有的角色',
				autoScroll: true,
				items: [listview_roles]
			}]
		});

		grid.on('rowclick', function(grid, rowIndex, e) {
			var rec = grid.getSelectionModel().getSelected();
			store_user_agent.removeAll();
			store_user_agent.proxy.setUrl(window.webRoot + 'data/useragents.json', true);
			store_user_agent.load();
			store_user_role.proxy.setUrl(window.webRoot + 'data/userroles.json', true);
			store_user_role.load();
			infotab.expand(true);
		});

		/** 查询 Start */
		var panel_query = new Ext.Panel({
            layout: 'border',
			region: 'center', 
			autoScroll:false,
			iconCls: 'searchbtn',
			border: false,
			tbar: [
				'编号:&nbsp;&nbsp;',
				new Ext.form.TextField({
					id: 'qryUserNo',
					enableKeyEvents: true,
					width: 120,
					listeners: 
						{'keypress': function(obj, e) {
								if (e.getKey() == e.ENTER) { 
									Ext.getCmp('btnSearch').fireEvent('click');   
								}   
							}
						}
				}),
				'-',
				'姓名:&nbsp;&nbsp;',
				new Ext.form.TextField({
					id: 'qryUserName',
					enableKeyEvents: true,
					width: 120,
					listeners: 
						{'keypress': function(obj, e) {
								if (e.getKey() == e.ENTER) { 
									Ext.getCmp('btnSearch').fireEvent('click');   
								}   
							}
						}
				}),
				'-',
				'类型:&nbsp;&nbsp;',
				new Ext.app.ux.DictSelector({
					id: 'qryUserType',
					dictType: 'USER_TYPE',
					fieldLabel: '类型',
					width: 120,
					name: 'typeId',
					hiddenName: 'typeId',
					enableKeyEvents: true,
					listeners: 
						{'keypress': function(obj, e) {
								if (e.getKey() == e.ENTER) { 
									Ext.getCmp('btnSearch').fireEvent('click');   
								}   
							}
						}
				}),
				'-',
				'部门:&nbsp;&nbsp;',
				new Ext.app.ux.DepartmentSelector({
					id: 'qryDept',
					fieldLabel: '部门',
					name: 'deptId',
					hiddenName: 'deptId',
					enableKeyEvents: true,
					listeners: 
						{'keypress': function(obj, e) {
								if (e.getKey() == e.ENTER) { 
									Ext.getCmp('btnSearch').fireEvent('click');   
								}   
							}
						}
				}), 
				'-',
				new Ext.Toolbar.Button({
					id: 'btnSearch',
					iconCls: 'searchbtn',
					text: '查询',
					listeners: 
						{'click': function(obj, e) {
								store.removeAll();
								store.load({params:{start:0, limit:pagesize}});
							}
						}
				}),
				'-',
				new Ext.Toolbar.Button({
					iconCls: 'gridbtn',
					text: '显示全部',
					handler: function() {
						Ext.getCmp('qryUserNo').setValue('');
						Ext.getCmp('qryUserName').setValue('');
						Ext.getCmp('qryUserType').setValue('');
						Ext.getCmp('qryDept').setValue('');
						store.load({params:{start:0, limit:pagesize}});
					}
				}),
				'-'
			],
			items: grid
		});
 
		store.on('beforeload', function(loader, node) {
			var no = Ext.getCmp('qryUserNo').getValue();
			var name = Ext.getCmp('qryUserName').getValue();
			var typeid = Ext.getCmp('qryUserType').getValue();
			var deptid = Ext.getCmp('qryDept').getValue();
			store.baseParams = {no:no, name:name, typeid:typeid, deptid: deptid};
		});

		/** 查询 End */

		/** 导入 Start */
		var upform = new Ext.FormPanel({
			fileUpload: true,
			width: 500,
			frame: true,
			autoHeight: true,
			bodyStyle: 'padding: 10px 10px 0 10px;',
			labelWidth: 50,
			defaults: {
				anchor: '95%',
				allowBlank: false,
				msgTarget: 'side'
			},
			items: [{
				xtype: 'fileuploadfield',
				emptyText: '请选择修改后的模板，模板文件可以点击"下载模板"获得',
				fieldLabel: '文件',
				name: 'uploadFile',
				buttonText: '',
				buttonCfg: {
					iconCls: 'uploadbtn'
				}
			}],
			buttons: [
			{
				text: '下载模板',
				handler: function(){
					var myMask = new Ext.LoadMask(grid.getEl(), {msg:"下载中请等待..."});
					myMask.show();
					Ext.Ajax.request({
						url: window.webRoot + 'rest/users/export/template',
						success: function(res) {
							myMask.hide();
							var respText = Ext.decode(res.responseText);   
							if(respText.code != 'OK') {
								Ext.Msg.alert('导出失败', respText.message + "（" + respText.code + "）");
							} else {
								window.location.href = respText.data;
							}
						},
						failure: function(res) {
							myMask.hide();
							var respText = Ext.decode(res.responseText);   
							Ext.Msg.alert('导出失败', respText.message + "（" + respText.code + "）");
						},
						method: 'POST', 
						timeout: 300000
					});
				}
			},
			{
				text: '确&nbsp;&nbsp;定',
				handler: function(){
					if(upform.getForm().isValid()){
						upform.getForm().submit({
							url: window.webRoot + 'rest/users/upload/xls',
							waitMsg: '上传中，请稍候...',
							success: function(form, action){
								Ext.Msg.alert('导入成功', '导入用户成功！添加:' + action.result.data.insert + ', 更新:' + action.result.data.update + ', 异常:' + action.result.data.error);
								var pgbar = grid.getBottomToolbar();
								var activePage = Math.ceil((pgbar.cursor + pgbar.pageSize) / pgbar.pageSize);
								var start = (activePage - 1) * pgbar.pageSize;
								store.load({params:{start:start, limit:pagesize}});
								uploadwin.hide();
								},
							failure: function(form, action) {
								switch (action.failureType) {
									case Ext.form.Action.CLIENT_INVALID:
										Ext.Msg.alert('导入失败', '数据字段格式错误！');
										break;
									case Ext.form.Action.CONNECT_FAILURE:
										Ext.Msg.alert('导入失败', '连接异常！');
										break;
									case Ext.form.Action.SERVER_INVALID:
										Ext.Msg.alert('导入失败', '导入用户失败！(' + action.result.msg + ')');
								}
							}
						});
					}
				}
			},{
				text: '取&nbsp;&nbsp;消',
				handler: function(){
					uploadwin.hide();
				}
			}]
		});

		uploadwin = new Ext.Window({
			applyTo:'upload-win',
			layout:'fit',
			width: 450,
			height:120,
			closeAction:'hide',
			modal: true,
			plain: true,
			title: "导入用户",
			iconCls: "addbtn",
			items: [upform]
		});

		/** 导入 End */

		win = new Ext.Window({
			applyTo:'adduser-win',
			layout:'fit',
			width: 350,
			height:300,
			closeAction:'hide',
			modal: true,
			plain: true,
			title: "添加用户",
			iconCls: "addbtn",
			items: [userForm]
		});

        var viewport = new Ext.Viewport({
            layout: 'border',
			autoHeight: true,
			border: false,
            items: [panel_query, infotab]
		});	
		infotab.collapse(true);
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
