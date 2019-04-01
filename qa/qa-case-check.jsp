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
    <title>质检案例审核</title>
 
    <link rel="stylesheet" type="text/css" href="../css/ext-all-notheme.css" />
    <link rel="stylesheet" type="text/css" href="../css/xtheme-gray.css" />

    <link rel="stylesheet" type="text/css" href="../css/common.css" />
    <link rel="stylesheet" type="text/css" href="../css/icon.css" />
    <link rel="stylesheet" type="text/css" href="../ux/css/DateTimePicker.css" />

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
    <script type="text/javascript" src="../js/app/common/Grid.js"></script>
    <script type="text/javascript" src="../js/app/common/Window.js"></script>
    <script type="text/javascript" src="../js/app/common/ColmunField.js"></script>
    <script type="text/javascript" src="../ux/DateTimeField.js"></script>
    <script type="text/javascript" src="../js/app/common/DateTime.js"></script>
    <script type="text/javascript" src="../js/app/rec/BeginTimeField.js"></script>
    <script type="text/javascript" src="../js/app/rec/EndTimeField.js"></script>
    <script type="text/javascript" src="../js/app/common/TextField.js"></script>
	<script type="text/javascript" src="../js/colmun/qa_case_record_check.js"></script>
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
	if(Session.doAccess(request.getSession().getId(), "FUNC", "REC_EXPORT")) {
%>
	var PRIVILEGE_REC_EXPORT = true;
<%
	} else {
%>
	var PRIVILEGE_REC_EXPORT = false;
<%
	}
%>

<%
	if(Session.doAccess(request.getSession().getId(), "FUNC", "REC_PLAY")) {
%>
	var PRIVILEGE_REC_PLAY = true;
<%
	} else {
%>
	var PRIVILEGE_REC_PLAY = false;
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
	//每页显示记录数
	var pagesize = parseInt('<%=pageSize%>');


	var Conditions = new Array();

	</script>
    <script type="text/javascript" src="../js/app/qa/QACaseRecordQuery.js"></script>
    <script type="text/javascript">
	Ext.onReady(function(){

		grid.getStore().on('beforeload', function(loader, node) {
			//质检案例状态（只显示已提交及已更改记录）
			loader.baseParams.qaCaseStatus = ['SUBMIT', 'UPDATED'];
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
