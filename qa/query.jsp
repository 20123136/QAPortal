<%@ page language="java" contentType="text/html; charset=UTF-8" %>
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
    <title>质检查询</title>

    <link rel="stylesheet" type="text/css" href="../css/ext-all-notheme.css" />
    <link rel="stylesheet" type="text/css" href="../css/xtheme-gray.css" />
    <link rel="stylesheet" type="text/css" href="../css/icon.css" />
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
    <script type="text/javascript" src="../js/app/mgr/AgentUserSelectorGrid.js"></script>
    <script type="text/javascript" src="../js/app/mgr/AgentUserSelectorWindow.js"></script>
    <script type="text/javascript" src="../js/app/rec/AgentTwinTriggerField.js"></script>
    <script type="text/javascript" src="../js/app/mgr/GroupSelectorGrid.js"></script>
    <script type="text/javascript" src="../js/app/mgr/GroupSelectorWindow.js"></script>
    <script type="text/javascript" src="../js/app/rec/GroupTwinTriggerField.js"></script>
    <script type="text/javascript" src="../js/app/mgr/DepartmentSelectorTreePanel.js"></script>
    <script type="text/javascript" src="../js/app/mgr/DepartmentSelectorWindow.js"></script>
    <script type="text/javascript" src="../js/app/rec/DepartmentTwinTriggerField.js"></script>
    <script type="text/javascript" src="../js/app/rec/CallTimeRangeField.js"></script>
    <script type="text/javascript" src="../js/app/qa/InspectorSelectorGrid.js"></script>
    <script type="text/javascript" src="../js/app/qa/InspectorSelectorWindow.js"></script>
    <script type="text/javascript" src="../js/app/qa/InspectorTwinTriggerField.js"></script>
    <script type="text/javascript" src="../js/app/qa/QASelectorGrid.js"></script>
    <script type="text/javascript" src="../js/app/qa/QASelectorWindow.js"></script>
    <script type="text/javascript" src="../js/app/qa/QATwinTriggerField.js"></script>
    <script type="text/javascript" src="../js/app/qa/QAGradeTwinTriggerField.js"></script>
    <script type="text/javascript" src="../js/colmun/qa_query.js"></script>
    <script type="text/javascript">

	var tabCount = 1;

	var ConditionFields = new Array();

	var QueryConditionFields = new Array();
	
	var QAConditionFields = new Array();
	
	Ext.onReady(function(){

		Ext.QuickTips.init();

		// 时间
		QueryConditionFields.push(new Ext.app.rec.DateRangeField());
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
		// 技能组
		QueryConditionFields.push(
			new Ext.app.rec.GroupTwinTriggerField({
				name: 'skillNo',
				width: 530,
				fieldLabel: '技能组'
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

		//质检组别
		QAConditionFields.push(
			new Ext.app.ux.DictSelector({
				width: 530,
				dictType: 'QA_GROUP',
				fieldLabel: '组别',
				name: 'qaGroupId',
				showEmpty: true
			})
		);
		
		// 质检员
		QAConditionFields.push(
			new Ext.app.qa.InspectorTwinTriggerField({
				name: 'qaInspectorId',
				width: 530,
				fieldLabel: '质检员'
			})
		);
		
		// 评级项
		QAConditionFields.push(
			new Ext.app.qa.QAGradeTwinTriggerField({
				name: 'qaGradeItemId',
				width: 530,
				fieldLabel: '评级项'
			})
		);

		// 评分项
		QAConditionFields.push(
			new Ext.app.qa.QATwinTriggerField({
				name: 'qaItemId',
				width: 530,
				fieldLabel: '评分项'
			})
		);

		var fieldSets = new Array();
		if(QueryConditionFields.length > 0) {
			fieldSets.push(
				new Ext.form.FieldSet({
					title: '查询条件',
					collapsible: true,
					collapsed: false,
					autoHeight: true,
					items: QueryConditionFields
				})
			);
			
			for(var i=0; i < QueryConditionFields.length; i++) {
				ConditionFields.push(QueryConditionFields[i]);
			}
		}

		if(QAConditionFields.length > 0) {
			fieldSets.push(
				new Ext.form.FieldSet({
					title: '质检条件',
					collapsible: true,
					collapsed: false,
					autoHeight: true,
					items: QAConditionFields
				})
			);
			for(var i=0; i < QAConditionFields.length; i++) {
				ConditionFields.push(QAConditionFields[i]);
			}
		}
		
		var displayColmuns = new Array();
		for(var i=0; i<Colmuns.length; i++) {
			if(!Colmuns[i].hidden && !Colmuns[i].group) {
				displayColmuns.push(Colmuns[i]);
			}
		}

		fieldSets.push(
			new Ext.form.FieldSet({
				title: '显示字段',
				collapsible: true,
				collapsed: true,
				autoHeight: true,
				items: [
					{  
						xtype: 'checkboxgroup',
						hideLabel: true,
						columns: 3,
						items: displayColmuns
					}
				]
			})
		);

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
									html:'<iframe src="result.jsp" border=0 width="100%" height="100%" frameborder="no" scrolling="auto"></iframe>'
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
