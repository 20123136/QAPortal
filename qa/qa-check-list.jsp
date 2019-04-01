<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.wilcom.qa.tools.Session"%>
<%
	response.setHeader("Pragma","No-cache");
	response.setHeader("Cache-Control","no-cache");
	response.setHeader("Expires","0");

	request.setCharacterEncoding("UTF-8");	
	
	String webRoot = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";

	String pageSize = "25";
%>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>申诉审核</title>
 
    <link rel="stylesheet" type="text/css" href="../css/ext-all-notheme.css" />
    <link rel="stylesheet" type="text/css" href="../css/xtheme-gray.css" />

    <link rel="stylesheet" type="text/css" href="../css/common.css" />
    <link rel="stylesheet" type="text/css" href="../css/icon.css" />
    <link rel="stylesheet" type="text/css" href="../ux/css/DateTimePicker.css" />
    <link rel="stylesheet" type="text/css" href="../ux/css/LockingGridView.css" />

 
    <script type="text/javascript" src="../js/ext-base.js"></script>
    <script type="text/javascript" src="../js/ext-all.js"></script>
    <script type="text/javascript" src="../js/ext-lang-zh_CN.js"></script>
	<script type="text/javascript" src="../js/ext-ui-combo-pagesize.js"></script>
	<script type="text/javascript" src="../js/func.js"></script>
    <script type="text/javascript" src="../ux/LockingGridView.js"></script>
    <script type="text/javascript" src="../js/app/common/Grid.js"></script>
    <script type="text/javascript" src="../js/app/common/Window.js"></script>
    <script type="text/javascript" src="../js/app/common/ColmunField.js"></script>
    <script type="text/javascript" src="../js/app/common/Radio.js"></script>
    <script type="text/javascript" src="../js/app/qa/QASelectorGrid.js"></script>
    <script type="text/javascript" src="../js/app/qa/QASelectorWindow.js"></script>
    <script type="text/javascript" src="../ux/DateTimeField.js"></script>
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

	function cacheCondition() {
		var conds = new Array();

		for(var i=0; i<searchTab.ConditionFields.length; i++) {
			var key = searchTab.ConditionFields[i].getKey();
			var val = searchTab.ConditionFields[i].getVal();
			var rawval = searchTab.ConditionFields[i].getRawVal();
			var txt = searchTab.ConditionFields[i].getTxt();
			
			if(key == 'pagesize') {
				pagesize = parseInt(val);
			}

			if(typeof key == 'object') {
				for(var j=0; j<key.length; j++) {
					conds.push({key: key[j], val: val[j], rawval: rawval[j], txt: txt[j]});
				}
			} else {
				conds.push({key: key, val: val, rawval: rawval, txt: txt});
			}

			if(key == 'stat' && val == 'true') {
				needStat = true;
			}
		}

		return conds;
	}
	
	function showAppealReason(v, p, rec, rowIndex, colIndex, store) {
		return '<span style="display:table;width:100%;" title="'+v+'">'+v + '</span>'
	}

	//报表名称
	var reportname = '';
	//表明
	var tablename = '';
	//数据源名称
	var ds = '';
	//每页显示记录数
	var pagesize = parseInt('<%=pageSize%>');

	var Conditions = new Array();

	var qaStatus = 'APPEALED';

	</script>
	<script type="text/javascript" src="../js/colmun/qa_check.js"></script>
    <script type="text/javascript" src="../js/app/qa/QARecordQuery.js"></script>
    <script type="text/javascript">
	Ext.onReady(function(){

		grid.getStore().on('beforeload', function(loader, node) {
			loader.removeAll(false);
			//质检状态（申诉中）
			loader.baseParams.qaStatus = qaStatus;;
		});
		
		grid.getStore().load();

		grid.getTopToolbar().add('&nbsp;');

		grid.getTopToolbar().add(
			new Ext.app.common.Radio({
				name: 'Status',
				boxLabel: '申诉中',
				checked: true,
				listeners:
					{
						'check': function(obj, checked) {
							if(checked) {
								qaStatus = 'APPEALED';
								grid.getStore().load();
							}
						}
					}
			})
		);

		grid.getTopToolbar().add('&nbsp;');

		grid.getTopToolbar().add(
			new Ext.app.common.Radio({
				name: 'Status',
				boxLabel: '已审核',
				listeners:
					{
						'check': function(obj, checked) {
							if(checked) {
								qaStatus = 'CHECKED';
								grid.getStore().load();
							}
						}
					}
			})
		);

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
