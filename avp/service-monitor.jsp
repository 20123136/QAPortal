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
    <title>服务监控</title>
 
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

	function showStatus(value, metaData, record, rowIndex, colIndex, store) {
		if(value == 'Running') {
			metaData.attr = 'style="background-color:#99FF66;"';
		} else {
			metaData.attr = 'style="background-color:#FF6666;"';
		}
		return value;
	}

	function showAlert(value, metaData, record, rowIndex, colIndex, store) {
		if(value > 0) {
			metaData.attr = 'style="background-color:#FF6666;"';
		}
		return value;
	}

	Ext.onReady(function(){
		
		Ext.QuickTips.init();
		
		var reader = new Ext.data.JsonReader({
			root: 'data',
			totalProperty: 'total',
			remoteSort: false,

			fields: [
				   {name: 'name'},
				   {name: 'status'},
				   {name: 'totalAccess'},
				   {name: 'totalError'},
				   {name: 'totalFailed'},
				   {name: 'type'},
				   {name: 'description'},
				   {name: 'lastActionTime'}
			]
		});

		var store = new Ext.data.GroupingStore({
				reader: reader,
				proxy: new Ext.data.HttpProxy({
					url: window.webRoot + 'Services'
				}),
				sortInfo:{field: 'name', direction: "ASC"},
				groupField:'type'
			});

		var grid = new Ext.grid.GridPanel({
            region: 'center',
			store: store,
			columns: [
				{
					header   : '服务名',
					width    : .1,
					sortable : false,
					dataIndex: 'name'
				},
				{
					header   : '类型',
					width    : .2,
					sortable : false,
					hidden	 : true,
					dataIndex: 'type'
				},
				{
					header   : '描述',
					width    : .2,
					sortable : false,
					dataIndex: 'description'
				},
				{
					header   : '状态',
					width    : .2,
					sortable : false,
					dataIndex: 'status',
					renderer : showStatus
				},
				{
					header   : '总访问量',
					width    : .2,
					sortable : false,
					dataIndex: 'totalAccess'
				},
				{
					header   : '异常量',
					width    : .2,
					sortable : false,
					dataIndex: 'totalError',
					renderer : showAlert
				},
				{
					header   : '错误量',
					width    : .2,
					sortable : false,
					dataIndex: 'totalFailed',
					renderer : showAlert
				},
				{
					header   : '最后活动时间',
					width    : .2,
					sortable : false,
					dataIndex: 'lastActionTime'
				}
			],

			view: new Ext.grid.GroupingView({
				forceFit:true,
				groupTextTpl: '{text} ({[values.rs.length]} {[values.rs.length > 1 ? "Items" : "Item"]})'
			}),
			border: false,
			autoWidth: true,
			autoHeight: true,
			collapsible: false
		});

        var viewport = new Ext.Viewport({
            layout: 'border',
			autoHeight: true,
			border: false,
            items: [grid]
		});	

		store.load();
		
		window.setInterval(function() {
				store.reload(store.lastOptions);
			}
		, 3000);

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
