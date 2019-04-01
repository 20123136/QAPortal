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
    <title>日志列表</title>
 
    <link rel="stylesheet" type="text/css" href="../css/ext-all.css" />
    <link rel="stylesheet" type="text/css" href="../css/icon.css" />
 
    <script type="text/javascript" src="../js/ext-base-debug.js"></script>
    <script type="text/javascript" src="../js/ext-all-debug.js"></script>
    <script type="text/javascript" src="../js/ext-lang-zh_CN.js"></script>

    <script type="text/javascript" src="../js/func.js"></script>
	<script >
		var webRoot = '<%=webRoot%>';
	</script>
    <script type="text/javascript">

	function showFileType(value, metaData, record, rowIndex, colIndex, store) {
		switch (value) {
			case 'dir'	:
				return '<img src=../images/icons/fam/folder.png>';
			case 'txt'	:
				return '<img src=../images/icons/fam/page_white_text.png>';
			default		:
				return '<img src=../images/icons/fam/page.png>';
		}
	}

	Ext.onReady(function(){
		
		Ext.QuickTips.init();
		
		var reader = new Ext.data.JsonReader({
			root: 'data',
			totalProperty: 'total',
			remoteSort: false,

			fields: [
				{name: 'name'},
				{name: 'type'},
				{name: 'lastModifyTime'},
				{name: 'size'},
				{name: 'appNo'},
				{name: 'path'}
			]
		});

		var store = new Ext.data.GroupingStore({
			reader: reader,
			proxy: new Ext.data.HttpProxy({
				url: window.webRoot + 'Logs'
			}),
			sortInfo:{field: 'name', direction: "DESC"},
			groupField:'appNo'
		});

		var grid = new Ext.grid.GridPanel({
            region: 'center',
			store: store,
			columns: [
				{
					header   : '类型',
					width    : .1,
					sortable : false,
					dataIndex: 'type',
					renderer : showFileType
				},
				{
					header   : '文件名',
					width    : .5,
					sortable : false,
					dataIndex: 'name'
				},
				{
					header   : '应用编号',
					width    : .2,
					sortable : false,
					hidden	 : true,
					dataIndex: 'appNo'
				},
				{
					header   : '大小',
					width    : .4,
					sortable : false,
					dataIndex: 'size'
				},
				{
					header   : '最后更新时间',
					width    : .4,
					sortable : false,
					dataIndex: 'lastModifyTime'
				}
			],

			view: new Ext.grid.GroupingView({
				forceFit:true,
				groupTextTpl: '{text} ({[values.rs.length]} {[values.rs.length > 1 ? "Items" : "Item"]})'
			}),
			border: false,
			autoWidth: true,
			autoScroll:true,   
			collapsible: false
		});

		grid.addListener('rowdblclick', function(obj, e) {
//			Ext.getCmp('btnViewLogFile').fireEvent('click'); 
			var rec = grid.getSelectionModel().getSelected();
			var name = encodeURL(rec.get('name'));
			name = name.replace('\.', '|');
			parent.logtab.add({
				title: rec.get('name'),
				iconCls: 'txtbtn',
				margins:'0 0 0 0',
				autoScroll:true,
				autoWidth:true,
				closable:true,
				html:'<iframe src="logs-view.jsp?file=' + name + '" border=0 width="100%" height="100%" frameborder="no" scrolling="auto"></iframe>'
			}).show();
		});

        var viewport = new Ext.Viewport({
            layout: 'border',
			border: false,
            items: [grid]
		});	

		store.load();

	});	
	</script>
 
</head>
<body>
	<div id="adduser-win" class="x-hidden"></div>
	<div id="assign-pri-win" class="x-hidden"></div>
	<div id="assign-user-win" class="x-hidden"></div>
	<div id="assign-tenant-win" class="x-hidden"></div>
</body>
</html>
