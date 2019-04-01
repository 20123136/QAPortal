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
    <title>质检任务明细</title>
 
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

<%
	if(Session.doAccess(request.getSession().getId(), "FUNC", "REC_DOWNLOAD")) {
%>
	var PRIVILEGE_REC_DOWNLOAD = true;
<%
	} else {
%>
	var PRIVILEGE_REC_DOWNLOAD = false;
<%
	}
%>

<%
	if(Session.doAccess(request.getSession().getId(), "FUNC", "QA_GRADE")) {
%>
	var PRIVILEGE_QA_GRADE = true;
<%
	} else {
%>
	var PRIVILEGE_QA_GRADE = false;
<%
	}
%>

<%
	if(Session.doAccess(request.getSession().getId(), "FUNC", "QA_CHECK")) {
%>
	var PRIVILEGE_QA_CHECK = true;
<%
	} else {
%>
	var PRIVILEGE_QA_CHECK = false;
<%
	}
%>

<%
	if(Session.doAccess(request.getSession().getId(), "FUNC", "QA_VIEW_DETAIL")) {
%>
	var PRIVILEGE_QA_VIEW_DETAIL = true;
<%
	} else {
%>
	var PRIVILEGE_QA_VIEW_DETAIL = false;
<%
	}
%>

<%
	if(Session.doAccess(request.getSession().getId(), "FUNC", "QA_CASE_SUBMIT")) {
%>
	var PRIVILEGE_CASE_SUBMIT = true;
<%
	} else {
%>
	var PRIVILEGE_CASE_SUBMIT = false;
<%
	}
%>
<%
	if(Session.doAccess(request.getSession().getId(), "FUNC", "QA_CASE_CHECK")) {
%>
	var PRIVILEGE_CASE_CHECK = true;
<%
	} else {
%>
	var PRIVILEGE_CASE_CHECK = false;
<%
	}
%>

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
	var status = '<%=status%>';
	//每页显示记录数
	var pagesize = parseInt('<%=pageSize%>');

	var Conditions = new Array();
	
	var qaStatus;

	function setStatusSelected() {
		var obj = Ext.getCmp('btnStatus');
		var value = '';

		var level1Selected = 0;
		Ext.each(obj.menu.items.items, function(obj2){
			var level2Selected = 0;
			Ext.each(obj2.menu.items.items, function(item){
				value = item.value;
				if(typeof(qaStatus) == 'string' && (qaStatus == value || qaStatus == '')) {
					item.setChecked(true, true);
					level2Selected++;
				} else if (typeof(qaStatus) == 'object') {
					var isSelected = false;
					Ext.each(qaStatus, function(str) {
						if(str == value) {
							isSelected = true;
						}
					});
					if(isSelected) {
						item.setChecked(true, true);
						level2Selected++;
					}
				}
			});
			if(level2Selected == obj2.menu.items.items.length) {
				obj2.setChecked(true, true);
				level1Selected++;
			}
		});

		if(level1Selected == obj.menu.items.items.length) {
			obj.setIconClass('greenbtn');
		} else if(level1Selected > 0) {
			obj.setIconClass('bluebtn');
		} else {
			obj.setIconClass('blackbtn');
		}
	}

	//检查当前按钮选择状态
	function getStatusSelected() {
		var statusSelected = new Array();
		var obj = Ext.getCmp('btnStatus');
		
		var allSelected = true;
		var totalSelected = 0;
		Ext.each(obj.menu.items.items, function(obj2){
			Ext.each(obj2.menu.items.items, function(item){
				if(item.checked){
					statusSelected.push(item.value);
					totalSelected++;
				} else {
					allSelected = false;
				}
			});
		});

		if(allSelected) {
			obj.setIconClass('greenbtn');
		} else if(totalSelected > 0) {
			obj.setIconClass('bluebtn');
		} else {
			statusSelected.push("-1");
			obj.setIconClass('blackbtn');
		}

		return statusSelected;
	}

	function clickLevel1(obj, checked) {
		Ext.each(obj.menu.items.items, function(item){
			item.setChecked(checked, true);
		});
		qaStatus = getStatusSelected();
		grid.getStore().load();
	}

	function clickLevel2(obj, checked) {
		var allchecked = true;
		Ext.each(obj.ownerCt.items.items, function(item){
			if(!item.checked) {
				allchecked = false;
			}
		});
		obj.ownerCt.ownerCt.setChecked(allchecked, true);
		qaStatus = getStatusSelected();
		grid.getStore().load();
	}

	</script>
	<script type="text/javascript" src="../js/colmun/qa_task_detail.js"></script>
    <script type="text/javascript" src="../js/app/qa/QARecordQuery.js"></script>
    <script type="text/javascript">
	Ext.onReady(function(){

		if(status == 'Total') {
			qaStatus = '';
		} else if(status == 'Complete') {
			qaStatus = new Array();
			qaStatus.push('COMPLETED');
			qaStatus.push('UPDATED');
			qaStatus.push('CHECKED');
			qaStatus.push('APPEALED');
		} else if(status == 'Uncomplete') {
			qaStatus = 'ASSIGNED';
		} else {
			qaStatus = '';
		}

		grid.getStore().on('beforeload', function(loader, node) {
			loader.removeAll(false);
			//质检任务编号
			if(logId) {
				loader.baseParams.taskNo = taskNo + '-' + logId;
			} else {
				loader.baseParams.taskNo = taskNo;
			}
			//质检状态
			loader.baseParams.qaStatus = qaStatus;
		});
		
		grid.on('render', function(obj) {
			obj.getTopToolbar().add(
				new Ext.SplitButton({
					id: 'btnStatus',
					text: '质检状态',
					iconCls: 'greenbtn',
					menu: [
						{
							xtype: 'menucheckitem',
							text: '未质检',
							name: 'uncompleted',
							hideOnClick: false,
							listeners: {
								'checkchange' : function(obj, checked) {
									clickLevel1(obj, checked);
								}
							},
							menu: [
								{
									xtype: 'menucheckitem',
									value: 'IDLE',
									text: '未分配',
									hideOnClick: false,
									listeners: {
										'checkchange' : function(obj, checked) {
											clickLevel2(obj, checked);
										}
									}
								},
								{
									xtype: 'menucheckitem',
									value: 'ASSIGNED',
									text: '已分配',
									hideOnClick: false,
									listeners: {
										'checkchange' : function(obj, checked) {
											clickLevel2(obj, checked);
										}
									}
								}
							]
						},
						{
							xtype: 'menucheckitem',
							text: '已质检',
							hideOnClick: false,
							listeners: {
								'checkchange' : function(obj, checked) {
									clickLevel1(obj, checked);
								}
							},
							menu: [
								{
									xtype: 'menucheckitem',
									value: 'COMPLETED',
									hideOnClick: false,
									text: '已质检',
									listeners: {
										'checkchange' : function(obj, checked) {
											clickLevel2(obj, checked);
										}
									}
								},
								{
									xtype: 'menucheckitem',
									value: 'UPDATED',
									hideOnClick: false,
									text: '已更改',
									listeners: {
										'checkchange' : function(obj, checked) {
											clickLevel2(obj, checked);
										}
									}
								},
								{
									xtype: 'menucheckitem',
									value: 'APPEALED',
									hideOnClick: false,
									text: '申诉中',
									listeners: {
										'checkchange' : function(obj, checked) {
											clickLevel2(obj, checked);
										}
									}
								},
								{
									xtype: 'menucheckitem',
									value: 'CHECKED',
									hideOnClick: false,
									text: '已审核',
									listeners: {
										'checkchange' : function(obj, checked) {
											clickLevel2(obj, checked);
										}
									}
								}
							]
						}
					]
				})
			);
			obj.getTopToolbar().addSeparator();

			setStatusSelected();
		});

		grid.getStore().load();

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
