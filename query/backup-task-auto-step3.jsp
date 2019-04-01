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
    <title>自动备份任务-Step4</title>

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
    <script type="text/javascript" src="../js/app/common/Arg.js"></script>
    <script type="text/javascript" src="../js/app/rec/BeginTimeField.js"></script>
    <script type="text/javascript" src="../js/app/rec/EndTimeField.js"></script>
    <script type="text/javascript" src="../js/app/rec/DateRangeField.js"></script>
    <script type="text/javascript" src="../js/app/rec/DateRangeTypeField.js"></script>
    <script type="text/javascript" src="../js/app/qa/ScheduleTypeField.js"></script>
	<script type="text/javascript" src="../js/func.js"></script>
    <script type="text/javascript">

	var ConditionFields = new Array();
 
	var TaskConditionFields = new Array();

	function disable() {
		Ext.each(ConditionFields, function(item) {
			try
			{
				item.disable();
			}
			catch (e)
			{
			}
		});
	}
	
	function enable() {
		Ext.each(ConditionFields, function(item) {
			try
			{
				item.enable();
			}
			catch (e)
			{
			}
		});
	}

	var tabStep0 = parent.frames['tabStep0'];

	var tabStep1 = parent.frames['tabStep1'];

	var tabStep2 = parent.frames['tabStep2'];

	function closeStep() {
		tabStep2.enable();
		parent.assignTab.remove(parent.assignTab.getActiveTab());
	}

	var form;

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
		for(var i=0; i<tabStep2.ConditionFields.length; i++) {
			var key = tabStep2.ConditionFields[i].getKey();
			var val = tabStep2.ConditionFields[i].getVal();
			var rawval = tabStep2.ConditionFields[i].getRawVal();
			var txt = tabStep2.ConditionFields[i].getTxt();

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

		//缓存Step3的条件
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

	function doSubmit() {
		Conditions = cacheCondition();

		myMask = new Ext.LoadMask(form.getEl(), {msg:"任务提交中请等待..."});
		myMask.show();

		Ext.Ajax.request({
			url: window.webRoot + 'QABackup/Task/Auto',
			method: 'POST',
			params: getParamsArray(),
			success: function(response,options) {
				var respText = Ext.util.JSON.decode(response.responseText);
				myMask.hide();
				if(respText.code != 'OK') {
					Ext.Msg.alert('提交失败', respText.message + "（" + respText.code + "）");
				} else {
					Ext.Msg.alert('提交成功', '计划任务已经提交');
				}
			},
			failure: function(response,options) {
				Ext.Msg.alert('提交失败', '提交抽样任务失败！');
				myMask.hide();
			}
		});
	}

	Ext.onReady(function(){

		Ext.QuickTips.init();

		// 计划类型
		TaskConditionFields.push(
			new Ext.app.qa.ScheduleTypeField({
				width: 530
			})
		);
		
		TaskConditionFields.push(
			new Ext.app.common.DateTime({
				fieldLabel: '执行时间',
				name: 'scheduleTime',
				emptyText: 'HH:mm:SS',
				format: 'H:i:s',
				value: '01:00:00',
				width: 200
			})
		);


		var fieldSets = new Array();
		if(TaskConditionFields.length > 0) {
			fieldSets.push(
				new Ext.form.FieldSet({
					title: '执行计划',
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

		form = new Ext.form.FormPanel({
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
					id: 'btnStep1',
					iconCls: 'leftbtn',
					text: '上一步',
					targetTab: tabStep1,
					listeners:
						{
							'click': function(obj, e) {
								Ext.Msg.show({
									title:'确认返回?',
									msg: '返回后本步骤操作内容将被取消，请再次确实是否要返回上一步?',
									buttons: Ext.Msg.YESNOCANCEL,
									fn: function(btn, text) {
										if(btn == "yes") {
											closeStep();
										}
									},
									icon: Ext.MessageBox.QUESTION
								});
							}
						}
				}),
				new Ext.Toolbar.Button({
					iconCls: 'finishbtn',
					text: '完&nbsp;&nbsp;成',
					targetTab: parent.assignTab,
					listeners:
						{
							'click': function(obj, e) {
								disable();
								obj.disable();
								doSubmit();
							}
						}
				})
			]
		});
	});
	</script>

</head>
<body>
	<div id="save-win" class="x-hidden"></div>
</body>
</html>
