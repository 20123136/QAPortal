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
    <title>角色管理</title>
 
    <link rel="stylesheet" type="text/css" href="../css/ext-all-notheme.css" />
    <link rel="stylesheet" type="text/css" href="../css/xtheme-gray.css" />
    <link rel="stylesheet" type="text/css" href="../ux/css/MultiSelect.css" />
 
    <style type=text/css>
        /* style rows on mouseover */
        .x-grid3-row-over .x-grid3-cell-inner {
            font-weight: bold;
        }
        
		.complete .x-tree-node-anchor span {
			color: red;
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
		.assignbtn {
			background-image:url("../images/icons/fam/connect.png");
		}
		.user_leaf {
			background-image:url("../images/icons/fam/plugin.gif");
		}
		.user_folder {
			background-image:url("../images/icons/fam/plugin_add.gif");
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
		.menubtn {
			background-image:url("../images/icons/fam/application_double.png");
		}
		.functionbtn {
			background-image:url("../images/icons/fam/key.png");
		}
		.deptbtn {
			background-image:url("../images/icons/fam/group.png");
		}

    </style>
 
    <script type="text/javascript" src="../js/ext-base-debug.js"></script>
    <script type="text/javascript" src="../js/ext-all-debug.js"></script>
    <script type="text/javascript" src="../js/ext-lang-zh_CN.js"></script>
    <script type="text/javascript" src="../js/ext-ui-combo-pagesize.js"></script>
    <script type="text/javascript" src="../ux/TabCloseMenu.js"></script>
	<script type="text/javascript" src="../ux/treegrid/TreeGridSorter.js"></script>
	<script type="text/javascript" src="../ux/treegrid/TreeGridColumnResizer.js"></script>
	<script type="text/javascript" src="../ux/treegrid/TreeGridNodeUI.js"></script>
	<script type="text/javascript" src="../ux/treegrid/TreeGridLoader.js"></script>
	<script type="text/javascript" src="../ux/treegrid/TreeGridColumns.js"></script>
	<script type="text/javascript" src="../ux/treegrid/TreeGrid.js"></script>

	<script type="text/javascript" src="../js/app/common/Grid.js"></script>
    <script type="text/javascript" src="../js/app/common/Tab.js"></script>
    <script type="text/javascript" src="../js/app/common/TreePanel.js"></script>
    <script type="text/javascript" src="../js/app/mgr/MenuSelectorGrid.js"></script>
    <script type="text/javascript" src="../js/app/mgr/PrivilegeFunctionSelectorGrid.js"></script>
    <script type="text/javascript" src="../js/app/mgr/DepartmentSelectorTreePanel.js"></script>
    <script type="text/javascript" src="../js/app/mgr/PrivilegeDepartmentSelectorPanel.js"></script>
    <script type="text/javascript" src="../js/app/mgr/PrivilegeTab.js"></script>
    <script type="text/javascript" src="../ux/MultiSelect.js"></script>
    <script type="text/javascript" src="../ux/ItemSelector.js"></script>
    <script type="text/javascript" src="../js/func.js"></script>
	<script >
		var webRoot = '<%=webRoot%>';
	</script>
    <script type="text/javascript">
	var curId = 0;
	var win;
	var win_assign_pri;
	var win_assign_user;
	var pagesize = 25;
	var grid;
	var form;
	var actiontype = "";

	var fields = [
				   {name: 'id'},
				   {name: 'name'},
				   {name: 'description'},
				   {name: 'status'}
				];

	function showStatus(val) {
		if(val == 'AVAILABLE') {
			return '<font style="color:green">已启用</font>';
		} else if(val == 'DISABLED') {
			return '<font style="color:red">已停用</font>';
		} else {
			'';
		}
	}

	Ext.onReady(function(){
		var store = new Ext.data.JsonStore({
			root: 'data',
			totalProperty: 'total',
			idProperty: 'id',
			remoteSort: false,

			fields: fields,
			
			restful: true,
			proxy: new Ext.data.HttpProxy({
				url: window.webRoot + 'rest/roles'
			})
		});
    
		store.setDefaultSort('name', 'asc');

		var toolbar = new Ext.Toolbar({
			width: '100%'
		});
		
		/** Start 添加角色 */
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnAdd',
				text: '添加角色',
				iconCls: 'addbtn',
				listeners: {
					'click': function(obj, e) {
						actiontype = "add";
						win.setTitle("添加角色");
						win.setIconClass("addbtn");
						form.form.reset();
						win.show(this);
					}
				}
			})
		);
		toolbar.addSeparator();
		/** End 添加角色 */
		
		/** Start 编辑角色 */
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnEdit',
				text: '编辑角色',
				disabled: true,
				iconCls: 'editbtn',
				listeners: {
					'click': function(obj, e) {
						var rec = grid.getSelectionModel().getSelected();
						if(!rec) {
							Ext.Msg.alert('编辑角色', '请选择要修改的角色！');
						} else {
							actiontype = "edit";
							win.setTitle("编辑角色");
							win.setIconClass("editbtn");
							form.form.reset();
							form.form.setValues(rec.data);
							win.show(this);
						}
					}
				}
			})
		);
		toolbar.addSeparator();
		/** End 编辑角色 */
		
		/** Start 删除角色 */
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnDelete',
				text: '删除角色',
				disabled: true,
				iconCls: 'delbtn',
				listeners: {
					'click': function(obj, e) {
						var rec = grid.getSelectionModel().getSelected();
						if(!rec) {
							Ext.Msg.alert('删除角色', '请选择要删除的角色！');
						} else {
							Ext.Msg.show({
								title:'删除角色?',
								msg: '请再次确实是否要将选中的角色删除?',
								buttons: Ext.Msg.YESNOCANCEL,
								fn: function(btn, text) {
									if(btn == "yes") {
										var ids = new Array();
										Ext.each(grid.getSelectionModel().getSelections(), function(rec) {
											ids.push(rec.get('id'));
										});
										Ext.Ajax.request({
											url: window.webRoot + 'rest/roles/',
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
												Ext.Msg.alert('删除失败', '删除角色失败！');
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
		/** End 删除角色 */
		
		/** Start 启用角色 */
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnEnable',
				text: '启用角色',
				disabled: true,
				iconCls: 'enablebtn',
				listeners: {
					'click': function(obj, e) {
						var rec = grid.getSelectionModel().getSelected();
						if(!rec) {
							Ext.Msg.alert('启用角色', '请选择要启用的角色！');
						} else {
							Ext.Msg.show({
								title:'启用角色?',
								msg: '请再次确实是否要启用已选中的角色?',
								buttons: Ext.Msg.YESNOCANCEL,
								fn: function(btn, text) {
									if(btn == "yes") {
										var ids = new Array();
										Ext.each(grid.getSelectionModel().getSelections(), function(rec) {
											ids.push(rec.get('id'));
										}); 
										Ext.Ajax.request({
											url: window.webRoot + 'rest/roles/enable',
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
											failure: function(response,options) {
												Ext.Msg.alert('启用失败', '启用角色失败！');
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
		/** End 启用角色 */
		
		/** Start 停用角色 */
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnDisable',
				text: '停用角色',
				disabled: true,
				iconCls: 'disablebtn',
				listeners: {
					'click': function(obj, e) {
						var rec = grid.getSelectionModel().getSelected();
						if(!rec) {
							Ext.Msg.alert('停用角色', '请选择要停用的角色！');
						} else {
							Ext.Msg.show({
								title:'停用角色?',
								msg: '请再次确实是否要停用已选中的角色?',
								buttons: Ext.Msg.YESNOCANCEL,
								fn: function(btn, text) {
									if(btn == "yes") {
										var ids = new Array();
										Ext.each(grid.getSelectionModel().getSelections(), function(rec) {
											ids.push(rec.get('id'));
										});
										Ext.Ajax.request({
											url: window.webRoot + 'rest/roles/disable',
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
											failure: function(response,options) {
												Ext.Msg.alert('停用失败', '停用角色失败！');
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
		/** End 停用角色 */
		
		/** Start 分配用户 */
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnAssignUser',
				text: '分配用户',
				disabled: true,
				iconCls: 'assignbtn',
				listeners: {
					'click': function(obj, e) {
						win_assign_user.setTitle("分配用户");
						win_assign_user.setIconClass("assignbtn");
						var rec = grid.getSelectionModel().getSelected();
						if(!rec) {
							Ext.Msg.alert('分配用户', '请选择要分配用户的角色！');
						} else {
							userFromStore.load();
							userToStore.removeAll();
							win_assign_user.show(this);
						}
					}
				}
			})
		);
		toolbar.addSeparator();
		/** End 分配用户 */
		
		/** Start 分配权限 */
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnAssignPrivilege',
				text: '分配权限',
				disabled: true,
				iconCls: 'assignbtn',
				listeners: {
					'click': function(obj, e) {
						win_assign_pri.setTitle("分配权限");
						win_assign_pri.setIconClass("assignbtn");
						var rec = grid.getSelectionModel().getSelected();
						if(!rec) {
							Ext.Msg.alert('分配用户', '请选择要分配用户的角色！');
						} else {
							if(grid.getSelectionModel().getCount() == 1) {
								Ext.getCmp('tabPrivilege').reset();
								Ext.Ajax.request({
									url: window.webRoot + 'rest/role/' + rec.get('id') + '/pris',
									success: function(response){
										var ids = new Array();
										var val = Ext.util.JSON.decode(response.responseText);
										if(val.code == 'OK'){
											setTimeout(function() {
												Ext.getCmp('tabPrivilege').setVal(val.data);
											},500);
										}
									}
								});
								win_assign_pri.show(this);
							}
						}
					}
				}
			})
		);
		toolbar.addSeparator();
		/** End 分配用户 */

		var sm = new Ext.grid.CheckboxSelectionModel();

		grid = new Ext.grid.GridPanel({
            region: 'center',
			tbar: toolbar,
			store: store,
			border: false,
			selModel: sm,
			columns: [
				sm, 
				{
					header   : '名称', 
					width    : .3, 
					sortable : true, 
					dataIndex: 'name'
				},
				{
					header   : '说明', 
					width    : .4, 
					sortable : true, 
					dataIndex: 'description'
				},
				{
					header   : '状态',
					width    : .2,
					sortable : true,
					dataIndex: 'status',
					renderer : showStatus
				}
			],
			stripeRows: true,
			height: 600,
			width: '100%',
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
						Ext.getCmp('btnAssignUser').fireEvent('click'); 
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
				text : '添加',
				iconCls : 'addbtn',
				handler : function(obj, e) {
						Ext.getCmp('btnAdd').fireEvent('click'); 
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
			rightClick.addSeparator();
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
			rightClick.addSeparator();
			rightClick.add({
				text : '分配用户',
				iconCls : 'assignbtn',
				handler : function(obj, e) {
						Ext.getCmp('btnAssignUser').fireEvent('click'); 
					}
			});
			rightClick.addSeparator();
			rightClick.add({
				text : '分配权限',
				iconCls : 'assignbtn',
				handler : function(obj, e) {
						Ext.getCmp('btnAssignPrivilege').fireEvent('click'); 
					}
			});

		grid.addListener('rowcontextmenu', function(client, rowIndex, e) {
			e.preventDefault();
            rightClick.showAt(e.getXY());
		});
		/** 列表右键点击菜单 End */	  
		
		grid.on('rowclick', function(grid, rowIndex, e) {
			try{
				Ext.getCmp('btnEdit').setDisabled(false);
				Ext.getCmp('btnDelete').setDisabled(false);
				Ext.getCmp('btnAssignUser').setDisabled(false);
				Ext.getCmp('btnAssignPrivilege').setDisabled(false);
				var rec = grid.getSelectionModel().getSelected();
				if(rec.get('status') == 'AVAILABLE') { 
					Ext.getCmp('btnEnable').setDisabled(true);
					Ext.getCmp('btnDisable').setDisabled(false);
				} else if (rec.get('status') == 'DISABLED') {
					Ext.getCmp('btnEnable').setDisabled(false);
					Ext.getCmp('btnDisable').setDisabled(true);
				} else {
					Ext.getCmp('btnEnable').setDisabled(true);
					Ext.getCmp('btnDisable').setDisabled(true);
				}
			} catch (e) {
			}
		});
		
		store.load({params:{start:0, limit:pagesize}});

		form = new Ext.FormPanel({
			labelWidth: 75,
			frame:true,
			width: 350,
			defaults: {width: 230},
			defaultType: 'textfield',

			reader: new Ext.data.JsonReader({root:'data'},fields),

			items: [{
					fieldLabel: '名称',
					name: 'name',
					allowBlank:false
				},{
					fieldLabel: 'ID',
					name: 'id',
					hidden:true
				},{
					fieldLabel: '说明',
					name: 'description',
					height: 160,
					xtype: 'textarea'
				}
				],

			buttons: [{
				text: '保&nbsp;存',
				handler: function() {
					if(form.form.isValid()) {
						if(actiontype == "add") {
							form.form.submit({
								url: window.webRoot + 'rest/role/',
								method: 'POST',
								params: {
									_method: 'POST'
								},
								success: function(form, action) {
									Ext.Msg.alert('保存成功', '添加角色成功！');
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
							var vals = form.form.getValues();
							form.form.submit({
								url: window.webRoot + 'rest/role/' + vals.id,
								method: 'POST',
								params: {
									_method: 'PUT'
								},
								success: function(form, action) {
									Ext.Msg.alert('修改成功', '修改角色成功！');
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

		win = new Ext.Window({
			applyTo:'adduser-win',
			layout:'fit',
			width: 350,
			height:300,
			closeAction:'hide',
			modal: true,
			plain: true,
			title: "添加角色",
			iconCls: "addbtn",
			items: [form]
		});

		/**  分配用户 Start */
		userFromStore = new Ext.data.JsonStore({
			root: 'data',
			totalProperty: 'total',
			idProperty: 'id',

			fields: ['id','name'],
			proxy: new Ext.data.HttpProxy({
				url: window.webRoot + 'rest/users'
			}),

			listeners: 
				{'load': function(obj, recs, opts) {
						if(grid.getSelectionModel().getCount() == 1) {
							var rec = grid.getSelectionModel().getSelected();
							Ext.Ajax.request({
								url: window.webRoot + 'rest/role/' + rec.get('id') + '/users',
								success: function(response){
									var ids = new Array();
									var val = Ext.util.JSON.decode(response.responseText);
									if(val.code == 'OK'){
										Ext.each(val.data, function(as) {
											ids.push(as.id);
										});
										Ext.getCmp('userSelector').setValue(ids);
									}
								}
							});
						}
					}
				}
		});

		userToStore = new Ext.data.ArrayStore({
			data: [],
			fields: ['id','name']
		});

		win_assign_user = new Ext.Window({
			applyTo:'assign-user-win',
			layout:'column',
			width: 497,
			height:420,
			closeAction:'hide',
			modal: true,
			plain: true,
			title: "分配用户",
			iconCls: "dispatchbtn",
			items:[{
				xtype: 'itemselector',
				name: 'itemselector',
				id: 'userSelector',
				fieldLabel: 'ItemSelector',
				imagePath: '../ux/images/',
				multiselects: [{
					width: 230,
					height: 355,
					store: userFromStore,
					displayField: 'name',
					valueField: 'id'
				},{
					width: 230,
					height: 355,
					store: userToStore,
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
							var userids = Ext.getCmp('userSelector').getValue().split(',');
							var ids = new Array();
							Ext.each(grid.getSelectionModel().getSelections(), function(rec) {
								ids.push(rec.get('id'));
							});
							Ext.Ajax.request({
								url: window.webRoot + 'rest/roles/assign/users',
								params: {
									_method: 'PUT',
									userid: userids,
									id: ids
								},
								success: function(response,options) {
									var respText = Ext.util.JSON.decode(response.responseText);
									if(respText.code != 'OK') {
										Ext.Msg.alert('分配用户失败', respText.message + "（" + respText.code + "）");
									} else {
										Ext.Msg.alert('分配用户成功', '用户已分配！');
									}
									win_assign_user.hide();
								},
								failure: function(response,options) {
									Ext.Msg.alert('分配用户失败', '分配用户失败！');
								}
							});
						} else {
							Ext.Msg.alert('分配用户', '请选择需要分配用户的角色');
						}
					}
				},{
					text: '取&nbsp;消',
					handler: function() {
						win_assign_user.hide();
					}
			}]

		});
		/**  分配用户 End */


		/**  分配权限 End */
		win_assign_pri = new Ext.Window({
			applyTo:'assign-pri-win',
			width: 850,
			height:485,
			closeAction:'hide',
			modal: true,
			plain: true,
			title: "分配权限",
			iconCls: "dispatchbtn",
			items:[
				new Ext.app.mgr.PrivilegeTab({
					id: 'tabPrivilege',
					height: 420	
				})
			],
			buttons: [
				{
					text: '保&nbsp;存',
					handler: function() {
						var rec = grid.getSelectionModel().getSelected();
						if(rec) {
							var ids = new Array();
							Ext.each(grid.getSelectionModel().getSelections(), function(rec) {
								ids.push(rec.get('id'));
							});
							var pris = Ext.getCmp('tabPrivilege').getVal();
							var menuids = '', funcids = '', deptids = '';
							if(pris['menu']) {
								menuids = pris['menu'];
							}
							if(pris['func']) {
								funcids = pris['func'];
							}
							if(pris['dept']) {
								deptids = pris['dept'];
							}
							Ext.Ajax.request({
								url: window.webRoot + 'rest/roles/assign/pris',
								params: {
									_method: 'PUT',
									menuid: menuids,
									funcid: funcids,
									deptid: deptids,
									id: ids
								},
								success: function(response,options) {
									var respText = Ext.util.JSON.decode(response.responseText);
									if(respText.code != 'OK') {
										Ext.Msg.alert('分配权限失败', respText.message + "（" + respText.code + "）");
									} else {
										Ext.Msg.alert('分配权限成功', '权限已分配！');
									}
									win_assign_pri.hide();
								},
								failure: function(response,options) {
									Ext.Msg.alert('分配权限失败', '分配权限失败！');
								}
							});
						} else {
							Ext.Msg.alert('分配权限', '请选择需要分配权限的角色');
						}
					}
				},{
					text: '取&nbsp;消',
					handler: function() {
						win_assign_pri.hide();
					}
			}]

		});
		/**  分配权限 End */


		/**
		 *  明细信息
		 **/


		/** 角色下的用户列表 Start */
		var store_role_user = new Ext.data.JsonStore({
			root: 'data',
			totalProperty: 'total',
			idProperty: 'id',
			remoteSort: false,

			fields: [
					   {name: 'id'},
					   {name: 'name'},
					   {name: 'no'}
					]
			,
			
			url: 'empty.jsp'
		});
    
		store_role_user.setDefaultSort('name', 'asc');

		var listview_users = new Ext.grid.GridPanel({
			store: store_role_user,
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
			height: 200,
			items: [{
				title: '角色下的用户',
				autoScroll: true,
				items: [listview_users]
			}]
		});

		grid.on('rowclick', function(grid, rowIndex, e) {
			var rec = grid.getSelectionModel().getSelected();
			store_role_user.proxy.setUrl(window.webRoot + 'rest/role/' + rec.get('id') + '/users', true);
			store_role_user.load();
			infotab.expand(true);
		});

        var viewport = new Ext.Viewport({
            layout: 'border',
			autoHeight: true,
			border: false,
            items: [grid, infotab]
		});	
		infotab.collapse(true);

	});	
	</script>
 
</head>
<body>
	<div id="adduser-win" class="x-hidden"></div>
	<div id="assign-pri-win" class="x-hidden"></div>
	<div id="assign-user-win" class="x-hidden"></div>
	<div id="assign-tenant-win" class="x-hidden"></div>
</body>
</html>
