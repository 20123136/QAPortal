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
	<title>转接IVR功能节点编号映射</title>

	<link rel="stylesheet" type="text/css" href="../css/ext-all.css" />
    
    <link rel="stylesheet" type="text/css" href="../css/common.css" />
    <link rel="stylesheet" type="text/css" href="../css/icon.css" />

	<script >
		var webRoot = '<%=webRoot%>';
	</script>

<script type="text/javascript" src="../js/ext-base.js"></script>
<script type="text/javascript" src="../js/ext-all.js"></script>
<script type="text/javascript" src="../js/ext-lang-zh_CN.js"></script>
<script type="text/javascript" src="../js/ext-ui-combo-pagesize.js"></script>
<script type="text/javascript" src="../js/app/common/ComboBox.js"></script>
<script type="text/javascript" src="../js/app/avp/IVRNodeSelector.js"></script>
<script type="text/javascript" src="../js/app/avp/LanguageSelector.js"></script>
<script type="text/javascript">
	var curId = 0;
	var win;
	var pagesize = 25;
	var grid;
	var form;
	var actiontype = "";

	var fields = [
				   {name: 'id'},
				   {name: 'key'},
				   {name: 'desc'},
				   {name: 'name'},
				   {name: 'language'},
				   {name: 'newNodeId'},
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
			remoteSort: false,

			fields: fields,
			
			proxy: new Ext.data.HttpProxy({
				url: window.webRoot + 'Conf/TransIVRNodeMaps'
			})

		});

		store.setDefaultSort('key', 'asc');
		
		var toolbarHelp = new Ext.Toolbar({
			width: '100%'
		});
		
		toolbarHelp.addButton(
			new Ext.form.DisplayField({
				fieldLabel: '',
				style: {align: 'right'},
				html:"&nbsp;&nbsp;<font color='#FF9900'>*</font>&nbsp;&nbsp;<font color='#646464'>转接IVR菜单节点映射页面用于维护座席转接或会议IVR时传送的IVR功能节点与IVR菜单节点的对照表。'功能节点编号'为座席转接或会议IVR时定义的功能节点编号，'菜单编号'为新IVR(VP)定义的IVR菜单节点编号。</font>"
			})
		);

		var toolbar = new Ext.Toolbar({
			width: '100%'
		});

		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnRefresh',
				text: '刷新',
				iconCls: 'refreshbtn',
				listeners: {
					'click': function(obj, e) {
						grid.getStore().reload();
					}
				}
			})
		);
		toolbar.addSeparator()
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnAdd',
				text: '添加',
				iconCls: 'confaddbtn',
				listeners: {
					'click': function(obj, e) {
						actiontype = "add";
						win.setTitle("添加功能节点编号映射关系");
						win.setIconClass("confaddbtn");
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
				iconCls: 'confeditbtn',
				listeners: {
					'click': function(obj, e) {
						var rec = grid.getSelectionModel().getSelected();
						if(!rec) {
							Ext.Msg.alert('编辑功能节点编号映射关系', '请选择要修改的功能节点编号映射关系！');
						} else {
							actiontype = "edit";
							win.setTitle("编辑功能节点编号映射关系");
							win.setIconClass("confeditbtn");
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
				iconCls: 'confdelbtn',
				listeners: {
					'click': function(obj, e) {
						var rec = grid.getSelectionModel().getSelected();
						if(!rec) {
							Ext.Msg.alert('删除功能节点编号映射关系', '请选择要删除的功能节点编号映射关系！');
						} else {
							Ext.Msg.show({
								title:'删除功能节点编号映射关系',
								msg: '请再次确实是否要将选择的功能节点编号映射关系删除?',
								buttons: Ext.Msg.YESNOCANCEL,
								fn: function(btn, text) {
									if(btn == "yes") {
										var ids = new Array();
										Ext.each(grid.getSelectionModel().getSelections(), function(rec) {
											ids.push(rec.get('id'));
										});
										grid.el.mask('请求以提交，请等待', 'x-mask-loading');
										Ext.Ajax.request({
											url: window.webRoot + 'Conf',
											method: 'POST',
											params: {
												_method: 'DELETE',
												id: ids
											},
											success: function(response,options) {
												grid.el.unmask();
												var respText = Ext.util.JSON.decode(response.responseText);
												if(respText.code == 'OK') {
													store.load();
												} else {
													Ext.Msg.alert('删除失败', '删除功能节点编号映射关系失败！');
												}
											},
											failure: function() {
												grid.el.unmask();
												Ext.Msg.alert('删除失败', '删除功能节点编号映射关系失败！');
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

		var sm = new Ext.grid.CheckboxSelectionModel();

		grid = new Ext.grid.GridPanel({
            region: 'center',
			tbar: toolbarHelp,
			store: store,
			border: false,
			selModel: sm,
			columns: [
				sm, 
				new Ext.grid.RowNumberer(), 
				{
					header   : '功能节点编号', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'key'
				},
				{
					header   : '名称', 
					width    : .3, 
					sortable : true, 
					dataIndex: 'name'
				},
				{
					header   : '语种', 
					width    : .1, 
					sortable : true, 
					dataIndex: 'language'
				},
				{
					header   : '新菜单编号', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'newNodeId'
				}
			],
			stripeRows: true,
			height: 600,
			width: '100%',
			viewConfig: {forceFit:true}, 
			loadMask: true,
			listeners : {
				'render' : function() {
					toolbar.render(this.tbar);
				}
            }
		});

		/** 列表双击操作 Start */
		grid.addListener('rowdblclick', function(obj, e) {
						Ext.getCmp('btnEdit').fireEvent('click'); 
					});    
		/** 列表双击操作 End */
		
		/** 列表右键点击菜单 Start */
		var rightClick = new Ext.menu.Menu();
		rightClick.add({
			text : '刷新',
			iconCls : 'refreshbtn',
			handler : function(obj, e) {
					Ext.getCmp('btnRefresh').fireEvent('click'); 
				}
		});
		rightClick.addSeparator();
		rightClick.add({
			text : '添加',
			iconCls : 'confaddbtn',
			handler : function(obj, e) {
					Ext.getCmp('btnAdd').fireEvent('click'); 
				}
		});
		rightClick.add({
			text : '编辑',
			iconCls : 'confeditbtn',
			handler : function(obj, e) {
					Ext.getCmp('btnEdit').fireEvent('click'); 
				}
		});
		rightClick.add({
			text : '删除',
			iconCls : 'confdelbtn',
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
			try {
				Ext.getCmp('btnEdit').setDisabled(false);
				Ext.getCmp('btnDelete').setDisabled(false);
			} catch (e)	{
			}
		});
		
		store.load({params:{start:0, limit:pagesize}});

		form = new Ext.FormPanel({
			labelWidth: 95,
			frame:true,
			width: 520,
			defaultType: 'textfield',

			items: [
				{
					fieldLabel: 'id',
					name: 'id',
					hidden:true
				},{
					fieldLabel: '功能节点编号(*)',
					name: 'key',
					width: 370,
					allowBlank:false
				},{
					fieldLabel: '名称',
					name: 'name',
					width: 370,
					allowBlank:true
				},
				new Ext.app.avp.LanguageSelector({
					fieldLabel: '语种(*)',
					name: 'language',
					width: 370,
					allowBlank:true,
					hiddenName: 'language'
				}),
				new Ext.app.avp.IVRNodeSelector({
					fieldLabel: '新菜单编号(*)',
					name: 'newNodeId',
					width: 370,
					allowBlank:true,
					hiddenName: 'newNodeId'
				})
			],

			buttons: [{
				text: '保&nbsp;存',
				handler: function() {
					if(form.form.isValid()) {
						if(actiontype == "add") {
							form.form.submit({
								url: window.webRoot + 'Conf/TransIVRNodeMap',
								method: 'POST',
								params: {
									_method: 'POST'
								},
								success: function(form, action) {
									Ext.Msg.alert('保存成功', '添加功能节点编号映射关系成功！');
									store.load();
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
											Ext.Msg.alert('保存失败', '添加功能节点编号映射关系失败！(' + action.result.message + ')');
									}
								},
								waitMsg: '数据保存中，请稍候...'
							});
						}
						if(actiontype == "edit") {
							var vals = form.form.getValues();
							form.form.submit({
								url: window.webRoot + 'Conf/TransIVRNodeMap/' + vals.id,
								method: 'POST',
								params: {
									_method: 'PUT'
								},
								success: function(form, action) {
									Ext.Msg.alert('修改成功', '修改功能节点编号映射关系成功！');
									store.load();
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
											Ext.Msg.alert('修改失败', '修改功能节点编号映射关系失败！(' + action.result.message + ')');
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

		var viewport = new Ext.Viewport({
			layout: 'border',
			autoHeight: true,
			border: false,
			items: [grid]
		});	

		win = new Ext.Window({
			layout:'fit',
			width: 520,
			height:190,
			closeAction:'hide',
			modal: true,
			plain: true,
			title: "添加菜单节点映射关系",
			iconCls: "addbtn",
			items: [form]
		});
		
//		infotab.collapse(true);
	});	
	</script>
</head>
</html>
