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
    <title>微信用户管理</title>
  
    <link rel="stylesheet" type="text/css" href="../css/ext-all-notheme.css" />
    <link rel="stylesheet" type="text/css" href="../css/xtheme-gray.css" />
	<link rel="stylesheet" type="text/css" href="../ux/fileuploadfield/css/fileuploadfield.css"/>
    <link rel="stylesheet" type="text/css" href="../ux/css/MultiSelect.css" />

    <link rel="stylesheet" type="text/css" href="../css/icon.css" />
 
    <script type="text/javascript" src="../js/ext-base.js"></script>
    <script type="text/javascript" src="../js/ext-all.js"></script>
    <script type="text/javascript" src="../js/ext-lang-zh_CN.js"></script>
    <script type="text/javascript" src="../js/app/ux/DepartmentSelector.js"></script>
    <script type="text/javascript" src="../js/ext-ui-combo-pagesize.js"></script>
    <script type="text/javascript" src="../js/app/common/ComboBox.js"></script>
    <script type="text/javascript" src="../js/app/mgr/RoleSelector.js"></script>
    <script type="text/javascript" src="../ux/MultiSelect.js"></script>
    <script type="text/javascript" src="../ux/ItemSelector.js"></script>
	<script type="text/javascript" src="../ux/fileuploadfield/FileUploadField.js"></script>
    <script type="text/javascript" src="../js/func.js"></script>
    <script type="text/javascript" src="../js/app/rec/Excel.js"></script>
	<script >
		var webRoot = '<%=webRoot%>';
	</script>
    <script type="text/javascript">
	var curId = 0;
	var win, win_assign_tenant, win_assign_role;
	var pagesize = 200;
	var grid;
	var userForm, tenantForm ;
	var actiontype = "";

	var fields = [
			/* 	   {name: 'id'},
				   {name: 'no'},
				   {name: 'name'},
				   {name: 'loginName'},
				   {name: 'deptId'},
				   {name: 'deptName'},
				   {name: 'tag'},
				   {name: 'roleName'},
				   {name: 'status'},
				   {
						name : 'statusName',
						convert: function(value, record) {
							if(record.status == '0') {
								return "<font color=green>已启用</font>";
							} else if(record.status == '1') {
								return "<font color=gray>已停用</font>";
							}
						}
					} */
					
					{name:'name'},
					{name:'company'},
					{name:'email'},
					{name:'telephone'},
					{name:'openid'},
					{name:'relation'},
					{
						name : 'relationName',
						convert: function(value,record){
							if(record.relation == 'Attention') {
								return "已关注";
							} else if(record.relation == 'UnAttention') {
								return "未关注";
							}else if(record.relation == 'Registed') {
								return "已绑定";
					    	}
					    }
					},
					{name: 'status'},
					   {
							name : 'statusName',
							convert: function(value, record) {
								if(record.status == '1') {
									return "<font color=green>已启用</font>";
								} else if(record.status == '0') {
									return "<font color=gray>已停用</font>";
								}
							}
					   }
				];

	Ext.onReady(function(){
		var store = new Ext.data.JsonStore({
			root: 'data',
			remoteSort: false,

			fields: fields,
			
			proxy: new Ext.data.HttpProxy({
				url: window.webRoot + 'WeChatUsers'
			})

		}); 
    
		store.setDefaultSort('name', 'asc');
 
		var toolbar = new Ext.Toolbar({
			width: '100%'
		});
		
 		//START添加用户功能工具条button
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnAdd',
				text: '添加',
				iconCls: 'useraddbtn',
				listeners: {
					'click': function(obj, e) {
						actiontype = "add";
						win.setTitle("添加用户");
						win.setIconClass("addbtn");
						userForm.form.reset();
						//Ext.getCmp('frmLoginName').setDisabled(false);
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
				text: '启用',
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
											ids.push(rec.get('openid'));
										});
										Ext.Ajax.request({
											url: window.webRoot + 'WeChatUser/enable',
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
													store.load({params:{start:0, limit:pagesize}});
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
				text: '停用',
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
											ids.push(rec.get('openid'));
										});
										Ext.Ajax.request({
											url: window.webRoot + 'WeChatUser/disable',
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
													store.load({params:{start:0, limit:pagesize}});
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
				text: '删除',
				disabled: true,
				iconCls: 'userdelbtn',
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
											ids.push(rec.get('openid'));
										});
										Ext.Ajax.request({
											url: window.webRoot + 'WeChatUser',
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
												/* 	var pgbar = grid.getBottomToolbar();
													var activePage = Math.ceil((pgbar.cursor + pgbar.pageSize) / pgbar.pageSize);
													var start = (activePage - 1) * pgbar.pageSize;
													store.load({params:{start:start, limit:pagesize}}); */
													store.load({params:{start:0, limit:pagesize}});
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
	

		
		//START导出功能工具条button

		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnExport',
				text: '导出',
				iconCls: 'exportbtn',
				  listeners: {
					'click': function(obj, e) {
						var myMask = new Ext.LoadMask(grid.getEl(), {msg:"导出中请等待..."});
						myMask.show();
						var columns={};
						for(var i=1;i<grid.colModel.config.length;i++)
						{
							columns[grid.colModel.config[i].dataIndex] = grid.colModel.config[i].header;
						} 
						var users = new Array();
						users.push(columns);
						var data=grid.getSelectionModel().getSelections();
						Ext.each(grid.getSelectionModel().getSelections(), function(rec) {
							users.push(rec.data);
						});

						
						Ext.Ajax.request({
						    url: window.webRoot + 'WeChatUsers/export/xls',
						    success: function(response, opts) {
								myMask.hide();
								var respText = Ext.decode(response.responseText);   
								if(respText.code != 'OK') {
									Ext.Msg.alert('导出失败', respText.message + "（" + respText.code + "）");
								} else {
									window.location.href = "/QAPortal/Export/GetWeChatUser/" + respText.data;
								}
 						        console.warn(respText);
						    },
						    failure: function(response, opts) {
								myMask.hide();
								var respText = Ext.decode(response.responseText);   
								Ext.Msg.alert('导出失败', respText.message + "（" + respText.code + "）");
							},
						    method:'POST',
							timeout: 300000,
							params:{data:Ext.encode(users)
							}
						});
					}
				}  
			})
		);
		toolbar.addSeparator();
		//END导出功能工具条button
		
		
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnReflash',
				text: '刷新用户列表',
				iconCls: 'refreshbtn',
				listeners: {
					'click': function(obj, e) {
						Ext.Msg.show({
							title:'更新用户?',
							msg: '请再次确实是否要更新微信用户列表?',
							buttons: Ext.Msg.YESNOCANCEL,
							fn: function(btn, text) {
								if(btn == "yes") {
									var myMask = new Ext.LoadMask(grid.getEl(), {msg:"更新中请等待..."});
									myMask.show();
				     		        Ext.Ajax.request({
						    	    url: window.webRoot + 'WeChatUsers/updateUser',
						         	method: 'POST',
						    	    success: function(response,options) {
						    	    myMask.hide();
							     	var respText = Ext.util.JSON.decode(response.responseText);
							     	if(respText.code != 'OK') {
								    	Ext.Msg.alert('用户更新失败', respText.message + "（" + respText.code + "）");
							    	} else {
								     	store.reload(store.lastOptions);
								    	Ext.Msg.alert('用户更新成功', respText.message + "（" + respText.code + "）");
							    	}
					      	 	},
						    failure: function() {
						    	myMask.hide();
								Ext.Msg.alert('用户更新失败', '用户更新失败！');
						        	}
					        	});
								}
							},
						});
					}
				}
			})
		);
		toolbar.addSeparator();
		

		var sm = new Ext.grid.CheckboxSelectionModel();

		grid = new Ext.grid.GridPanel({
            region: 'center',
			iconCls: 'gridbtn',
			tbar: toolbar,
			store: store,
			border: false,
			selModel: sm,
			columns: [
                new Ext.grid.RowNumberer(),
				sm, 
				{
					header   : '用户昵称', 
					width    : 30, 
					sortable : true, 
					dataIndex: 'name'
				},
				{
					header   : '公司', 
					width    : 30, 
					sortable : true, 
					dataIndex: 'company'
				},
				{
					header   : '邮件', 
					width    : 40, 
					sortable : true, 
					dataIndex: 'email'
				},
				{
					header   : '手机号码', 
					width    : 30, 
					sortable : true, 
					dataIndex: 'telephone'
				},
				{
					header   : '微信号', 
					width    : 80, 
					sortable : true, 
					dataIndex: 'openid'
				},
				{
					header   : '关系', 
					width    : 40, 
					sortable : true, 
					dataIndex: 'relationName'
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

		/* 	bbar: new Ext.PagingToolbar({
                plugins: [new Ext.ui.plugins.ComboPageSize({ addToItem: false, prefixText: '每页', postfixText: '条'})],
				pageSize: pagesize,
				store: store,
				displayInfo: true,
				displayMsg: '当前显示第 <font color="blue">{0}</font> 到 <font color="blue">{1}</font> 条记录， 共 <font color="blue">{2}</font> 条记录',
				emptyMsg: "无记录"
			})
			*/
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
			/* rightClick.add({
				id: 'menuAddUser',
				text : '添加',
				iconCls : 'useraddbtn',
				handler : function(obj, e) {
						Ext.getCmp('btnAdd').fireEvent('click'); 
					}
			}); */
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
				id: 'menuDelete',
				text : '删除',
				iconCls : 'userdelbtn',
				handler : function(obj, e) {
						Ext.getCmp('btnDelete').fireEvent('click'); 
					}
			});
	//		rightClick.addSeparator();
/*
			rightClick.add({
				id: 'menuAssignAgent',
				text : '分配座席',
				iconCls : 'assignbtn',
				handler : function(obj, e) {
						Ext.getCmp('btnAssignAgent').fireEvent('click'); 
					}
			});
			rightClick.addSeparator();
*/
			

			rightClick.add({
				text : '导出',
				iconCls : 'exportbtn',
				handler : function(obj, e) {
						Ext.getCmp('btnExport').fireEvent('click');
					}
			});
/*
			rightClick.add({
				text : '导入',
				iconCls : 'importbtn',
				handler : function(obj, e) {
						Ext.getCmp('btnImport').fireEvent('click');
					}
			});
*/
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
				if(rec.get('status') == '1') {
					Ext.getCmp('btnEnable').setDisabled(true);
					Ext.getCmp('btnDisable').setDisabled(false);
					Ext.getCmp('menuEnable').setDisabled(true);
					Ext.getCmp('menuDisable').setDisabled(false);
					Ext.getCmp('menuDelete').setDisabled(true);
				} else if(rec.get('status') == '0') {
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

//		store_type.load();

		userForm = new Ext.FormPanel({
			labelWidth: 75,
			frame:true,
			width: 350,
			defaults: {width: 230},
			defaultType: 'textfield',

			reader: new Ext.data.JsonReader({root:'data'},fields),

			items: [{
					fieldLabel: '用户昵称',
					name: 'name'
				},
				{
				fieldLabel: '公司',
				name: 'company'
		    	},
		    	{
		    	fieldLabel: '邮件',
				name: 'email'
		    	},
		    	{
		    	fieldLabel: '手机号码',
				name: 'telephone'
		    	},
				{
					fieldLabel: '微信号',
					name: 'openid',
					readOnly: true
				}
				],

			buttons: [{
				text: '保&nbsp;存',
				handler: function() {
					if(userForm.form.isValid()) {
						if(actiontype == "add") {
							userForm.form.submit({
								url: window.webRoot + 'WeChatUser',
								method: 'POST',
								params: {
									_method: 'POST'
								},
								success: function(form, action) {
									Ext.Msg.alert('保存成功', '添加用户成功！');
									store.load({params:{start:0, limit:pagesize}});
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
							console.log(vals);
							userForm.form.submit({
								url: window.webRoot + 'WeChatUser/' + vals.openid,
								method: 'POST',
								params: {
									_method: 'PUT'
								},
								success: function(form, action) {
									Ext.Msg.alert('修改成功', '修改用户成功！');
									/* var pgbar = grid.getBottomToolbar();
									var activePage = Math.ceil((pgbar.cursor + pgbar.pageSize) / pgbar.pageSize);
									var start = (activePage - 1) * pgbar.pageSize;
									store.load({params:{start:start, limit:pagesize}}); */
									store.load({params:{start:0, limit:pagesize}});
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
			tbar: [
				'微信号:&nbsp;&nbsp;',
				new Ext.form.TextField({
					id: 'openid',
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
						Ext.getCmp('openid').setValue('');
						store.load({params:{start:0, limit:pagesize}});
					}
				}),
				'-'
			],
			items: grid
		});
 
		store.on('beforeload', function(loader, node) {
			var openid = Ext.getCmp('openid').getValue();
			
			store.baseParams = {openid:openid};
		});

		/** 查询 End */

	

		win = new Ext.Window({
			applyTo:'adduser-win',
			layout:'fit',
			width: 350,
			height:220,
			closeAction:'hide',
			modal: true,
			plain: true,
			title: "添加用户",
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
