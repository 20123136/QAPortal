<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.wilcom.qa.tools.Session"%>
<%
	response.setHeader("Pragma","No-cache");
	response.setHeader("Cache-Control","no-cache");
	response.setHeader("Expires","0");

	request.setCharacterEncoding("UTF-8");	
	
	String webRoot = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";

	String taskNo = request.getParameter("taskNo") == null? "" : request.getParameter("taskNo");

	String taskName = request.getParameter("taskName") == null? "" : request.getParameter("taskName");

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

	//任务名称
	var taskName = '<%=taskName%>';

	//每页显示记录数
	var pagesize = parseInt('<%=pageSize%>');

	var Conditions = new Array();


	var fields = [
				   {name: 'id'},
				   {name: 'taskId'},
				   {
					   name:'taskName',
					   convert: function(value, record) {
							return taskName;
						}
					   },
				   {
						name : 'beginTime', 
						convert: function(value, record) {
							return record.beginTimeStr;
						}
					},
				   {name: 'beginTimeStr'},
				   {
						name : 'endTime', 
						convert: function(value, record) {
							return record.endTimeStr;
						}
					},
				   {name: 'endTimeStr'},
				   {name: 'endCode'},
				   {
						name : 'endCodeName',
						convert: function(value, record) {
							if(record.status == '0') {
								return "成功";
							} else if(record.status == '1') {
								return "失败";
							}
						}
					},
				   {name: 'endMsg'},
				   {name: 'status'},
				   {
						name : 'statusName',
						convert: function(value, record) {
							if(record.status == '0') {
								return "<font color=green>正常</font>";
							} else if(record.status == '1') {
								return "<font color=gray>异常</font>";
							}
						}
					}
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
				url: window.webRoot + 'OBTask/' + taskNo + '/Detail'
			})
		});
    
		store.setDefaultSort('beginTimeStr', 'asc');
		
		var toolbar = new Ext.Toolbar({
			width: '100%'
		});
		
		/** Start 查看明细详情 */
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnViewDetail',
				text: '名单详情',
				disabled: true,
				iconCls: 'commentbtn',
			//	disabled: true,
				listeners: {
					'click': function(obj, e) {
						var rec = grid.getSelectionModel().getSelected();
						var no=rec.get('id');
                        var name=rec.get('name');
						parent.tabs.add({
							title: '查看名单明细',
							iconCls: 'commentsbtn',
							margins:'0 0 0 0',
							autoScroll:true,
							autoWidth:true,
							closable:true,
							html:'<iframe src="ob-name-detail-list.jsp?No=' + no + '&taskNo=' + taskNo + '" border=0 width="100%" height="100%" frameborder="no" scrolling="auto"></iframe>'
						}).show();
						
					}
				}
			})
		);
		toolbar.addSeparator();
		/** End 查看明细详情 */
		
		var grid = new Ext.grid.GridPanel({
            region: 'center',
			store: store,
			tbar: toolbar,
			border: false,
			columns: [
			      {
			        header :'任务名称',
			        width :.1,
			        sortIndex:true,
			        dataIndex: 'taskName'
			    },  
				{
					header   : '外拨任务ID', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'taskId'
				},
				{
					header   : '任务执行开始时间', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'beginTimeStr'
				},
				{
					header   : '任务最晚执行时间', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'endTimeStr'
				},
				{
					header   : '外拨结果', 
					width    : .1, 
					sortable : true, 
					dataIndex: 'endCodeName'
				},
				{
					header   : '结束意愿说明', 
					width    : .1, 
					sortable : true, 
					dataIndex: 'endMsg'
				},
				{
					header   : '任务执行状态', 
					width    : .1, 
					sortable : true, 
					dataIndex: 'statusName'
				
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
		
		
		/** 列表右键点击菜单 Start */
		var rightClick = new Ext.menu.Menu();
	    	rightClick.add({
			     id: 'menuDetail',
			     text : '名单详情',
			     iconCls : 'commentbtn',
			     handler : function(obj, e) {
				 Ext.getCmp('btnViewDetail').fireEvent('click'); 
				}
		    });
	    	
			grid.addListener('rowcontextmenu', function(client, rowIndex, e) {
				e.preventDefault();
	            rightClick.showAt(e.getXY());
			});
			/** 列表右键点击菜单 End */	
			
			
			grid.on('rowclick', function(grid, rowIndex, e) {
			
				Ext.getCmp('btnViewDetail').setDisabled(false);
				
		});
		

		grid.getStore().on('beforeload', function(loader, node) {
			loader.removeAll(false);
			
		    loader.baseParams.taskNo = taskNo;
			
			//备份结果
			//loader.baseParams.backupResult = backupResult;
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
