<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Expires", "0");

	request.setCharacterEncoding("UTF-8");

	String webRoot = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";

%>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>数据源管理</title>

    <link rel="stylesheet" type="text/css" href="../css/ext-all-notheme.css" />
    <link rel="stylesheet" type="text/css" href="../css/xtheme-gray.css" />

	<link rel="stylesheet" type="text/css" href="../css/icon.css" />

	<script >
		var webRoot = '<%=webRoot%>';
	</script>

<script type="text/javascript" src="../js/ext-base.js"></script>
<script type="text/javascript" src="../js/ext-all.js"></script>
<script type="text/javascript" src="../js/ext-lang-zh_CN.js"></script>
<script type="text/javascript" src="../js/ext-ui-combo-pagesize.js"></script>
<script type="text/javascript">
	var curId = 0;
	var win;
	var pagesize = 25;
	var grid;
	var form;
	var actiontype = "";

	var fields = [
				   {name: 'id'},
				   {name: 'name'},
				   {name: 'description'},
				   {name: 'url'},
				   {name: 'clazz'},
				   {name: 'typeId'},
				   {name: 'userName'},
				   {name: 'password'},
				   {name: 'minActiveConn'},
				   {name: 'maxActiveConn'},
				   {name: 'status'}
				];

	function showStatus(val) {
		if(val == '0') {
			return '<font style="color:green">已启用</font>';
		} else if(val == '1') {
			return '<font style="color:red">已停用</font>';
		} else {
			'';
		}
	}


	Ext.onReady(function(){
		var store = new Ext.data.JsonStore({
			root: 'data',
			totalProperty: 'total',
			remoteSort: false,

			fields: fields,
			
			proxy: new Ext.data.HttpProxy({
				url: window.webRoot + 'DataSources'
			})

		});

		store.setDefaultSort('name', 'asc');

		var toolbar = new Ext.Toolbar({
			width: '100%'
		});

		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnAdd',
				text: '添加',
				iconCls: 'dbaddbtn',
				listeners: {
					'click': function(obj, e) {
						actiontype = "add";
						win.setTitle("添加");
						win.setIconClass("dbaddbtn");
						form.form.reset();
						win.show(this);
					}
				}
			})
		);
		toolbar.addSeparator()
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnEdit',
				text: '编辑',
				disabled: true,
				iconCls: 'dbeditbtn',
				listeners: {
					'click': function(obj, e) {
						var rec = grid.getSelectionModel().getSelected();
						if(!rec) {
							Ext.Msg.alert('编辑数据源', '请选择要修改的数据源！');
						} else {
							actiontype = "edit";
							win.setTitle("编辑数据源");
							win.setIconClass("dbeditbtn");
							form.form.reset();
							form.form.setValues(rec.data);
							win.show(this);
						}
					}
				}
			})
		);
		toolbar.addSeparator();
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnDelete',
				text: '删除',
				disabled: true,
				iconCls: 'dbdelbtn',
				listeners: {
					'click': function(obj, e) {
						var rec = grid.getSelectionModel().getSelected();
						if(!rec) {
							Ext.Msg.alert('删除数据源', '请选择要删除的数据源！');
						} else {
							Ext.Msg.show({
								title:'删除数据源',
								msg: '请再次确实是否要将选择的数据源删除?',
								buttons: Ext.Msg.YESNOCANCEL,
								fn: function(btn, text) {
									if(btn == "yes") {
										var ids = new Array();
										Ext.each(grid.getSelectionModel().getSelections(), function(rec) {
											ids.push(rec.get('id'));
										});
										grid.el.mask('请求已提交，请等待', 'x-mask-loading');
										Ext.Ajax.request({
											url: window.webRoot + 'DataSource',
											method: 'POST',
											params: {
												_method: 'DELETE',
												id: ids
											},
											success: function(response,options) {
												grid.el.unmask();
												var respText = Ext.util.JSON.decode(response.responseText);
												if(respText.code == 'OK') {
													var pgbar = grid.getBottomToolbar()
													var activePage = Math.ceil((pgbar.cursor + pgbar.pageSize) / pgbar.pageSize);
													var start = (activePage - 1) * pgbar.pageSize;
													store.load({params:{start:start, limit:pagesize}});
												} else {
													Ext.Msg.alert('删除失败', '删除数据源失败！');
												}
											},
											failure: function() {
												grid.el.unmask();
												Ext.Msg.alert('删除失败', '删除数据源失败！');
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
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnTest',
				text: '测试',
				disabled: true,
				iconCls: 'dbtestbtn',
				listeners: {
					'click': function(obj, e) {
						var rec = grid.getSelectionModel().getSelected();
						if(!rec) {
							Ext.Msg.alert('测试连接', '请选择要测试的数据源！');
						} else {
							grid.el.mask('请求已提交，请等待', 'x-mask-loading');
							Ext.Ajax.request({
								url: window.webRoot + 'DataSource/' +rec.get('id') + '/test',
								success: function(response,options) {
									grid.el.unmask();
									var respText = Ext.util.JSON.decode(response.responseText);
									if(respText.code == 'OK') {
										Ext.Msg.alert('连接成功', '连接数据源成功！');
									} else {
										Ext.Msg.alert('连接失败', '连接数据源失败！');
									}
								},
								failure: function() {
									grid.el.unmask();
									Ext.Msg.alert('连接失败', '连接数据源失败！');
								}
							});
						}
					}
				}
			})
		);
		toolbar.addSeparator();
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnEnable',
				text: '启用',
				disabled: true,
				iconCls: 'enablebtn',
				listeners: {
					'click': function(obj, e) {
						var rec = grid.getSelectionModel().getSelected();
						if(!rec) {
							Ext.Msg.alert('启用数据源', '请选择要启用的数据源！');
						} else {
							Ext.Msg.show({
								title:'启用数据源?',
								msg: '请再次确实是否要启用已选中的数据源?',
								buttons: Ext.Msg.YESNOCANCEL,
								fn: function(btn, text) {
									if(btn == "yes") {
										var ids = new Array();
										Ext.each(grid.getSelectionModel().getSelections(), function(rec) {
											ids.push(rec.get('id'));
										}); 
										grid.el.mask('请求已提交，请等待', 'x-mask-loading');
										Ext.Ajax.request({
											url: window.webRoot + 'DataSource/enable',
											method: 'POST',
											params: {
												_method: 'PUT',
												id: ids
											},   
											success: function(response,options) {
												grid.el.unmask();
												var respText = Ext.util.JSON.decode(response.responseText);
												if(respText.code != 'OK') {
													Ext.Msg.alert('启用失败', respText.message + "（" + respText.code + "）");
												} else {
													var pgbar = grid.getBottomToolbar()
													var activePage = Math.ceil((pgbar.cursor + pgbar.pageSize) / pgbar.pageSize);
													var start = (activePage - 1) * pgbar.pageSize;
													store.load({params:{start:start, limit:pagesize}});
												}
											},
											failure: function(response,options) {
												grid.el.unmask();
												Ext.Msg.alert('启用失败', '启用数据源失败！');
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
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnDisable',
				text: '停用',
				disabled: true,
				iconCls: 'disablebtn',
				listeners: {
					'click': function(obj, e) {
						var rec = grid.getSelectionModel().getSelected();
						if(!rec) {
							Ext.Msg.alert('停用数据源', '请选择要停用的数据源！');
						} else {
							Ext.Msg.show({
								title:'停用数据源?',
								msg: '请再次确实是否要停用已选中的数据源?',
								buttons: Ext.Msg.YESNOCANCEL,
								fn: function(btn, text) {
									if(btn == "yes") {
										var ids = new Array();
										Ext.each(grid.getSelectionModel().getSelections(), function(rec) {
											ids.push(rec.get('id'));
										});
										grid.el.mask('请求已提交，请等待', 'x-mask-loading');
										Ext.Ajax.request({
											url: window.webRoot + 'DataSource/disable',
											method: 'POST',
											params: {
												_method: 'PUT',
												id: ids
											},
											success: function(response,options) {
												grid.el.unmask();
												var respText = Ext.util.JSON.decode(response.responseText);
												if(respText.code != 'OK') {
													Ext.Msg.alert('停用失败', respText.message + "（" + respText.code + "）");
												} else {
													var pgbar = grid.getBottomToolbar()
													var activePage = Math.ceil((pgbar.cursor + pgbar.pageSize) / pgbar.pageSize);
													var start = (activePage - 1) * pgbar.pageSize;
													store.load({params:{start:start, limit:pagesize}});
												}
											},
											failure: function(response,options) {
												grid.el.unmask();
												Ext.Msg.alert('停用失败', '停用数据源失败！');
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
		toolbar.addSeparator()

		var sm = new Ext.grid.CheckboxSelectionModel();

		grid = new Ext.grid.GridPanel({
            region: 'center',
			tbar: toolbar,
			store: store,
			border: false,
			selModel: sm,
			columns: [
				sm, 
				new Ext.grid.RowNumberer(), 
				{
					header   : '名称', 
					width    : .1, 
					sortable : true, 
					dataIndex: 'name'
				},
				{
					header   : '描述', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'description'
				},
				{
					header   : 'URL', 
					width    : .3, 
					sortable : true, 
					dataIndex: 'url'
				},
				{
					header   : '用户名', 
					width    : .1, 
					sortable : true, 
					dataIndex: 'userName'
				},
				{
					header   : '状态',
					width    : .1,
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
/*
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
				text : '添加',
				iconCls : 'dbaddbtn',
				handler : function(obj, e) {
						Ext.getCmp('btnAdd').fireEvent('click'); 
					}
			});
			rightClick.add({
				text : '编辑',
				iconCls : 'dbeditbtn',
				handler : function(obj, e) {
						Ext.getCmp('btnEdit').fireEvent('click'); 
					}
			});
			rightClick.add({
				text : '删除',
				iconCls : 'dbdelbtn',
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
			rightClick.addSeparator();
			rightClick.add({
				text : '测试',
				iconCls : 'dbtestbtn',
				handler : function(obj, e) {
						Ext.getCmp('btnTest').fireEvent('click'); 
					}
			});
 		grid.addListener('rowcontextmenu', function(client, rowIndex, e) {
			e.preventDefault();
            rightClick.showAt(e.getXY());
		}); 
		/** 列表右键点击菜单 End */	  
		
		grid.on('rowclick', function(grid, rowIndex, e) {
			try {
				Ext.getCmp('btnEdit').setDisabled(false);
				Ext.getCmp('btnDelete').setDisabled(false);
				Ext.getCmp('btnTest').setDisabled(false);
				var rec = grid.getSelectionModel().getSelected();
				if(rec.get('status') == '0') { 
					Ext.getCmp('btnEnable').setDisabled(true);
					Ext.getCmp('btnDisable').setDisabled(false);
				} else if (rec.get('status') == '1') {
					Ext.getCmp('btnEnable').setDisabled(false);
					Ext.getCmp('btnDisable').setDisabled(true);
				} else {
					Ext.getCmp('btnEnable').setDisabled(true);
					Ext.getCmp('btnDisable').setDisabled(true);
				}
			} catch (e)	{
			}
		});
		
		store.load({params:{start:0, limit:pagesize}});

		form = new Ext.FormPanel({
			labelWidth: 75,
			frame:true,
			width: 520,
			defaults: {width: 160},
			defaultType: 'textfield',

			items: [
				{
					fieldLabel: 'id',
					name: 'id',
					hidden:true
				},{
					fieldLabel: '名称(*)',
					name: 'name',
					width: 160,
					allowBlank:false
				},{
					fieldLabel: '描述(*)',
					name: 'description',
					width: 380,
					allowBlank:false
				},{
					fieldLabel: '类型',
					name: 'typeId',
					allowBlank:false,
					value:'SQLServer',
					hidden:true
				},{
					fieldLabel: '类(*)',
					name: 'clazz',
					width: 380,
					value: 'com.microsoft.sqlserver.jdbc.SQLServerDriver',
					allowBlank:false
				},{
					fieldLabel: 'URL(*)',
					name: 'url',
					width: 380,
					emptyText: 'jdbc:sqlserver://{IP}:{PORT};DatabaseName={DATABASE}',
					allowBlank:false
				},{
					fieldLabel: '用户名(*)',
					name: 'userName',
					width: 160,
					allowBlank:false
				},{
					fieldLabel: '密码',
					name: 'password',
					width: 160,
					inputType: 'password'
				},{
					fieldLabel: '最小活动连接数',
					name: 'minActiveConn',
					allowBlank:false,
					value:1,
					hidden:true
				},{
					fieldLabel: '最大活动连接数',
					name: 'maxActiveConn',
					allowBlank:false,
					value:5,
					hidden:true
				}
			],

			buttons: [{
				text: '保&nbsp;存',
				handler: function() {
					if(form.form.isValid()) {
						if(actiontype == "add") {
							form.form.submit({
								url: window.webRoot + 'DataSource',
								method: 'POST',
								params: {
									_method: 'POST'
								},
								success: function(form, action) {
									Ext.Msg.alert('保存成功', '添加数据源成功！');
									var pgbar = grid.getBottomToolbar()
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
											Ext.Msg.alert('保存失败', '添加数据源失败！(' + action.result.msg + ')');
									}
								},
								waitMsg: '数据保存中，请稍候...'
							});
						}
						if(actiontype == "edit") {
							var vals = form.form.getValues();
							form.form.submit({
								url: window.webRoot + 'DataSource/' + vals.id,
								method: 'POST',
								params: {
									_method: 'PUT'
								},
								success: function(form, action) {
									Ext.Msg.alert('修改成功', '修改数据源成功！');
									var pgbar = grid.getBottomToolbar()
									var activePage = Math.ceil((pgbar.cursor + pgbar.pageSize) / pgbar.pageSize);
									var start = (activePage - 1) * pgbar.pageSize;
									store.load({params:{start:start, limit:pagesize}});
									win.hide();
								},
								failure: function(form, action) {
									switch (action.failureType) {
										case Ext.form.Action.CLIENT_INVALID:
											Ext.Msg.alert('修改失败', '数据字段格式错误！');
											break;
										case Ext.form.Action.CONNECT_FAILURE:
											Ext.Msg.alert('修改失败', '连接异常！');
											break;
										case Ext.form.Action.SERVER_INVALID:
											Ext.Msg.alert('修改失败', '修改数据源失败！(' + action.result.msg + ')');
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

		store.on('beforeload', function(loader, node) {
		});	
		
		var viewport = new Ext.Viewport({
			layout: 'border',
			autoHeight: true,
			border: false,
			items: [grid]
		});	

		win = new Ext.Window({
			applyTo:'adduser-win',
			layout:'fit',
			width: 520,
			height:250,
			closeAction:'hide',
			modal: true,
			plain: true,
			title: "添加数据源",
			iconCls: "addbtn",
			items: [form]
		});
		
//		infotab.collapse(true);
	});	
	</script>

</head>
<body>
<div id="adduser-win" class="x-hidden"></div>
</body>
</html>
