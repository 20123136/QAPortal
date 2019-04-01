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
    <title>质检项管理</title>
 
    <link rel="stylesheet" type="text/css" href="../css/ext-all-notheme.css" />
    <link rel="stylesheet" type="text/css" href="../css/xtheme-gray.css" />

	<link rel="stylesheet" type="text/css" href="../ux/css/Spinner.css" />

    <link rel="stylesheet" type="text/css" href="../css/icon.css" />
    <link rel="stylesheet" type="text/css" href="../css/common.css" />
	<script>
		var webRoot = '<%=webRoot%>';
	</script>
 
    <script type="text/javascript" src="../js/ext-base-debug.js"></script>
    <script type="text/javascript" src="../js/ext-all-debug.js"></script>
    <script type="text/javascript" src="../js/ext-lang-zh_CN.js"></script>
    <script type="text/javascript" src="../js/ext-ui-combo-pagesize.js"></script>
    <script type="text/javascript" src="../ux/Spinner.js"></script>
    <script type="text/javascript" src="../ux/SpinnerField.js"></script>

	<script type="text/javascript" src="../js/func.js"></script>

	<script type="text/javascript">
	var curId = 0;
	var pagesize = 25;
	var storeLevel0, storeLevel1, storeLevel2, storeLevel3;
	var gridLevel0, gridLevel1, gridLevel2, gridLevel3;

	function showStatus(v, p, rec, rowIndex) {
		if(v == 'ENABLE') {
			return '<img src=../images/icons/fam/accept.png>';
		} else if(v == 'DISABLE') {
			return '<img src=../images/icons/fam/delete.png>';
		} else if(v == 'RUNNING') {
			return '<img src=../images/loading.gif>';
		} else {
			return '';
		}
	}

	function resetScore() {
		var total3 = 0, total2 = 0, total1 = 0;

		storeLevel3.each(function (rec) {
			total3 = parseInt(rec.get('value')) > total3 ? parseInt(rec.get('value')) : total3;
		});

		gridLevel2.getSelectionModel().getSelected().set('value', total3);
		storeLevel2.commitChanges();

		storeLevel2.each(function (rec) {
			total2 += parseInt(rec.get('value'));
		});
		gridLevel1.getSelectionModel().getSelected().set('value', total2);
		storeLevel1.commitChanges();

//		storeLevel1.each(function (rec) {
//			total1 += parseInt(rec.get('value'));
//		});

//		gridLevel0.getSelectionModel().getSelected().set('score', total1);
//		storeLevel0.commitChanges();

	}

	var fields = [
				   {name: 'id'},
				   {name: 'no'},
				   {name: 'desc'},
				   {name: 'typeId'},
				   {name: 'scheduleType'},
				   {name: 'scheduleTime'},
				   {name: 'createUserName'},
				   {name: 'createUserId'},
				   {name: 'createTime'},
				   {name: 'displayExecuteTime'},
				   {name: 'displayCompleteTime'},
				   {name: 'displaySpentTime'},
				   {name: 'displayCreateTime'},
				   {name: 'executeResult'},
				   {name: 'executeStatus'},
				   {name: 'executeLogId'},
				   {name: 'lastResultId'},
				   {name: 'sampleTotal'},
				   {name: 'sampleCountPlan'},
				   {name: 'sampleCountPractice'},
				   {name: 'userCountPlan'},
				   {name: 'userCountPractice'},
				   {name: 'statusComplete'},
				   {name: 'statusUncomplete'},
				   {name: 'completeRate'},
				   {name: 'status'},
				   {name: 'lastQaTime'}
				];

	Ext.onReady(function(){

		/** Start 质检项组别 */

		fieldsLevel0 = [
					   {name: 'id'},
					   {name: 'name'},
					   {name: 'desc'},
					   {name: 'value'},
					   {name: 'typeId'},
					   {name: 'status'},
					   {name: 'score'}
					];

		storeLevel0 = new Ext.data.JsonStore({
			root: 'data',
			totalProperty: 'total',
			remoteSort: false,

			fields: fieldsLevel0,
			
			proxy: new Ext.data.HttpProxy({
				url: window.webRoot + 'Dicts/Type/QA_ITEM_GROUP'
			})
        });
    
		storeLevel0.setDefaultSort('name', 'asc');

		var toolbarLevel0 = new Ext.Toolbar({
			width: '100%'
		});

		formLevel0 = new Ext.FormPanel({
			labelWidth: 75,
			frame:true,
			width: 350,
			defaults: {width: 230},
			defaultType: 'textfield',

			reader: new Ext.data.JsonReader({root:'data'},fieldsLevel0),

			items: [{
					fieldLabel: '名称',
					name: 'name',
					allowBlank:false
				},{
					fieldLabel: '值(*)',
					name: 'value',
					width: 230,
					allowBlank:false
				},{
					fieldLabel: 'ID',
					name: 'id',
					hidden:true
				}
			],

			buttons: [{
				text: '保&nbsp;存',
				handler: function(obj) {
					if(obj.ownerCt.ownerCt.form.isValid()) {
						if(obj.ownerCt.ownerCt.actiontype == "add") {
							obj.ownerCt.ownerCt.form.submit({
								url: window.webRoot + 'Dict/Type/QA_ITEM_GROUP',
								method: 'POST',
								params: {
									_method: 'POST'
								},
								success: function(form, action) {
									Ext.Msg.alert('保存成功', '添加组别成功！');
									storeLevel0.load();
									winLevel0.hide();
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
						if(obj.ownerCt.ownerCt.actiontype == "edit") {
							var vals = obj.ownerCt.ownerCt.form.getValues();
							obj.ownerCt.ownerCt.form.submit({
								url: window.webRoot + 'Dict/' + vals.id,
								method: 'POST',
								params: {
									_method: 'PUT'
								},
								success: function(form, action) {
									Ext.Msg.alert('修改成功', '修改角色成功！');
									storeLevel0.load();
									winLevel0.hide();
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
					winLevel0.hide();
				}
			}]
		});

		winLevel0 = new Ext.Window({
			layout:'fit',
			width: 350,
			height:135,
			closeAction:'hide',
			modal: true,
			plain: true,
			title: "添加组别",
			iconCls: "addbtn",
			items: [formLevel0]
		});
		
		/** End 添加 */
		toolbarLevel0.addButton(new Ext.Toolbar.Button({
				id: 'btnAdd',
				text: '添加',
				iconCls: 'qaitemaddbtn',
				listeners: {
					'click': function(obj, e) {
						winLevel0.setTitle("添加组别");
						winLevel0.setIconClass("qaitemaddbtn");
						winLevel0.show(this);
						formLevel0.form.reset();
						formLevel0.actiontype = "add";
					}
				}
			})
		);
		/** End 添加 */
		
		/** Start 编辑 */
		toolbarLevel0.addButton(new Ext.Toolbar.Button({
				id: 'btnEdit',
				text: '编辑',
				disabled: true,
				iconCls: 'qaitemeditbtn',
				listeners: {
					'click': function(obj, e) {
						var rec = gridLevel0.getSelectionModel().getSelected();
						if(!rec) {
							Ext.Msg.alert('编辑', '请选择要修改的！');
						} else {
							winLevel0.setTitle("编辑组别");
							winLevel0.setIconClass("qaitemeditbtn");
							winLevel0.show(this);
							formLevel0.form.reset();
							formLevel0.form.setValues(rec.data);
							formLevel0.actiontype = "edit";
						}
					}
				}
			})
		);
		/** End 编辑 */
		
		/** Start 删除 */
		toolbarLevel0.addButton(new Ext.Toolbar.Button({
				id: 'btnDelete',
				text: '删除',
				disabled: true,
				iconCls: 'qaitemdelbtn',
				listeners: {
					'click': function(obj, e) {
						var rec = gridLevel0.getSelectionModel().getSelected();
						if(!rec) {
							Ext.Msg.alert('删除', '请选择要删除的！');
						} else {
							Ext.Msg.show({
								title:'删除?',
								msg: '请再次确实是否要将选中的删除?',
								buttons: Ext.Msg.YESNOCANCEL,
								fn: function(btn, text) {
									if(btn == "yes") {
										var ids = new Array();
										Ext.each(gridLevel0.getSelectionModel().getSelections(), function(rec) {
											ids.push(rec.get('id'));
										});
										Ext.Ajax.request({
											url: window.webRoot + 'Dict',
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
													storeLevel0.removeAll();
													storeLevel0.load({params:{start:0, limit:100}});
													Ext.getCmp('btnEdit').setDisabled(true);
													Ext.getCmp('btnDelete').setDisabled(true);
													Ext.getCmp('btnAdd1').setDisabled(true);
													Ext.getCmp('btnEdit1').setDisabled(true);
													Ext.getCmp('btnDelete1').setDisabled(true);
													Ext.getCmp('btnAdd2').setDisabled(true);
													Ext.getCmp('btnEdit2').setDisabled(true);
													Ext.getCmp('btnDelete2').setDisabled(true);
													Ext.getCmp('btnAdd3').setDisabled(true);
													Ext.getCmp('btnEdit3').setDisabled(true);
													Ext.getCmp('btnDelete3').setDisabled(true);
													storeLevel1.removeAll();
													storeLevel2.removeAll();
													storeLevel3.removeAll();
												}
											},
											failure: function(response,options) {
												Ext.Msg.alert('删除失败', '删除失败！');
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
		/** End 删除 */

		var sm = new Ext.grid.CheckboxSelectionModel();

		gridLevel0 = new Ext.grid.GridPanel({
			title: '组别',
			tbar: toolbarLevel0,
			store: storeLevel0,
			columnWidth: .25,
			border: false,
			selModel: sm,
			columns: [
				sm, 
				{
					header   : '名称', 
					width    : .4, 
					sortable : true, 
					dataIndex: 'name'
//				},
//				{
//					header   : '总分', 
//					width    : .1, 
//					sortable : true, 
//					dataIndex: 'score'
				}
			],
			stripeRows: true,
			height: 600,
			width: 300,
			viewConfig: {forceFit:true}, 
			loadMask: true
		});

		/** 列表双击操作 Start */
		gridLevel0.addListener('rowdblclick', function(obj, e) {
						Ext.getCmp('btnEdit').fireEvent('click'); 
					});    
		/** 列表双击操作 End */
		
		/** 列表右键点击菜单 Start */
		var rightClick0 = new Ext.menu.Menu();
			rightClick0.add({
				text : '添加',
				iconCls : 'qaitemaddbtn',
				handler : function(obj, e) {
						Ext.getCmp('btnAdd').fireEvent('click'); 
					}
			});
			rightClick0.add({
				text : '修改',
				iconCls : 'qaitemeditbtn',
				handler : function(obj, e) {
						Ext.getCmp('btnEdit').fireEvent('click'); 
					}
			});
			rightClick0.add({
				text : '删除',
				iconCls : 'qaitemdelbtn',
				handler : function(obj, e) {
						Ext.getCmp('btnDelete').fireEvent('click'); 
					}
			});

		gridLevel0.addListener('rowcontextmenu', function(client, rowIndex, e) {
			e.preventDefault();
            rightClick0.showAt(e.getXY());
		});
		/** 列表右键点击菜单 End */	  
		
		gridLevel0.getSelectionModel().on('rowselect', function(obj, rowIndex, rec) {
			if(obj.getCount() > 0) {
				rec = obj.getSelected();
				try{
					Ext.getCmp('btnEdit').setDisabled(false);
					Ext.getCmp('btnDelete').setDisabled(false);
					Ext.getCmp('btnAdd1').setDisabled(false);
					Ext.getCmp('btnEdit1').setDisabled(true);
					Ext.getCmp('btnDelete1').setDisabled(true);
					Ext.getCmp('btnAdd2').setDisabled(true);
					Ext.getCmp('btnEdit2').setDisabled(true);
					Ext.getCmp('btnDelete2').setDisabled(true);
					Ext.getCmp('btnAdd3').setDisabled(true);
					Ext.getCmp('btnEdit3').setDisabled(true);
					Ext.getCmp('btnDelete3').setDisabled(true);
				} catch (e) {
				}

				var rec = obj.getSelected();
				storeLevel1.removeAll();
				storeLevel1.proxy.setUrl(window.webRoot + 'QAItemGroups/' + rec.get('value') + '/0', true);
				storeLevel1.load();
				storeLevel2.removeAll();
				storeLevel3.removeAll();
			} else {
				try{
					Ext.getCmp('btnEdit').setDisabled(true);
					Ext.getCmp('btnDelete').setDisabled(true);
					Ext.getCmp('btnAdd1').setDisabled(true);
					Ext.getCmp('btnEdit1').setDisabled(true);
					Ext.getCmp('btnDelete1').setDisabled(true);
					Ext.getCmp('btnAdd2').setDisabled(true);
					Ext.getCmp('btnEdit2').setDisabled(true);
					Ext.getCmp('btnDelete2').setDisabled(true);
					Ext.getCmp('btnAdd3').setDisabled(true);
					Ext.getCmp('btnEdit3').setDisabled(true);
					Ext.getCmp('btnDelete3').setDisabled(true);
				} catch (e) {
				}
				storeLevel1.removeAll();
				storeLevel2.removeAll();
				storeLevel3.removeAll();
			}
		});
		
		gridLevel0.getSelectionModel().on('rowdeselect', function(obj, rowIndex, rec) {
			if(obj.getCount() > 0) {
				rec = obj.getSelected();
				try{
					Ext.getCmp('btnEdit').setDisabled(false);
					Ext.getCmp('btnDelete').setDisabled(false);
					Ext.getCmp('btnAdd1').setDisabled(false);
					Ext.getCmp('btnEdit1').setDisabled(true);
					Ext.getCmp('btnDelete1').setDisabled(true);
					Ext.getCmp('btnAdd2').setDisabled(true);
					Ext.getCmp('btnEdit2').setDisabled(true);
					Ext.getCmp('btnDelete2').setDisabled(true);
					Ext.getCmp('btnAdd3').setDisabled(true);
					Ext.getCmp('btnEdit3').setDisabled(true);
					Ext.getCmp('btnDelete3').setDisabled(true);
				} catch (e) {
				}
				var rec = obj.getSelected();
				storeLevel1.removeAll();
				storeLevel1.proxy.setUrl(window.webRoot + 'QAItemGroups/' + rec.get('value') + '/0', true);
				storeLevel1.load();
				storeLevel2.removeAll();
				storeLevel3.removeAll();
			} else {
				try{
					Ext.getCmp('btnEdit').setDisabled(true);
					Ext.getCmp('btnDelete').setDisabled(true);
					Ext.getCmp('btnAdd1').setDisabled(true);
					Ext.getCmp('btnEdit1').setDisabled(true);
					Ext.getCmp('btnDelete1').setDisabled(true);
					Ext.getCmp('btnAdd2').setDisabled(true);
					Ext.getCmp('btnEdit2').setDisabled(true);
					Ext.getCmp('btnDelete2').setDisabled(true);
					Ext.getCmp('btnAdd3').setDisabled(true);
					Ext.getCmp('btnEdit3').setDisabled(true);
					Ext.getCmp('btnDelete3').setDisabled(true);
				} catch (e) {
				}
				storeLevel1.removeAll();
				storeLevel2.removeAll();
				storeLevel3.removeAll();
			}
		});
		
		storeLevel0.load({params:{start:0, limit:100}});
		/** Start 质检项组别 */


		/** Start 一级质检类 */
		storeLevel1 = new Ext.data.JsonStore({
			root: 'data',
			totalProperty: 'total',
			idProperty: 'id',
			remoteSort: false,

			fields: [
					   {name: 'id'},
					   {name: 'typeId'},
					   {name: 'groupTypeId'},
					   {name: 'fatherId'},
					   {name: 'order'},
					   {name: 'value'},
					   {name: 'description'},
					   {name: 'status'},
					   {name: 'name'}
					]
			,
			
			url: 'empty.jsp'
		});
    
		storeLevel1.setDefaultSort('order', 'asc');

		var toolbarLevel1 = new Ext.Toolbar({
			width: '100%'
		});

		formLevel1 = new Ext.FormPanel({
			labelWidth: 75,
			frame:true,
			width: 350,
			defaults: {width: 230},
			defaultType: 'textfield',

			reader: new Ext.data.JsonReader({root:'data'},fieldsLevel0),

			items: [{
					fieldLabel: '名称',
					name: 'name',
					allowBlank:false
				},{
					fieldLabel: '类型',
					name: 'typeId',
					value: '',
					hidden:true
				},{
					fieldLabel: '组别ID',
					name: 'groupTypeId',
					hidden:true
				},{
					fieldLabel: '父类ID',
					name: 'fatherId',
					hidden:true
				},{
					fieldLabel: '备注',
					name: 'description',
					value: '',
					hidden:true
				},{
					fieldLabel: '状态',
					name: 'status',
					value: '0',
					hidden:true
				},{
					fieldLabel: 'ID',
					name: 'id',
					hidden:true
				}
			],

			buttons: [{
				text: '保&nbsp;存',
				handler: function(obj) {
					if(obj.ownerCt.ownerCt.form.isValid()) {
						if(obj.ownerCt.ownerCt.actiontype == "add") {
							obj.ownerCt.ownerCt.form.submit({
								url: window.webRoot + 'QAItemGroup',
								method: 'POST',
								params: {
									_method: 'POST'
								},
								success: function(form, action) {
									Ext.Msg.alert('保存成功', '添加一级质检类成功！');
									storeLevel1.load();
									winLevel1.hide();
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
						if(obj.ownerCt.ownerCt.actiontype == "edit") {
							var vals = obj.ownerCt.ownerCt.form.getValues();
							obj.ownerCt.ownerCt.form.submit({
								url: window.webRoot + 'QAItemGroup/' + vals.id,
								method: 'POST',
								params: {
									_method: 'PUT'
								},
								success: function(form, action) {
									Ext.Msg.alert('修改成功', '修改一级质检类成功！');
									storeLevel1.load();
									winLevel1.hide();
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
					winLevel1.hide();
				}
			}]
		});

		winLevel1 = new Ext.Window({
			layout:'fit',
			width: 350,
			height:120,
			closeAction:'hide',
			modal: true,
			plain: true,
			title: "添加一级质检类",
			iconCls: "addbtn",
			items: [formLevel1]
		});

		/** Start 添加 */
		toolbarLevel1.addButton(new Ext.Toolbar.Button({
				id: 'btnAdd1',
				text: '添加',
				disabled: true,
				iconCls: 'qaitemaddbtn',
				listeners: {
					'click': function(obj, e) {
						winLevel1.setTitle("添加一级质检类");
						winLevel1.setIconClass("qaitemaddbtn");
						winLevel1.show(this);
						formLevel1.form.reset();
						formLevel1.actiontype = "add";
						formLevel1.find('name', 'typeId')[0].setValue('');
						formLevel1.find('name', 'groupTypeId')[0].setValue(gridLevel0.getSelectionModel().getSelected().get('value'));
						formLevel1.find('name', 'description')[0].setValue('');
						formLevel1.find('name', 'fatherId')[0].setValue('0');
						formLevel1.find('name', 'status')[0].setValue('0');
					}
				}
			})
		);
		/** End 添加 */
		
		/** Start 编辑 */
		toolbarLevel1.addButton(new Ext.Toolbar.Button({
				id: 'btnEdit1',
				text: '编辑',
				disabled: true,
				iconCls: 'qaitemeditbtn',
				listeners: {
					'click': function(obj, e) {
						var rec = gridLevel1.getSelectionModel().getSelected();
						if(!rec) {
							Ext.Msg.alert('编辑', '请选择要修改的一级质检类！');
						} else {
							winLevel1.setTitle("编辑一级质检类");
							winLevel1.setIconClass("qaitemeditbtn");
							winLevel1.show(this);
							formLevel1.form.reset();
							formLevel1.form.setValues(rec.data);
							formLevel1.actiontype = "edit";
						}
					}
				}
			})
		);
		/** End 编辑 */
		
		/** Start 删除 */
		toolbarLevel1.addButton(new Ext.Toolbar.Button({
				id: 'btnDelete1',
				text: '删除',
				disabled: true,
				iconCls: 'qaitemdelbtn',
				listeners: {
					'click': function(obj, e) {
						var rec = gridLevel1.getSelectionModel().getSelected();
						if(!rec) {
							Ext.Msg.alert('删除', '请选择要删除的一级质检类！');
						} else {
							Ext.Msg.show({
								title:'删除?',
								msg: '请再次确实是否要将选中的记录删除?',
								buttons: Ext.Msg.YESNOCANCEL,
								fn: function(btn, text) {
									if(btn == "yes") {
										var ids = new Array();
										Ext.each(gridLevel1.getSelectionModel().getSelections(), function(rec) {
											ids.push(rec.get('id'));
										});
										Ext.Ajax.request({
											url: window.webRoot + 'QAItemGroup',
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
													storeLevel1.removeAll();
													storeLevel1.load({params:{start:0, limit:100}});
													Ext.getCmp('btnEdit1').setDisabled(true);
													Ext.getCmp('btnDelete1').setDisabled(true);
													Ext.getCmp('btnAdd2').setDisabled(true);
													Ext.getCmp('btnEdit2').setDisabled(true);
													Ext.getCmp('btnDelete2').setDisabled(true);
													Ext.getCmp('btnAdd3').setDisabled(true);
													Ext.getCmp('btnEdit3').setDisabled(true);
													Ext.getCmp('btnDelete3').setDisabled(true);
													storeLevel2.removeAll();
													storeLevel3.removeAll();
												}
											},
											failure: function(response,options) {
												Ext.Msg.alert('删除失败', '删除失败！');
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
		/** End 删除 */

		var sm = new Ext.grid.CheckboxSelectionModel();

		gridLevel1 = new Ext.grid.GridPanel({
			title: '一级质检类',
			columnWidth: .25,
			tbar: toolbarLevel1,
			store: storeLevel1,
			border: false,
			selModel: sm,
			columns: [
				sm, 
				{
					header   : '名称', 
					width    : .4, 
					sortable : true, 
					dataIndex: 'name'
				},
				{
					header   : '总分', 
					width    : .1, 
					sortable : true, 
					dataIndex: 'value'
				}
			],
			stripeRows: true,
			enableDragDrop : true,
			ddGroup: 'gridDD', 
			dropConfig: {appendOnly:false}, 
			height: 600,
			width: 300,
			viewConfig: {forceFit:true}, 
			loadMask: true
		});

		gridLevel1.addListener('render', function(obj, e) {
			new Ext.dd.DropTarget(gridLevel1.getEl(), {  
				ddGroup: 'gridDD',  
				copy    : false,  
				notifyDrop: function (dd, e, data) {  
					//选择行  
					var rows = gridLevel1.getSelectionModel().getSelections();  
					//选择行数  
					var count = rows.length;  
					//拖动到几行  
					var dropIndex = dd.getDragData(e).rowIndex;  
					var array=[];  
					for(var i=0;i<count;i++){  
						var index = dropIndex+i;  
						array.push(index);  
					}  
					gridLevel1.getStore().remove(gridLevel1.getStore().getById(data.selections[0].id));  
					gridLevel1.getStore().insert(dropIndex,data.selections);   
					gridLevel1.getSelectionModel().selectRows(array);   
					gridLevel1.getView().refresh(); 
					var ids = new Array();
					for (var i = 0; i < gridLevel1.getStore().getCount(); i++) {
						ids.push(gridLevel1.getStore().data.items[i].id);
					}
					Ext.Ajax.request({
						url: window.webRoot + 'QAItemGroup/Order',
						method: 'POST',
						params: {
							_method: 'PUT',
							id: ids
						},
						success: function(response,options) {
							var respText = Ext.util.JSON.decode(response.responseText);
							if(respText.code == 'OK') {
							} else {
								Ext.Msg.alert('保存失败', '保存顺序失败！');
							}
						},
						failure: function() {
							Ext.Msg.alert('保存失败', '保存顺序失败！');
						}
					});
				}  
			}); 
		});    

		/** 列表双击操作 Start */
		gridLevel1.addListener('rowdblclick', function(obj, e) {
						Ext.getCmp('btnEdit1').fireEvent('click'); 
					});    
		/** 列表双击操作 End */
		
		/** 列表右键点击菜单 Start */
		var rightClick1 = new Ext.menu.Menu();
			rightClick1.add({
				text : '添加',
				iconCls : 'qaitemaddbtn',
				handler : function(obj, e) {
						Ext.getCmp('btnAdd1').fireEvent('click'); 
					}
			});
			rightClick1.add({
				text : '修改',
				iconCls : 'qaitemeditbtn',
				handler : function(obj, e) {
						Ext.getCmp('btnEdit1').fireEvent('click'); 
					}
			});
			rightClick1.add({
				text : '删除',
				iconCls : 'qaitemdelbtn',
				handler : function(obj, e) {
						Ext.getCmp('btnDelete1').fireEvent('click'); 
					}
			});

		gridLevel1.addListener('rowcontextmenu', function(client, rowIndex, e) {
			e.preventDefault();
            rightClick1.showAt(e.getXY());
		});
		/** 列表右键点击菜单 End */	  
		
		
		gridLevel1.getSelectionModel().on('rowselect', function(obj, rowIndex, rec) {
			if(obj.getCount() > 0) {
				try{
					Ext.getCmp('btnEdit1').setDisabled(false);
					Ext.getCmp('btnDelete1').setDisabled(false);
					Ext.getCmp('btnAdd2').setDisabled(false);
					Ext.getCmp('btnEdit2').setDisabled(true);
					Ext.getCmp('btnDelete2').setDisabled(true);
					Ext.getCmp('btnAdd3').setDisabled(true);
					Ext.getCmp('btnEdit3').setDisabled(true);
					Ext.getCmp('btnDelete3').setDisabled(true);
				} catch (e) {
				}

				var rec = obj.getSelected();
				storeLevel2.removeAll();
				storeLevel2.proxy.setUrl(window.webRoot + 'QAItemGroups/' + gridLevel0.getSelectionModel().getSelected().get('value') + '/' + rec.get('id'), true);
				storeLevel2.load();
				storeLevel3.removeAll();
			} else {
				try{
					Ext.getCmp('btnEdit1').setDisabled(true);
					Ext.getCmp('btnDelete1').setDisabled(true);
					Ext.getCmp('btnAdd2').setDisabled(true);
					Ext.getCmp('btnEdit2').setDisabled(true);
					Ext.getCmp('btnDelete2').setDisabled(true);
					Ext.getCmp('btnAdd3').setDisabled(true);
					Ext.getCmp('btnEdit3').setDisabled(true);
					Ext.getCmp('btnDelete3').setDisabled(true);
				} catch (e) {
				}
				storeLevel2.removeAll();
				storeLevel3.removeAll();
			}
		});
		
		gridLevel1.getSelectionModel().on('rowdeselect', function(obj, rowIndex, rec) {
			if(obj.getCount() > 0) {
				try{
					Ext.getCmp('btnEdit1').setDisabled(false);
					Ext.getCmp('btnDelete1').setDisabled(false);
					Ext.getCmp('btnAdd2').setDisabled(false);
					Ext.getCmp('btnEdit2').setDisabled(true);
					Ext.getCmp('btnDelete2').setDisabled(true);
					Ext.getCmp('btnAdd3').setDisabled(true);
					Ext.getCmp('btnEdit3').setDisabled(true);
					Ext.getCmp('btnDelete3').setDisabled(true);
				} catch (e) {
				}
				var rec = obj.getSelected();
				storeLevel2.removeAll();
				storeLevel2.proxy.setUrl(window.webRoot + 'QAItemGroups/' + gridLevel0.getSelectionModel().getSelected().get('value') + '/' + rec.get('id'), true);
				storeLevel2.load();
				storeLevel3.removeAll();
			} else {
				try{
					Ext.getCmp('btnEdit1').setDisabled(true);
					Ext.getCmp('btnDelete1').setDisabled(true);
					Ext.getCmp('btnAdd2').setDisabled(true);
					Ext.getCmp('btnEdit2').setDisabled(true);
					Ext.getCmp('btnDelete2').setDisabled(true);
					Ext.getCmp('btnAdd3').setDisabled(true);
					Ext.getCmp('btnEdit3').setDisabled(true);
					Ext.getCmp('btnDelete3').setDisabled(true);
				} catch (e) {
				}
				storeLevel2.removeAll();
				storeLevel3.removeAll();
			}
		});
		
//		storeLevel1.load({params:{start:0, limit:pagesize}});
		/** Start 一级质检类 */


		/** Start 二级质检类 */
		storeLevel2 = new Ext.data.JsonStore({
			root: 'data',
			totalProperty: 'total',
			idProperty: 'id',
			remoteSort: false,

			fields: [
					   {name: 'id'},
					   {name: 'typeId'},
					   {name: 'groupTypeId'},
					   {name: 'fatherId'},
					   {name: 'order'},
					   {name: 'value'},
					   {name: 'description'},
					   {name: 'status'},
					   {name: 'name'}
					]
			,
			
			url: 'empty.jsp'
		});
    
		storeLevel2.setDefaultSort('order', 'asc');

		var toolbarLevel2 = new Ext.Toolbar({
			width: '100%'
		});

		formLevel2 = new Ext.FormPanel({
			labelWidth: 75,
			frame:true,
			width: 350,
			defaults: {width: 230},
			defaultType: 'textfield',

			reader: new Ext.data.JsonReader({root:'data'},fieldsLevel0),

			items: [{
					fieldLabel: '名称',
					name: 'name',
					allowBlank:false
				},{
					fieldLabel: '类型',
					name: 'typeId',
					value: '',
					hidden:true
				},{
					fieldLabel: '组别ID',
					name: 'groupTypeId',
					hidden:true
				},{
					fieldLabel: '父类ID',
					name: 'fatherId',
					hidden:true
				},{
					fieldLabel: '备注',
					name: 'description',
					value: '',
					hidden:true
				},{
					fieldLabel: '状态',
					name: 'status',
					value: '0',
					hidden:true
				},{
					fieldLabel: 'ID',
					name: 'id',
					hidden:true
				}
			],

			buttons: [{
				text: '保&nbsp;存',
				handler: function(obj) {
					if(obj.ownerCt.ownerCt.form.isValid()) {
						if(obj.ownerCt.ownerCt.actiontype == "add") {
							obj.ownerCt.ownerCt.form.submit({
								url: window.webRoot + 'QAItemGroup',
								method: 'POST',
								params: {
									_method: 'POST'
								},
								success: function(form, action) {
									Ext.Msg.alert('保存成功', '添加二级质检类成功！');
									storeLevel2.load();
									winLevel2.hide();
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
						if(obj.ownerCt.ownerCt.actiontype == "edit") {
							var vals = obj.ownerCt.ownerCt.form.getValues();
							obj.ownerCt.ownerCt.form.submit({
								url: window.webRoot + 'QAItemGroup/' + vals.id,
								method: 'POST',
								params: {
									_method: 'PUT'
								},
								success: function(form, action) {
									Ext.Msg.alert('修改成功', '修改二级质检类成功！');
									storeLevel2.load();
									winLevel2.hide();
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
					winLevel2.hide();
				}
			}]
		});

		winLevel2 = new Ext.Window({
			layout:'fit',
			width: 350,
			height:120,
			closeAction:'hide',
			modal: true,
			plain: true,
			title: "添加二级质检类",
			iconCls: "addbtn",
			items: [formLevel2]
		});

		/** End 添加 */
		toolbarLevel2.addButton(new Ext.Toolbar.Button({
				id: 'btnAdd2',
				text: '添加',
				iconCls: 'qaitemaddbtn',
				disabled: true,
				listeners: {
					'click': function(obj, e) {
						winLevel2.setTitle("添加二级质检类");
						winLevel2.setIconClass("qaitemaddbtn");
						winLevel2.show(this);
						formLevel2.form.reset();
						formLevel2.actiontype = "add";
						formLevel2.find('name', 'typeId')[0].setValue('');
						formLevel2.find('name', 'groupTypeId')[0].setValue(gridLevel0.getSelectionModel().getSelected().get('value'));
						formLevel2.find('name', 'description')[0].setValue('');
						formLevel2.find('name', 'fatherId')[0].setValue(gridLevel1.getSelectionModel().getSelected().get('id'));
						formLevel2.find('name', 'status')[0].setValue('0');
					}
				}
			})
		);
		/** End 添加 */
		
		/** Start 编辑 */
		toolbarLevel2.addButton(new Ext.Toolbar.Button({
				id: 'btnEdit2',
				text: '编辑',
				disabled: true,
				iconCls: 'qaitemeditbtn',
				listeners: {
					'click': function(obj, e) {
						var rec = gridLevel2.getSelectionModel().getSelected();
						if(!rec) {
							Ext.Msg.alert('编辑', '请选择要修改的二级质检类！');
						} else {
							winLevel2.setTitle("编辑二级质检类");
							winLevel2.setIconClass("qaitemeditbtn");
							winLevel2.show(this);
							formLevel2.form.reset();
							formLevel2.form.setValues(rec.data);
							formLevel2.actiontype = "edit";
						}
					}
				}
			})
		);
		/** End 编辑 */
		
		/** Start 删除 */
		toolbarLevel2.addButton(new Ext.Toolbar.Button({
				id: 'btnDelete2',
				text: '删除',
				disabled: true,
				iconCls: 'qaitemdelbtn',
				listeners: {
					'click': function(obj, e) {
						var rec = gridLevel2.getSelectionModel().getSelected();
						if(!rec) {
							Ext.Msg.alert('删除', '请选择要删除的二级质检类！');
						} else {
							Ext.Msg.show({
								title:'删除?',
								msg: '请再次确实是否要将选中的记录删除?',
								buttons: Ext.Msg.YESNOCANCEL,
								fn: function(btn, text) {
									if(btn == "yes") {
										var ids = new Array();
										Ext.each(gridLevel2.getSelectionModel().getSelections(), function(rec) {
											ids.push(rec.get('id'));
										});
										Ext.Ajax.request({
											url: window.webRoot + 'QAItemGroup',
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
													storeLevel2.removeAll();
													storeLevel2.load({params:{start:0, limit:100}});
													Ext.getCmp('btnEdit2').setDisabled(true);
													Ext.getCmp('btnDelete2').setDisabled(true);
													Ext.getCmp('btnAdd3').setDisabled(true);
													Ext.getCmp('btnEdit3').setDisabled(true);
													Ext.getCmp('btnDelete3').setDisabled(true);
													storeLevel3.removeAll();
												}
											},
											failure: function(response,options) {
												Ext.Msg.alert('删除失败', '删除失败！');
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
		/** End 删除 */

		var sm = new Ext.grid.CheckboxSelectionModel();

		gridLevel2 = new Ext.grid.GridPanel({
			title: '二级质检类',
			columnWidth: .25,
			tbar: toolbarLevel2,
			store: storeLevel2,
			border: false,
			selModel: sm,
			columns: [
				sm, 
				{
					header   : '名称', 
					width    : .4, 
					sortable : true, 
					dataIndex: 'name'
				},
				{
					header   : '分数', 
					width    : .1, 
					sortable : true, 
					dataIndex: 'value'
				}
			],
			stripeRows: true,
			enableDragDrop : true,
			ddGroup: 'gridDD', 
			dropConfig: {appendOnly:false}, 
			height: 600,
			width: 300,
			viewConfig: {forceFit:true}, 
			loadMask: true
		});

		gridLevel2.addListener('render', function(obj, e) {
			new Ext.dd.DropTarget(gridLevel2.getEl(), {  
				ddGroup: 'gridDD',  
				copy    : false,  
				notifyDrop: function (dd, e, data) {  
					//选择行  
					var rows = gridLevel2.getSelectionModel().getSelections();  
					//选择行数  
					var count = rows.length;  
					//拖动到几行  
					var dropIndex = dd.getDragData(e).rowIndex;  
					var array=[];  
					for(var i=0;i<count;i++){  
						var index = dropIndex+i;  
						array.push(index);  
					}  
					gridLevel2.getStore().remove(gridLevel2.getStore().getById(data.selections[0].id));  
					gridLevel2.getStore().insert(dropIndex,data.selections);
					gridLevel2.getSelectionModel().selectRows(array);   
					gridLevel2.getView().refresh(); 
					var ids = new Array();
					for (var i = 0; i < gridLevel2.getStore().getCount(); i++) {
						ids.push(gridLevel2.getStore().data.items[i].id);
					}
					Ext.Ajax.request({
						url: window.webRoot + 'QAItemGroup/Order',
						method: 'POST',
						params: {
							_method: 'PUT',
							id: ids
						},
						success: function(response,options) {
							var respText = Ext.util.JSON.decode(response.responseText);
							if(respText.code == 'OK') {
							} else {
								Ext.Msg.alert('保存失败', '保存顺序失败！');
							}
						},
						failure: function() {
							Ext.Msg.alert('保存失败', '保存顺序失败！');
						}
					});
				}  
			}); 
		});    

		/** 列表双击操作 Start */
		gridLevel2.addListener('rowdblclick', function(obj, e) {
						Ext.getCmp('btnViewInfo').fireEvent('click'); 
					});    
		/** 列表双击操作 End */
		
		/** 列表右键点击菜单 Start */
		var rightClick2 = new Ext.menu.Menu();
			rightClick2.add({
				text : '添加',
				iconCls : 'qaitemaddbtn',
				handler : function(obj, e) {
						Ext.getCmp('btnAdd2').fireEvent('click'); 
					}
			});
			rightClick2.add({
				text : '修改',
				iconCls : 'qaitemeditbtn',
				handler : function(obj, e) {
						Ext.getCmp('btnEdit2').fireEvent('click'); 
					}
			});
			rightClick2.add({
				text : '删除',
				iconCls : 'qaitemdelbtn',
				handler : function(obj, e) {
						Ext.getCmp('btnDelete2').fireEvent('click'); 
					}
			});

		gridLevel2.addListener('rowcontextmenu', function(client, rowIndex, e) {
			e.preventDefault();
            rightClick2.showAt(e.getXY());
		});
		/** 列表右键点击菜单 End */	  
		
		gridLevel2.getSelectionModel().on('rowselect', function(obj, rowIndex, rec) {
			if(obj.getCount() > 0) {
				rec = obj.getSelected();
				try{
					Ext.getCmp('btnEdit2').setDisabled(false);
					Ext.getCmp('btnDelete2').setDisabled(false);
					Ext.getCmp('btnAdd3').setDisabled(false);
					Ext.getCmp('btnEdit3').setDisabled(true);
					Ext.getCmp('btnDelete3').setDisabled(true);
				} catch (e) {
				}
				var rec = obj.getSelected();
				storeLevel3.removeAll();
				storeLevel3.proxy.setUrl(window.webRoot + 'QAItems/' + rec.get('id'), true);
				storeLevel3.load();
			} else {
				try{
					Ext.getCmp('btnEdit2').setDisabled(true);
					Ext.getCmp('btnDelete2').setDisabled(true);
					Ext.getCmp('btnAdd3').setDisabled(true);
					Ext.getCmp('btnEdit3').setDisabled(true);
					Ext.getCmp('btnDelete3').setDisabled(true);
				} catch (e) {
				}
				storeLevel3.removeAll();
			}
		});
		
		gridLevel2.getSelectionModel().on('rowdeselect', function(obj, rowIndex, rec) {
			if(obj.getCount() > 0) {
				rec = obj.getSelected();
				try{
					Ext.getCmp('btnEdit2').setDisabled(false);
					Ext.getCmp('btnDelete2').setDisabled(false);
					Ext.getCmp('btnAdd3').setDisabled(false);
					Ext.getCmp('btnEdit3').setDisabled(true);
					Ext.getCmp('btnDelete3').setDisabled(true);
				} catch (e) {
				}
				var rec = obj.getSelected();
				storeLevel3.removeAll();
				storeLevel3.proxy.setUrl(window.webRoot + 'QAItems/' + rec.get('id'), true);
				storeLevel3.load();
			} else {
				try{
					Ext.getCmp('btnEdit2').setDisabled(true);
					Ext.getCmp('btnDelete2').setDisabled(true);
					Ext.getCmp('btnAdd3').setDisabled(true);
					Ext.getCmp('btnEdit3').setDisabled(true);
					Ext.getCmp('btnDelete3').setDisabled(true);
				} catch (e) {
				}
				storeLevel3.removeAll();
			}
		});
		
//		storeLevel2.load({params:{start:0, limit:pagesize}});
		/** Start 二级质检类 */


		/** Start 质检项 */
		storeLevel3 = new Ext.data.JsonStore({
			root: 'data',
			totalProperty: 'total',
			idProperty: 'id',
			remoteSort: false,

			fields: [
					   {name: 'id'},
					   {name: 'groupId'},
					   {name: 'value'},
					   {name: 'order'},
					   {name: 'desc'},
					   {name: 'status'},
					   {name: 'name'}
					]
			,
			
			url: 'empty.jsp'
		});
    
		storeLevel3.setDefaultSort('order', 'asc');

		storeLevel3.on('load', function() {
			resetScore();
		});

		var toolbarLevel3 = new Ext.Toolbar({
			width: '100%'
		});

		formLevel3 = new Ext.FormPanel({
			labelWidth: 75,
			frame:true,
			width: 350,
			defaults: {width: 230},
			defaultType: 'textfield',

			reader: new Ext.data.JsonReader({root:'data'},fieldsLevel0),

			items: [{
					fieldLabel: '名称',
					name: 'name',
					allowBlank:false
				},{
					xtype: 'spinnerfield',
					fieldLabel: '分数',
					name: 'value',
					value: 0,
					allowBlank:false
				},{
					fieldLabel: '组别ID',
					name: 'groupId',
					hidden:true
				},{
					fieldLabel: '备注',
					name: 'desc',
					value: '',
					hidden:true
				},{
					fieldLabel: '状态',
					name: 'status',
					value: '0',
					hidden:true
				},{
					fieldLabel: 'ID',
					name: 'id',
					hidden:true
				}
			],

			buttons: [{
				text: '保&nbsp;存',
				handler: function(obj) {
					if(obj.ownerCt.ownerCt.form.isValid()) {
						if(obj.ownerCt.ownerCt.actiontype == "add") {
							obj.ownerCt.ownerCt.form.submit({
								url: window.webRoot + 'QAItem',
								method: 'POST',
								params: {
									_method: 'POST'
								},
								success: function(form, action) {
									Ext.Msg.alert('保存成功', '添加质检项成功！');
									storeLevel3.load();
									winLevel3.hide();
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
						if(obj.ownerCt.ownerCt.actiontype == "edit") {
							var vals = obj.ownerCt.ownerCt.form.getValues();
							obj.ownerCt.ownerCt.form.submit({
								url: window.webRoot + 'QAItem/' + vals.id,
								method: 'POST',
								params: {
									_method: 'PUT'
								},
								success: function(form, action) {
									Ext.Msg.alert('修改成功', '修改质检项成功！');
									storeLevel3.load();
									winLevel3.hide();
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
					winLevel3.hide();
				}
			}]
		});

		winLevel3 = new Ext.Window({
			layout:'fit',
			width: 350,
			height:150,
			closeAction:'hide',
			modal: true,
			plain: true,
			title: "添加质检项",
			iconCls: "addbtn",
			items: [formLevel3]
		});

		toolbarLevel3.addButton(new Ext.Toolbar.Button({
				id: 'btnAdd3',
				text: '添加',
				iconCls: 'qaitemaddbtn',
				disabled: true,
				listeners: {
					'click': function(obj, e) {
						winLevel3.setTitle("添加质检项");
						winLevel3.setIconClass("qaitemaddbtn");
						winLevel3.show(this);
						formLevel3.form.reset();
						formLevel3.actiontype = "add";
						formLevel3.find('name', 'groupId')[0].setValue(gridLevel2.getSelectionModel().getSelected().get('id'));
					}
				}
			})
		);
		/** End 添加 */
		
		/** Start 编辑 */
		toolbarLevel3.addButton(new Ext.Toolbar.Button({
				id: 'btnEdit3',
				text: '编辑',
				disabled: true,
				iconCls: 'qaitemeditbtn',
				listeners: {
					'click': function(obj, e) {
						var rec = gridLevel3.getSelectionModel().getSelected();
						if(!rec) {
							Ext.Msg.alert('编辑', '请选择要修改的质检项！');
						} else {
							winLevel3.setTitle("编辑质检项");
							winLevel3.setIconClass("qaitemeditbtn");
							winLevel3.show(this);
							formLevel3.form.reset();
							formLevel3.form.setValues(rec.data);
							formLevel3.actiontype = "edit";
						}
					}
				}
			})
		);
		/** End 编辑 */
		
		/** Start 删除 */
		toolbarLevel3.addButton(new Ext.Toolbar.Button({
				id: 'btnDelete3',
				text: '删除',
				disabled: true,
				iconCls: 'qaitemdelbtn',
				listeners: {
					'click': function(obj, e) {
						var rec = gridLevel3.getSelectionModel().getSelected();
						if(!rec) {
							Ext.Msg.alert('删除', '请选择要删除的质检项！');
						} else {
							Ext.Msg.show({
								title:'删除?',
								msg: '请再次确实是否要将选中的删除?',
								buttons: Ext.Msg.YESNOCANCEL,
								fn: function(btn, text) {
									if(btn == "yes") {
										var ids = new Array();
										Ext.each(gridLevel3.getSelectionModel().getSelections(), function(rec) {
											ids.push(rec.get('id'));
										});
										Ext.Ajax.request({
											url: window.webRoot + 'QAItem',
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
													storeLevel3.removeAll();
													storeLevel3.load({params:{start:0, limit:100}});
													Ext.getCmp('btnEdit3').setDisabled(true);
													Ext.getCmp('btnDelete3').setDisabled(true);
												}
											},
											failure: function(response,options) {
												Ext.Msg.alert('删除失败', '删除失败！');
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
		/** End 删除 */

		var sm = new Ext.grid.CheckboxSelectionModel();

		gridLevel3 = new Ext.grid.GridPanel({
            title: '质检项',
			columnWidth: .25,
			tbar: toolbarLevel3,
			store: storeLevel3,
			border: false,
			selModel: sm,
			columns: [
				sm, 
				{
					header   : '名称', 
					width    : .4, 
					sortable : true, 
					dataIndex: 'name'
				},
				{
					header   : '分数', 
					width    : .1, 
					sortable : true, 
					dataIndex: 'value'
				}
			],
			stripeRows: true,
			enableDragDrop : true,
			ddGroup: 'gridDD', 
			dropConfig: {appendOnly:false}, 
			height: 600,
			width: 300,
			viewConfig: {forceFit:true}, 
			loadMask: true
		});

		gridLevel3.addListener('render', function(obj, e) {
			new Ext.dd.DropTarget(gridLevel3.getEl(), {  
				ddGroup: 'gridDD',  
				copy    : false,  
				notifyDrop: function (dd, e, data) {  
					//选择行  
					var rows = gridLevel3.getSelectionModel().getSelections();  
					//选择行数  
					var count = rows.length;  
					//拖动到几行  
					var dropIndex = dd.getDragData(e).rowIndex;  
					var array=[];  
					for(var i=0;i<count;i++){  
						var index = dropIndex+i;  
						array.push(index);  
					}  
					gridLevel3.getStore().remove(gridLevel3.getStore().getById(data.selections[0].id));  
					gridLevel3.getStore().insert(dropIndex,data.selections); 
					gridLevel3.getSelectionModel().selectRows(array);   
					gridLevel3.getView().refresh(); 
					var ids = new Array();
					for (var i = 0; i < gridLevel3.getStore().getCount(); i++) {
						ids.push(gridLevel3.getStore().data.items[i].id);
					}
					Ext.Ajax.request({
						url: window.webRoot + 'QAItem/Order',
						method: 'POST',
						params: {
							_method: 'PUT',
							id: ids
						},
						success: function(response,options) {
							var respText = Ext.util.JSON.decode(response.responseText);
							if(respText.code == 'OK') {
							} else {
								Ext.Msg.alert('保存失败', '保存顺序失败！');
							}
						},
						failure: function() {
							Ext.Msg.alert('保存失败', '保存顺序失败！');
						}
					});
				}  
			}); 
		});    

		/** 列表双击操作 Start */
		gridLevel3.addListener('rowdblclick', function(obj, e) {
						Ext.getCmp('btnEdit3').fireEvent('click'); 
					});    
		/** 列表双击操作 End */
		
		/** 列表右键点击菜单 Start */
		var rightClick3 = new Ext.menu.Menu();
			rightClick3.add({
				text : '添加',
				iconCls : 'qaitemaddbtn',
				handler : function(obj, e) {
						Ext.getCmp('btnAdd3').fireEvent('click'); 
					}
			});
			rightClick3.add({
				text : '修改',
				iconCls : 'qaitemeditbtn',
				handler : function(obj, e) {
						Ext.getCmp('btnEdit3').fireEvent('click'); 
					}
			});
			rightClick3.add({
				text : '删除',
				iconCls : 'qaitemdelbtn',
				handler : function(obj, e) {
						Ext.getCmp('btnDelete3').fireEvent('click'); 
					}
			});

		gridLevel3.addListener('rowcontextmenu', function(client, rowIndex, e) {
			e.preventDefault();
            rightClick3.showAt(e.getXY());
		});
		/** 列表右键点击菜单 End */	  
		
		gridLevel3.getSelectionModel().on('rowselect', function(obj, rowIndex, rec) {
			if(obj.getCount() > 0) {
				rec = obj.getSelected();
				try{
					Ext.getCmp('btnEdit3').setDisabled(false);
					Ext.getCmp('btnDelete3').setDisabled(false);
				} catch (e) {
				}
			} else {
				try{
					Ext.getCmp('btnEdit3').setDisabled(true);
					Ext.getCmp('btnDelete3').setDisabled(true);
				} catch (e) {
				}
			}
		});
		
		gridLevel3.getSelectionModel().on('rowdeselect', function(obj, rowIndex, rec) {
			if(obj.getCount() > 0) {
				rec = obj.getSelected();
				try{
					Ext.getCmp('btnEdit3').setDisabled(false);
					Ext.getCmp('btnDelete3').setDisabled(false);
				} catch (e) {
				}
			} else {
				try{
					Ext.getCmp('btnEdit3').setDisabled(true);
					Ext.getCmp('btnDelete3').setDisabled(true);
				} catch (e) {
				}
			}
		});
		
//		storeLevel3.load({params:{start:0, limit:pagesize}});
		/** Start 质检项 */

        var viewport = new Ext.Viewport({
            layout: 'column',
			autoHeight: true,
			border: false,
            items: [gridLevel0, gridLevel1, gridLevel2, gridLevel3]
		});	

	});	
	</script>
 
</head>
<body>
	<div id="adduser-win" class="x-hidden"></div>
</body>
</html>
