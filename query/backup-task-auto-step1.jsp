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
    <title>自动备份任务-Step2</title>

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
	<script type="text/javascript" src="../js/func.js"></script>
    <script type="text/javascript">

	var ConditionFields = new Array();
 
	var QueryConditionFields = new Array();
	
	var SampleConditionFields = new Array();

	var tabStep0 = parent.frames['tabStep0'];

	function closeStep() {
		tabStep0.enable();
		parent.assignTab.remove(parent.assignTab.getActiveTab());
	}
	
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

	Ext.onReady(function(){

		Ext.QuickTips.init();

		// 相对时间范围
		QueryConditionFields.push(
			new Ext.app.ux.DictSelector({
				width: 530,
				dictType: 'RELATIVE_TIME_TYPE',
				fieldLabel: '时间范围',
				name: 'relativeTimeType',
				showEmpty: false,
				defaultValue: 'default'
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

			// 时间范围类型
			QueryConditionFields.push(
				new Ext.app.common.Arg('dateRangeType', 'Relative')
			);

			// 开始时间
			QueryConditionFields.push(
				new Ext.app.common.Arg('beginTime', '2010-01-01 00:00:00')
			);

			// 结束时间
			QueryConditionFields.push(
				new Ext.app.common.Arg('endTime', '2010-01-01 00:00:00')
			);
			
			for(var i=0; i < QueryConditionFields.length; i++) {
				ConditionFields.push(QueryConditionFields[i]);
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
					id: 'btnStep0',
					iconCls: 'leftbtn',
					text: '上一步',
					listeners:
						{
							'click': function(obj, e) {
								//如何第三步存在，则直接显示第一步
								if(parent.frames['tabStep2']) {
									if(parent.frames['tabStep0']) {
										//如果第一步页面已经存在，则直接显示
										parent.assignTab.setActiveTab(0);
									}
								} else {
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
						}
				}),
				new Ext.Toolbar.Button({
					iconCls: 'rightbtn',
					text: '下一步',
					targetTab: parent.assignTab,
					listeners:
						{
							'click': function(obj, e) {
								disable();
								
								if(parent.frames['tabStep2']) {
									//如果第二步页面已经存在，则直接显示
									parent.assignTab.setActiveTab(2);
								} else {
									obj.targetTab.add({
										title: 'Step3:设置分配方式',
										iconCls: 'gridbtn',
										margins:'0 0 0 0',
										autoScroll:true,
										autoWidth:true,
										closable:false,
										html:'<iframe name=tabStep2 src="backup-task-auto-step2.jsp" border=0 width="100%" height="100%" frameborder="no" scrolling="auto"></iframe>'
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
	});
	</script>

</head>
<body>
	<div id="save-win" class="x-hidden"></div>
</body>
</html>
