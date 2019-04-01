<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
	response.setHeader("Pragma","No-cache");
	response.setHeader("Cache-Control","no-cache");
	response.setHeader("Expires","0");

	request.setCharacterEncoding("UTF-8");

	String time = request.getParameter("time");
	String server = request.getParameter("server");
	String channel = request.getParameter("channel");

	String webRoot = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<html> 
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>显示日志</title>
 
    <link rel="stylesheet" type="text/css" href="../css/ext-all.css" />
    <link rel="stylesheet" type="text/css" href="../css/icon.css" />
 
    <script type="text/javascript" src="../js/ext-base-debug.js"></script>
    <script type="text/javascript" src="../js/ext-all-debug.js"></script>
    <script type="text/javascript" src="../js/ext-lang-zh_CN.js"></script>
    <script type="text/javascript" src="../js/ext-ui-combo-pagesize.js"></script>
   
	<script type="text/javascript" src="../js/htmlformat.js"></script>

    <script type="text/javascript" src="../js/func.js"></script>
	<script >
		var webRoot = '<%=webRoot%>';
	</script>

	<style>
		.x-grid3-cell-text-visible .x-grid3-cell-inner{overflow:visible;padding:3px 3px 3px 5px;white-space:normal;}
	</style>

    <script type="text/javascript">
	function showLogType(value, metaData, record, rowIndex, colIndex, store) {
		if(value == 'AG') {
			metaData.attr = 'style="color:#FF9900;"';
		} else if (value == 'KeyPress') {
			metaData.attr = 'style="color:#9933CC;"';
		} else if (value == 'MENU') {
			metaData.attr = 'style="color:#0000FF;"';
		} else if (value == 'APP') {
			metaData.attr = 'style="color:#C0C0C0;"';
		} else if (value == 'CTI') {
			metaData.attr = 'style="color:#00CCFF;"';
		} else if (value == 'FAX') {
			metaData.attr = 'style="color:#556B2F;"';
		}
		return value;
	}

	function showLogLevel(value, metaData, record, rowIndex, colIndex, store) {
		if(value == 'FAILED') {
			metaData.attr = 'style="color:#FF6600;"';
		} else if (value == 'ERROR') {
			metaData.attr = 'style="color:#FF0000;"';
		} else {
			metaData.attr = 'style="color:#C0C0C0;"';
		}
		return value;
	}

	function showLog(value, metaData, record, rowIndex, colIndex, store) {
		if(record.get('type') == 'Failed') {
			metaData.attr = 'style="color:#FF6600;"';
		} else if (record.get('type') == 'Error') {
			metaData.attr = 'style="color:#FF0000;"';
		}
		return value;
	}

	function showXml(xml) {
		var rec = grid.getSelectionModel().getSelected();
		xmlwin.show();
		
		var xml = style_html(rec.get('XML'), 4, '\t', 80);

		xml = xml.replace(/\</g, '&lt;');
		xml = xml.replace(/\>/g, '&gt;');
		xml = xml.replace(/\t/g, '&nbsp;&nbsp;&nbsp;&nbsp;');
		xml = xml.replace(/\n/g, '<br>');

		Ext.getDom('divXml').innerHTML = xml;
	}

	var pagesize = 50;
	var xmlwin;
	
	var cookiePageSize = getCookie('wilcom.logserver.pagesize');
	if(cookiePageSize) {
		pagesize = parseInt(cookiePageSize);
	}

	Ext.onReady(function(){
		
		Ext.QuickTips.init();

		var fields = [
			{name: 'NO'},
			{name: 'LOGTIME'},
			{name: 'CHANNEL'},
			{name: 'SERVER'},
			{name: 'LEVEL'},
			{name: 'TYPE'},
			{name: 'CONTENT'},
			{name: 'XML'}
		];

		var store = new Ext.data.JsonStore({
			root: 'data',
			totalProperty: 'total',
			remoteSort: false,

			fields: fields,
			
			proxy: new Ext.data.HttpProxy({
				url: window.webRoot + 'LogServer/Call/' + encodeURL('<%= server %>') + '/' + encodeURL('<%= channel %>') + '/' + encodeURL('<%= time %>') 
			})

		});
    
		store.setDefaultSort('NO', 'asc');

		store.on('beforeload', function(store, opts) {
		});

		grid = new Ext.grid.GridPanel({
            region: 'center',
			store: store,
			border: false,
			columns: [
				{
					header   : '行号', 
					width    : .05, 
					sortable : true, 
					dataIndex: 'NO'
				},
				{
					header   : '时间', 
					width    : .15, 
					sortable : true, 
					dataIndex: 'LOGTIME'
				},
				{
					header   : '级别', 
					width    : .05, 
					sortable : true, 
					renderer : showLogLevel,
					dataIndex: 'LEVEL'
				},
				{
					header   : '类型', 
					width    : .05, 
					sortable : true, 
					renderer : showLogType,
					dataIndex: 'TYPE'
				},
				{
					header   : '内容', 
					width    : .7, 
					sortable : true, 
					renderer : showLog,
					dataIndex: 'CONTENT'
				}
			],
			stripeRows: true,
			bodyStyle:'width:100%',
			autoWidth:true,
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
		
		grid.store.on('load', function() {
			grid.el.select("table[class=x-grid3-row-table]").each(function(x) {
				x.addClass('x-grid3-cell-text-visible');
			});
			var size = grid.getBottomToolbar().pageSize;
			setCookie("wilcom.logserver.pagesize",size, 240);
		});

        var viewport = new Ext.Viewport({
            layout: 'border',
			autoHeight: true,
			border: false,
            items: [grid]
		});	

		store.load({params:{start:0, limit:pagesize}});
	
		xmlwin = new Ext.Window({
			layout:'fit',
			width: 500,
			height:480,
			closeAction:'hide',
			modal: true,
			plain: true,
			title: "查看报文",
			iconCls: "addbtn",
			items: [
				new Ext.Panel({
					width: 500,
					autoScroll: true,
					html: '<div id=divXml></div>'
				})
			]
		});
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
