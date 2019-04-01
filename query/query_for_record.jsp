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
    <script type="text/javascript" src="../js/func.js"></script>
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
    <script type="text/javascript" src="../js/app/rec/DateTypeField.js"></script>
    <script type="text/javascript" src="../js/app/rec/DateRangeField.js"></script>
    <script type="text/javascript" src="../js/app/rec/DateRangeTypeField.js"></script>
    <script type="text/javascript" src="../js/app/mgr/AgentUserSelectorGrid.js"></script>
    <script type="text/javascript" src="../js/app/mgr/AgentUserSelectorWindow.js"></script>
    <script type="text/javascript" src="../js/app/rec/AgentTwinTriggerField.js"></script>
    <script type="text/javascript" src="../js/app/mgr/DepartmentSelectorTreePanel.js"></script>
    <script type="text/javascript" src="../js/app/mgr/DepartmentSelectorWindow.js"></script>
    <script type="text/javascript" src="../js/app/rec/DepartmentTwinTriggerField.js"></script>
    <script type="text/javascript" src="../js/app/rec/CallTimeRangeField.js"></script>
	<script type="text/javascript" src="../js/colmun/Record_Query_Only.js"></script>
    <script type="text/javascript">

	var tabCount = 1;

	var ConditionFields = new Array();

	var QueryConditionFields = new Array();

	var QAConditionFields = new Array();

	Ext.onReady(function(){

		Ext.QuickTips.init();

		// 时间范围类型
		QueryConditionFields.push(new Ext.app.rec.DateRangeTypeField({
			fieldLabel: '时间范围'
		}));

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

  		// 座席号码
		QueryConditionFields.push(
				new Ext.app.common.TextField({
					width: 530,
					fieldLabel: '座席号码',
					name: 'agentId'
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

		// 座席
	/*
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

		//全局号码（不区分主被叫）
		QueryConditionFields.push(
				new Ext.app.common.TextField({
					width: 530,
					fieldLabel: '全局号码',
					name: 'telephone'
				})
			);
		// 录音编号
		QueryConditionFields.push(
			new Ext.app.common.TextField({
				width: 530,
				fieldLabel: '录音编号',
				name: 'callId'
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
		// 路由点
		QueryConditionFields.push(
			new Ext.app.rec.RoutePointTwinTriggerField({
				name: 'rpNo',
				width: 530,
				fieldLabel: '路由点'
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
	*/
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



	/**-------------------------拷贝自result_for_record.jsp------------start---------*/
	/**-------------------------用于查询条件必填项的检测提示---------------------*/
	var searchTab = parent.frames['searchTab'];

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
	/**-------------------------拷贝自result_for_record.jsp--------end-------------*/


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
								//保存当前已勾选的显示列
								var cols = new Array();
								for(var i=0; i<Colmuns.length; i++) {
									if(Colmuns[i].checked) {
										cols.push(Colmuns[i].value + ':true' + ':' + Colmuns[i].boxLabel);
									} else {
										cols.push(Colmuns[i].value + ':false' + ':' + Colmuns[i].boxLabel);
									}
								}

								Ext.Ajax.request({
									url: window.webRoot + 'Columns/QA/RecQuery',
									method: 'POST',
									params: {
										cols: cols
									},
									success: function(response,options) {
									},
									failure: function(response,options) {
									}
								});
								var Conditions = cacheCondition();
								var beginTime = "";
								var endTime = "";
								var dnis = "";
								for(var i=0; i<Conditions.length; i++) {
									var key = Conditions[i].key;
									var val = Conditions[i].val;
									if("beginTime" === key){
										beginTime = val;
									}
									if("endTime" === key){
										endTime = val;
									}
									if("dnis" === key){
										dnis = val;
									}
								}
								if(!beginTime || !endTime || !dnis){
									alert("开始时间、结束时间以及被叫号码都为必填项，请重新输入查询条件");
								}else if(beginTime && endTime && dnis){
									obj.targetTab.add({
										title: '查询结果',
										iconCls: 'gridbtn',
										margins:'0 0 0 0',
										autoScroll:true,
										autoWidth:true,
										closable:true,
										html:'<iframe src="result_for_record.jsp" border=0 width="100%" height="100%" frameborder="no" scrolling="auto"></iframe>'
									}).show();
								}
							}/* ,
							'render':function(obj,e){
								console.log("##################");
							} */
						}
				})
			]
		});

		//显示已保存的勾选的显示列
		var t;
		Ext.Ajax.request({
			url: window.webRoot + 'Columns/QA/RecQuery',
			method: 'GET',
			success: function(response,options) {
				var respText = Ext.util.JSON.decode(response.responseText);
				if(respText.code == 'OK') {
					Ext.each(respText.data, function(col) {
						for(var i=0; i<Colmuns.length; i++) {
							if(col.name == Colmuns[i].value) {
								if(col.value == 'true') {
									Colmuns[i].setValue(true);
								}
								if(col.value == 'false') {
									Colmuns[i].setValue(false);
								}
							}
						}
					});
				}
			},
			failure: function(response,options) {
			}
		});

	});
	</script>

</head>
<body>
	<div id="save-win" class="x-hidden"></div>
</body>
</html>
