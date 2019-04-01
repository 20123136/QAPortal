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
	<title>录音文件服务器配置</title>

    <link rel="stylesheet" type="text/css" href="../css/ext-all-notheme.css" />
    <link rel="stylesheet" type="text/css" href="../css/xtheme-gray.css" />
    <link rel="stylesheet" type="text/css" href="../ux/css/Spinner.css" />
    <link rel="stylesheet" type="text/css" href="../ux/css/DateTimePicker.css" />

	<style type=text/css>
		/* style rows on mouseover */
		.x-grid3-row-over .x-grid3-cell-inner {
			font-weight: bold;
		}

		.titletext {
			font-weight: bold;
		}

		.addbtn {
			background-image: url("../images/icons/fam/computer_add.png");
		}

		.editbtn {
			background-image: url("../images/icons/fam/computer_edit.png");
		}

		.delbtn {
			background-image: url("../images/icons/fam/computer_delete.png");
		}

		.searchbtn {
			background-image: url("../images/default/dd/qry.gif");
		}

		.gridbtn {
			background-image: url("../images/icons/fam/computer.png");
		}
		.testbtn {
			background-image: url("../images/icons/fam/computer_go.png");
		}
		.enablebtn {
			background-image:url("../images/icons/fam/accept.png");
		}
		.disablebtn {
			background-image:url("../images/icons/fam/delete.png");
		}
	</style>
	<script >
		var webRoot = '<%=webRoot%>';
	</script>

	<script type="text/javascript" src="../js/ext-base.js"></script>
	<script type="text/javascript" src="../js/ext-all.js"></script>
	<script type="text/javascript" src="../js/ext-lang-zh_CN.js"></script>
	<script type="text/javascript" src="../js/ext-ui-combo-pagesize.js"></script>
    <script type="text/javascript" src="../ux/DateTimeField.js"></script>
    <script type="text/javascript" src="../ux/Spinner.js"></script>
    <script type="text/javascript" src="../ux/SpinnerField.js"></script>
    <script type="text/javascript" src="../js/app/ux/DictSelector.js"></script>

<script type="text/javascript">
	var curId = 0;
	var win;
	var pagesize = 25;
	var grid;
	var form;
	var actiontype = "";
	
	var protocolStore = new Ext.data.ArrayStore({
		fields: [{
					name : "value"
				}, {
					name : "name"
				}],
		data: [['Ftp', 'Ftp目录'], ['SMB', '共享目录']]
	});

	var fields = [
				   {name: 'id'},
				   {name: 'name'},
				   {name: 'desc'},
				   {name: 'domain'},
				   {name: 'ip'},
				   {name: 'path'},
				   {name: 'protocol'},
				   {
						name : 'protocolName', 
						convert: function(value, record) {
							return record.protocol == 'Ftp'? 'Ftp目录' : '共享目录';
						}
					},
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
				   {name: 'userName'},
				   {name: 'password'},
				   {name: 'port'},
				   {name: 'status'}
				];

	function showTestResult(val, p, rec, rowIndex) {
		if(val== 'Success') {
			return '<font style="color:green">成功</font>';
		} else if(val== 'Failed') {
			return '<font style="color:red">失败</font>';
		} else if(val == 'Error') {
			return '<font style="color:red">失败</font>:' + rec.get('description');
		} else {
			'';
		}
	}

	function showStatus(val) {
		if(val == '0') {
			return '<font style="color:green">已启用</font>';
		} else if(val == '1') {
			return '<font style="color:red">已停用</font>';
		} else {
			'';
		}
	}

	function selectType(obj, type) {
		if(type == 'Ftp') {
			obj.ownerCt.find('name','ip')[0].show();
			obj.ownerCt.find('name','domain')[0].hide();
			obj.ownerCt.find('name','port')[0].show();
			obj.ownerCt.find('name','path')[0].show();
			obj.ownerCt.find('name','userName')[0].show();
			obj.ownerCt.find('name','password')[0].show();
		} else if(type == 'SMB') {
			obj.ownerCt.find('name','ip')[0].show();
			obj.ownerCt.find('name','domain')[0].show();
			obj.ownerCt.find('name','port')[0].hide();
			obj.ownerCt.find('name','path')[0].show();
			obj.ownerCt.find('name','userName')[0].show();
			obj.ownerCt.find('name','password')[0].show();
		} else {
			obj.ownerCt.find('name','ip')[0].hide();
			obj.ownerCt.find('name','domain')[0].hide();
			obj.ownerCt.find('name','port')[0].hide();
			obj.ownerCt.find('name','path')[0].hide();
			obj.ownerCt.find('name','userName')[0].hide();
			obj.ownerCt.find('name','password')[0].hide();
		}
	}

	Ext.onReady(function(){
		var store = new Ext.data.JsonStore({
			root: 'data',
			totalProperty: 'total',
			remoteSort: false,

			fields: fields,
			
			proxy: new Ext.data.HttpProxy({
				url: window.webRoot + 'FilePaths'
			})

		});

		store.setDefaultSort('name', 'asc');

		var toolbar = new Ext.Toolbar({
			width: '100%'
		});

		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnAdd',
				text: '添加',
				iconCls: 'addbtn',
				listeners: {
					'click': function(obj, e) {
						actiontype = "add";
						win.setTitle("添加录音目录");
						win.setIconClass("addbtn");
						form.form.reset();
						selectType(form.find('name', 'protocol')[0], '');
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
				iconCls: 'editbtn',
				listeners: {
					'click': function(obj, e) {
						var rec = grid.getSelectionModel().getSelected();
						if(!rec) {
							Ext.Msg.alert('编辑录音目录', '请选择要修改的录音目录！');
						} else {
							actiontype = "edit";
							win.setTitle("编辑录音目录");
							win.setIconClass("editbtn");
							form.form.reset();
							form.form.setValues(rec.data);
							selectType(form.find('name', 'protocol')[0], rec.get('protocol'));
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
				iconCls: 'delbtn',
				listeners: {
					'click': function(obj, e) {
						var rec = grid.getSelectionModel().getSelected();
						if(!rec) {
							Ext.Msg.alert('删除录音目录', '请选择要删除的录音目录！');
						} else {
							Ext.Msg.show({
								title:'删除录音目录',
								msg: '请再次确实是否要将选择的录音目录删除?',
								buttons: Ext.Msg.YESNOCANCEL,
								fn: function(btn, text) {
									if(btn == "yes") {
										var ids = new Array();
										Ext.each(grid.getSelectionModel().getSelections(), function(rec) {
											ids.push(rec.get('id'));
										});
										grid.el.mask('请求已提交，请等待', 'x-mask-loading');
										Ext.Ajax.request({
											url: window.webRoot + 'FilePath',
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
													Ext.Msg.alert('删除失败', '删除录音目录失败！');
												}
											},
											failure: function() {
												grid.el.unmask();
												Ext.Msg.alert('删除失败', '删除录音目录失败！');
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
				iconCls: 'testbtn',
				listeners: {
					'click': function(obj, e) {
						var rec = grid.getSelectionModel().getSelected();
						if(!rec) {
							Ext.Msg.alert('测试连接', '请选择要测试的录音目录！');
						} else {
							grid.el.mask('请求已提交，请等待', 'x-mask-loading');
							testStore.proxy = new Ext.data.HttpProxy({
									method: 'GET',
									url: window.webRoot + 'FilePath/' +rec.get('id') + '/Test'
								});
							testStore.load();
							grid.el.unmask();
							testWin.show();
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
							Ext.Msg.alert('启用录音目录', '请选择要启用的录音目录！');
						} else {
							Ext.Msg.show({
								title:'启用录音目录?',
								msg: '请再次确实是否要启用已选中的录音目录?',
								buttons: Ext.Msg.YESNOCANCEL,
								fn: function(btn, text) {
									if(btn == "yes") {
										var ids = new Array();
										Ext.each(grid.getSelectionModel().getSelections(), function(rec) {
											ids.push(rec.get('id'));
										}); 
										grid.el.mask('请求已提交，请等待', 'x-mask-loading');
										Ext.Ajax.request({
											url: window.webRoot + 'FilePath/enable',
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
												Ext.Msg.alert('启用失败', '启用录音目录失败！');
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
							Ext.Msg.alert('停用录音目录', '请选择要停用的录音目录！');
						} else {
							Ext.Msg.show({
								title:'停用录音目录?',
								msg: '请再次确实是否要停用已选中的录音目录?',
								buttons: Ext.Msg.YESNOCANCEL,
								fn: function(btn, text) {
									if(btn == "yes") {
										var ids = new Array();
										Ext.each(grid.getSelectionModel().getSelections(), function(rec) {
											ids.push(rec.get('id'));
										});
										grid.el.mask('请求已提交，请等待', 'x-mask-loading');
										Ext.Ajax.request({
											url: window.webRoot + 'FilePath/disable',
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
												Ext.Msg.alert('停用失败', '停用录音目录失败！');
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
					dataIndex: 'desc'
				},
				{
					header   : '开始时间', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'beginTimeStr'
				},
				{
					header   : '结束时间', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'endTimeStr'
				},
				{
					header   : '类型', 
					width    : .1, 
					sortable : true, 
					dataIndex: 'protocolName'
				},
				{
					header   : 'IP', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'ip'
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
				iconCls : 'testbtn',
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
			defaults: {width: 200},
			defaultType: 'textfield',

			items: [
				{
					fieldLabel: 'id',
					name: 'id',
					hidden:true
				},{
					fieldLabel: '名称(*)',
					name: 'name',
					width: 200,
					allowBlank:false
				},{
					fieldLabel: '描述(*)',
					name: 'desc',
					width: 380,
					allowBlank:false
				},
				new Cls.form.DateTimeField({
					emptyText: 'YYYY-MM-DD HH:mm:SS',
					fieldLabel: '开始时间(*)',
					name: 'beginTime',
					width: 200,
					allowBlank:false,
					format: 'Y-m-d H:i:s'	
				}),
				new Cls.form.DateTimeField({
					emptyText: 'YYYY-MM-DD HH:mm:SS',
					fieldLabel: '结束时间(*)',
					name: 'endTime',
					width: 200,
					allowBlank:false,
					format: 'Y-m-d H:i:s'	
				}),
				{
					xtype: 'combo',
					fieldLabel: '协议',
					id: 'cmbProtocol',
					name: 'protocol',
					width: 200,
					store : protocolStore,
					valueField : 'value',
					displayField : 'name',
					mode: 'local',
					typeAhead: true,
					forceSelection: true,
					editable: false,
					triggerAction: 'all',
					selectOnFocus:true,
					hiddenName: 'protocol',
					allowBlank:false,
					listeners: {
						"select" : function(combo, record, index) {
							selectType(combo, record.get('value'));
						}
					}
				},{
					fieldLabel: 'IP(*)',
					name: 'ip',
					width: 380,
					hidden: true,
					allowBlank:false
				},{
					fieldLabel: '域名',
					name: 'domain',
					width: 380,
					hidden: true,
					allowBlank:true
				},{
					xtype: 'spinnerfield',
					fieldLabel: '端口(*)',
					name: 'port',
					width: 200,
					value: '21',
					hidden: true,
					allowBlank:true
				},{
					fieldLabel: '初始目录',
					name: 'path',
					width: 380,
					hidden: true,
					allowBlank:true
				},{
					fieldLabel: '用户名(*)',
					name: 'userName',
					width: 200,
					hidden: true,
					allowBlank:false
				},{
					fieldLabel: '密码',
					name: 'password',
					width: 200,
					hidden: true,
					inputType: 'password'
				}
			],

			buttons: [{
				text: '保&nbsp;存',
				handler: function() {
					if(form.form.isValid()) {
						if(actiontype == "add") {
							form.form.submit({
								url: window.webRoot + 'FilePath',
								method: 'POST',
								params: {
									_method: 'POST'
								},
								success: function(form, action) {
									Ext.Msg.alert('保存成功', '添加录音目录成功！');
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
											Ext.Msg.alert('保存失败', '添加录音目录失败！(' + action.result.msg + ')');
									}
								},
								waitMsg: '数据保存中，请稍候...'
							});
						}
						if(actiontype == "edit") {
							var vals = form.form.getValues();
							form.form.submit({
								url: window.webRoot + 'FilePath/' + vals.id,
								method: 'POST',
								params: {
									_method: 'PUT'
								},
								success: function(form, action) {
									Ext.Msg.alert('修改成功', '修改录音目录成功！');
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
											Ext.Msg.alert('修改失败', '修改录音目录失败！(' + action.result.msg + ')');
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
			layout:'fit',
			width: 520,
			height:350,
			closeAction:'hide',
			modal: true,
			plain: true,
			title: "添加录音目录",
			iconCls: "addbtn",
			items: [form]
		});

		/** 测试连接 Start */
		testStore = new Ext.data.JsonStore({
			root: 'data',
			totalProperty: 'total',
			remoteSort: false,

			fields: [
			   {name: 'step'},
			   {name: 'description'},
			   {name: 'result'},
			   {name: 'errMsg'}
			],
			
			url: 'empty.jsp'
		});

		testStore.setDefaultSort('step', 'asc');

		testGrid = new Ext.grid.GridPanel({
            region: 'center',
			store: testStore,
			border: false,
			columns: [
				{
					header   : '步骤', 
					width    : .1, 
					sortable : true, 
					dataIndex: 'step'
				},
				{
					header   : '描述', 
					width    : .6, 
					sortable : true, 
					dataIndex: 'description'
				},
				{
					header   : '结果', 
					width    : .3, 
					sortable : true, 
					dataIndex: 'result',
					renderer : showTestResult
				}
			],
			stripeRows: true,
			height: 300,
			width: 500,
			viewConfig: {forceFit:true}, 
			loadMask: true
		});

		testWin = new Ext.Window({
			layout:'fit',
			width: 520,
			height:300,
			closeAction:'hide',
			modal: true,
			plain: true,
			title: "测试结果",
			iconCls: "testbtn",
			items: [testGrid]
		});
		/** 测试连接 End */
		
	});	
	</script>

</head>
<body>
</body>
</html>
