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
    <title>个性化菜单管理</title>
 
    <link rel="stylesheet" type="text/css" href="../css/ext-all-notheme.css" />
    <link rel="stylesheet" type="text/css" href="../css/xtheme-gray.css" />
    <link rel="stylesheet" type="text/css" href="../ux/treegrid/treegrid.css" rel="stylesheet" />
    
	<link rel="stylesheet" type="text/css" href="../css/icon.css" />
 
    <script type="text/javascript" src="../js/ext-base.js"></script>
    <script type="text/javascript" src="../js/ext-all.js"></script>
	<script type="text/javascript" src="../ux/treegrid/TreeGridSorter.js"></script>
	<script type="text/javascript" src="../ux/treegrid/TreeGridColumnResizer.js"></script>
	<script type="text/javascript" src="../ux/treegrid/TreeGridNodeUI.js"></script>
	<script type="text/javascript" src="../ux/treegrid/TreeGridLoader.js"></script>
	<script type="text/javascript" src="../ux/treegrid/TreeGridColumns.js"></script>
	<script type="text/javascript" src="../ux/treegrid/TreeGrid.js"></script>
    <script type="text/javascript" src="../js/ext-lang-zh_CN.js"></script>
    <script type="text/javascript" src="../js/app/ux/DictSelector.js"></script>
    <script type="text/javascript" src="../js/func.js"></script>
	<script >
		var webRoot = '<%=webRoot%>';
	</script>
    <script type="text/javascript">
	var curId = 0;
	var win;
	var pagesize = 25;
	var tree;
	var form;
	var actiontype = "";

	var fields = [
				   {name: 'id'},
				   {name: 'name'},
				   {name: 'fatherId'},
				   {name: 'fatherName'},
				   {name: 'key'},
				   {name: 'url'},
				   {name: 'desc'},
				   {name: 'typeId'},
				   {name: 'typeName'}
				];

	Ext.onReady(function(){
		var toolbar = new Ext.Toolbar({
			width: '100%'
		});

		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnAddBrother',
				text: '添加同级菜单',
				iconCls: 'priaddbtn',
				listeners: {
					'click': function(obj, e) {
						var node = tree.getSelectionModel().getSelectedNode();
						actiontype = "add";
						win.setTitle("添加菜单");
						win.setIconClass("priaddbtn");
						form.form.reset();
						if(node) {
							form.findById('fatherid').setValue(node.attributes.fatherId);
							form.findById('fathername').setValue(node.parentNode.attributes.name);
						} else {
							form.findById('fatherid').setValue(0);
							form.findById('fathername').setValue('');
						}
						win.show(this);
					}
				}
			})
		);
		toolbar.addSeparator()

		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnAddChild',
				text: '添加下级菜单',
				iconCls: 'priaddbtn',
				listeners: {
					'click': function(obj, e) {
						var node = tree.getSelectionModel().getSelectedNode();
						actiontype = "add";
						win.setTitle("添加菜单");
						win.setIconClass("priaddbtn");
						form.form.reset();
						if(node) {
							form.findById('fatherid').setValue(node.attributes.id);
							form.findById('fathername').setValue(node.attributes.name);
						} else {
							form.findById('fatherid').setValue(0);
							form.findById('fathername').setValue('');
						}
						win.show(this);
					}
				}
			})
		);
		toolbar.addSeparator();
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnEdit',
				text: '编辑菜单',
				disabled: true,
				iconCls: 'prieditbtn',
				listeners: {
					'click': function(obj, e) {
						var node = tree.getSelectionModel().getSelectedNode();
						if(!node) {
							Ext.Msg.alert('编辑菜单', '请选择要修改的菜单！');
						} else {
							actiontype = "edit";
							win.setTitle("编辑菜单");
							win.setIconClass("prieditbtn");
							form.form.reset();
							form.form.setValues(node.attributes);
							win.show(this);
						}
					}
				}
			})
		);
		toolbar.addSeparator();
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnDelete',
				text: '删除菜单',
				disabled: true,
				iconCls: 'pridelbtn',
				listeners: {
					'click': function(obj, e) {
						var node = tree.getSelectionModel().getSelectedNode();
						if(!node) {
							Ext.Msg.alert('删除菜单', '请选择要删除的菜单！');
						} else {
							Ext.Msg.show({
								title:'删除菜单?',
								msg: '请再次确实是否要将选中的菜单删除?',
								buttons: Ext.Msg.YESNOCANCEL,
								fn: function(btn, text) {
									if(btn == "yes") {
										Ext.Ajax.request({
											url: window.webRoot + 'WeChatMenu/' + node.attributes.id,
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
												Ext.Msg.alert('删除失败', '删除租户失败！');
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
		//微信同步菜单
		toolbar.addButton(new Ext.Toolbar.Button({
			id: 'syncMenu',
			text: '同步菜单',
			iconCls: 'refreshbtn',
			listeners: {
				'click': function(obj, e) {
						Ext.Msg.show({
							title:'同步菜单?',
							msg: '请再次确实是否要同步微信个性化菜单?',
							buttons: Ext.Msg.YESNOCANCEL,
							fn: function(btn, text) {
								if(btn == "yes") {
									Ext.Ajax.request({
										url: window.webRoot + 'WeChatMenu/SyncMenu',
										method: 'POST',
										success: function(response,options) {
											var respText = Ext.util.JSON.decode(response.responseText);
											if(respText.code != 'OK') {
												Ext.Msg.alert('同步失败', respText.message + "（" + respText.code + "）");
											} else {
												Ext.Msg.alert('同步成功', '微信个性化菜单已同步！');
											}
										},
										failure: function() {
											Ext.Msg.alert('同步失败', '同步微信个性化菜单失败！');
										}
									});
								}
							},
							icon: Ext.MessageBox.QUESTION
						});
				}
			}
		})
	);
	toolbar.addSeparator();

		tree = new Ext.ux.tree.TreeGrid({
			width: Ext.getBody().getWidth(),
			height: Ext.getBody().getHeight(),
			tbar: toolbar,
			border: false,
			enableDD: true,
			iconCls: 'pribtn',
			renderTo: Ext.getBody(),

			columns:[{
				header: '名称',
				width: 180,
				dataIndex: 'name'
			},{
				header: '类型',
				width: 80,
				dataIndex: 'typeName'
			},{
				header: '关键字',
				width: 180,
				dataIndex: 'key'
			},{
				header: 'URL',
				width: 240,
				dataIndex: 'url'
			},{
				header: '描述',
				width: 300,
				dataIndex: 'desc'
			}],

			dataUrl: window.webRoot + 'WeChatMenu/TreeView/0'
		});

		tree.on('click', function(node, e) {
			try{
				Ext.getCmp('btnEdit').setDisabled(false);
				Ext.getCmp('btnDelete').setDisabled(false);
			} catch (e) {
			}
		});

		/** 列表双击操作 Start */
			tree.addListener('dblclick', function(obj, e) {
							Ext.getCmp('btnEdit').fireEvent('click'); 
						});    
		/** 列表双击操作 End */
		
		/** 列表右键点击菜单 Start */
		var rightClick = new Ext.menu.Menu();
		rightClick.add({
			text : '添加同级菜单',
			iconCls : 'priaddbtn',
			handler : function(obj, e) {
					Ext.getCmp('btnAddBrother').fireEvent('click'); 
				}
		});
		rightClick.add({
			text : '添加下级菜单',
			iconCls : 'priaddbtn',
			handler : function(obj, e) {
					Ext.getCmp('btnAddChild').fireEvent('click'); 
				}
		});
		rightClick.add({
			text : '编辑',
			iconCls : 'prieditbtn',
			handler : function(obj, e) {
					Ext.getCmp('btnEdit').fireEvent('click'); 
				}
		});
		rightClick.add({
			text : '删除',
			iconCls : 'pridelbtn',
			handler : function(obj, e) {
					Ext.getCmp('btnDelete').fireEvent('click'); 
				}
		});
 		tree.addListener('contextmenu', function(node, e) {
			e.preventDefault();
            rightClick.showAt(e.getXY());
		});
		/** 列表右键点击菜单 End */	  

		tree.on('movenode', function(t, node, oldParent, newParent, index) {
			Ext.Ajax.request({
				method: 'POST',
				params: {
					_method: 'PUT'
				},
				url: window.webRoot + 'WeChatMenu/'+node.attributes.id+'/moveto/'+newParent.attributes.id,
				success: function() {
					
				},
				failure: function() {
					Ext.Msg.alert('保存失败', '移动菜单的操作失败！');
					tree.getLoader().load(tree.getRootNode());
				}
			});
		});

		form = new Ext.FormPanel({
			labelWidth: 75,
			frame:true,
			width: 350,
			defaults: {width: 230},
			defaultType: 'textfield',

			reader: new Ext.data.JsonReader({root:'data'},fields),

			items: [{
					fieldLabel: '菜单名称',
					name: 'name',
					allowBlank:false
				},{
					fieldLabel: 'ID',
					name: 'id',
					hidden:true
				},{
					id: 'fatherid',
					fieldLabel: '父菜单ID',
					name: 'fatherId',
					hidden: true
				},{
					id: 'fathername',
					fieldLabel: '上级菜单',
					name: 'fatherName',
					disabled: true
				}, 
				new Ext.app.ux.DictSelector({
					dictType: 'WECHATMENU_TYPE',
					fieldLabel: '类型',
					width: 120,
					name: 'typeId',
					hiddenName: 'typeId'
				})
				,{
					fieldLabel: '关键字',
					name: 'key'
				},{
					fieldLabel: 'URL',
					name: 'url'
				},{
					fieldLabel: '简要说明',
					name: 'desc',
					height: 80,
					xtype: 'textarea'
				}
			],

			buttons: [{
				text: '保&nbsp;存',
				handler: function() {
					var vals = form.form.getValues();
					if(form.form.isValid()) {
						if(actiontype == "add") {
							form.form.submit({
								url: window.webRoot + 'WeChatMenu',
								method: 'POST',
								params: {
									_method: 'POST'
								},
								success: function(form, action) {
									Ext.Msg.alert('保存成功', '添加菜单成功！');
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
							form.form.submit({
								url: window.webRoot + 'WeChatMenu/' + vals.id,
								method: 'POST',
								params: {
									_method: 'PUT'
								},
								success: function(form, action) {
									Ext.Msg.alert('修改成功', '修改菜单成功！');
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

		win = new Ext.Window({
			applyTo:'adduser-win',
			layout:'fit',
			width: 350,
			height:300,
			closeAction:'hide',
			modal: true,
			plain: true,
			title: "添加菜单",
			iconCls: "addbtn",
			items: [form]
		});

	});	
	</script>

</head>
<body>
	<div id="adduser-win" class="x-hidden"></div>
</body>
</html>
