<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.wilcom.qa.tools.Session"%>
<%
	response.setHeader("Pragma","No-cache");
	response.setHeader("Cache-Control","no-cache");
	response.setHeader("Expires","0");

	request.setCharacterEncoding("UTF-8");	
	
	String rpt = request.getParameter("rpt");

	String reportname = request.getParameter("reportname") == null? "" : request.getParameter("reportname");
	String tablename = request.getParameter("tablename") == null? "" : request.getParameter("tablename");
 	String ds = request.getParameter("ds") == null? "" : request.getParameter("ds");

	String refresh = request.getParameter("refresh") == null? "" : request.getParameter("refresh");

	String webRoot = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";

	String pageSize = "25";
%>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>录音查询</title>
 
    <link rel="stylesheet" type="text/css" href="../css/ext-all-notheme.css" />
    <link rel="stylesheet" type="text/css" href="../css/xtheme-gray.css" />
    <link rel="stylesheet" type="text/css" href="../ux/css/LockingGridView.css" />

    <link rel="stylesheet" type="text/css" href="../css/common.css" />
    <link rel="stylesheet" type="text/css" href="../css/icon.css" />

    <style type=text/css>
        /* style rows on mouseover */
        .x-grid3-row-over .x-grid3-cell-inner {
            font-weight: bold;
        }

		.x-grid-record-played{
			background: #d6ffd2;
		}
    </style>
 
    <script type="text/javascript">
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

	</script>

    <script type="text/javascript" src="../js/ext-base.js"></script>
    <script type="text/javascript" src="../js/ext-all.js"></script>
    <script type="text/javascript" src="../js/ext-lang-zh_CN.js"></script>
	<script type="text/javascript" src="../js/ext-ui-combo-pagesize.js"></script>
    <script type="text/javascript" src="../ux/LockingGridView.js"></script>
    <script type="text/javascript" src="../js/app/common/Grid.js"></script>
    <script type="text/javascript" src="../js/app/common/Window.js"></script>
    <script type="text/javascript" src="../js/app/qa/QASelectorGrid.js"></script>
    <script type="text/javascript" src="../js/app/qa/QASelectorWindow.js"></script>
	<script >
		var webRoot = '<%=webRoot%>';
	</script>
    <script type="text/javascript">

	Ext.Ajax.timeout = 900000;

	var searchTab = parent.frames['searchTab'];

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

	//报表名称
	var reportname = '<%=reportname%>';
	//表明
	var tablename = '<%=tablename%>';
	//数据源名称
	var ds = '<%=ds%>';
	//每页显示记录数
	var pagesize = parseInt('<%=pageSize%>');


	var Conditions = cacheCondition();
	var Colmuns = searchTab.Colmuns;
	
	function getRecordRowClass(rec, idx, params, store) {
		if(rec.get('played') == 1) {
			return 'x-grid-record-played';
		}
	}
	</script>
    <script type="text/javascript" src="../js/app/rec/RecordQuery.js"></script>
    <script type="text/javascript">
	Ext.onReady(function(){
		
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
