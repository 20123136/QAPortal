<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.wilcom.qa.tools.Session"%>
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
    <title>录音备份-Step4</title>

    <link rel="stylesheet" type="text/css" href="../css/ext-all-notheme.css" />
    <link rel="stylesheet" type="text/css" href="../css/xtheme-gray.css" />
    <link rel="stylesheet" type="text/css" href="../css/icon.css" />
    <link rel="stylesheet" type="text/css" href="../css/common.css" />
    <link rel="stylesheet" type="text/css" href="../ux/css/DateTimePicker.css" />
    <link rel="stylesheet" type="text/css" href="../ux/css/Spinner.css" />

    <style type=text/css>
        /* style rows on mouseover */
        .x-grid3-row-over .x-grid3-cell-inner {
            font-weight: bold;
        }

        .titletext {
            font-weight: bold;
        }
	</style>
	<script >
		var webRoot = '<%=webRoot%>';
	</script>

    <script type="text/javascript" src="../js/ext-base-debug.js"></script>
    <script type="text/javascript" src="../js/ext-all-debug.js"></script>
    <script type="text/javascript" src="../js/ext-lang-zh_CN.js"></script>
    <script type="text/javascript" src="../js/ext-ui-combo-pagesize.js"></script>
    <script type="text/javascript" src="../ux/DateTimeField.js"></script>
    <script type="text/javascript" src="../js/app/ux/DictSelector.js"></script>
    <script type="text/javascript" src="../js/app/ux/DepartmentSelector.js"></script>
    <script type="text/javascript" src="../ux/Spinner.js"></script>
    <script type="text/javascript" src="../ux/SpinnerField.js"></script>
    <script type="text/javascript" src="../js/app/common/DateTime.js"></script>
    <script type="text/javascript" src="../js/app/common/Grid.js"></script>
    <script type="text/javascript" src="../js/app/common/EditorGrid.js"></script>
    <script type="text/javascript" src="../js/app/common/Window.js"></script>
    <script type="text/javascript" src="../js/app/common/TwinTriggerField.js"></script>
    <script type="text/javascript" src="../js/app/common/TreePanel.js"></script>
    <script type="text/javascript" src="../js/app/common/TextField.js"></script>
    <script type="text/javascript" src="../js/app/common/NumberField.js"></script>
    <script type="text/javascript" src="../js/app/common/ColmunField.js"></script>
    <script type="text/javascript" src="../js/app/common/ComboBox.js"></script>

	<script type="text/javascript" src="../js/func.js"></script>
    <script type="text/javascript">

	var tabCount = 1;

	var ConditionFields = new Array();

	var BackupConditionFields = new Array();

	var Conditions;

	var tabStep0 = parent.frames['tabStep0'];

	var tabStep1 = parent.frames['tabStep1'];

	var tabStep2 = parent.frames['tabStep2'];

	var timerId;

	var logId = '';

	function cacheCondition() {
		var conds = new Array();
 
		//缓存Step0的条件
		for(var i=0; i<tabStep0.ConditionFields.length; i++) {
			var key = tabStep0.ConditionFields[i].getKey();
			var val = tabStep0.ConditionFields[i].getVal();
			var rawval = tabStep0.ConditionFields[i].getRawVal();
			var txt = tabStep0.ConditionFields[i].getTxt();

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
		}

		//缓存Step1的条件
		for(var i=0; i<tabStep1.ConditionFields.length; i++) {
			var key = tabStep1.ConditionFields[i].getKey();
			var val = tabStep1.ConditionFields[i].getVal();
			var rawval = tabStep1.ConditionFields[i].getRawVal();
			var txt = tabStep1.ConditionFields[i].getTxt();

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
		}

		//缓存Step2的条件
		for(var i=0; i<tabStep2.BackupConditionFields.length; i++) {
			var key = tabStep2.BackupConditionFields[i].getKey();
			var val = tabStep2.BackupConditionFields[i].getVal();
			var rawval = tabStep2.BackupConditionFields[i].getRawVal();
			var txt = tabStep2.BackupConditionFields[i].getTxt();
			
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
		}

		return conds;
	}

	function getParamsArray() {
		var params = new Object();

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

	function getTaskStatus() {
		timerId = window.setInterval(function() {
				Ext.Ajax.request({
					url: window.webRoot + 'QABackup/Task/Status/' + tabStep0.getTaskNo(),
					method: 'GET',
					success: function(response,options) {
						var respText = Ext.util.JSON.decode(response.responseText);
						if(respText.code != 'OK') {
//							Ext.Msg.alert('提交失败', respText.message + "（" + respText.code + "）");
						} else {
							Ext.getDom('spanAssignTaskBeginTime').innerHTML = respText.data.displayExecuteTime;
							Ext.getDom('spanAssignTaskSpentTime').innerHTML = respText.data.displaySpentTime;
							Ext.getDom('spanAssignTotal').innerHTML = respText.data.total;
							Ext.getDom('spanCompletedCount').innerHTML = respText.data.completedCount;
							Ext.getDom('spanCompletedSize').innerHTML = respText.data.completedSize + 'M';
							Ext.getDom('spanFailedCount').innerHTML = respText.data.failedCount;
							Ext.getDom('spanSkipedCount').innerHTML = respText.data.skipedCount;
							if(respText.data.status == 'Begin') {
								Ext.getDom('spanAssingTaskStatus').innerHTML = '初始化中';
								Ext.getDom('imgAssingTaskStatus').src = '../images/loading.gif';
							} else if(respText.data.status == 'doQuery') {
								Ext.getDom('spanAssingTaskStatus').innerHTML = '抽样查询中';
								Ext.getDom('imgAssingTaskStatus').src = '../images/loading.gif';
							} else if(respText.data.status == 'doBackup') {
								Ext.getDom('spanAssingTaskStatus').innerHTML = '备份中';
								Ext.getDom('imgAssingTaskStatus').src = '../images/loading.gif';
							} else if(respText.data.status == 'doRuning') {
								Ext.getDom('spanAssingTaskStatus').innerHTML = '运行中';
								Ext.getDom('imgAssingTaskStatus').src = '../images/loading.gif';
							} else if(respText.data.status == 'doSave') {
								Ext.getDom('spanAssingTaskStatus').innerHTML = '保存中';
								Ext.getDom('imgAssingTaskStatus').src = '../images/loading.gif';
							} else if(respText.data.status == 'End') {
								if(respText.data.result == '000') {
									Ext.getDom('spanAssingTaskStatus').innerHTML = '已完成（<font color=green>执行成功</font>）';
									Ext.getDom('imgAssingTaskStatus').src = '../images/icons/fam/accept.png';
									logId = respText.data.taskLogId;
								} else {
									Ext.getDom('spanAssingTaskStatus').innerHTML = '已完成（<font color=red>执行失败:' + respText.data.result + '</font>）!';
									Ext.getDom('imgAssingTaskStatus').src = '../images/icons/fam/exclamation.png';
								}
								clearInterval(timerId);
								Ext.getCmp('btnViewDetail').enable();
							} else {
								Ext.getDom('spanAssingTaskStatus').innerHTML = '';
							}
						}
					},
					failure: function(response,options) {
						clearInterval(timerId);
					}
				})
			}
			, 3000);
	}

	var myMask;

	Ext.onReady(function(){

		Ext.QuickTips.init();
	
		Conditions = cacheCondition();

		var fieldSets = new Array();

		fieldSets.push(
			new Ext.form.FieldSet({
				title: '任务信息',
				collapsible: true,
				collapsed: false,
				autoHeight: true,
				items: [
					{
						border: false,
						fieldLabel: '',
						width: 680,
						html: '<table width=666 align=center border="0" cellpadding="0" cellspacing="5" width="100%">' +
								'<tr>' +
								'<td width=100 align=left>任务编号: </td>' +
								'<td colspan=3 align=left><span id=spanAssignTaskNo style="color:blue;"></span></td>' +
								'</tr>' +
								'<tr>' +
								'<td width=100 align=left>任务名称: </td>' +
								'<td colspan=3 align=left><span id=spanAssignTaskComment style="color:blue;"></span></td>' +
								'</tr>' +
							   '</table>'
					}
				]
			})
		);

		fieldSets.push(
			new Ext.form.FieldSet({
				title: '执行信息',
				collapsible: true,
				collapsed: false,
				autoHeight: true,
				items: [
					{
						border: false,
						fieldLabel: '',
						width: 680,
						html: '<table width=666 align=center border="0" cellpadding="0" cellspacing="5" width="100%">' +
								'<tr>' +
								'<td width=100 align=left>开始时间: </td>' +
								'<td width=135 align=left><span id=spanAssignTaskBeginTime style="color:blue;"></span></td>' +
								'<td width=100 align=left>持续时长: </td>' +
								'<td colspan=3 align=left><span id=spanAssignTaskSpentTime style="color:blue;"></span></td>' +
								'</tr>' +
								'<tr id=trResultTotal>' +
								'<td width=100 align=left>录音数量: </td>' +
								'<td colspan=5 align=left><span id=spanAssignTotal style="color:blue;"></span></td>' +
								'</tr>' +
								'<tr>' +
								'<td width=100 align=left>已备份数量: </td>' +
								'<td width=135 align=left><span id=spanCompletedCount style="color:blue;"></span></td>' +
								'<td width=100 align=left>忽略录音量: </td>' +
								'<td width=135 align=left><span id=spanSkipedCount style="color:blue;"></span></td>' +
								'<td width=100 align=left>备份失败量: </td>' +
								'<td width=245 align=left><span id=spanFailedCount style="color:blue;"></span></td>' +
								'</tr>' +
								'<tr>' +
								'<td width=100 align=left>已备份大小: </td>' +
								'<td colspan=5 align=left><span id=spanCompletedSize style="color:blue;"></span></td>' +
								'</tr>' +
								'<tr>' +
								'<td width=100 align=left>运行状态: </td>' +
								'<td colspan=5 align=left><span id=spanAssingTaskStatus style="color:blue;"></span>&nbsp;&nbsp;<img id=imgAssingTaskStatus src=../images/loading.gif style="margin-bottom:-3px"></td>' +
								'</tr>' +
							   '</table>'
					}
				]
			})
		);
/*
		if(BackupConditionFields.length > 0) {
			fieldSets.push(
				new Ext.form.FieldSet({
					title: '运行进度',
					collapsible: true,
					collapsed: false,
					autoHeight: true,
					items: [
						{
							border: false,
							fieldLabel: '',
							width: 680,
							html: '<table width=666 align=center border="0" cellpadding="0" cellspacing="5" width="100%">' +
									'<tr>' +
									'<td width=100 align=left>查询记录: </td>' +
									'<td width=445 align=left><div id=divProgress1></div></td>' +
									'<td width=100 align=left><img src=../images/loading.gif style="margin-bottom:-3px"></td>' +
									'</tr>' +
									'<tr hight=10><td colspan=3><td></tr>' +
									'<tr>' +
									'<td width=100 align=left>分配记录: </td>' +
									'<td width=445 align=left><div id=divProgress2></div></td>' +
									'<td width=100 align=left><img src=../images/loading.gif style="margin-bottom:-3px"></td>' +
									'</tr>' +
									'<tr hight=10><td colspan=3><td></tr>' +
									'<tr>' +
									'<td width=100 align=left>生成记录: </td>' +
									'<td width=445 align=left><div id=divProgress3></div></td>' +
									'<td width=100 align=left><img src=../images/loading.gif style="margin-bottom:-3px"></td>' +
									'</tr>' +
								   '</table>'
						}
					]
				})
			);
		}
*/
		var form = new Ext.form.FormPanel({
			renderTo: Ext.getBody(),
			width: 700,
			border	: false,
			bodyStyle: 'padding: 10px',
			defaults: {
				anchor: '0'
			},

			items : fieldSets,
			
			buttons: [
				new Ext.Toolbar.Button({
					id: 'btnViewDetail',
					iconCls: 'commentsbtn',
					text: '查看备份明细',
					disabled: true,
					targetTab: parent.assignTab,
					listeners:
						{
							'click': function(obj, e) {
								//如果Step4已经存在则直接显示
								if(parent.frames['tabStep4']) {
									parent.assignTab.setActiveTab(3);
									return;
								}
								
								obj.targetTab.add({
									title: '查看备份明细',
									iconCls: 'commentsbtn',
									margins:'0 0 0 0',
									autoScroll:true,
									autoWidth:true,
									html:'<iframe name=tabStep4 src="backup-task-detail-list.jsp?taskNo=' + tabStep0.getTaskNo() + '&logId=' + logId + '" border=0 width="100%" height="100%" frameborder="no" scrolling="auto"></iframe>'
								}).show();
							}
						}
				})
			]
		});
/*
		var progress1 = new Ext.ProgressBar({
			text: '',
			width: 440,
			renderTo: 'divProgress1'
		});

		var progress2 = new Ext.ProgressBar({
			text: '',
			width: 440,
			renderTo: 'divProgress2'
		});

		var progress3 = new Ext.ProgressBar({
			text: '',
			width: 440,
			renderTo: 'divProgress3'
		});
*/
		/** 抽样查询 Start */

		myMask = new Ext.LoadMask(form.getEl(), {msg:"任务提交中请等待..."});
		myMask.show();

		Ext.Ajax.request({
			url: window.webRoot + 'QABackup/Task/Manual',
			method: 'POST',
			params: getParamsArray(),
			success: function(response,options) {
				var respText = Ext.util.JSON.decode(response.responseText);
				myMask.hide();
				if(respText.code != 'OK') {
					Ext.Msg.alert('提交失败', respText.message + "（" + respText.code + "）");
				} else {
		
					Ext.getDom('spanAssignTaskNo').innerHTML = tabStep0.getTaskNo();
					Ext.getDom('spanAssignTaskComment').innerHTML = tabStep0.getTaskComment();

					getTaskStatus();
/*
					Ext.getDom('spanTotalCount').innerHTML = respText.data.total;
					Ext.getDom('spanTotalAvailCount').innerHTML = respText.data.idleCount;

					//显示上一步选择的抽样类型
					var sampleType = tabStep1.getSampleType();
					if(sampleType[0] == 'TotalLimit') {
						Ext.getDom('spanSampleType').innerHTML = '按抽检数量（' + sampleType[1] + '）';
					} else if(sampleType[0] == 'RateLimit') {
						Ext.getDom('spanSampleType').innerHTML = '按抽检百分比（' + sampleType[1] + '%）';
					} else {
						Ext.getDom('spanSampleType').innerHTML = '';
					}

					var availCount = respText.data.idleCount;
					var limitCount = (sampleType[1] && sampleType[1] > 0) ? sampleType[1] : '0';
					var sampleCount = 0;
					if(sampleType[0] == 'TotalLimit') {
						if(availCount > limitCount) {
							sampleCount = limitCount;
						} else {
							sampleCount = availCount;
						}
					} else if(sampleType[0] == 'RateLimit') {
						if(limitCount > 0) {
							sampleCount = parseInt(availCount * limitCount * 0.01);
						} else {
							sampleCount = 0;
						}
					} else {
						sampleCount = 0;
					}
					Ext.getDom('spanSampleTotalCount').innerHTML = sampleCount;

					if(sampleCount <= 0) {
						Ext.Msg.alert('查询失败', '没有找到符合条件的记录！');
						disable();
					}

					BackupConditionFields[1].sampleCount = sampleCount;
					BackupConditionFields[3].sampleCount = sampleCount;
*/
				}
			},
			failure: function(response,options) {
				Ext.Msg.alert('提交失败', '提交备份任务失败！');
				myMask.hide();
			}
		});
		/** 抽样查询 End */

	});
	</script>

</head>
<body>
	<div id="save-win" class="x-hidden"></div>
</body>
</html>
