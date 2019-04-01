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
    <title>会话管理</title>
 
    <link rel="stylesheet" type="text/css" href="../css/ext-all-notheme.css" />
    <link rel="stylesheet" type="text/css" href="../css/xtheme-gray.css" />
 
    <style type=text/css>
        /* style rows on mouseover */
        .x-grid3-row-over .x-grid3-cell-inner {
            font-weight: bold;
        }

        .titletext {
            font-weight: bold;
        }
		.searchbtn {
			background-image:url("../images/default/dd/qry.gif");
		}
		.gridbtn {
			background-image:url("../images/icons/fam/comments.png");
		}

    </style>
	<script >
		var webRoot = '<%=webRoot%>';
	</script>
 
    <script type="text/javascript" src="../js/ext-base.js"></script>
    <script type="text/javascript" src="../js/ext-all.js"></script>
    <script type="text/javascript" src="../js/ext-lang-zh_CN.js"></script>
    <script type="text/javascript">
	var pagesize = 25;
	var grid;


	var fields = [
				   {name: 'id'},
				   {name: 'userName'},
				   {name: 'sid'},
				   {name: 'roleIds'},
				   {name: 'roleNames'},
				   {name: 'deptName'},
				   {name: 'beginTime'},
				   {name: 'beginTimeStr'},
				   {name: 'endTime'},
				   {name: 'endTimeStr'},
				   {name: 'lastActionTime'},
				   {name: 'lastActionTimeStr'},
				   {name: 'status'}
				];

	Ext.onReady(function(){
		var store = new Ext.data.JsonStore({
			root: 'data',
			totalProperty: 'total',
			remoteSort: false,

			fields: fields,
			
			proxy: new Ext.data.HttpProxy({
				url: window.webRoot + 'Sessions/Active'
			})

		});
    
		store.setDefaultSort('beginTime', 'asc');

		grid = new Ext.grid.GridPanel({
            region: 'center',
			title: '会话列表',
			iconCls: 'gridbtn',
			store: store,
			border: false,
			columns: [
				new Ext.grid.RowNumberer(), 
				{
					header   : '会话ID', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'sid'
				},
				{
					header   : '开始时间', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'beginTimeStr'
				},
				{
					header   : '结束时间', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'endTimeStr'
				},
				{
					header   : '最后访问时间', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'lastActionTimeStr'
				},
				{
					header   : '姓名', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'userName'
				},
				{
					header   : '角色', 
					width    : .3, 
					sortable : true, 
					dataIndex: 'roleNames'
				},
				{
					header   : '状态', 
					width    : .1, 
					sortable : true, 
					dataIndex: 'status'
				}
			],
			stripeRows: true,
			bodyStyle:'width:100%',
			autoWidth:true,
			viewConfig: {forceFit:true}, 
			loadMask: true,

			bbar: new Ext.PagingToolbar({
				pageSize: pagesize,
				store: store,
				displayInfo: true,
				displayMsg: '当前显示第 <font color="blue">{0}</font> 到 <font color="blue">{1}</font> 条记录， 共 <font color="blue">{2}</font> 条记录',
				emptyMsg: "无记录"
			})
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
</body>
</html>
