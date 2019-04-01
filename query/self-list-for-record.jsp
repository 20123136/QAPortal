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
    <title>我的录音(录音查询Only)</title>
 
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
 
     <script type="text/javascript">

     function findVariable(window, variable){
 		if(window.parent[variable]){
 			return window.parent[variable];
 		}
 		if(window.parent == window){
 			return;
 		}
 		return findVariable(window.parent, variable);
 	}
 	
 	var userInfo;
 	try{
 		userInfo = findVariable(window,'userInfo');
 	}catch(e){
 		
 	}
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

	</script>
 
    <script type="text/javascript" src="../js/ext-base.js"></script>
    <script type="text/javascript" src="../js/ext-all.js"></script>
    <script type="text/javascript" src="../js/ext-lang-zh_CN.js"></script>
	<script type="text/javascript" src="../js/ext-ui-combo-pagesize.js"></script>
    <script type="text/javascript" src="../ux/LockingGridView.js"></script>
    <script type="text/javascript" src="../js/app/common/Grid.js"></script>
    <script type="text/javascript" src="../js/app/common/Window.js"></script>
    <script type="text/javascript" src="../js/app/common/ColmunField.js"></script>
    <script type="text/javascript" src="../ux/DateTimeField.js"></script>
    <script type="text/javascript" src="../js/app/common/DateTime.js"></script>
    <script type="text/javascript" src="../js/app/rec/BeginTimeField.js"></script>
    <script type="text/javascript" src="../js/app/rec/EndTimeField.js"></script>
    <script type="text/javascript" src="../js/app/common/TextField.js"></script>
	<script type="text/javascript" src="../js/colmun/Record_Query_Only.js"></script>
	<script >
		var webRoot = '<%=webRoot%>';
	</script>
    <script type="text/javascript">

	Ext.Ajax.timeout = 900000;

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
	var reportname = '';
	//表明
	var tablename = '';
	//数据源名称
	var ds = '';
	//每页显示记录数
	var pagesize = parseInt('<%=pageSize%>');


	var Conditions = new Array();
	
	function getRecordRowClass(rec, idx, params, store) {
		if(rec.get('played') == 1) {
			return 'x-grid-record-played';
		}
	}

	</script>
    <script type="text/javascript" src="../js/app/rec/RecordQueryOnly.js"></script>
    <script type="text/javascript">
	Ext.onReady(function(){

		/** 查询 Start */
		var panel_query = new Ext.Panel({
            layout: 'border',
			region: 'center', 
			autoScroll:false,
			iconCls: 'searchbtn',
			border: false,
			tbar: [
				'-',
				'开始时间:&nbsp;&nbsp;',
				new Ext.app.rec.BeginTimeField({
					id: 'qryBeginTime',
					name: 'beginTime',
					listeners: 
						{'keypress': function(obj, e) {
								if (e.getKey() == e.ENTER) { 
									Ext.getCmp('btnSearch').fireEvent('click');   
								}   
							}
						}
				}),
				'-',
				'结束时间:&nbsp;&nbsp;',
				new Ext.app.rec.EndTimeField({
					id: 'qryEndTime',
					name: 'endTime',
					listeners: 
						{'keypress': function(obj, e) {
								if (e.getKey() == e.ENTER) { 
									Ext.getCmp('btnSearch').fireEvent('click');   
								}   
							}
						}
				}),
				'-',
				'主叫:&nbsp;&nbsp;',
				new Ext.app.common.TextField({
					id: 'qryAni',
					width: 120,
					fieldLabel: '主叫',
					name: 'ani'
				}),
				'-',
				'被叫:&nbsp;&nbsp;',
				new Ext.app.common.TextField({
					id: 'qryDnis',
					width: 120,
					fieldLabel: '被叫',
					name: 'dnis'
				}),
				'-',
				new Ext.Toolbar.Button({
					id: 'btnSearch',
					iconCls: 'searchbtn',
					text: '查询',
					listeners: 
						{'click': function(obj, e) {
								grid.getStore().removeAll();
								grid.getStore().load({params:{start:0, limit:pagesize}});
							}
						}
				}),
				'-',
				new Ext.Toolbar.Button({
					iconCls: 'gridbtn',
					text: '显示全部',
					handler: function() {
						Ext.getCmp('qryAni').setValue('');
						Ext.getCmp('qryDnis').setValue('');
						grid.getStore().load({params:{start:0, limit:pagesize}});
					}
				}),
				'-'
			],
			items: grid
		});
		/** 查询 End */
		
		grid.getStore().on('beforeload', function(loader, node) {
			//座席Id（当前登录用户）
			loader.baseParams.agentId = userInfo.userNo;
			//开始时间
			loader.baseParams.beginTime = Ext.getCmp('qryBeginTime').getRawValue();
			//结束时间
			loader.baseParams.endTime = Ext.getCmp('qryEndTime').getRawValue();
			//主叫号码
			loader.baseParams.ani = Ext.getCmp('qryAni').getValue();
			//被叫号码
			loader.baseParams.dnis = Ext.getCmp('qryDnis').getValue();
		});
		
		grid.getStore().load();

		var viewport = new Ext.Viewport({
            layout: 'border',
			autoHeight: true,
			border: false,
            items: [panel_query]
		});	
	});
	</script>

</head>
<body>
<div id="favorite-win" class="x-hidden"></div>
</body>
</html>
