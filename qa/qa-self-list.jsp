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
    <title>我的质检列表</title>
 
    <link rel="stylesheet" type="text/css" href="../css/ext-all-notheme.css" />
    <link rel="stylesheet" type="text/css" href="../css/xtheme-gray.css" />

    <link rel="stylesheet" type="text/css" href="../css/common.css" />
    <link rel="stylesheet" type="text/css" href="../css/icon.css" />
    <link rel="stylesheet" type="text/css" href="../ux/css/DateTimePicker.css" />
    <link rel="stylesheet" type="text/css" href="../ux/css/LockingGridView.css" />
    <link rel="stylesheet" type="text/css" href="../ux/css/Spinner.css" />

    <style type=text/css>
        /* style rows on mouseover */
        .x-grid3-row-over .x-grid3-cell-inner {
            font-weight: bold;
        }

		.x-grid-record-played{
			background: #d6ffd2;
		}
    </style>
	<script >
		var webRoot = '<%=webRoot%>';
	</script>
 
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
    <script type="text/javascript" src="../js/app/common/TwinTriggerField.js"></script>
    <script type="text/javascript" src="../js/app/qa/QASelectorGrid.js"></script>
    <script type="text/javascript" src="../js/app/qa/QASelectorWindow.js"></script>
    <script type="text/javascript" src="../ux/Spinner.js"></script>
    <script type="text/javascript" src="../ux/SpinnerField.js"></script>
    <script type="text/javascript" src="../js/app/common/NumberField.js"></script>
    <script type="text/javascript" src="../ux/DateTimeField.js"></script>
    <script type="text/javascript" src="../js/app/ux/DictSelector.js"></script>
    <script type="text/javascript" src="../js/app/ux/DepartmentSelector.js"></script>
    <script type="text/javascript" src="../js/app/common/DateTime.js"></script>
    <script type="text/javascript" src="../js/app/rec/BeginTimeField.js"></script>
    <script type="text/javascript" src="../js/app/rec/EndTimeField.js"></script>
    <script type="text/javascript" src="../js/app/common/TextField.js"></script>
    <script type="text/javascript" src="../js/app/common/TreePanel.js"></script>
    <script type="text/javascript" src="../js/app/rec/DateRangeField.js"></script>
    <script type="text/javascript" src="../js/app/rec/DateRangeTypeField.js"></script>
    <script type="text/javascript" src="../js/app/qa/QADateRangeField.js"></script>
    <script type="text/javascript" src="../js/app/qa/QADateRangeTypeField.js"></script>
    <script type="text/javascript" src="../js/app/mgr/AgentUserSelectorGrid.js"></script>
    <script type="text/javascript" src="../js/app/mgr/AgentUserSelectorWindow.js"></script>
    <script type="text/javascript" src="../js/app/rec/AgentTwinTriggerField.js"></script>
    <script type="text/javascript" src="../js/app/mgr/DepartmentSelectorTreePanel.js"></script>
    <script type="text/javascript" src="../js/app/mgr/DepartmentSelectorWindow.js"></script>
    <script type="text/javascript" src="../js/app/rec/DepartmentTwinTriggerField.js"></script>
    <script type="text/javascript" src="../js/app/rec/CallTimeRangeField.js"></script>
    <script type="text/javascript" src="../js/app/qa/QAStatusSelectorGrid.js"></script>
    <script type="text/javascript" src="../js/app/qa/QAStatusSelectorWindow.js"></script>
    <script type="text/javascript" src="../js/app/qa/QAStatusTwinTriggerField.js"></script>
    <script type="text/javascript" src="../js/app/qa/InspectorSelectorGrid.js"></script>
    <script type="text/javascript" src="../js/app/qa/InspectorSelectorWindow.js"></script>
    <script type="text/javascript" src="../js/app/qa/InspectorTwinTriggerField.js"></script>
    <script type="text/javascript" src="../js/app/qa/QAScoreRangeField.js"></script>
	<script type="text/javascript" src="../js/colmun/qa_self.js"></script>
	<script >
		var webRoot = '<%=webRoot%>';
	</script>
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

	function getParamsArray(Conditions) {
		var params = new Array();

		params['reportname'] = reportname;
		params['tablename'] = tablename;
		params['ds'] = ds;

		for(var i=0; i<Conditions.length; i++) {
			var key = Conditions[i].key;
			var val = Conditions[i].val;
			if(typeof key == 'object') {
				for(var j=0; j<key.length; j++) {
					pushParam(params, key[j], val[j]);
				}
			} else {
				pushParam(params, key, val);
			}
		}

		return params;
	}

	function pushParam(params, key, value) {
		if(params[key]) {
			if(typeof params[key] == 'object') {
				params[key].push(value);
			} else {
				var tmp = params[key];
				params[key] = new Array();
				params[key].push(tmp);
				params[key].push(value);
			}
		} else {
			params[key] = value;
		}
	}

	/* Start 初始数据 */
	//日质检任务
	var datas = new Array();
	var data;
	var d = new Date();
	var s;
	for(var i=0; i<7; i++) {
		data = new Array();
		s = formatDateTime(d.getTime()).substring(0,10);
		if(i == 0) {
			data.push('今天');
			data.push(s);
			data.push(0);
			data.push(0);
			data.push(true);
			data.push('Day');
		} else if (i == 1) {
			data.push('昨天');
			data.push(s);
			data.push(0);
			data.push(0);
			data.push(false);
			data.push('Day');
		} else {
			data.push(s);
			data.push(s);
			data.push(0);
			data.push(0);
			data.push(false);
			data.push('Day');
		}
		datas.push(data);
		d.setTime(d.getTime() - 24*60*60*1000);
	}

	var dayStore = new Ext.data.ArrayStore({
		fields: [{
					name : "name"
				}, {
					name : "value"
				}, {
					name : "completed"
				}, {
					name : "uncompleted"
				}, {
					name : "selected"
				}, {
					name : "type"
				}],
		data: datas
	});

	//指定周
	var datas = new Array();
	var data;
	var d = new Date();
	var s, s1, s2;
	if(d.getDay() > 0) {
		d.setTime(d.getTime() - (d.getDay() - 1)*24*60*60*1000);
	} else {
		d.setTime(d.getTime() - 6*24*60*60*1000);
	}
	for(var i=0; i<7; i++) {
		data = new Array();
		s = formatDateTime(d.getTime()).substring(0,10);
		s1 = formatDateTime(d.getTime()).substring(5,10);
		d.setTime(d.getTime() + 6*24*60*60*1000);
		s2 = formatDateTime(d.getTime()).substring(5,10);
		d.setTime(d.getTime() - 13*24*60*60*1000);
		if(i == 0) {
			data.push('本周');
			data.push(s);
			data.push(0);
			data.push(0);
			data.push(true);
			data.push('Week');
		} else if (i == 1) {
			data.push('上周');
			data.push(s);
			data.push(0);
			data.push(0);
			data.push(false);
			data.push('Week');
		} else {
			data.push(s1 + '/' + s2);
			data.push(s);
			data.push(0);
			data.push(0);
			data.push(false);
			data.push('Week');
		}
		datas.push(data);
	}

	var weekStore = new Ext.data.ArrayStore({
		fields: [{
					name : "name"
				}, {
					name : "value"
				}, {
					name : "completed"
				}, {
					name : "uncompleted"
				}, {
					name : "selected"
				}, {
					name : "type"
				}],
		data: datas
	});

	//指定月
	var datas = new Array();
	var data;
	var d = new Date();
	var s, s1, s2;
	
//	d.setTime(d.getTime() + 8*60*60*1000);
	for(var i=0; i<4; i++) {
		data = new Array();
		d.setDate(1);
		s = formatDateTime(d.getTime()).substring(0,10);
		s1 = formatDateTime(d.getTime()).substring(0,7);
		if(i == 0) {
			data.push('本月');
			data.push(s);
			data.push(0);
			data.push(0);
			data.push(true);
			data.push('Month');
		} else if (i == 1) {
			data.push('上月');
			data.push(s);
			data.push(0);
			data.push(0);
			data.push(false);
			data.push('Month');
		} else {
			data.push(s1);
			data.push(s);
			data.push(0);
			data.push(0);
			data.push(false);
			data.push('Month');
		}
		datas.push(data);
		d.setTime(d.getTime() - 8*60*60*1000);
		d.setMonth(d.getMonth() - 1);
	}

	var monthStore = new Ext.data.ArrayStore({
		fields: [{
					name : "name"
				}, {
					name : "value"
				}, {
					name : "completed"
				}, {
					name : "uncompleted"
				}, {
					name : "selected"
				}, {
					name : "type"
				}],
		data: datas
	});

	//计划任务
	var sampleStore = new Ext.data.JsonStore({
		root: 'data',
		totalProperty: 'total',
		remoteSort: true,
		idProperty: 'id',

		fields: [
			   {name: 'id'},
			   {name: 'taskNo'},
			   {name: 'taskType'},
			   {name: 'taskName'},
			   {name: 'assignDate'},
			   {name: 'selected'},
			   {name: 'total'},
			   {name: 'idleCount'},
			   {name: 'completedCount'},
			   {name: 'updatedCount'},
			   {name: 'checkedCount'},
			   {name: 'assignedCount'},
			   {name: 'appealedCount'},
			   {name: 'finishedCount'},
			   {name: 'unfinishedCount'}
		],
		proxy: new Ext.data.HttpProxy({
			url: window.webRoot + 'Report/QARecord/User/TaskStat'
		})
	});

	var statusStore, condStore;

	//更新计划时间统计
	function loadPlannedData(type, store) {
		Ext.Ajax.request({
			url: window.webRoot + 'Report/QARecord/User/PlannedStat/' + type,
			success: function(res) {
				var respText = Ext.decode(res.responseText);   
				if(respText.code == 'OK') {
					var datas = new Object();
					var time, completed, uncompleted;
					Ext.each(respText.data, function(d) {
						time = d.qaPlannedTime;
						completed = d.finishedCount;
						uncompleted = d.unfinishedCount;
						datas[time] = new Array();
						datas[time].push(completed);
						datas[time].push(uncompleted);
					});
					store.each(function(rec) {
						time = rec.get('value');
						if(datas[time]) {
							rec.set('completed', datas[time][0]);
							rec.set('uncompleted', datas[time][1]);
						} else {
							rec.set('completed', 0);
							rec.set('uncompleted', 0);
						}
					});
					store.commitChanges();
				}
			},
			failure: function(res) {
			},
			method: 'GET', 
			timeout: 3000
		});
	}

	//更新质检状态统计
	function loadStatusData(store) {
		Ext.Ajax.request({
			url: window.webRoot + 'Report/QARecord/User/TotalStat',
			success: function(res) {
				var respText = Ext.decode(res.responseText);   
				if(respText.code == 'OK') {
					var datas = new Object();
					datas['UNFINISHED'] = respText.data.assignedCount + respText.data.idleCount;
					datas['FINISHED'] = respText.data.completedCount + respText.data.updatedCount + respText.data.checkedCount + respText.data.appealedCount;
					datas['COMPLETED'] = respText.data.completedCount;
					datas['UPDATED'] = respText.data.updatedCount;
					datas['APPEALED'] = respText.data.appealedCount;
					datas['CHECKED'] = respText.data.checkedCount;
					store.each(function(rec) {
						time = rec.get('value');
						if(datas[time]) {
							rec.set('count', datas[time]);
						} else {
							rec.set('count', 0);
						}
					});
					store.commitChanges();
				}
			},
			failure: function(res) {
			},
			method: 'POST', 
			params: 'qaUserId='
		});
	}

	function cacheCondition(ConditionFields) {
		var conds = new Array();

		for(var i=0; i<ConditionFields.length; i++) {
			var key = ConditionFields[i].getKey();
			var val = ConditionFields[i].getVal();
			var rawval = ConditionFields[i].getRawVal();
			var txt = ConditionFields[i].getTxt();
			
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
	
	//质检记录状态
	var qaStatus;

	//质检计划完成时间类型
	var qaPlannedType;

	//质检计划完成时间
	var qaPlannedTime;

	//质检任务编号
	var taskNo;

	var recQueryWin;

	var QueryConditionFields = new Array();

	var QAConditionFields = new Array();

	var Conditions = new Array();

	function setStatusSelected() {
		var obj = Ext.getCmp('btnStatus');
		var value = '';

		var level1Selected = 0;
		var hasSelected = false;
		Ext.each(obj.menu.items.items, function(obj2){
			var level2Selected = 0;
			Ext.each(obj2.menu.items.items, function(item){
				value = item.value;
				if(typeof(qaStatus) == 'string' && (qaStatus == value || qaStatus == '')) {
					item.setChecked(true, true);
					level2Selected++;
					hasSelected = true;
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
						hasSelected = true;
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
		} else if(hasSelected) {
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
	
	function getRecordRowClass(rec, idx, params, store) {
		if(rec.get('played') == 1) {
			return 'x-grid-record-played';
		}
	}

	function showSelected(v, p, rec, rowIndex, colIndex, store) {
		if(!rec.get('selected')) {
			return '';
		} else {
			return '<img src=../images/icons/fam/tick.png>';
		}
	}

	function showStatusStat(v, p, rec, rowIndex, colIndex, store) {
		var type = rec.get('type');
		var completed = rec.get('completed');
		var uncompleted = rec.get('uncompleted');
		var s = '';
		if(uncompleted > 0) {
			s += '<a href=# style="color:#000000" onclick="doSearch(\'' + type + '\', \'' + rec.get('value') + '\', \'Uncompleted\')">' + uncompleted + '</a>';
		} else {
			s += uncompleted;
		}
		s += '&nbsp;/&nbsp;';
		if(completed > 0) {
			s += '<a href=# style="color:#000000" onclick="doSearch(\'' + type + '\', \'' + rec.get('value') + '\', \'Completed\')">' + completed + '</a>';
		} else {
			s += completed;
		}
		return s;
	}

	function showTaskStat(v, p, rec, rowIndex, colIndex, store) {
		var type = 'Task';
		var completed = rec.get('finishedCount');
		var uncompleted = rec.get('unfinishedCount');
		var s = '';
		if(uncompleted > 0) {
			s += '<a href=# style="color:#000000" onclick="doSearch(\'' + type + '\', \'' + rec.get('id') + '\', \'Uncompleted\')">' + uncompleted + '</a>';
		} else {
			s += uncompleted;
		}
		s += '&nbsp;/&nbsp;';
		if(completed > 0) {
			s += '<a href=# style="color:#000000" onclick="doSearch(\'' + type + '\', \'' + rec.get('id') + '\', \'Completed\')">' + completed + '</a>';
		} else {
			s += completed;
		}
		return s;
	}

	function showTypeName(v, p, rec, rowIndex, colIndex, store) {
		var type = rec.get('type');
		return '<a href=# style="color:#000000" onclick="doSearch(\'' + type + '\', \'' + rec.get('value') + '\', \'Total\')">' + v + '</a>';
	}

	function showTaskName(v, p, rec, rowIndex, colIndex, store) {
		var type = 'Task';
		return '<a href=# style="color:#000000" onclick="doSearch(\'' + type + '\', \'' + rec.get('id') + '\', \'Total\')" title="' + v +'">' + v + '</a>';
	}

	function showStatusName(v, p, rec, rowIndex, colIndex, store) {
		var type = 'Status';
		return '<a href=# style="color:#000000" onclick="doSearch(\'' + type + '\', \'' + rec.get('value') + '\', \'' + rec.get('value') + '\')" title="' + v +'">' + v + '</a>';
	}

	function showQueryName(v, p, rec, rowIndex, colIndex, store) {
		if(rec.get('value') == 'REC_QUERY') {
			var type = 'Query';
			return '<a href=# style="color:#000000" onclick="recQueryWin.show()" title="' + v +'">' + v + '</a>';
		} else {
			var type = 'QAQuery';
			return '<a href=# style="color:#000000" onclick="qaQueryWin.show()" title="' + v +'">' + v + '</a>';
		}
	}

	function doSearch(type, value, status) {
		if(type == 'Day') {
			qaPlannedType = 'Day';
			qaPlannedTime = value;
			taskNo = null;
			Conditions = null;
		}
		if(type == 'Week') {
			qaPlannedType = 'Week';
			qaPlannedTime = value;
			taskNo = null;
			Conditions = null;
		}
		if(type == 'Month') {
			qaPlannedType = 'Month';
			qaPlannedTime = value;
			taskNo = null;
			Conditions = null;
		}
		if(type == 'Task') {
			qaPlannedType = null;
			qaPlannedTime = null;
			taskNo = value;
			Conditions = null;
		}
		if(type == 'Status') {
			qaPlannedType = null;
			qaPlannedTime = null;
			taskNo = null;
			Conditions = null;
		}
		if(type == 'Query') {
			qaPlannedType = null;
			qaPlannedTime = null;
			taskNo = null;
			Conditions = cacheCondition(QueryConditionFields);
		}
		if(type == 'QAQuery') {
			qaPlannedType = null;
			qaPlannedTime = null;
			taskNo = null;
			Conditions = cacheCondition(QAConditionFields);
		}

		if(status == 'Total') {
			qaStatus = null;
		} else if(status == 'Completed' || status == 'FINISHED') {
			qaStatus = new Array();
			qaStatus.push('COMPLETED');
			qaStatus.push('UPDATED');
			qaStatus.push('CHECKED');
			qaStatus.push('APPEALED');
		} else if(status == 'Uncompleted' || status == 'UNFINISHED') {
			qaStatus = 'ASSIGNED';
		} else {
			qaStatus = status;
		}

		//设置当前行为选中状态
		//指定日
		dayStore.each(function(rec) {
			if(type == 'Day' && rec.get('value') == value) {
				rec.set('selected', true);
			} else {
				rec.set('selected', false);
			}
		});
		dayStore.commitChanges();
		
		//指定周
		weekStore.each(function(rec) {
			if(type == 'Week' && rec.get('value') == value) {
				rec.set('selected', true);
			} else {
				rec.set('selected', false);
			}
		});
		weekStore.commitChanges();
		
		//指定月
		monthStore.each(function(rec) {
			if(type == 'Month' && rec.get('value') == value) {
				rec.set('selected', true);
			} else {
				rec.set('selected', false);
			}
		});
		monthStore.commitChanges();
		
		//计划任务
		sampleStore.each(function(rec) {
			if(type == 'Task' && rec.get('id') == value) {
				rec.set('selected', true);
			} else {
				rec.set('selected', false);
			}
		});
		sampleStore.commitChanges();
		
		//状态统计
		statusStore.each(function(rec) {
			if(type == 'Status' && rec.get('value') == value) {
				rec.set('selected', true);
			} else {
				rec.set('selected', false);
			}
		});
		statusStore.commitChanges();
		
		//复合查询
		condStore.each(function(rec) {
			if((type == 'Query' || type == 'QAQuery') && rec.get('value') == value) {
				rec.set('selected', true);
			} else {
				rec.set('selected', false);
			}
		});
		condStore.commitChanges();

		grid.getStore().load();
	}

	</script>
    <script type="text/javascript" src="../js/app/qa/QARecordQuery.js"></script>
    <script type="text/javascript">
	Ext.onReady(function(){
		Ext.QuickTips.init();

		/** 查询 Start */
		var panel_query = new Ext.Panel({
            layout: 'border',
			region: 'center', 
			autoScroll:false,
			iconCls: 'searchbtn',
			border: false,
			tbar: [
				'-',
				new Ext.app.common.Radio({
					id: 'radioUncomplete',
					hideLabel: true,
					boxLabel: '未质检',
					name: 'status',
					value: 'Uncomplete',
					checked: true,
					listeners: {
						'check' : function(obj, checked) {
							if(checked) {
								grid.getStore().load();
							}
						}
					}
				}),{
				   width: 30,
				   xtype: 'displayfield',
				   value: '&nbsp;&nbsp;'
				},
				new Ext.app.common.Radio({
					id: 'radioComplete',
					hideLabel: true,
					boxLabel: '已质检',
					name: 'status',
					value: 'Complete',
					checked: false,
					listeners: {
						'check' : function(obj, checked) {
							if(checked) {
								grid.getStore().load();
							}
						}
					}
				})
/*
				'质检开始时间:&nbsp;&nbsp;',
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
				'质检结束时间:&nbsp;&nbsp;',
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
*/
			],
			items: grid
		});
		/** 查询 End */
		
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
		
		//初始显示未质检记录
		qaStatus = new Array();
		qaStatus.push('IDLE');
		qaStatus.push('ASSIGNED');

		grid.getStore().on('beforeload', function(loader, node) {
			loader.removeAll(false);

			
			//复合查询
			if(Conditions) {
				loader.baseParams = getParamsArray(Conditions);
				//质检员（当前登录用户）
				loader.baseParams.qaUser = userInfo.userId;
			} else {
				loader.baseParams = new Object();
				//质检员（当前登录用户）
				loader.baseParams.qaUser = userInfo.userId;
				//质检状态
				if(qaStatus) {
					loader.baseParams.qaStatus = qaStatus;
				} else {
					loader.baseParams.qaStatus = '';
				}
				//质检计划执行时间类型
				if(qaPlannedType) {
					loader.baseParams.qaPlannedType = qaPlannedType;
				} else {
					loader.baseParams.qaPlannedType = '';
				}
				//质检计划执行时间
				if(qaPlannedTime) {
					loader.baseParams.qaPlannedTime = qaPlannedTime;
				} else {
					loader.baseParams.qaPlannedTime = '';
				}
				//质检任务
				if(taskNo) {
					loader.baseParams.taskNo = taskNo;
				} else {
					loader.baseParams.taskNo = '';
				}
			}
		});

//		grid.getStore().load();

		/** Start 质检查询导航 */
		var dayGrid = new Ext.grid.GridPanel({
			title: '日质检任务',
			iconCls: 'timebtn',
            region: 'center',
			store: dayStore,
			border: false,
			hideHeaders: true,
			columns: [
				{
					header   : '&nbsp;', 
					width    : .1, 
					sortable : true, 
					dataIndex: 'selected',
					renderer : showSelected
				},
				{
					header   : '日期', 
					width    : .4, 
					sortable : true, 
					dataIndex: 'name',
					renderer : showTypeName
				},
				{
					header   : '已质检', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'completed',
					renderer : showStatusStat
				}
			],
			width: '100%',
			viewConfig: {forceFit:true,  scrollOffset: 1}, 
			loadMask: true
		});

		dayGrid.on('beforeexpand', function(obj) {
			loadPlannedData('Day', obj.getStore());
		});

		//周质检任务
		var weekGrid = new Ext.grid.GridPanel({
			title: '周质检任务',
			iconCls: 'timebtn',
            region: 'center',
			store: weekStore,
			border: false,
			hideHeaders: true,
			columns: [
				{
					header   : '&nbsp;', 
					width    : .1, 
					sortable : true, 
					dataIndex: 'selected',
					renderer : showSelected
				},
				{
					header   : '日期', 
					width    : .4, 
					sortable : true, 
					dataIndex: 'name',
					renderer : showTypeName
				},
				{
					header   : '已质检', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'completed',
					renderer : showStatusStat
				}
			],
			width: '100%',
			viewConfig: {forceFit:true,  scrollOffset: 1}, 
			loadMask: true
		});
		
		weekGrid.on('beforeexpand', function(obj) {
			loadPlannedData('Week', obj.getStore());
		});

		//月质检任务
		var monthGrid = new Ext.grid.GridPanel({
			title: '月质检任务',
			iconCls: 'timebtn',
            region: 'center',
			store: monthStore,
			border: false,
			hideHeaders: true,
			columns: [
				{
					header   : '&nbsp;', 
					width    : .1, 
					sortable : true, 
					dataIndex: 'selected',
					renderer : showSelected
				},
				{
					header   : '日期', 
					width    : .4, 
					sortable : true, 
					dataIndex: 'name',
					renderer : showTypeName
				},
				{
					header   : '已质检', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'completed',
					renderer : showStatusStat
				}
			],
			width: '100%',
			viewConfig: {forceFit:true,  scrollOffset: 1}, 
			loadMask: true
		});
		
		monthGrid.on('beforeexpand', function(obj) {
			loadPlannedData('Month', obj.getStore());
		});

		//抽样任务
		var sampleGrid = new Ext.grid.GridPanel({
			title: '抽样任务',
			iconCls: 'package',
            region: 'center',
			store: sampleStore,
			border: false,
			hideHeaders: true,
			columns: [
				{
					header   : '&nbsp;', 
					width    : .1, 
					sortable : true, 
					dataIndex: 'selected',
					renderer : showSelected
				},
				{
					header   : '名称', 
					width    : .4, 
					sortable : true, 
					dataIndex: 'taskName',
					renderer: showTaskName
				},
				{
					header   : '已质检', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'finishedCount',
					renderer : showTaskStat		
				}
			],
			width: '100%',
			viewConfig: {forceFit:true,  scrollOffset: 1}, 
			loadMask: true
		});
		
		sampleGrid.on('beforeexpand', function(obj) {
			obj.getStore().load();
		});

		//按质检状态
		statusStore = new Ext.data.ArrayStore({
            fields: [{
                        name : "name"
                    }, {
                        name : "value"
                    }, {
                        name : "count"
                    }, {
                        name : "selected"
                    }],
			data: [['未质检', 'UNFINISHED', 0], ['已质检', 'FINISHED', 0], ['已质检（已提交）', 'COMPLETED', 0], ['已质检（已更改）', 'UPDATED', 0], ['已质检（申诉中）', 'APPEALED', 0], ['已质检（已审核）', 'CHECKED', 0]]
        });

		var statusGrid = new Ext.grid.GridPanel({
			title: '质检状态',
			iconCls: 'commentbtn',
            region: 'center',
			store: statusStore,
			border: false,
			hideHeaders: true,
			columns: [
				{
					header   : '&nbsp;', 
					width    : .1, 
					sortable : true, 
					dataIndex: 'selected',
					renderer : showSelected
				},
				{
					header   : '质检状态', 
					width    : .4, 
					sortable : true, 
					dataIndex: 'name',
					renderer: showStatusName
				},
				{
					header   : '数量', 
					width    : .1, 
					sortable : true, 
					dataIndex: 'count'
				}
			],
			width: '100%',
			viewConfig: {forceFit:true,  scrollOffset: 1}, 
			loadMask: true
		});
		
		statusGrid.on('beforeexpand', function(obj) {
			loadStatusData(obj.getStore());
		});

		//复合查询
		condStore = new Ext.data.ArrayStore({
            fields: [{
                        name : "name"
                    }, {
                        name : "value"
                    }],
			data: [['按录音信息查询', 'REC_QUERY'], ['按质检信息查询', 'QA_QUERY']]
        });

		var condGrid = new Ext.grid.GridPanel({
			title: '复合查询',
			iconCls: 'rec_query',
            region: 'center',
			store: condStore,
			border: false,
			hideHeaders: true,
			columns: [
				{
					header   : '&nbsp;', 
					width    : .1, 
					sortable : true, 
					dataIndex: 'selected',
					renderer : showSelected
				},
				{
					header   : '查询类型', 
					width    : .6, 
					sortable : true, 
					dataIndex: 'name',
					renderer : showQueryName
				}
			],
			width: '100%',
			viewConfig: {forceFit:true,  scrollOffset: 1}, 
			loadMask: true
		});

		/** Start 按录音条件查询 */
		// 时间范围类型
		QueryConditionFields.push(new Ext.app.rec.DateRangeTypeField());

		// 时间
		QueryConditionFields.push(new Ext.app.rec.DateRangeField({
			name: 'absoluteTimeType',
			hidden: false,
			fieldLabel: ''
		}));
		
		// 相对时间范围
		QueryConditionFields.push(
			new Ext.app.ux.DictSelector({
				width: 530,
				dictType: 'RELATIVE_TIME_TYPE',
				fieldLabel: '',
				hidden: true,
				name: 'relativeTimeType',
				showEmpty: false,
				defaultValue: 'default'
			})
		);

		// 座席
		QueryConditionFields.push(
			new Ext.app.rec.AgentTwinTriggerField({
				name: 'agentNo',
				width: 530,
				fieldLabel: '座席'
			})
		);
		// 部门
		QueryConditionFields.push(
			new Ext.app.rec.DepartmentTwinTriggerField({
				name: 'deptId',
				width: 530,
				fieldLabel: '部门'
			})
		);
		// 分机号码
		QueryConditionFields.push(
			new Ext.app.common.TextField({
				width: 530,
				fieldLabel: '分机号码',
				name: 'extNo'
			})
		);
		// 主叫号码
		QueryConditionFields.push(
			new Ext.app.common.TextField({
				width: 530,
				fieldLabel: '主叫号码',
				name: 'ani'
			})
		);
		// 被叫号码
		QueryConditionFields.push(
			new Ext.app.common.TextField({
				width: 530,
				fieldLabel: '被叫号码',
				name: 'dnis'
			})
		);
		// 呼叫时长
		QueryConditionFields.push(
			new Ext.app.rec.CallTimeRangeField({
				fieldLabel: '通话时长(秒)'
			})
		);
		// 呼叫类型
		QueryConditionFields.push(
			new Ext.app.ux.DictSelector({
				width: 530,
				dictType: 'CALL_TYPE',
				fieldLabel: '呼叫类型',
				name: 'callType',
				showEmpty: true
			})
		);

		recQueryWin = new Ext.Window({
			width: 715,
			height:320,
			closeAction:'hide',
			modal: true,
			plain: true,
			hidden: true,
			title: '按录音信息查询',
			iconCls: 'searchbtn',
			items:[
				new Ext.form.FormPanel({
					width: 700,
					border	: false,
					bodyStyle: 'padding: 10px',
					defaults: {
						anchor: '0'
					},

					items : QueryConditionFields
				})
			],
			buttons: [
				new Ext.Toolbar.Button({
					iconCls: 'searchbtn',
					text: '查询',
					targetTab: parent.rpttab,
					listeners:
						{
							'click': function(obj, e) {
								doSearch('Query', 'REC_QUERY', 'Total'); 
								recQueryWin.hide();
							}
						}
				}),
				new Ext.Toolbar.Button({
					iconCls: 'stopbtn',
					text: '取消',
					targetTab: parent.rpttab,
					listeners:
						{
							'click': function(obj, e) {
								recQueryWin.hide();
							}
						}
				})
			]
		});


		/** End 按录音条件查询 */

		/** Start 按质检条件查询 */
		// 时间范围类型
		QAConditionFields.push(new Ext.app.qa.QADateRangeTypeField());

		// 时间
		QAConditionFields.push(new Ext.app.qa.QADateRangeField({
			name: 'qaAbsoluteTimeType',
			hidden: false,
			fieldLabel: ''
		}));
		
		// 相对时间范围
		QAConditionFields.push(
			new Ext.app.ux.DictSelector({
				width: 530,
				dictType: 'RELATIVE_TIME_TYPE',
				fieldLabel: '',
				hidden: true,
				name: 'qaRelativeTimeType',
				showEmpty: false,
				defaultValue: 'default'
			})
		);

		// 质检分数
		QAConditionFields.push(
			new Ext.app.qa.QAScoreRangeField({
				fieldLabel: '质检分数'
			})
		);
		// 质检记录状态
		QAConditionFields.push(
			new Ext.app.qa.QAStatusTwinTriggerField({
				name: 'qaStatus',
				width: 530,
				fieldLabel: '质检状态'
			})
		);

		qaQueryWin = new Ext.Window({
			width: 715,
			height:180,
			closeAction:'hide',
			modal: true,
			plain: true,
			hidden: true,
			title: '按质检信息查询',
			iconCls: 'searchbtn',
			items:[
				new Ext.form.FormPanel({
					width: 700,
					border	: false,
					bodyStyle: 'padding: 10px',
					defaults: {
						anchor: '0'
					},

					items : QAConditionFields
				})
			],
			buttons: [
				new Ext.Toolbar.Button({
					iconCls: 'searchbtn',
					text: '查询',
					targetTab: parent.rpttab,
					listeners:
						{
							'click': function(obj, e) {
								doSearch('QAQuery', 'QA_QUERY', 'Total'); 
								qaQueryWin.hide();
							}
						}
				}),
				new Ext.Toolbar.Button({
					iconCls: 'stopbtn',
					text: '取消',
					targetTab: parent.rpttab,
					listeners:
						{
							'click': function(obj, e) {
								qaQueryWin.hide();
							}
						}
				})
			]
		});

		/** Start 质检完成后更新统计 */
		grid.getStore().on('update', function() {
			if(!dayGrid.collapsed) {
				loadPlannedData('Day', dayGrid.getStore());
				return;
			}
			if(!weekGrid.collapsed) {
				loadPlannedData('Week', weekGrid.getStore());
				return;
			}
			if(!monthGrid.collapsed) {
				loadPlannedData('Month', monthGrid.getStore());
				return;
			}
			if(!statusGrid.collapsed) {
				loadStatusData(statusGrid.getStore());
				return;
			}
			if(!sampleGrid.collapsed) {
				sampleGrid.getStore().load();
				return;
			}
		});

		/** End 质检完成后更新统计 */


		/** End 按录音条件查询 */

		var viewport = new Ext.Viewport({
            layout: 'border',
			autoHeight: true,
			border: false,
            items: [
			{
                region: 'west',
                title: '分类查询',
                split: true,
                width: 200,
                minSize: 175,
                maxSize: 400,
                collapsible: true,
                margins: '0 0 0 0',
                iconCls: 'searchbtn',
                layout: {
                    type: 'accordion',
                    animate: true
                },
                items: [
				dayGrid,
				weekGrid,
				monthGrid,
				sampleGrid,
				statusGrid,
				condGrid
				]
			}, grid
			],
			listeners: {
				'render' : function(obj) {
					var d = new Date();
					doSearch('Day', formatDateTime(d.getTime()).substring(0,10), 'Total');
					loadPlannedData('Day', dayStore);
				}
			}
		});	
	});
	</script>

</head>
<body>
<div id="favorite-win" class="x-hidden"></div>
</body>
</html>
