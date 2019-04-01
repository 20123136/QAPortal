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
    <title>组织架构管理</title>
 
    <link rel="stylesheet" type="text/css" href="../css/ext-all-notheme.css" />
    <link rel="stylesheet" type="text/css" href="../css/xtheme-gray.css" />
    <link rel="stylesheet" type="text/css" href="../ux/treegrid/treegrid.css" rel="stylesheet" />
  
    <style type=text/css>
        /* style rows on mouseover */
        .x-grid3-row-over .x-grid3-cell-inner {
            font-weight: bold;
        }

        .titletext {
            font-weight: bold;
        }
		.addbtn {
			background-image:url("../images/icons/fam/group_add.png");
		}
		.editbtn {
			background-image:url("../images/icons/fam/group_edit.png");
		}
		.delbtn {
			background-image:url("../images/icons/fam/group_delete.png");
		}
		.treebtn {
			background-image:url("../images/icons/fam/group.png");
		}
		.assignbtn {
			background-image:url("../images/icons/fam/connect.png");
		}
		.enablebtn {
			background-image:url("../images/icons/fam/accept.png");
		}
		.disablebtn {
			background-image:url("../images/icons/fam/delete.png");
		}

    </style>
 
    <script type="text/javascript" src="../js/ext-base.js"></script>
    <script type="text/javascript" src="../js/ext-all.js"></script>
	<script type="text/javascript" src="../ux/treegrid/TreeGridSorter.js"></script>
	<script type="text/javascript" src="../ux/treegrid/TreeGridColumnResizer.js"></script>
	<script type="text/javascript" src="../ux/treegrid/TreeGridNodeUI.js"></script>
	<script type="text/javascript" src="../ux/treegrid/TreeGridLoader.js"></script>
	<script type="text/javascript" src="../ux/treegrid/TreeGridColumns.js"></script>
	<script type="text/javascript" src="../ux/treegrid/TreeGrid.js"></script>
    <script type="text/javascript" src="../js/ext-lang-zh_CN.js"></script>
    <script type="text/javascript" src="../js/app/ux/TenantSelector.js"></script>
    <script type="text/javascript" src="../js/func.js"></script>
	<script >
		var webRoot = '<%=webRoot%>';
	</script>
    <script type="text/javascript">
	var curId = 0;
	var win;
	var pagesize = 25;
	var tree;
	var dptForm;
	var actiontype = "";
	var fields = [
				   {name: 'id'},
				   {name: 'name'},
				   {name: 'fatherId'},
				   {name: 'fatherName'},
				   {name: 'desc'},
				   {name: 'siteId'}
				];

	Ext.onReady(function(){
		var toolbar = new Ext.Toolbar({
			width: '100%'
		});

		/** Start 添加同级部门  */
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnAddBrother',
				text: '添加同级部门',
				iconCls: 'addbtn',
				listeners: {
					'click': function(obj, e) {
						var node = tree.getSelectionModel().getSelectedNode();
						actiontype = "add";
						win.setTitle("添加部门");
						win.setIconClass("addbtn");
						dptForm.form.reset();
						if(node) {
							dptForm.findById('fatherId').setValue(node.attributes.fatherId);
							dptForm.findById('fatherName').setValue(node.parentNode.attributes.name);
						} else {
							dptForm.findById('fatherId').setValue(0);
							dptForm.findById('fatherName').setValue('');
						}
						win.show(this);
					}
				}
			})
		);
		toolbar.addSeparator();

		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnAddChild',
				text: '添加下级部门',
				iconCls: 'addbtn',
				listeners: {
					'click': function(obj, e) {
						var node = tree.getSelectionModel().getSelectedNode();
						actiontype = "add";
						win.setTitle("添加部门");
						win.setIconClass("addbtn");
						dptForm.form.reset();
						if(node) {
							dptForm.findById('fatherId').setValue(node.attributes.id);
							dptForm.findById('fatherName').setValue(node.attributes.name);
						} else {
							dptForm.findById('fatherId').setValue(0);
							dptForm.findById('fatherName').setValue('');
						}
						win.show(this);
					}
				}
			})
		);
		toolbar.addSeparator();
		/** End 添加同级部门  */
		
		/** Start 编辑  */
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnEdit',
				text: '编辑',
				disabled: true,
				iconCls: 'editbtn',
				listeners: {
					'click': function(obj, e) {
						var node = tree.getSelectionModel().getSelectedNode();
						if(!node) {
							Ext.Msg.alert('编辑部门', '请选择要修改的部门！');
						} else {
							actiontype = "edit";
							win.setTitle("编辑部门");
							win.setIconClass("editbtn");
							dptForm.form.reset();
							dptForm.form.setValues(node.attributes);
							win.show(this);
						}
					}
				}
			})
		);
		toolbar.addSeparator();
		/** End 编辑  */
		
		/** Start 删除  */
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnDelete',
				text: '删除',
				disabled: true,
				iconCls: 'delbtn',
				listeners: {
					'click': function(obj, e) {
						var node = tree.getSelectionModel().getSelectedNode();
						if(!node) {
							Ext.Msg.alert('删除部门', '请选择要删除的部门！');
						} else {
							Ext.Msg.show({
								title:'删除部门?',
								msg: '请再次确实是否要将选中的部门删除?',
								buttons: Ext.Msg.YESNOCANCEL,
								fn: function(btn, text) {
									if(btn == "yes") {
										if(!node.leaf) {
											Ext.Msg.show({
												title:'删除部门?',
												msg: '当前部门下有子部门，所有子部门将会同时被删除！请再次确实是否要将选中的部门删除?',
												buttons: Ext.Msg.YESNOCANCEL,
												fn: function(btn, text) {
													if(btn == "yes") {
														Ext.Ajax.request({
															url: window.webRoot + 'Dept/' + node.attributes.id,
															method: 'POST',
															params: {
																_method: 'DELETE'
															},
															success: function(response,options) {
																var respText = Ext.util.JSON.decode(response.responseText);
																if(respText.code != 'OK') {
																	Ext.Msg.alert('删除失败', respText.message + "（" + respText.code + "）");
																} else {
																	tree.getLoader().load(tree.getRootNode());
																}
															},
															failure: function() {
																Ext.Msg.alert('删除失败', '删除部门失败！');
															}
														});
													}
												},
												icon: Ext.MessageBox.QUESTION
											});						
										} else {
											Ext.Ajax.request({
												url: window.webRoot + 'Dept/' + node.attributes.id,
												method: 'POST',
												params: {
													_method: 'DELETE'
												},
												success: function(response,options) {
													var respText = Ext.util.JSON.decode(response.responseText);
													if(respText.code != 'OK') {
														Ext.Msg.alert('删除失败', respText.message + "（" + respText.code + "）");
													} else {
														tree.getLoader().load(tree.getRootNode());
													}
												},
												failure: function() {
													Ext.Msg.alert('删除失败', '删除部门失败！');
												}
											});
										}
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
		/** End 删除  */
		
		/** Start 启用  */
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnEnable',
				text: '启用',
				disabled: true,
				iconCls: 'enablebtn',
				listeners: {
					'click': function(obj, e) {
						var node = tree.getSelectionModel().getSelectedNode();
						if(!node) {
							Ext.Msg.alert('启用部门', '请选择要启用的部门！');
						} else {
							Ext.Msg.show({
								title:'启用部门?',
								msg: '请再次确实是否要启用已选中的部门?',
								buttons: Ext.Msg.YESNOCANCEL,
								fn: function(btn, text) {
									if(btn == "yes") {
										Ext.Ajax.request({
											url: window.webRoot + 'Dept/' + node.attributes.id + '/enable',
											method: 'POST',
											params: {
												_method: 'PUT'
											},   
											success: function(response,options) {
												var respText = Ext.util.JSON.decode(response.responseText);
												if(respText.code != 'OK') {
													Ext.Msg.alert('启用失败', respText.message + "（" + respText.code + "）");
												} else {
													tree.getLoader().load(tree.getRootNode());
												}
											},
											failure: function(response,options) {
												Ext.Msg.alert('启用失败', '启用部门失败！');
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
		/** End 启用 */
		
		/** Start 停用  */
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnDisable',
				text: '停用',
				disabled: true,
				iconCls: 'disablebtn',
				listeners: {
					'click': function(obj, e) {
						var node = tree.getSelectionModel().getSelectedNode();
						if(!node) {
							Ext.Msg.alert('停用部门', '请选择要停用的部门！');
						} else {
							Ext.Msg.show({
								title:'停用部门?',
								msg: '请再次确实是否要停用已选中的部门?',
								buttons: Ext.Msg.YESNOCANCEL,
								fn: function(btn, text) {
									if(btn == "yes") {
										Ext.Ajax.request({
											url: window.webRoot + 'Dept/' + node.attributes.id + '/disable',
											method: 'POST',
											params: {
												_method: 'PUT'
											},
											success: function(response,options) {
												var respText = Ext.util.JSON.decode(response.responseText);
												if(respText.code != 'OK') {
													Ext.Msg.alert('停用失败', respText.message + "（" + respText.code + "）");
												} else {
													tree.getLoader().load(tree.getRootNode());
												}
											},
											failure: function(response,options) {
												Ext.Msg.alert('停用失败', '停用部门失败！');
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
		/** End 停用 */

		tree = new Ext.ux.tree.TreeGrid({
			region: 'center',
			width: Ext.getBody().getWidth(),
			height: Ext.getBody().getHeight(),
			tbar: toolbar,
			enableDD: true,
			iconCls: 'treebtn',
			border: false,
		renderTo: Ext.getBody(),

			columns:[{
				header: '名称',
				dataIndex: 'name',
				width: 300
			},{
				header: '描述',
				dataIndex: 'desc',
				width: 500
			},
			{
				header   : '状态',
				width: 300,
				dataIndex: 'status',
				tpl: new Ext.XTemplate('{status:this.showStatus}', {
					showStatus: function(v) {
						if(v == '0') {
							return '<font style="color:green">已启用</font>';
						} else if(v == '1') {
							return '<font style="color:red">已停用</font>';
						} else {
							'';
						}
					}
				})
			}],

			dataUrl: window.webRoot + 'Dept/TreeView/0'
		});

		tree.on('click', function(node, e) {
			try{
				Ext.getCmp('btnEdit').setDisabled(false);
				Ext.getCmp('btnDelete').setDisabled(false);
				Ext.getCmp('btnEnable').setDisabled(false);
				Ext.getCmp('btnDisable').setDisabled(false);
			} catch (e) {
			}
		});

		tree.on('movenode', function(t, node, oldParent, newParent, index) {
			Ext.Ajax.request({
				method: 'POST',
				params: {
					_method: 'PUT'
				},
				url: window.webRoot + 'Dept/'+node.attributes.id+'/moveto/'+newParent.attributes.id,
				success: function() {
					
				},
				failure: function() {
					Ext.Msg.alert('保存失败', '移动部门节点的操作失败！');
					tree.getLoader().load(tree.getRootNode());
				}
			});

		});

		/** 列表双击操作 Start */
		tree.addListener('dblclick', function(obj, e) {
						Ext.getCmp('btnEdit').fireEvent('click'); 
					});    
/*
		tree.addListener('dblclick', function(obj, e) {
						Ext.getCmp('btnDelete').fireEvent('click'); 
					}); 
*/
		/** 列表双击操作 End */
		
		/** 列表右键点击菜单 Start */
		var rightClick = new Ext.menu.Menu();
			rightClick.add({
				text : '添加同级部门',
				iconCls : 'addbtn',
				handler : function(obj, e) {
						Ext.getCmp('btnAddBrother').fireEvent('click'); 
					}
			});
			rightClick.add({
				text : '添加下级部门',
				iconCls : 'addbtn',
				handler : function(obj, e) {
						Ext.getCmp('btnAddChild').fireEvent('click'); 
					}
			});
			rightClick.add({
				text : '编辑',
				iconCls : 'editbtn',
				handler : function(obj, e) {
						Ext.getCmp('btnEdit').fireEvent('click'); 
					}
			});
			rightClick.add({
				text : '删除',
				iconCls : 'delbtn',
				handler : function(obj, e) {
						Ext.getCmp('btnDelete').fireEvent('click'); 
					}
			});
			rightClick.add({
				text : '启用',
				iconCls : 'enablebtn',
				handler : function(obj, e) {
						Ext.getCmp('btnEnable').fireEvent('click'); 
					}
			});
			rightClick.add({
				text : '停用',
				iconCls : 'disablebtn',
				handler : function(obj, e) {
						Ext.getCmp('btnDisable').fireEvent('click'); 
					}
			});
		tree.addListener('contextmenu', function(node, e) {
			e.preventDefault();
            rightClick.showAt(e.getXY());
		});
		/** 列表右键点击菜单 End */	  

		dptForm = new Ext.FormPanel({
			labelWidth: 75,
			frame:true,
			width: 350,
			defaults: {width: 230},
			defaultType: 'textfield',

			reader: new Ext.data.JsonReader({root:'data'},fields),

			items: [{
					fieldLabel: '部门名称',
					name: 'name',
					allowBlank:false
				},{
					fieldLabel: 'ID',
					name: 'id',
					hidden:true
				},{
					id: 'fatherId',
					fieldLabel: '父部门ID',
					name: 'fatherId',
					hidden: true
				},{
					id: 'fatherName',
					fieldLabel: '上级部门',
					name: 'fatherName',
					disabled: true
				},{
					fieldLabel: '简要说明',
					name: 'desc',
					height: 120,
					xtype: 'textarea'
				}
			],

			buttons: [{
				text: '保&nbsp;存',
				handler: function() {
					var vals = dptForm.form.getValues();
					if(dptForm.form.isValid()) {
						if(actiontype == "add") {
							dptForm.form.submit({
								url: window.webRoot + 'Dept',
								method: 'POST',
								params: {
									_method: 'POST'
								},
								success: function(form, action) {
									Ext.Msg.alert('保存成功', '添加部门成功！');
									tree.getLoader().load(tree.getRootNode());
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
							dptForm.form.submit({
								url: window.webRoot + 'Dept/' + vals.id,
								method: 'POST',
								params: {
									_method: 'PUT'
								},
								success: function(form, action) {
									Ext.Msg.alert('修改成功', '修改部门成功！');
									tree.getLoader().load(tree.getRootNode());
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

		/**
		 *  明细信息
		 **/

		/** 部门下的用户列表 Start */
		var store_department_user = new Ext.data.JsonStore({
			root: 'data',
			totalProperty: 'total',
			idProperty: 'id',
			remoteSort: false,

			fields: [
					   {name: 'id'},
					   {name: 'name'},
					   {name: 'no'},
						{
							name : 'tenantId', 
							convert: function(value, record) {
								return record.tenant? record.tenant.id : '';
							}
						},
						{
							name : 'tenantName', 
							convert: function(value, record) {
								return record.tenant? record.tenant.name : '';
							}
						}
					]
			,
			
			url: 'empty.jsp'
		});
    
		store_department_user.setDefaultSort('name', 'asc');

		var listview_users = new Ext.grid.GridPanel({
			store: store_department_user,
			border: false,
			viewConfig: {forceFit:true}, 
			loadMask: true,
			autoHeight:true,
			columns: [
				{
				header   : '用户编号', 
				width: .2,
				dataIndex: 'no'
				},
				{
				header   : '用户名称', 
				width: .4,
				dataIndex: 'name'
				}
			]
		});
		/** 角色下的用户列表 End */
		
		var infotab = new Ext.TabPanel({
			collapsible: true,
			region: 'south',
			collapseMode:'mini',
			activeTab: 0, 
			border: false,
			height: 200,
			items: [{
				title: '部门下的用户',
				autoScroll: true,
				items: [listview_users]
			}]
		});

		tree.on('click', function(node, e) {
			var id = node.attributes.id;
			store_department_user.proxy.setUrl(window.webRoot + 'Dept/' + id + '/users', true);
			store_department_user.load();
			infotab.expand(true);
		});

        var viewport = new Ext.Viewport({
            layout: 'border',
			autoHeight: true,
			border: false,
            items: [tree, infotab]
		});	
		infotab.collapse(true);

		win = new Ext.Window({
			applyTo:'adduser-win',
			layout:'fit',
			width: 350,
			height:300,
			closeAction:'hide',
			modal: true,
			plain: true,
			title: "添加部门",
			iconCls: "addbtn",
			items: [dptForm]
		});

	});	
	</script>

</head>
<body>
	<div id="adduser-win" class="x-hidden"></div>
</body>
</html>
