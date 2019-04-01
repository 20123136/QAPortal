<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.wilcom.qa.tools.Session"%>
<%
	response.setHeader("Pragma","No-cache");
	response.setHeader("Cache-Control","no-cache");
	response.setHeader("Expires","0");

	request.setCharacterEncoding("UTF-8");	
	
	String webRoot = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";

	String taskNo = request.getParameter("taskNo") == null? "" : request.getParameter("taskNo");

	String logId = request.getParameter("logId") == null? "" : request.getParameter("logId");

	String status = request.getParameter("status") == null? "" : request.getParameter("status");

	String pageSize = "25";
%>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>备份任务明细</title>
 
    <link rel="stylesheet" type="text/css" href="../css/ext-all-notheme.css" />
    <link rel="stylesheet" type="text/css" href="../css/xtheme-gray.css" />

    <link rel="stylesheet" type="text/css" href="../css/common.css" />
    <link rel="stylesheet" type="text/css" href="../css/icon.css" />
    <link rel="stylesheet" type="text/css" href="../ux/css/DateTimePicker.css" />
    <link rel="stylesheet" type="text/css" href="../ux/css/LockingGridView.css" />

    <style type=text/css>
        /* style rows on mouseover */
        .x-grid3-row-over .x-grid3-cell-inner {
            font-weight: bold;
        }

		.x-grid-record-played{
			background: #d6ffd2;
		}
    </style>
 
    <script type="text/javascript" src="../js/ext-base.js"></script>
    <script type="text/javascript" src="../js/ext-all.js"></script>
    <script type="text/javascript" src="../js/ext-lang-zh_CN.js"></script>
	<script type="text/javascript" src="../js/ext-ui-combo-pagesize.js"></script>
    <script type="text/javascript" src="../js/func.js"></script>
    <script type="text/javascript" src="../ux/LockingGridView.js"></script>
    <script type="text/javascript" src="../js/app/common/Grid.js"></script>
    <script type="text/javascript" src="../js/app/common/Window.js"></script>
    <script type="text/javascript" src="../js/app/common/ColmunField.js"></script>
    <script type="text/javascript" src="../js/app/common/Checkbox.js"></script>
    <script type="text/javascript" src="../js/app/qa/QASelectorGrid.js"></script>
    <script type="text/javascript" src="../js/app/qa/QASelectorWindow.js"></script>
    <script type="text/javascript" src="../ux/DateTimeField.js"></script>
    <script type="text/javascript" src="../ux/Clone.js"></script>
    <script type="text/javascript" src="../js/app/common/DateTime.js"></script>
    <script type="text/javascript" src="../js/app/rec/BeginTimeField.js"></script>
    <script type="text/javascript" src="../js/app/rec/EndTimeField.js"></script>
    <script type="text/javascript" src="../js/app/common/TextField.js"></script>
	<script >
		var webRoot = '<%=webRoot%>';
	</script>
    <script type="text/javascript">

	Ext.Ajax.timeout = 900000;

	//报表名称
	var reportname = '';
	//表明
	var tablename = '';
	//数据源名称
	var ds = '';
	//任务编号
	var taskNo = '<%=taskNo%>';
	//任务执行流水号
	var logId = '<%=logId%>';
	//状态
	var backupResult = '<%=status%>';

	//每页显示记录数
	var pagesize = parseInt('<%=pageSize%>');

	var Conditions = new Array();

	function showResult(v, p, rec, rowIndex) {
		if(v == 'Success') {
			return '<font color=green>成功</font>';
		} else if(v == 'Failed') {
			return '<font color=red>失败</font>:' + rec.get('executeResultMessage');
		} else if(v == 'Skipped') {
			return '<font color=gray>忽略</font>';
		} else {
			return v;
		}
	}

	var fields = [
				   {name: 'id'},
				   {name: 'callId'},
				   {name: 'backupTime'},
				   {name: 'fileName'},
				   {name: 'displaySpent'},
				   {name: 'fileSize'},
				   {name: 'executeResult'},
				   {name: 'executeResultMessage'}
				];

	</script>
    <script type="text/javascript">
	Ext.onReady(function(){
		var store = new Ext.data.JsonStore({
			root: 'data',
			totalProperty: 'total',
			idProperty: 'id',
			remoteSort: false,

			fields: fields,
			
			restful: true,
			proxy: new Ext.data.HttpProxy({
				url: window.webRoot + 'QABackup/Task/' + taskNo + '.' + logId + '/Detail'
			})
		});
    
		store.setDefaultSort('backupTime', 'asc');
		
		var grid = new Ext.grid.GridPanel({
            region: 'center',
			store: store,
			border: false,
			columns: [
				{
					header   : '录音编号', 
					width    : .1, 
					sortable : true, 
					dataIndex: 'id'
				},
				{
					header   : '呼叫编号', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'callId'
				},
				{
					header   : '录音时间', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'backupTime'
				},
				{
					header   : '原文件路径', 
					width    : .5, 
					sortable : true, 
					dataIndex: 'fileName'
				},
				{
					header   : '耗时', 
					width    : .1, 
					sortable : true, 
					dataIndex: 'displaySpent'
				},
				{
					header   : '文件大小', 
					width    : .1, 
					sortable : true, 
					dataIndex: 'fileSize'
				},
				{
					header   : '执行结果', 
					width    : .1, 
					sortable : true, 
					dataIndex: 'executeResult',
					renderer : showResult
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

		grid.getStore().on('beforeload', function(loader, node) {
			loader.removeAll(false);
			//备份任务编号
			if(logId) {
				loader.baseParams.taskNo = taskNo + '-' + logId;
			} else {
				loader.baseParams.taskNo = taskNo;
			}
			//备份结果
			loader.baseParams.backupResult = backupResult;
		});
		
		grid.getStore().load({params:{start:0, limit:pagesize}});

		var viewport = new Ext.Viewport({
            layout: 'border',
			autoHeight: true,
			border: false,
            items: [grid]
		});	
	});
	</script>

</head>
<body>
<div id="favorite-win" class="x-hidden"></div>
</body>
</html>
