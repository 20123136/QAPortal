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
	<title>英文语音列表</title>

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
<script type="text/javascript" src="../js/app/avp/CustomerTypeSelector.js"></script>
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
					{name: 'no'},
					{name: 'description'},
					{name: 'language'},
					{name: 'status'},
					{name: 'isExist'},
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
				url: window.webRoot + 'Voice/EnglishVoices'
			})

		});

		store.setDefaultSort('id', 'asc');

		var toolbarHelp = new Ext.Toolbar({
			width: '100%'
		});

		toolbarHelp.addButton(
			new Ext.form.DisplayField({
				fieldLabel: '',
				style: {align: 'right'},
				html:"&nbsp;&nbsp;<font color='#FF9900'>*</font>&nbsp;&nbsp;<font color='#646464'>本页面用于维护英文语音列表。</font>"
			})
		);

		var toolbar = new Ext.Toolbar({
			width: '100%'
		});

		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnAdd',
				text: '添加',
				iconCls: 'confaddbtn',
				listeners: {
					'click': function(obj, e) {
						actiontype = "add";
						win.setTitle("添加英文语音");
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
							Ext.Msg.alert('编辑英文语音', '请选择要修改的英文语音！');
						} else {
							actiontype = "edit";
							win.setTitle("编辑英文语音");
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
							Ext.Msg.alert('删除英文语音', '请选择要删除的英文语音！');
						} else {
							Ext.Msg.show({
								title:'删除英文语音',
								msg: '请再次确实是否要将选择的英文语音删除?',
								buttons: Ext.Msg.YESNOCANCEL,
								fn: function(btn, text) {
									if(btn == "yes") {
										var ids = new Array();
										Ext.each(grid.getSelectionModel().getSelections(), function(rec) {
											ids.push(rec.get('id'));
										});
										grid.el.mask('请求以提交，请等待', 'x-mask-loading');
										Ext.Ajax.request({
											url: window.webRoot + 'Voice',
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
													Ext.Msg.alert('删除失败', '删除英文语音失败！');
												}
											},
											failure: function() {
												grid.el.unmask();
												Ext.Msg.alert('删除失败', '删除英文语音失败！');
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
				new Ext.grid.RowNumberer(),
				{
					header   : '编号',
					width    : .1,
					sortable : false,
					dataIndex: 'no'
				},
				{
					header   : '内容',
					width    : .2,
					sortable : false,
					dataIndex: 'description'
				},
				{
					header   : '是否存在',
					width    : .2,
					sortable : false,
					dataIndex: 'isExist',
					renderer: function (val) {
						if(val){
					        return '<img src= "../images/icons/fam/accept.png" />'
					    } else {
					    	return '<img src= "../images/icons/fam/delete.png" />'
					    }
					}
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
			}),

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
			labelWidth: 75,
			frame:true,
			width: 520,
			defaultType: 'textfield',

			items: [
			    	{
						fieldLabel: 'id',
						name: 'id',
						hidden:true
					},{
						fieldLabel: '编号(*)',
						name: 'no',
						width:160,
						allowBlank:false
					},{
						fieldLabel: 'language',
						name: 'language',
						hidden:true
					},{
						xtype: 'textarea',
						fieldLabel: '内容',
						name: 'description',
						width: 380,
						allowBlank:false
					}
			],

			buttons: [{
				text: '保&nbsp;存',
				handler: function() {
					if(form.form.isValid()) {
						if(actiontype == "add") {
							form.form.submit({
								url: window.webRoot + 'Voice/2',
								method: 'POST',
								params: {
									language: '2',
									_method: 'POST'
								},
								success: function(form, action) {
									Ext.Msg.alert('保存成功', '添加英文语音成功！');
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
											Ext.Msg.alert('保存失败', '添加英文语音失败！(' + action.result.message + ')');
									}
								},
								waitMsg: '数据保存中，请稍候...'
							});
						}
						if(actiontype == "edit") {
							var vals = form.form.getValues();
							form.form.submit({
								url: window.webRoot + 'Voice/' + vals.id,
								method: 'POST',
								params: {
									_method: 'PUT'
								},
								success: function(form, action) {
									Ext.Msg.alert('修改成功', '修改英文语音成功！');
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
											Ext.Msg.alert('修改失败', '修改英文语音失败！(' + action.result.message + ')');
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
				'编号:&nbsp;&nbsp;',
				new Ext.form.TextField({
					id: 'qryNo',
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
				'内容:&nbsp;&nbsp;',
				new Ext.form.TextField({
					id: 'qryDescription',
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
						Ext.getCmp('qryNo').setValue('');
						Ext.getCmp('qryDescription').setValue('');
						store.load({params:{start:0, limit:pagesize}});
					}
				}),
				'-'
			],
			items: grid
		});
 
		store.on('beforeload', function(loader, node) {
			var no = Ext.getCmp('qryNo').getValue();
			var description = Ext.getCmp('qryDescription').getValue();
			store.baseParams = {no:no, description:description};
		});
		/** 查询 End */

		var viewport = new Ext.Viewport({
			layout: 'border',
			autoHeight: true,
			border: false,
			items: [panel_query]
		});

		win = new Ext.Window({
			layout:'fit',
			width: 520,
			height:225,
			closeAction:'hide',
			modal: true,
			plain: true,
			title: "添加英文语音",
			iconCls: "addbtn",
			items: [form]
		});

//		infotab.collapse(true);
	});
	</script>
</head>
</html>
