<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
	response.setHeader("Pragma","No-cache");
	response.setHeader("Cache-Control","no-cache");
	response.setHeader("Expires","0");

	request.setCharacterEncoding("UTF-8");	

	String taskNo = request.getParameter("taskNo") == null? "" : request.getParameter("taskNo");

	String logId = request.getParameter("logId") == null? "" : request.getParameter("logId");
	
	String webRoot = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<html> 
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>手动质检抽样任务质检员统计</title>
 
    <link rel="stylesheet" type="text/css" href="../css/ext-all-notheme.css" />
    <link rel="stylesheet" type="text/css" href="../css/xtheme-gray.css" />

    <link rel="stylesheet" type="text/css" href="../css/icon.css" />
    <link rel="stylesheet" type="text/css" href="../css/common.css" />
	<script >
		var webRoot = '<%=webRoot%>';
	</script>
 
    <script type="text/javascript" src="../js/ext-base-debug.js"></script>
    <script type="text/javascript" src="../js/ext-all-debug.js"></script>
    <script type="text/javascript" src="../js/ext-lang-zh_CN.js"></script>
    <script type="text/javascript" src="../js/ext-ui-combo-pagesize.js"></script>
    <script type="text/javascript" src="../ux/ColumnHeaderGroup.js"></script>

	<script type="text/javascript" src="../js/func.js"></script>

	<script type="text/javascript">
	var curId = 0;
	var pagesize = 500;
	var grid;
	
	//任务编号
	var taskNo = '<%=taskNo%>';
	//任务执行流水号
	var logId = '<%=logId%>';

	var fields = [
				   {name: 'qaUserId'},
				   {name: 'qaUserName'},
				   {name: 'qaDeptId'},
				   {name: 'qaDeptName'},
				   {name: 'total'},
				   {name: 'idleCount'},
				   {name: 'completedCount'},
				   {name: 'updatedCount'},
				   {name: 'checkedCount'},
				   {name: 'assignedCount'},
				   {name: 'appealedCount'},
				   {name: 'finishedCount'},
				   {name: 'unfinishedCount'},
				   {name: 'assignedCallTime'},
				   {name: 'finishedCallTime'},
				   {name: 'caseTotal'},
				   {name: 'caseCount1'},
				   {name: 'caseCount2'},
				   {name: 'caseCount3'},
				   {name: 'caseCheckedCount1'},
				   {name: 'caseCheckedCount2'},
				   {name: 'caseCheckedCount3'},
				   {name: 'completeRate'}
				];


	function showCompleteRate(v, p, rec, rowIndex) {
		return v + '%';
	}

	function showUserCount(v, p, rec, rowIndex) {
		if(v > 0) {
			return '<a href=# onclick=\'doViewUserStatus("' + rec.get('no') + '","' + rec.get('executeLogId') + ')\'>' + v + '</a>';
		} else {
			return v;
		}
	}

	function showTotal(v, p, rec, rowIndex) {
		if(v > 0) {
			return '<a href=# onclick=\'doViewDetail("' + rec.get('no') + '","' + rec.get('executeLogId') + '","Total")\'>' + v + '</a>';
		} else {
			return v;
		}
	}

	function showComplete(v, p, rec, rowIndex) {
		if(v > 0) {
			return '<a href=# onclick=\'doViewDetail("' + rec.get('no') + '","' + rec.get('executeLogId') + '", "Complete")\'>' + v + '</a>';
		} else {
			return v;
		}
	}

	function showUncomplete(v, p, rec, rowIndex) {
		if(v > 0) {
			return '<a href=# onclick=\'doViewDetail("' + rec.get('no') + '","' + rec.get('executeLogId') + '", "Uncomplete")\'>' + v + '</a>';
		} else {
			return v;
		}
	}

	function doViewDetail(taskNo, logId, status) {
		parent.tabs.add({
			title: '明细记录(' + taskNo + ')',
			iconCls: 'commentsbtn',
			margins:'0 0 0 0',
			autoScroll:true,
			autoWidth:true,
			closable:true,
			html:'<iframe src="assign-task-detail-list.jsp?taskNo=' + taskNo + '&logId=' + logId + '&status=' + status + '" border=0 width="100%" height="100%" frameborder="no" scrolling="auto"></iframe>'
		}).show();
	}

	Ext.onReady(function(){
		var store = new Ext.data.JsonStore({
			root: 'data',
			totalProperty: 'total',
			idProperty: 'id',
			remoteSort: true,

			fields: fields,
			
			proxy: new Ext.data.HttpProxy({
				url: window.webRoot + 'Report/QARecord/UserStat'
			})
		});

		var sm = new Ext.grid.CheckboxSelectionModel();

		/** Start 汇总标题 */
		var groupColsObj =  [
			{header: '&nbsp;', colspan: 1, align: 'center'},
			{header: '质检员信息', colspan: 2, align: 'center'},
			{header: '评分统计', colspan: 5, align: 'center'},
			{header: '典型案例统计', colspan: 4, align: 'center'}
		]

		/** End 汇总标题 */

		grid = new Ext.grid.GridPanel({
            region: 'center',
			store: store,
			border: false,
			plugins: new Ext.ux.grid.ColumnHeaderGroup({
					rows: [groupColsObj]
			}),
			columns: [
				new Ext.grid.RowNumberer(), 
				{
					header   : '质检员', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'qaUserName'
				},
				{
					header   : '质检组', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'qaDeptName'
				},
				{
					header   : '分配数量', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'total'
				},
				{
					header   : '已评分', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'finishedCount'
				},
				{
					header   : '未评分', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'unfinishedCount'
				},
				{
					header   : '达成率', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'completeRate',
					renderer: showCompleteRate
				},
				{
					header   : '已监听秒数', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'finishedCallTime'
				},
				{
					header   : '优秀案例提交数', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'caseCount1'
				},
				{
					header   : '合格案例提交数', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'caseCount2'
				},
				{
					header   : '不合格案例提交数', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'caseCount3'
				},
				{
					header   : '总提交数', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'caseTotal'
				}
			],
			stripeRows: true,
			height: 600,
			width: '100%',
			viewConfig: {forceFit:true}, 
			loadMask: true
		});

		store.on('beforeload', function(loader, node) {
			//任务编号
			loader.baseParams.taskNo = taskNo + '-' + logId;
		});

		store.on('load', function(obj, node) {
			var stat = new Array();
			//计算总计
			var value;
			obj.each(function(rec) {
				for(key in rec.data) {
					value = rec.data[key];
					if(IsNum(value)) {
						if(!stat[key]) {
							stat[key] = 0;
						}
						stat[key] += value;
					}
				}
			});
			
			var rate = stat['total'] && stat['total'] > 0 ? 100.00 * stat['finishedCount'] / stat['total'] : 0;

			var p = new Ext.data.Record({  
				qaUserName: '<b><font color=\'green\'>总计:</font></b>',
				qaDeptName: '&nbsp;',
				total: '<b>' + (stat['total'] ? stat['total'] : '0') + '</b>',
				finishedCount: '<b>' + (stat['finishedCount'] ? stat['finishedCount'] : '0') + '</b>',
				unfinishedCount: '<b>' + (stat['unfinishedCount'] ? stat['unfinishedCount'] : '0') + '</b>',
				finishedCallTime: '<b>' + (stat['finishedCallTime'] ? stat['finishedCallTime'] : '0') + '</b>',
				caseCount1: '<b>' + (stat['caseCount1'] ? stat['caseCount1'] : '0') + '</b>',
				caseCount2: '<b>' + (stat['caseCount2'] ? stat['caseCount2'] : '0') + '</b>',
				caseCount3: '<b>' + (stat['caseCount3'] ? stat['caseCount3'] : '0') + '</b>',
				caseTotal: '<b>' + (stat['caseTotal'] ? stat['caseTotal'] : '0') + '</b>',
				completeRate: '<b>' + rate.toFixed(2) + '</b>'
			});
			
			var n = obj.getCount();
			obj.insert(n, p);
			obj.commitChanges();
			grid.getView().getRow(n).style.backgroundColor = '#DCDCDC';
		});
		
		store.load({params:{start:0, limit:pagesize}});

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
	<div id="adduser-win" class="x-hidden"></div>
</body>
</html>
