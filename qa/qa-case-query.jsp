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
    <title>录音查询</title>

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
    <script type="text/javascript" src="../js/app/common/Arg.js"></script>
    <script type="text/javascript" src="../js/app/rec/BeginTimeField.js"></script>
    <script type="text/javascript" src="../js/app/rec/EndTimeField.js"></script>
    <script type="text/javascript" src="../js/app/rec/DateRangeField.js"></script>
    <script type="text/javascript" src="../js/app/qa/QACaseAttributeSelectorGrid.js"></script>
    <script type="text/javascript" src="../js/app/qa/QACaseAttributeSelectorWindow.js"></script>
    <script type="text/javascript" src="../js/app/qa/QACaseAttributeTwinTriggerField.js"></script>
    <script type="text/javascript" src="../js/app/qa/QACaseTypeSelectorGrid.js"></script>
    <script type="text/javascript" src="../js/app/qa/QACaseTypeSelectorWindow.js"></script>
    <script type="text/javascript" src="../js/app/qa/QACaseTypeTwinTriggerField.js"></script>
    <script type="text/javascript" src="../js/app/qa/QACaseType0SelectorGrid.js"></script>
    <script type="text/javascript" src="../js/app/qa/QACaseType0SelectorWindow.js"></script>
    <script type="text/javascript" src="../js/app/qa/QACaseType0TwinTriggerField.js"></script>
    <script type="text/javascript" src="../js/app/qa/InspectorSelectorGrid.js"></script>
    <script type="text/javascript" src="../js/app/qa/InspectorSelectorWindow.js"></script>
    <script type="text/javascript" src="../js/app/qa/InspectorTwinTriggerField.js"></script>
	<script type="text/javascript" src="../js/colmun/qa_case_record_query.js"></script>
    <script type="text/javascript">

	var tabCount = 1;

	var ConditionFields = new Array();

	var QueryConditionFields = new Array();
	
	var QAConditionFields = new Array();

	function checkInput() {
		//检查座席组别是否输入
		if(!ConditionFields[3].getValue()) {
			Ext.Msg.alert('输入错误', '座席组别不能为空！');
			ConditionFields[3].focus();
			return false;
		}

		return true;
	}
	
	Ext.onReady(function(){

		Ext.QuickTips.init();

		// 时间
		QueryConditionFields.push(new Ext.app.rec.DateRangeField({
			fieldLabel: '提交时间'
		}));

		// 提交人列表
		QueryConditionFields.push(
			new Ext.app.qa.InspectorTwinTriggerField({
				name: 'qaCaseUserId',
				width: 530,
				fieldLabel: '提交人',
				privilegeKey: 'QA_CASE_SUBMIT'
			})
		);
		
		// 质检案例属性
		QueryConditionFields.push(
			new Ext.app.qa.QACaseAttributeTwinTriggerField({
				name: 'qaCaseAttribute',
				width: 530,
				fieldLabel: '案例属性'
			})
		);

		// 部门
		QueryConditionFields.push(
			new Ext.app.ux.DictSelector({
				fieldLabel: '座席组别',
				width: 530,
				dictType: 'QA_ITEM_GROUP',
				hidden: false,
				name: 'deptId',
				showEmpty: false,
				defaultValue: 'default',
				listeners: {
					'select': function(obj, record, idx) {
						QueryConditionFields[4].setGroupTypeId(obj.getValue());
						QueryConditionFields[4].setValue('');
						QueryConditionFields[4].val = new Array();
						QueryConditionFields[4].rawval = new Array();
						QueryConditionFields[4].show();
						QueryConditionFields[5].setGroupTypeId(obj.getValue());
						QueryConditionFields[5].setValue('');
						QueryConditionFields[5].val = new Array();
						QueryConditionFields[5].rawval = new Array();
						QueryConditionFields[5].show();
					}
				}
			})
		);
		
		// 质检案例大类
		QueryConditionFields.push(
			new Ext.app.qa.QACaseType0TwinTriggerField({
				name: 'qaCaseType',
				width: 530,
				fieldLabel: '案例大类',
				groupTypeId: '',
				hidden: true
			})
		);
		
		// 质检案例类型
		QueryConditionFields.push(
			new Ext.app.qa.QACaseTypeTwinTriggerField({
				name: 'qaCaseType',
				width: 530,
				fieldLabel: '案例类型',
				groupTypeId: '',
				hidden: true
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

			// 案例状态（只查询已审核记录）
			QueryConditionFields.push(
				new Ext.app.common.Arg('qaCaseStatus', 'CHECKED')
			);
			
			for(var i=0; i < QueryConditionFields.length; i++) {
				ConditionFields.push(QueryConditionFields[i]);
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
								
								if(!checkInput()) {
									return;
								}

								obj.targetTab.add({
									title: '查询结果',
									iconCls: 'gridbtn',
									margins:'0 0 0 0',
									autoScroll:true,
									autoWidth:true,
									closable:true,
									html:'<iframe src="qa-case-result.jsp" border=0 width="100%" height="100%" frameborder="no" scrolling="auto"></iframe>'
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
