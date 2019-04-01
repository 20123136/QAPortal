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
    <title>自动备份任务-Step3</title>

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
    <script type="text/javascript" src="../js/app/common/Radio.js"></script>
    <script type="text/javascript" src="../js/app/common/Arg.js"></script>
    <script type="text/javascript" src="../js/app/common/Radio.js"></script>
    <script type="text/javascript" src="../js/app/common/Checkbox.js"></script>
	<script type="text/javascript" src="../js/app/rec/FileServerSelector.js"></script>
	<script type="text/javascript" src="../js/func.js"></script>
    <script type="text/javascript">

	var tabCount = 1;

	var ConditionFields = new Array();

	var BackupConditionFields = new Array();

	var Conditions;

	var tabStep1 = parent.frames['tabStep1'];

	function closeStep() {
		tabStep1.enable();
		parent.assignTab.remove(parent.assignTab.getActiveTab());
	}

	function disable() {
		Ext.each(BackupConditionFields, function(item) {
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
		Ext.each(BackupConditionFields, function(item) {
			try
			{
				item.enable();
			}
			catch (e)
			{
			}
		});
	}

	function checkInput() {
		//如果选择了平均分配
		if(!BackupConditionFields[0].getValue()) {
			Ext.Msg.alert('操作失败', '没有选择目标文件服务器！');
			return false;
		}
		return true;
	}

	var myMask;

	Ext.onReady(function(){

		Ext.QuickTips.init();

		// 分配方式
		BackupConditionFields.push(new Ext.app.rec.FileServerSelector({
			name: 'fileServerId',
			fieldLabel: '目标文件服务器',
			width: 530
		}));

		// 删除源文件
		BackupConditionFields.push(new Ext.app.common.Checkbox({
			name: 'delSourceFile',
			width: 530,
			value: 'Y',
			boxLabel: '备份完成后删除原始录音文件'
		}));

		// 发送邮件报告
		BackupConditionFields.push(new Ext.app.common.Checkbox({
			name: 'sendReport',
			width: 530,
			value: 'Y',
			boxLabel: '备份完成后发送报告（Email）'
		}));
		
		//发送微信报告
		BackupConditionFields.push(new Ext.app.common.Checkbox({
			name: 'sendWechat',
			width: 530,
			value: 'Y',
			boxLabel: '备份完成后发送报告（wechat）'
		}));

		var fieldSets = new Array();

		if(BackupConditionFields.length > 0) {
			fieldSets.push(
				new Ext.form.FieldSet({
					title: '备份方式',
					collapsible: true,
					collapsed: false,
					autoHeight: true,
					items: BackupConditionFields
				})
			);
			for(var i=0; i < BackupConditionFields.length; i++) {
				ConditionFields.push(BackupConditionFields[i]);
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
					id: 'btnStep1',
					iconCls: 'leftbtn',
					text: '上一步',
					targetTab: tabStep1,
					listeners:
						{
							'click': function(obj, e) {
								//如何上一步存在，则直接显示第一步
								if(parent.frames['tabStep3']) {
									if(parent.frames['tabStep1']) {
										//如果第一步页面已经存在，则直接显示
										parent.assignTab.setActiveTab(1);
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
					id: 'btnStep3',
					iconCls: 'rightbtn',
					text: '下一步',
					targetTab: parent.assignTab,
					listeners:
						{
							'click': function(obj, e) {
								//如果Step3已经存在则直接显示
								if(parent.frames['tabStep3']) {
									parent.assignTab.setActiveTab(3);
									return;
								}

								if(!checkInput()) {
									return;
								}

								disable();

								obj.targetTab.add({
									title: 'Step4:设置执行计划',
									iconCls: 'clockbtn',
									margins:'0 0 0 0',
									autoScroll:true,
									autoWidth:true,
									html:'<iframe name=tabStep3 src="backup-task-auto-step3.jsp" border=0 width="100%" height="100%" frameborder="no" scrolling="auto"></iframe>'
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
