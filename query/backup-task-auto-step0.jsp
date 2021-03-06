﻿<%@ page language="java" contentType="text/html; charset=UTF-8" %>
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
    <title>自动备份任务-Step1</title>

    <link rel="stylesheet" type="text/css" href="../css/ext-all-notheme.css" />
    <link rel="stylesheet" type="text/css" href="../css/xtheme-gray.css" />
    <link rel="stylesheet" type="text/css" href="../css/icon.css" />
    <link rel="stylesheet" type="text/css" href="../css/icon.css" />
    <link rel="stylesheet" type="text/css" href="../css/common.css" />
    <link rel="stylesheet" type="text/css" href="../ux/css/DateTimePicker.css" />
    <link rel="stylesheet" type="text/css" href="../ux/css/Spinner.css" />

	<script >
		var webRoot = '<%=webRoot%>';
	</script>

    <script type="text/javascript" src="../js/ext-base.js"></script>
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
    <script type="text/javascript" src="../js/app/common/Window.js"></script>
    <script type="text/javascript" src="../js/app/common/TwinTriggerField.js"></script>
    <script type="text/javascript" src="../js/app/common/TreePanel.js"></script>
    <script type="text/javascript" src="../js/app/common/TextField.js"></script>
    <script type="text/javascript" src="../js/app/common/NumberField.js"></script>
    <script type="text/javascript" src="../js/app/common/ColmunField.js"></script>
    <script type="text/javascript" src="../js/app/common/ComboBox.js"></script>

	<script type="text/javascript" src="../js/func.js"></script>
    <script type="text/javascript">

	var ConditionFields = new Array();
 
	var TaskConditionFields = new Array();
	
	function disable() {
		Ext.each(ConditionFields, function(item) {
			item.disable();
		});
	}
	
	function enable() {
		Ext.each(ConditionFields, function(item) {
			item.enable();
		});
	}

	function getTaskNo() {
		return TaskConditionFields[0].getVal();
	}

	function getTaskComment() {
		return TaskConditionFields[1].getVal();
	}

	function checkInput() {
		//检查任务名称是否输入
		if(!TaskConditionFields[1].getValue()) {
			Ext.Msg.alert('输入错误', '任务名称不能为空！');
			TaskConditionFields[1].focus();
			return false;
		}

		return true;
	}

	Ext.onReady(function(){

		Ext.QuickTips.init();

		// 任务编号
		TaskConditionFields.push(
			new Ext.app.common.TextField({
				width: 530,
				fieldLabel: '任务编号',
				disabled: true,
				readOnly: true,
				name: 'qaTaskNo'
			})
		);

		// 任务名称
		TaskConditionFields.push(
			new Ext.app.common.TextField({
				width: 530,
				fieldLabel: '任务名称',
				name: 'taskComment'
			})
		);

		var fieldSets = new Array();
		if(TaskConditionFields.length > 0) {
			fieldSets.push(
				new Ext.form.FieldSet({
					title: '任务信息',
					collapsible: true,
					collapsed: false,
					autoHeight: true,
					items: TaskConditionFields
				})
			);
			
			for(var i=0; i < TaskConditionFields.length; i++) {
				ConditionFields.push(TaskConditionFields[i]);
			}
		}

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
					iconCls: 'rightbtn',
					text: '下一步',
					targetTab: parent.assignTab,
					listeners:
						{
							'click': function(obj, e) {

								if(!checkInput()) {
									return;
								}
		
								disable();
								
								if(parent.frames['tabStep1']) {
									//如果第二步页面已经存在，则直接显示
									parent.assignTab.setActiveTab(1);
								} else {
									obj.targetTab.add({
										title: 'Step2:设置查询条件',
										iconCls: 'searchbtn',
										margins:'0 0 0 0',
										autoScroll:true,
										autoWidth:true,
										closable:false,
										html:'<iframe name=tabStep1 src="backup-task-auto-step1.jsp" border=0 width="100%" height="100%" frameborder="no" scrolling="auto"></iframe>'
									}).show();
								}
							}
						}
				})
			]
		});


		//如果第二步页面存在则，当前页面不可编辑
		if(parent.frames['tabStep2']) {
			disable();
		}

		//自动生成一个任务编号
		Ext.Ajax.request({
			url: window.webRoot + 'QABackup/Task/GenerateNo/Auto',
			success: function(res) {
				var respText = Ext.decode(res.responseText);   
				if(respText.code == 'OK') {
					TaskConditionFields[0].setValue(respText.data);
				}
			},
			failure: function(res) {
			},
			method: 'GET', 
			timeout: 3000
		});
	});
	</script>

</head>
<body>
	<div id="save-win" class="x-hidden"></div>
</body>
</html>
