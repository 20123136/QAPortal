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
	<title>日文线强制工作日</title>

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
						url: window.webRoot + 'CodeBase/5015/Reload',
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
				url: window.webRoot + 'CodeBase/5015'
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
				html:"&nbsp;&nbsp;<font color='#FF9900'>*</font>&nbsp;&nbsp;<font color='#646464'>本页面用于显示日文线强制工作日。数据以CSR系统的数据库为基础，并由CSR系统维护，本页面只做展示。数据最后一次更新时间为: <span style='color:#0000FF' id=spanReloadTime></span>。<a href=# onclick='doReload()'>手动更新</a></font>"
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
					header   : '日期',
					width    : .2,
					sortable : true,
					dataIndex: 'value'
				},
				{
					header   : '名称',
					width    : .6,
					sortable : true,
					dataIndex: 'name'
				}
			],
			stripeRows: true,
			height: 600,
			width: '100%',
			viewConfig: {forceFit:true},
			loadMask: true
		});
			
		store.load();

		store.on('load', function() {
			Ext.Ajax.request({
				url: window.webRoot + 'CodeBase/5015/UpdateTime',
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

		var viewport = new Ext.Viewport({
			layout: 'border',
			autoHeight: true,
			border: false,
			items: [grid]
		});

//		infotab.collapse(true);
	});
	</script>
</head>
</html>
