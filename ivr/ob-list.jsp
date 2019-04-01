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
    <title>外拨管理</title>
  
    <link rel="stylesheet" type="text/css" href="../css/ext-all-notheme.css" />
    <link rel="stylesheet" type="text/css" href="../css/xtheme-gray.css" />
    <link rel="stylesheet" type="text/css" href="../ux/css/MultiSelect.css" />

    <link rel="stylesheet" type="text/css" href="../css/icon.css" />
 
    <script type="text/javascript" src="../js/ext-base.js"></script>
    <script type="text/javascript" src="../js/ext-all.js"></script>
    <script type="text/javascript" src="../js/ext-lang-zh_CN.js"></script>
    <script type="text/javascript" src="../js/ext-ui-combo-pagesize.js"></script>
    <script type="text/javascript" src="../js/app/common/ComboBox.js"></script>
    <script type="text/javascript" src="../js/app/mgr/OBGroupSelector.js"></script>
    <script type="text/javascript" src="../ux/MultiSelect.js"></script>
    <script type="text/javascript" src="../ux/ItemSelector.js"></script>
    <script type="text/javascript" src="../js/func.js"></script>
    <script type="text/javascript" src="../js/app/rec/Excel.js"></script>
	<script >
		var webRoot = '<%=webRoot%>';
	</script>
    <script type="text/javascript">
	var curId = 0;
	var win;
	var pagesize = 25;
	var grid;
	var userForm ;
	var actiontype = "";

	var fields = [
				   {name: 'id'},
 				   {name: 'phoneNo'},
				   {name: 'groupName'},
				   {name: 'groupId'},
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
				url: window.webRoot + 'OBs'
			})

		}); 
    
		store.setDefaultSort('phoneNo', 'asc');
 
		var toolbar = new Ext.Toolbar({
			width: '100%'
		});
		
		//START添加外拨功能工具条button
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnAdd',
				text: '添加',
				iconCls: 'useraddbtn',
				listeners: {
					'click': function(obj, e) {
						actiontype = "add";
						win.setTitle("添加外拨");
						win.setIconClass("addbtn");
						userForm.form.reset();
						win.show(this);
					}
				}
			})
		);
		toolbar.addSeparator();
		//END添加外拨功能工具条button
		
	
		//START编辑外拨功能工具条button
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnEdit',
				text: '编辑',
				disabled: true,
				iconCls: 'usereditbtn',
				listeners: {
					'click': function(obj, e) {
						var rec = grid.getSelectionModel().getSelected();
						if(!rec) {
							Ext.Msg.alert('编辑外拨', '请选择要修改的外拨！');
						} else {
							actiontype = "edit";
							win.setTitle("编辑外拨");
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
		//END编辑外拨功能工具条button
		
		//START启用外拨功能工具条button
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnEnable',
				text: '启用',
				disabled: true,
				iconCls: 'enablebtn',
				listeners: {
					'click': function(obj, e) {
						var rec = grid.getSelectionModel().getSelected();
						if(!rec) {
							Ext.Msg.alert('启用外拨', '请选择要启用的外拨！');
						} else {
							Ext.Msg.show({
								title:'启用外拨?',
								msg: '请再次确实是否要启用选中的外拨?',
								buttons: Ext.Msg.YESNOCANCEL,
								fn: function(btn, text) {
									if(btn == "yes") {
										var ids = new Array();
										Ext.each(grid.getSelectionModel().getSelections(), function(rec) {
											ids.push(rec.get('id'));
										});
										Ext.Ajax.request({
											url: window.webRoot + 'OB/enable',
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
												Ext.Msg.alert('启用失败', '启用外拨失败！');
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
		//END启用外拨功能工具条button
		
		//START停用外拨功能工具条button
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnDisable',
				text: '停用',
				disabled: true,
				iconCls: 'disablebtn',
				listeners: {
					'click': function(obj, e) {
						var rec = grid.getSelectionModel().getSelected();
						if(!rec) {
							Ext.Msg.alert('停用外拨', '请选择要停用的外拨！');
						} else {
							Ext.Msg.show({
								title:'停用外拨?',
								msg: '请再次确实是否要停用选中的外拨?',
								buttons: Ext.Msg.YESNOCANCEL,
								fn: function(btn, text) {
									if(btn == "yes") {
										var ids = new Array();
										Ext.each(grid.getSelectionModel().getSelections(), function(rec) {
											ids.push(rec.get('id'));
										});
										Ext.Ajax.request({
											url: window.webRoot + 'OB/disable',
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
												Ext.Msg.alert('停用失败', '停用外拨失败！');
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
		//END停用外拨功能工具条button
		
		//START删除外拨功能工具条button
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnDelete',
				text: '删除',
				disabled: true,
				iconCls: 'userdelbtn',
				listeners: {
					'click': function(obj, e) {
						var rec = grid.getSelectionModel().getSelected();
						if(!rec) {
							Ext.Msg.alert('删除外拨', '请选择要删除的外拨！');
						} else {
							Ext.Msg.show({
								title:'删除外拨?',
								msg: '请再次确实是否要将选中的外拨删除?',
								buttons: Ext.Msg.YESNOCANCEL,
								fn: function(btn, text) {
									if(btn == "yes") {
										var ids = new Array();
										Ext.each(grid.getSelectionModel().getSelections(), function(rec) {
											ids.push(rec.get('id'));
										});
										Ext.Ajax.request({
											url: window.webRoot + 'OB',
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
												Ext.Msg.alert('删除失败', '删除外拨失败！');
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
		//END删除外拨功能工具条button

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
					header   : '手机号码', 
					width    : 60, 
					sortable : true, 
					dataIndex: 'phoneNo'
				},
				{
					header   : '外拨组别', 
					width    : 60, 
					sortable : true, 
					dataIndex: 'groupName'
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
				id: 'menuDelete',
				text : '删除',
				iconCls : 'userdelbtn',
				handler : function(obj, e) {
						Ext.getCmp('btnDelete').fireEvent('click'); 
					}
			});

			rightClick.addSeparator();


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
			labelWidth: 75,
			frame:true,
			width: 350,
			defaults: {width: 230},
			defaultType: 'textfield',

			reader: new Ext.data.JsonReader({root:'data'},fields),

			items: [{
					fieldLabel: '手机号',
					name: 'phoneNo'
				},
				{
					fieldLabel: '流水号',
					name: 'id',
					hidden:true
				},
				new Ext.app.mgr.OBGroupSelector({
					id : 'frmGroup',
					hiddenName : 'groupId',
					name: 'groupId'
				})
				],

			buttons: [{
				text: '保&nbsp;存',
				handler: function() {
					if(userForm.form.isValid()) {
						if(actiontype == "add") {
							userForm.form.submit({
								url: window.webRoot + 'OB',
								method: 'POST',
								params: {
									_method: 'POST'
								},
								success: function(form, action) {
									Ext.Msg.alert('保存成功', '添加外拨成功！');
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
								url: window.webRoot + 'OB/' + vals.id,
								method: 'POST',
								params: {
									_method: 'PUT'
								},
								success: function(form, action) {
									Ext.Msg.alert('修改成功', '修改外拨成功！');
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
			tbar: [
				'手机号码:&nbsp;&nbsp;',
				new Ext.form.TextField({
					id: 'qryPhoneNo',
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
				'外拨组别:&nbsp;&nbsp;',
				new Ext.app.mgr.OBGroupSelector({
					id: 'qryGroupName',
					fieldLabel: '组别名称',
					hiddenName : 'groupId',
					valueField: 'id',
					displayField: 'name',
					name: 'groupId',
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
						Ext.getCmp('qryPhoneNo').setValue('');
						Ext.getCmp('qryGroupName').setValue('');
						store.load({params:{start:0, limit:pagesize}});
					}
				}),
				'-'
			],
			items: grid
		});
 
		store.on('beforeload', function(loader, node) {
			var name = Ext.getCmp('qryGroupName').getValue();
			var no= Ext.getCmp('qryPhoneNo').getValue();
			store.baseParams = {phoneNo:no, groupId:name};
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
			title: "添加外拨",
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
