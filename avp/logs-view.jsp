<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
	response.setHeader("Pragma","No-cache");
	response.setHeader("Cache-Control","no-cache");
	response.setHeader("Expires","0");

	request.setCharacterEncoding("UTF-8");

	String file = request.getParameter("file");

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

    <script type="text/javascript" src="../js/func.js"></script>
	<script >
		var webRoot = '<%=webRoot%>';
	</script>

	<style>
		.x-grid3-cell-text-visible .x-grid3-cell-inner{overflow:visible;padding:3px 3px 3px 5px;white-space:normal;}
	</style>

    <script type="text/javascript">
	function showLogType(value, metaData, record, rowIndex, colIndex, store) {
		if(value == 'Failed') {
			metaData.attr = 'style="color:#FF6600;"';
		} else if (value == 'Error') {
			metaData.attr = 'style="color:#FF0000;"';
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

	var pagesize = 50;

	Ext.onReady(function(){
		
		Ext.QuickTips.init();

		var fields = [
			{name: 'no'},
			{name: 'logtime'},
			{name: 'appno'},
			{name: 'type'},
			{name: 'log'}
		];

		var store = new Ext.data.JsonStore({
			root: 'data',
			totalProperty: 'total',
			remoteSort: false,

			fields: fields,
			
			proxy: new Ext.data.HttpProxy({
				url: window.webRoot + 'Log/' + encodeURL('<%= file %>')
			})

		});
    
		store.setDefaultSort('no', 'asc');

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
					dataIndex: 'no'
				},
				{
					header   : '时间', 
					width    : .15, 
					sortable : true, 
					dataIndex: 'logtime'
				},
				{
					header   : '类型', 
					width    : .1, 
					sortable : true, 
					renderer : showLogType,
					dataIndex: 'type'
				},
				{
					header   : '内容', 
					width    : .7, 
					sortable : true, 
					renderer : showLog,
					dataIndex: 'log'
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
		});

        var viewport = new Ext.Viewport({
            layout: 'border',
			autoHeight: true,
			border: false,
            items: [grid]
		});	

		store.load({params:{start:0, limit:pagesize}});

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
