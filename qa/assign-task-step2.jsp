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
    <title>质检分配</title>

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
    <script type="text/javascript" src="../js/app/qa/InspectorSelectorGrid.js"></script>
    <script type="text/javascript" src="../js/app/qa/InspectorSelectorEditorGrid.js"></script>
    <script type="text/javascript" src="../js/app/qa/InspectorSelectorWindow.js"></script>
    <script type="text/javascript" src="../js/app/qa/InspectorTwinTriggerField.js"></script>
	<script type="text/javascript" src="../js/func.js"></script>
    <script type="text/javascript">

	var tabCount = 1;

	var ConditionFields = new Array();

	var SampleConditionFields = new Array();

	var Conditions;

	var tabStep1 = parent.frames['tabStep1'];

	function cacheCondition() {
		var conds = new Array();

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

	function closeStep() {
		tabStep1.enable();
		parent.assignTab.remove(parent.assignTab.getActiveTab());
	}

	function disable() {
		Ext.each(SampleConditionFields, function(item) {
			item.disable();
		});
	}

	function enable() {
		Ext.each(SampleConditionFields, function(item) {
			item.enable();
		});
	}

	function checkInput() {
		//检查可分配的记录是否有效
		if(parseInt(Ext.getDom('spanSampleTotalCount').innerHTML) <= 0) {
			Ext.Msg.alert('操作失败', '没有可分配的录音记录！');
			return false;
		}

		//如果选择了平均分配
		if(SampleConditionFields[0].getValue()) {
			if(!SampleConditionFields[1].getVal() || SampleConditionFields[1].getVal().length == 0) {
				Ext.Msg.alert('操作失败', '没有分配录音记录！');
				return false;
			}
		}
		if(SampleConditionFields[2].getValue()) {
			if(!SampleConditionFields[3].getVal() || SampleConditionFields[3].getVal().length == 0) {
				Ext.Msg.alert('操作失败', '没有分配录音记录！');
				return false;
			}
		}

		return true;
	}

	var myMask;

	Ext.onReady(function(){

		Ext.QuickTips.init();
	
		Conditions = cacheCondition();

		// 分配方式
		SampleConditionFields.push(new Ext.app.common.Radio({
			fieldLabel: '分配方式',
			boxLabel: '平均分配',
			name: 'assignType',
			value: 'Average',
			checked: true,
			listeners: {
				'check' : function(obj, checked) {
					if(checked) {
						obj.ownerCt.find('name', 'qaUserAverage')[0].enable();
						obj.ownerCt.find('name', 'qaUserManual')[0].disable();
					}
				}
			}
		}));

		// 分配方式
		SampleConditionFields.push(
			new Ext.app.qa.InspectorTwinTriggerField({
				name: 'qaUserAverage',
				width: 530,
				fieldLabel: '',
				privilegeKey: 'QAUSER_FLAG',
				showmode: 'AssignView'
			})
		);

		// 分配方式
		SampleConditionFields.push(new Ext.app.common.Radio({
			fieldLabel: '',
			boxLabel: '指定分配',
			name: 'assignType',
			value: 'Manual',
			listeners: {
				'check' : function(obj, checked) {
					if(checked) {
						obj.ownerCt.find('name', 'qaUserAverage')[0].disable();
						obj.ownerCt.find('name', 'qaUserManual')[0].enable();
					}
				}
			}
		}));

		// 分配方式
		SampleConditionFields.push(
			new Ext.app.qa.InspectorTwinTriggerField({
				name: 'qaUserManual',
				width: 530,
				fieldLabel: '',
				disabled: true,
				privilegeKey: 'QAUSER_FLAG',
				showmode: 'AssignEdit'
			})
		);
		
		var fieldSets = new Array();

		fieldSets.push(
			new Ext.form.FieldSet({
				title: '抽样信息',
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
								'<td width=100 align=left>总&nbsp;&nbsp;记&nbsp;&nbsp;录&nbsp;&nbsp;数: </td>' + 
								'<td width=135 align=left><span id=spanTotalCount style="color:blue;">0</span></td>' + 
								'<td width=445 align=left><font color=#FF9900>*</font>&nbsp;&nbsp;<font color=#3399FF>符合抽样查询条件的所有录音记录总数（包含已质检和已分配录音记录）</font></td>' + 
								'</tr>' +
								'<tr>' +
								'<td width=100 align=left>未分配的记录数: </td>' + 
								'<td width=135 align=left><span id=spanTotalAvailCount style="color:blue;">0</span></td>' + 
								'<td width=445 align=left><font color=#FF9900>*</font>&nbsp;&nbsp;<font color=#3399FF>符合抽样查询条件的且未质检，未被分配的记录总数</font></td>' + 
								'</tr>' +
								'<tr>' +
								'<td width=100 align=left>抽&nbsp;&nbsp;样&nbsp;&nbsp;方&nbsp;&nbsp;式: </td>' + 
								'<td width=135 align=left><span id=spanSampleType style="color:blue;"></span></td>' + 
								'<td width=445 align=left><font color=#FF9900>*</font>&nbsp;&nbsp;<font color=#3399FF>上一步选择的质检抽样方式</font></td>' + 
								'</tr>' +
								'<tr>' +
								'<td width=100 align=left>最终抽样记录数: </td>' + 
								'<td width=135 align=left><span id=spanSampleTotalCount style="color:blue;">0</span></td>' + 
								'<td width=445 align=left><font color=#FF9900>*</font>&nbsp;&nbsp;<font color=#3399FF>按照已选择抽样方式计算出的抽样记录总数</font></td>' + 
								'</tr>' +
							   '</table>'
					}
				]
			})
		);

		if(SampleConditionFields.length > 0) {
			fieldSets.push(
				new Ext.form.FieldSet({
					title: '分配方式',
					collapsible: true,
					collapsed: false,
					autoHeight: true,
					items: SampleConditionFields
				})
			);
			for(var i=0; i < SampleConditionFields.length; i++) {
				ConditionFields.push(SampleConditionFields[i]);
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
								//如何第三步存在，则直接显示第一步
								if(parent.frames['tabStep3']) {
									if(parent.frames['tabStep1']) {
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
					id: 'btnComplete',
					iconCls: 'completebtn',
					text: '完&nbsp;&nbsp;成',
					targetTab: parent.assignTab,
					listeners:
						{
							'click': function(obj, e) {
								//如果Step4已经存在则直接显示
								if(parent.frames['tabStep3']) {
									parent.assignTab.setActiveTab(3);
									return;
								}

								if(!checkInput()) {
									return;
								}

								disable();

								obj.targetTab.add({
									title: 'Step4:完成分配',
									iconCls: 'completebtn',
									margins:'0 0 0 0',
									autoScroll:true,
									autoWidth:true,
									html:'<iframe name=tabStep3 src="assign-task-step3.jsp" border=0 width="100%" height="100%" frameborder="no" scrolling="auto"></iframe>'
								}).show();
							}
						}
				})
			]
		});
		
		/** 抽样查询 Start */
		myMask = new Ext.LoadMask(form.getEl(), {msg:"查询中请等待..."});
		myMask.show();
		
		if(parent.frames['tabStep3']) {
			disable();
		}

		Ext.Ajax.request({
			url: window.webRoot + 'Report/RecordDetails/TotalStat',
			method: 'POST',
			params: getParamsArray(),
			success: function(response,options) {
				var respText = Ext.util.JSON.decode(response.responseText);
				myMask.hide();
				if(respText.code != 'OK') {
					Ext.Msg.alert('查询失败', respText.message + "（" + respText.code + "）");
					disable();
				} else {
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

					SampleConditionFields[1].sampleCount = sampleCount;
					SampleConditionFields[3].sampleCount = sampleCount;
				}
			},
			failure: function(response,options) {
				Ext.Msg.alert('查询失败', '查询抽样记录失败！');
				myMask.hide();
				disable();
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
