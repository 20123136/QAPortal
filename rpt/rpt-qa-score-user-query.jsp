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
    <title>QA成绩汇总（按排名）-查询</title>

    <link rel="stylesheet" type="text/css" href="../css/ext-all-notheme.css" />
    <link rel="stylesheet" type="text/css" href="../css/xtheme-gray.css" />
    <link rel="stylesheet" type="text/css" href="../css/common.css" />
    <link rel="stylesheet" type="text/css" href="../css/icon.css" />
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
    <script type="text/javascript" src="../js/app/rec/BeginTimeField.js"></script>
    <script type="text/javascript" src="../js/app/rec/EndTimeField.js"></script>
    <script type="text/javascript" src="../js/app/rec/DateRangeField.js"></script>
    <script type="text/javascript" src="../js/app/rec/DateRangeTypeField.js"></script>
    <script type="text/javascript" src="../js/app/mgr/AgentUserSelectorGrid.js"></script>
    <script type="text/javascript" src="../js/app/mgr/AgentUserSelectorWindow.js"></script>
    <script type="text/javascript" src="../js/app/rec/AgentTwinTriggerField.js"></script>
    <script type="text/javascript">

	var ConditionFields = new Array();
	
	Ext.onReady(function(){

		Ext.QuickTips.init();

		// 时间范围类型
		ConditionFields.push(new Ext.app.rec.DateRangeTypeField());

		// 时间
		ConditionFields.push(new Ext.app.rec.DateRangeField({
			name: 'absoluteTimeType',
			hidden: false,
			beginTimeFieldName: 'qaBeginTime',
			endTimeFieldName: 'qaEndTime',
			fieldLabel: ''
		}));
		
		// 相对时间范围
		ConditionFields.push(
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

		// 部门
		ConditionFields.push(
			new Ext.app.ux.DictSelector({
				fieldLabel: '座席组别',
				width: 530,
				dictType: 'QA_ITEM_GROUP',
				hidden: false,
				name: 'deptId',
				showEmpty: true,
				defaultValue: 'default'
			})
		);

		// 座席
		ConditionFields.push(
			new Ext.app.rec.AgentTwinTriggerField({
				name: 'agentNo',
				width: 530,
				fieldLabel: '座席'
			})
		);

		var fieldSets = new Array();
		if(ConditionFields.length > 0) {
			fieldSets.push(
				new Ext.form.FieldSet({
					title: '查询条件',
					collapsible: true,
					collapsed: false,
					autoHeight: true,
					items: ConditionFields
				})
			);
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
					iconCls: 'searchbtn',
					text: '查询',
					targetTab: parent.rpttab,
					listeners:
						{
							'click': function(obj, e) {
								obj.targetTab.add({
									title: '查询结果',
									iconCls: 'gridbtn',
									margins:'0 0 0 0',
									autoScroll:true,
									autoWidth:true,
									closable:true,
									html:'<iframe src="rpt-qa-score-user-result.jsp" border=0 width="100%" height="100%" frameborder="no" scrolling="auto"></iframe>'
								}).show();
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
