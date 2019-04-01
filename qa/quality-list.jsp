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
    <title>我的质检</title>

    <link rel="stylesheet" type="text/css" href="../css/ext-all-notheme.css" />
    <link rel="stylesheet" type="text/css" href="../css/xtheme-gray.css" />
    <link rel="stylesheet" type="text/css" href="../css/icon.css" />
    <link rel="stylesheet" type="text/css" href="../ux/css/DateTimePicker.css" />
    <link rel="stylesheet" type="text/css" href="../ux/css/Spinner.css" />
    <style type=text/css>
        /* style rows on mouseover */
        .x-grid3-row-over .x-grid3-cell-inner {
            font-weight: bold;
        }

        .titletext {
            font-weight: bold;
        }
	</style>
	<script >
		var webRoot = '<%=webRoot%>';
	</script>

    <script type="text/javascript" src="../js/ext-base.js"></script>
    <script type="text/javascript" src="../js/ext-all-debug.js"></script>
    <script type="text/javascript" src="../js/ext-lang-zh_CN.js"></script>
    <script type="text/javascript" src="../js/ext-ui-combo-pagesize.js"></script>
	<script type="text/javascript" src="../ux/PagingMemoryProxy.js"></script>
    <script type="text/javascript">
	var pagesize = 25;
	var tabCount = 1;

	var ConditionFields = new Array();

	var QueryConditionFields = new Array();
	
	var QAConditionFields = new Array();
	
	Ext.onReady(function(){
		// var store = new Ext.data.JsonStore({
			// root: 'data',
			// totalProperty: 'total',
			// remoteSort: false,

			// fields: fields,
			
			// proxy: new Ext.data.HttpProxy({
				// url: window.webRoot + 'Conf/Skills'
			// })

		// });

		// store.setDefaultSort('key', 'asc');
		var myData = [
			['3m Co',71.72,0.02,0.03,'9/1 12:00am'],
			['Alcoa Inc',29.01,0.42,1.47,'9/1 12:00am'],
			['Altria Group Inc',83.81,0.28,0.34,'9/1 12:00am'],
			['American Express Company',52.55,0.01,0.02,'9/1 12:00am'],
			['American International Group, Inc.',64.13,0.31,0.49,'9/1 12:00am'],
			['AT&T Inc.',31.61,-0.48,-1.54,'9/1 12:00am'],
			['Boeing Co.',75.43,0.53,0.71,'9/1 12:00am'],
			['Caterpillar Inc.',67.27,0.92,1.39,'9/1 12:00am'],
			['Citigroup, Inc.',49.37,0.02,0.04,'9/1 12:00am'],
			['E.I. du Pont de Nemours and Company',40.48,0.51,1.28,'9/1 12:00am'],
			['Exxon Mobil Corp',68.1,-0.43,-0.64,'9/1 12:00am'],
			['General Electric Company',34.14,-0.08,-0.23,'9/1 12:00am'],
			['General Motors Corporation',30.27,1.09,3.74,'9/1 12:00am'],
			['Hewlett-Packard Co.',36.53,-0.03,-0.08,'9/1 12:00am'],
			['Honeywell Intl Inc',38.77,0.05,0.13,'9/1 12:00am'],
			['Intel Corporation',19.88,0.31,1.58,'9/1 12:00am'],
			['International Business Machines',81.41,0.44,0.54,'9/1 12:00am'],
			['Johnson & Johnson',64.72,0.06,0.09,'9/1 12:00am'],
			['JP Morgan & Chase & Co',45.73,0.07,0.15,'9/1 12:00am'],
			['McDonald\'s Corporation',36.76,0.86,2.40,'9/1 12:00am'],
			['Merck & Co., Inc.',40.96,0.41,1.01,'9/1 12:00am'],
			['Microsoft Corporation',25.84,0.14,0.54,'9/1 12:00am'],
			['Pfizer Inc',27.96,0.4,1.45,'9/1 12:00am'],
			['The Coca-Cola Company',45.07,0.26,0.58,'9/1 12:00am'],
			['The Home Depot, Inc.',34.64,0.35,1.02,'9/1 12:00am'],
			['The Procter & Gamble Company',61.91,0.01,0.02,'9/1 12:00am'],
			['United Technologies Corporation',63.26,0.55,0.88,'9/1 12:00am'],
			['Verizon Communications',35.57,0.39,1.11,'9/1 12:00am'],
			['Wal-Mart Stores, Inc.',45.45,0.73,1.63,'9/1 12:00am']
		];
		
		var store = new Ext.data.Store({
			proxy: new Ext.ux.data.PagingMemoryProxy(myData),
			remoteSort:true,
			sortInfo: {field:'price', direction:'ASC'},
			reader: new Ext.data.ArrayReader({
				fields: [
				   {name: 'company'},
				   {name: 'price', type: 'float'},
				   {name: 'change', type: 'float'},
				   {name: 'pctChange', type: 'float'},
				   {name: 'lastChange', type: 'date', dateFormat: 'n/j h:ia'}
				]
			})
		});
		
		
		var toolbarHelp = new Ext.Toolbar({
			width: '100%'
		});

		// toolbarHelp.addButton(
			// new Ext.form.DisplayField({
				// fieldLabel: '',
				// style: {align: 'right'},
				// html:"&nbsp;&nbsp;<font color='#FF9900'>*</font>&nbsp;&nbsp;<font color='#646464'>技能组管理页面用户维护技能列表。'编号'为VP内部定义的技能组编号，'GroupId'和'TypeId'为转接座席时需要设置到随路数据中的数据。</font>"
			// })
		// );

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
						win.setTitle("添加技能组");
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
							Ext.Msg.alert('编辑技能组', '请选择要修改的技能组！');
						} else {
							actiontype = "edit";
							win.setTitle("编辑技能组");
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
							Ext.Msg.alert('删除技能组', '请选择要删除的技能组！');
						} else {
							Ext.Msg.show({
								title:'删除技能组',
								msg: '请再次确实是否要将选择的技能组删除?',
								buttons: Ext.Msg.YESNOCANCEL,
								fn: function(btn, text) {
									if(btn == "yes") {
										var ids = new Array();
										Ext.each(grid.getSelectionModel().getSelections(), function(rec) {
											ids.push(rec.get('id'));
										});
										grid.el.mask('请求已提交，请等待', 'x-mask-loading');
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
													Ext.Msg.alert('删除失败', '删除技能组失败！');
												}
											},
											failure: function() {
												grid.el.unmask();
												Ext.Msg.alert('删除失败', '删除技能组失败！');
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
					header   : '质检员', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'price'
				},
				{
					header   : '质检组长', 
					width    : .3, 
					sortable : true, 
					dataIndex: 'price'
				},
				{
					header   : '质检管理员', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'price'
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
				Ext.getCmp('btnTest').setDisabled(false);
			} catch (e)	{
			}
		});
		
		//store.load({params:{start:0, limit:pagesize}});
		store.load();
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
					fieldLabel: '编号(*)',
					name: 'key',
					width: 160,
					allowBlank:false
				},{
					fieldLabel: '名称(*)',
					name: 'name',
					width: 380,
					allowBlank:false
				},{
					fieldLabel: 'GroupId(*)',
					name: 'groupId',
					width: 160,
					allowBlank:false
				},{
					fieldLabel: 'TypeId(*)',
					name: 'typeId',
					width: 160,
					allowBlank:false
				}
			],

			buttons: [{
				text: '保&nbsp;存',
				handler: function() {
					if(form.form.isValid()) {
						if(actiontype == "add") {
							form.form.submit({
								url: window.webRoot + 'Conf/Skill',
								method: 'POST',
								params: {
									_method: 'POST'
								},
								success: function(form, action) {
									Ext.Msg.alert('保存成功', '添加技能组成功！');
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
											Ext.Msg.alert('保存失败', '添加技能组失败！(' + action.result.message + ')');
									}
								},
								waitMsg: '数据保存中，请稍候...'
							});
						}
						if(actiontype == "edit") {
							var vals = form.form.getValues();
							form.form.submit({
								url: window.webRoot + 'Conf/Skill/' + vals.id,
								method: 'POST',
								params: {
									_method: 'PUT'
								},
								success: function(form, action) {
									Ext.Msg.alert('修改成功', '修改技能组成功！');
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
											Ext.Msg.alert('修改失败', '修改技能组失败！(' + action.result.message + ')');
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
			title: "添加技能组",
			iconCls: "addbtn",
			items: [form]
		});
		
	});
	</script>

</head>
<body>
	<div id="save-win" class="x-hidden"></div>
</body>
</html>
