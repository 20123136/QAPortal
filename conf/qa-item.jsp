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
    <title>质检评分项管理</title>
 
    <link rel="stylesheet" type="text/css" href="../css/ext-all-notheme.css" />
    <link rel="stylesheet" type="text/css" href="../css/xtheme-gray.css" />
    <link rel="stylesheet" type="text/css" href="../css/icon.css" />
    <link rel="stylesheet" type="text/css" href="../ux/treegrid/treegrid.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../ux/css/Spinner.css" />

    <script type="text/javascript" src="../js/ext-base.js"></script>
    <script type="text/javascript" src="../js/ext-all-debug.js"></script>
	<script type="text/javascript" src="../ux/treegrid/TreeGridSorter.js"></script>
	<script type="text/javascript" src="../ux/treegrid/TreeGridColumnResizer.js"></script>
	<script type="text/javascript" src="../ux/treegrid/TreeGridNodeUI.js"></script>
	<script type="text/javascript" src="../ux/treegrid/TreeGridLoader.js"></script>
	<script type="text/javascript" src="../ux/treegrid/TreeGridColumns.js"></script>
	<script type="text/javascript" src="../ux/treegrid/TreeGrid.js"></script>
    <script type="text/javascript" src="../ux/Spinner.js"></script>
    <script type="text/javascript" src="../ux/SpinnerField.js"></script>
    <script type="text/javascript" src="../js/ext-lang-zh_CN.js"></script>
    <script type="text/javascript" src="../js/app/ux/DictSelector.js"></script>
	<script type="text/javascript" src="../ux/fileuploadfield/FileUploadField.js"></script>
    <script type="text/javascript" src="../js/func.js"></script>
	<script >
		var webRoot = '<%=webRoot%>';
	</script>
    <script type="text/javascript">
	var curId = 0;
	var win;
	var pagesize = 25;
	var tree;
	var groupForm;
	var actiontype = "";
	var fields = [
				   {name: 'id'},
				   {name: 'name'},
				   {name: 'group'},
				   {name: 'item'},
				   {name: 'typeId'},
				   {name: 'groupTypeId'},
				   {name: 'description'},
				   {name: 'value'}
				];

	Ext.onReady(function(){
		var toolbar = new Ext.Toolbar({
			width: '100%'
		});

		toolbar.addSeparator()

		var addMenu = new Ext.menu.Menu();
		addMenu.add({
				id: 'btnAddGroup',
				text: '质检类',
				iconCls: 'qaitemaddbtn',
				listeners: {
					'click': function(obj, e) {
						actiontype = "add";
						
						var node = tree.getSelectionModel().getSelectedNode();
						groupWin.setTitle("添加质检类");
						groupWin.setIconClass("addbtn");
						groupForm.form.reset();
						if(node) {
							groupForm.findById('fatherId').setValue(node.attributes.id);
							groupForm.findById('fatherName').setValue(node.attributes.name);
						} else {
							groupForm.findById('fatherId').setValue(0);
							groupForm.findById('fatherName').setValue('');
						}
						groupWin.show(this);
					}
				}
			}
		);
		addMenu.add({
				id: 'btnAddItem',
				text: '质检项',
				iconCls: 'qaitemaddbtn',
				listeners: {
					'click': function(obj, e) {
						actiontype = "add";
						var node = tree.getSelectionModel().getSelectedNode();
						if(!node) {
							Ext.Msg.alert('添加', '请先选择质检类！');
						} else {
							itemWin.setTitle("添加质检项");
							itemWin.setIconClass("addbtn");
							itemForm.form.reset();
							itemForm.findById('groupId').setValue(node.attributes.id);
							itemForm.findById('groupName').setValue(node.attributes.name);
							itemWin.show(this);
						}
					}
				}
			}
		);

		toolbar.add({
			text : '添加',
			iconCls : 'qaitemaddbtn',
			menu: addMenu
		});
		toolbar.addSeparator()

		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnEdit',
				text: '编辑',
				disabled: true,
				iconCls: 'qaitemeditbtn',
				listeners: {
					'click': function(obj, e) {
						var node = tree.getSelectionModel().getSelectedNode();
						if(!node) {
							Ext.Msg.alert('编辑', '请选择要修改的记录！');
						} else {
							if(node.attributes.group) {
								actiontype = "edit";
								groupWin.setTitle("编辑质检类");
								groupWin.setIconClass("qaitemeditbtn");
								groupForm.form.reset();
								groupForm.form.setValues(node.attributes);
								groupWin.show(this);
							}
							if(node.attributes.item) {
								actiontype = "edit";
								itemWin.setTitle("编辑质检项");
								itemWin.setIconClass("qaitemeditbtn");
								itemForm.form.reset();
								itemForm.form.setValues(node.attributes);
								itemForm.findById('groupId').setValue(node.attributes.fatherId);
								itemForm.findById('groupName').setValue(node.attributes.fatherName);
								itemWin.show(this);
							}
						}
					}
				}
			})
		);
		toolbar.addSeparator()

		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnDelete',
				text: '删除',
				disabled: true,
				iconCls: 'qaitemdelbtn',
				handler: function() {
					var node = tree.getSelectionModel().getSelectedNode();
					if(!node) {
						Ext.Msg.alert('删除', '请选择要删除的记录！');
					} else {
						Ext.Msg.show({
							title:'删除?',
							msg: '请再次确实是否要将选中的记录删除?',
							buttons: Ext.Msg.YESNOCANCEL,
							fn: function(btn, text) {
								if(btn == "yes") {
									if(node.attributes.group) {
										Ext.Ajax.request({
											url: window.webRoot + 'QAItemGroup/' + node.attributes.id,
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
												Ext.Msg.alert('删除失败', '删除质检类失败！');
											}
										});
									}
									if(node.attributes.item) {
										Ext.Ajax.request({
											url: window.webRoot + 'QAItem/' + node.attributes.id,
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
												Ext.Msg.alert('删除失败', '删除质检项失败！');
											}
										});
									}
								}
							},
							icon: Ext.MessageBox.QUESTION
						});						
					}
				}
			})
		);
		toolbar.addSeparator()

		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnEnable',
				text: '启用',
				disabled: true,
				iconCls: 'enablebtn',
				listeners: {
					'click': function(obj, e) {
						var node = tree.getSelectionModel().getSelectedNode();
						if(!node) {
							Ext.Msg.alert('启用', '请选择要启用的记录！');
						} else {
							Ext.Msg.show({
								title:'启用质检项?',
								msg: '请再次确实是否要启用已选中的记录?',
								buttons: Ext.Msg.YESNOCANCEL,
								fn: function(btn, text) {
									if(btn == "yes") {
										if(node.attributes.group) {
											Ext.Ajax.request({
												url: window.webRoot + 'QAItemGroup/' + node.attributes.id + '/Enable',
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
													Ext.Msg.alert('启用失败', '启用质检类失败！');
												}
											});
										}
										if(node.attributes.item) {
											Ext.Ajax.request({
												url: window.webRoot + 'QAItem/' + node.attributes.id + '/Enable',
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
													Ext.Msg.alert('启用失败', '启用质检项失败！');
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
		toolbar.addSeparator()

		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnDisable',
				text: '停用',
				disabled: true,
				iconCls: 'disablebtn',
				listeners: {
					'click': function(obj, e) {
						var node = tree.getSelectionModel().getSelectedNode();
						if(!node) {
							Ext.Msg.alert('停用质检项', '请选择要停用的质检项！');
						} else {
							Ext.Msg.show({
								title:'停用质检项?',
								msg: '请再次确实是否要停用已选中的质检项?',
								buttons: Ext.Msg.YESNOCANCEL,
								fn: function(btn, text) {
									if(btn == "yes") {
										if(node.attributes.group) {
											Ext.Ajax.request({
												url: window.webRoot + 'QAItemGroup/' + node.attributes.id + '/Disable',
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
													Ext.Msg.alert('停用失败', '停用质检类失败！');
												}
											});
										}
										if(node.attributes.item) {
											Ext.Ajax.request({
												url: window.webRoot + 'QAItem/' + node.attributes.id + '/Disable',
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
													Ext.Msg.alert('停用失败', '停用质检项失败！');
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
		toolbar.addSeparator()

		var treeloader =  new Ext.ux.tree.TreeGridLoader({
			url: '../blank.jsp'
		});

		tree = new Ext.ux.tree.TreeGrid({
			region: 'center',
			width: Ext.getBody().getWidth(),
			height: Ext.getBody().getHeight(),
			tbar: toolbar,
			enableDD: true,
			iconCls: 'treebtn',
			border: false,
			defaultSortable: false,
			enableSort: false,
//			renderTo: Ext.getBody(),

			columns:[{
				header: '名称',
				dataIndex: 'name',
				width: 315
			},{
				header: '分值',
				dataIndex: 'value',
				width: 120
			},{
				header: '描述',
				dataIndex: 'desc',
				width: 260
			},
			{
				header   : '状态',
				width: 120,
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

			loader: treeloader,
			rootVisible: false,
			root: new Ext.tree.AsyncTreeNode()
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

		tree.on('beforeload', 
			function(node){ 
				tree.loader.dataUrl = window.webRoot + 'QAItemGroup/TreeView/0'; 
			}
		); 

		tree.on('movenode', function(t, node, oldParent, newParent, index) {
			Ext.Ajax.request({
				method: 'POST',
				params: {
					_method: 'PUT'
				},
				url: window.webRoot + 'rest/dept/'+node.attributes.id+'/moveto/'+newParent.attributes.id,
				success: function() {
					
				},
				failure: function() {
					Ext.Msg.alert('保存失败', '移动质检项节点的操作失败！');
					tree.getLoader().load(tree.getRootNode());
				}
			});

		});

		/** 列表双击操作 Start */
			tree.addListener('dblclick', function(obj, e) {
							Ext.getCmp('btnEdit').fireEvent('click'); 
						});    
//			tree.addListener('dblclick', function(obj, e) {
//							Ext.getCmp('btnDelete').fireEvent('click'); 
//						});    
		/** 列表双击操作 End */
		
		/** 列表右键点击菜单 Start */
		var rightClick = new Ext.menu.Menu();
			rightClick.add({
				text : '添加',
				iconCls : 'qaitemaddbtn',
				menu: addMenu
			});
			rightClick.add({
				text : '编辑',
				iconCls : 'qaitemeditbtn',
				handler : function(obj, e) {
						Ext.getCmp('btnEdit').fireEvent('click'); 
					}
			});
			rightClick.add({
				text : '删除',
				iconCls : 'qaitemdelbtn',
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

		groupForm = new Ext.FormPanel({
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
					id: 'typeId',
					fieldLabel: '业务类型ID',
					name: 'typeId',
					hidden: true
				},{
					id: 'fatherId',
					fieldLabel: '父类ID',
					name: 'fatherId',
					hidden: true
				},{
					id: 'fatherName',
					fieldLabel: '父类',
					name: 'fatherName',
					disabled: true
				},{
					fieldLabel: '模式',
					name: 'mode',
					hidden: true
				},{
					fieldLabel: '说明',
					name: 'description',
					height: 120,
					xtype: 'textarea'
				}
			],

			buttons: [{
				text: '保&nbsp;存',
				handler: function() {
					var vals = groupForm.form.getValues();
					if(groupForm.form.isValid()) {
						if(actiontype == "add") {
							groupForm.form.submit({
								url: window.webRoot + 'QAItemGroup',
								method: 'POST',
								params: {
									_method: 'POST'
								},
								success: function(form, action) {
									Ext.Msg.alert('保存成功', '添加质检类成功！');
									tree.getLoader().load(tree.getRootNode());
									groupWin.hide();
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
							groupForm.form.submit({
								url: window.webRoot + 'QAItemGroup/' + vals.id,
								method: 'POST',
								params: {
									_method: 'PUT'
								},
								success: function(form, action) {
									Ext.Msg.alert('修改成功', '修改质检类成功！');
									tree.getLoader().load(tree.getRootNode());
									groupWin.hide();
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
					groupWin.hide();
				}
			}]
		});

		itemForm = new Ext.FormPanel({
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
					id: 'groupId',
					fieldLabel: '类ID',
					name: 'groupId',
					hidden: true
				},{
					id: 'groupName',
					fieldLabel: '质检类',
					name: 'groupName',
					disabled: true
				},{
					xtype: 'spinnerfield',
					fieldLabel: '分值',
					name: 'value',
					value: 0,
					allowBlank:false
				},{
					fieldLabel: '说明',
					name: 'desc',
					height: 120,
					xtype: 'textarea'
				}
			],

			buttons: [{
				text: '保&nbsp;存',
				handler: function() {
					var vals = itemForm.form.getValues();
					if(itemForm.form.isValid()) {
						if(actiontype == "add") {
							itemForm.form.submit({
								url: window.webRoot + 'QAItem',
								method: 'POST',
								params: {
									_method: 'POST'
								},
								success: function(form, action) {
									Ext.Msg.alert('保存成功', '添加质检项成功！');
									tree.getLoader().load(tree.getRootNode());
									itemWin.hide();
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
							itemForm.form.submit({
								url: window.webRoot + 'QAItem/' + vals.id,
								method: 'POST',
								params: {
									_method: 'PUT'
								},
								success: function(form, action) {
									Ext.Msg.alert('修改成功', '修改质检项成功！');
									tree.getLoader().load(tree.getRootNode());
									itemWin.hide();
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
					itemWin.hide();
				}
			}]
		});

//		store.on('beforeload', function(loader, node) {
//			var typeId = Ext.getCmp('qryType').getValue();
//			var groupTypeId = Ext.getCmp('qryGroupType').getValue();
//			store.baseParams = {typeId:typeId, groupTypeId: groupTypeId};
//		});
		/** 查询 End */

        var viewport = new Ext.Viewport({
            layout: 'border',
			autoHeight: true,
			border: false,
            items: [tree]
		});	

		groupWin = new Ext.Window({
			applyTo:'addgroup-win',
			layout:'fit',
			width: 350,
			height:300,
			closeAction:'hide',
			modal: true,
			plain: true,
			title: "添加",
			iconCls: "addbtn",
			items: [groupForm]
		});

		itemWin = new Ext.Window({
			applyTo:'additem-win',
			layout:'fit',
			width: 350,
			height:300,
			closeAction:'hide',
			modal: true,
			plain: true,
			title: "添加",
			iconCls: "addbtn",
			items: [itemForm]
		});

	});	
	</script>

</head>
<body>
	<div id="addgroup-win" class="x-hidden"></div>
	<div id="additem-win" class="x-hidden"></div>
</body>
</html>
