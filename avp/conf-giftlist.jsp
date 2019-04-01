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
	<title>礼品列表</title>

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
<script type="text/javascript">
	var curId = 0;
	var win;
	var pagesize = 25;
	var grid;
	var form;
	var actiontype = "";
	
	var fields = [
				   {name: 'code'},
				   {name: 'type'},
				   {name: 'desc'},
				   {name: 'name'},
				   {name: 'value'}
				];

	function doReload() {
		Ext.Msg.show({
			title:'更新数据',
			msg: '请再次确实是否要从数据库中重新读取数据，并更新缓存?',
			buttons: Ext.Msg.YESNOCANCEL,
			fn: function(btn, text) {
				if(btn == "yes") {
					Ext.Ajax.request({
						url: window.webRoot + 'CodeBase/5006/Reload',
						method: 'GET',
						success: function(response,options) {
							var respText = Ext.util.JSON.decode(response.responseText);
							if(respText.code == 'OK') {
								Ext.Msg.alert('更新成功', '数据已经重新从数据库中读取并更新缓存');
								grid.getStore().load();
							} else {
								Ext.Msg.alert('更新失败', respText.message + "（" + respText.code + "）");
							}
						},
						failure: function(response,options) {
							Ext.getDom('spanReloadTime').innerHTML = 'Null';
						}
					});
				}
			},
			icon: Ext.MessageBox.QUESTION
		});						
	}

	Ext.onReady(function(){
		var store = new Ext.data.JsonStore({
			root: 'data',
			totalProperty: 'total',
			remoteSort: false,

			fields: fields,

			proxy: new Ext.data.HttpProxy({
				url: window.webRoot + 'CodeBase/5006'
			})

		});

		store.setDefaultSort('code', 'asc');

		var toolbarHelp = new Ext.Toolbar({
			width: '100%'
		});

		toolbarHelp.addButton(
			new Ext.form.DisplayField({
				fieldLabel: '',
				style: {align: 'right'},
				html:"&nbsp;&nbsp;<font color='#FF9900'>*</font>&nbsp;&nbsp;<font color='#646464'>本页面用于显示礼品列表。数据以CSR系统的数据库为基础，并由CSR系统维护，本页面只做展示。数据最后一次更新时间为: <span style='color:#0000FF' id=spanReloadTime></span>。<a href=# onclick='doReload()'>手动更新</a></font>"
			})
		);

		grid = new Ext.grid.GridPanel({
            region: 'center',
			tbar: toolbarHelp,
			store: store,
			border: false,
			columns: [
				new Ext.grid.RowNumberer(),
				{
					header   : '礼品编号',
					width    : .2,
					sortable : true,
					dataIndex: 'code'
				},
				{
					header   : '中文名称',
					width    : .6,
					sortable : true,
					dataIndex: 'name'
				},
				{
					header   : '英文名称',
					width    : .6,
					sortable : true,
					dataIndex: 'desc'
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
			
		store.load({params:{start:0, limit:pagesize}});

		store.on('load', function() {
			Ext.Ajax.request({
				url: window.webRoot + 'CodeBase/5006/UpdateTime',
				method: 'GET',
				success: function(response,options) {
					var respText = Ext.util.JSON.decode(response.responseText);
					if(respText.code == 'OK') {
						Ext.getDom('spanReloadTime').innerHTML = respText.data;
					} else {
						Ext.getDom('spanReloadTime').innerHTML = 'Null';
					}
				},
				failure: function(response,options) {
					Ext.getDom('spanReloadTime').innerHTML = 'Null';
				}
			});
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
					id: 'qryGiftCode',
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
				'姓名:&nbsp;&nbsp;',
				new Ext.form.TextField({
					id: 'qryGiftName',
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
						Ext.getCmp('qryGiftCode').setValue('');
						Ext.getCmp('qryGiftName').setValue('');
						store.load({params:{start:0, limit:pagesize}});
					}
				}),
				'-'
			],
			items: grid
		});
 
		store.on('beforeload', function(loader, node) {
			var code = Ext.getCmp('qryGiftCode').getValue();
			var name = Ext.getCmp('qryGiftName').getValue();
			store.baseParams = {code:code, name:name};
		});
		/** 查询 End */

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
</html>
