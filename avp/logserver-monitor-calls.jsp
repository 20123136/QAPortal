<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Expires", "0");

	request.setCharacterEncoding("UTF-8");

	String webRoot = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";

%>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>端口监控</title>

	<link rel="stylesheet" type="text/css" href="../css/ext-all.css" />

    <link rel="stylesheet" type="text/css" href="../css/common.css" />
    <link rel="stylesheet" type="text/css" href="../css/icon.css" />
    <link rel="stylesheet" type="text/css" href="../ux/css/DateTimePicker.css" />

	<script >
		var webRoot = '<%=webRoot%>';
	</script>
    <style type="text/css">
        .x-props-grid {
            padding:0px;
        }
    </style>
<script type="text/javascript" src="../js/ext-base.js"></script>
<script type="text/javascript" src="../js/ext-all-debug.js"></script>
<script type="text/javascript" src="../js/ext-lang-zh_CN.js"></script>
<script type="text/javascript" src="../js/ext-ui-combo-pagesize.js"></script>
<script type="text/javascript" src="../ux/DateTimeField.js"></script>
<script type="text/javascript" src="../js/func.js"></script>
<!-- ExtJS adapter for Highcharts -->
<script type="text/javascript" src="../js/adapter-extjs.js"></script>
<!-- Highcharts includes -->
<script type="text/javascript" src="../js/highcharts.src.js"></script>
<!-- ExtJS Plugin for Highcharts -->
<script type="text/javascript" src="../js/Ext.ux.HighChart.js"></script>
<script type="text/javascript" src="../js/app/avp/StatChart.js"></script>
<script type="text/javascript">
	var curId = 0;
	var win;
	var pagesize = 50;
	var grid;
	var form;
	var actiontype = "";
	var propsGrid;

	var stat_tpl = new Ext.Template([
		'<br/>',
		'&nbsp;&nbsp;当前呼叫总数&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;<b>{ActiveCalls}</b><br/>',
		'<br/>',
		'&nbsp;&nbsp;当日呼叫总数&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;<b>{TodayCalls}</b><br/>',
		'<br/>',
		'&nbsp;&nbsp;当日最大并发量&nbsp;:&nbsp;&nbsp;&nbsp;<b>{TodayPCalls}</b> ({TodayPCalls_Time})<br/>',
		'<br/>',
		'&nbsp;&nbsp;累计呼叫总数&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;<b>{Calls}</b><br/>',
		'<br/>',
		'&nbsp;&nbsp;累计最大并发量&nbsp;:&nbsp;&nbsp;&nbsp;<b>{PCalls}</b> ({PCalls_Time})<br/>',
		'<br/>'
	]);

	var chart;

	function showBusiness(value, metaData, record, rowIndex, colIndex, store) {
		var val = record.get('BUSINESSTYPE');
		if(val == 'Normal') {
			metaData.attr = 'style="color:#0033CC;"';
		} else if (val == 'VIP') {
			metaData.attr = 'style="color:#FFCC00;"';
		} else if (val == 'Platinum') {
			metaData.attr = 'style="color:#FFCC00;"';
		} else if (val == 'Point') {
			metaData.attr = 'style="color:#33CC00;"';
		}
		return value;
	}

	function showStatus(value, metaData, record, rowIndex, colIndex, store) {
		if(record.get('STATUS') == '0') {
			metaData.attr = 'style="color:#008000;"';
			return '通话中';
		} else if (record.get('STATUS') == '1') {
			metaData.attr = 'style="color:#808080;"';
			return '已结束';
		}
		return value;
	}
	
	var statFields = [
				   {name: 'Business'},
				   {name: 'Normal'},
				   {name: 'Satisfaction'},
				   {name: 'TransferIVR'},
				   {name: 'ConferenceIVR'},
				   {name: 'VoiceMail'},
				   {name: 'VoiceMailRTT'},
				   {name: 'Total'}
				];
	
	var totalFields = [
				   {name: 'key'},
				   {name: 'value'}
				];
	
	var functionTotal = new Array();
	
	var statData = [{
			Business: '金普线',
			Normal: 0,
			Satisfaction: 0,
			TransferIVR: 0,
			ConferenceIVR: 0,
			VoiceMail: 0,
			VoiceMailRTT: 0,
			Total: 0
		}, {
			Business: '白金专线',
			Normal: 0,
			Satisfaction: 0,
			TransferIVR: 0,
			ConferenceIVR: 0,
			VoiceMail: 0,
			VoiceMailRTT: 0,
			Total: 0
		}, {
			Business: 'VIP专线',
			Normal: 0,
			Satisfaction: 0,
			TransferIVR: 0,
			ConferenceIVR: 0,
			VoiceMail: 0,
			VoiceMailRTT: 0,
			Total: 0
		}, {
			Business: '积分专线',
			Normal: 0,
			Satisfaction: 0,
			TransferIVR: 0,
			ConferenceIVR: 0,
			VoiceMail: 0,
			VoiceMailRTT: 0,
			Total: 0
		}, {
			Business: '合计',
			Normal: 0,
			Satisfaction: 0,
			TransferIVR: 0,
			ConferenceIVR: 0,
			VoiceMail: 0,
			VoiceMailRTT: 0,
			Total: 0
		}
	];
	var statStore = new Ext.data.JsonStore({
		fields: statFields,
		data: statData
	});
	
	var totalData = [{
			key: '当前呼叫总数',
			value: 0
		}, {
			key: '当日呼叫总数',
			value: 0
		}, {
			key: '当日最大并发量',
			value: ''
		}, {
			key: '累计呼叫总数',
			value: 0
		}, {
			key: '累计最大并发量',
			value: ''
		}
	];

	var totalStore = new Ext.data.JsonStore({
		fields: totalFields,
		data: totalData
	});

	function loadStat() {
		Ext.Ajax.request({
			url: window.webRoot + 'LogServer/Stats',
			success: function(response,options) {
				var respText = Ext.util.JSON.decode(response.responseText);
				if(respText.code == 'OK') {
					//stat_tpl.overwrite(Ext.getCmp('stat-panel').body, respText.data);
					//当前呼叫总数
					totalData[0].value = respText.data.ActiveCalls;
					//当日呼叫总数
					totalData[1].value = respText.data.TodayCalls;
					//当日最大并发量
					totalData[2].value = respText.data.TodayPCalls + '  (' + respText.data.TodayPCalls_Time + ')';
					//累计呼叫总数
					totalData[3].value = respText.data.Calls;
					//累计最大并发量
					totalData[4].value = respText.data.PCalls + '  (' + respText.data.PCalls_Time + ')';

					totalStore.loadData(totalData);
					
					//正常进线
					functionTotal['Normal'] = 0;
					functionTotal['Normal'] += respText.data.Normal.normalCalls;
					functionTotal['Normal'] += respText.data.Platinum.normalCalls;
					functionTotal['Normal'] += respText.data.Point.normalCalls;
					functionTotal['Normal'] += respText.data.VIP.normalCalls;
					
					//满意度
					functionTotal['Satisfaction'] = 0;
					functionTotal['Satisfaction'] += respText.data.Normal.satisfactionCalls;
					functionTotal['Satisfaction'] += respText.data.Platinum.satisfactionCalls;
					functionTotal['Satisfaction'] += respText.data.Point.satisfactionCalls;
					functionTotal['Satisfaction'] += respText.data.VIP.satisfactionCalls;
					
					//转接IVR
					functionTotal['TransferIVR'] = 0;
					functionTotal['TransferIVR'] += respText.data.Normal.transferIVRCalls;
					functionTotal['TransferIVR'] += respText.data.Platinum.transferIVRCalls;
					functionTotal['TransferIVR'] += respText.data.Point.transferIVRCalls;
					functionTotal['TransferIVR'] += respText.data.VIP.transferIVRCalls;
					
					//会议IVR
					functionTotal['ConferenceIVR'] = 0;
					functionTotal['ConferenceIVR'] += respText.data.Normal.conferenceIVRCalls;
					functionTotal['ConferenceIVR'] += respText.data.Platinum.conferenceIVRCalls;
					functionTotal['ConferenceIVR'] += respText.data.Point.conferenceIVRCalls;
					functionTotal['ConferenceIVR'] += respText.data.VIP.conferenceIVRCalls;
					
					//语音留言
					functionTotal['VoiceMail'] = 0;
					functionTotal['VoiceMail'] += respText.data.Normal.voiceMailCalls;
					functionTotal['VoiceMail'] += respText.data.Platinum.voiceMailCalls;
					functionTotal['VoiceMail'] += respText.data.Point.voiceMailCalls;
					functionTotal['VoiceMail'] += respText.data.VIP.voiceMailCalls;
					
					//语音留言RTT
					functionTotal['VoiceMailRTT'] = 0;
					functionTotal['VoiceMailRTT'] += respText.data.Normal.voiceMailRTTCalls;
					functionTotal['VoiceMailRTT'] += respText.data.Platinum.voiceMailRTTCalls;
					functionTotal['VoiceMailRTT'] += respText.data.Point.voiceMailRTTCalls;
					functionTotal['VoiceMailRTT'] += respText.data.VIP.voiceMailRTTCalls;
					
					//合计
					functionTotal['Total'] = 0;
					functionTotal['Total'] += respText.data.ActiveNormalCalls;
					functionTotal['Total'] += respText.data.ActivePlatinumCalls;
					functionTotal['Total'] += respText.data.ActiveVIPCalls;
					functionTotal['Total'] += respText.data.ActivePointCalls;

					//金普线
					statData[0].Normal = respText.data.Normal.normalCalls;
					statData[0].Satisfaction = respText.data.Normal.satisfactionCalls;
					statData[0].TransferIVR = respText.data.Normal.transferIVRCalls;
					statData[0].ConferenceIVR = respText.data.Normal.conferenceIVRCalls;
					statData[0].VoiceMail = respText.data.Normal.voiceMailCalls;
					statData[0].VoiceMailRTT = respText.data.Normal.voiceMailRTTCalls;
					statData[0].Total = respText.data.ActiveNormalCalls;

					//白金专线
					statData[1].Normal = respText.data.Platinum.normalCalls;
					statData[1].Satisfaction = respText.data.Platinum.satisfactionCalls;
					statData[1].TransferIVR = respText.data.Platinum.transferIVRCalls;
					statData[1].ConferenceIVR = respText.data.Platinum.conferenceIVRCalls;
					statData[1].VoiceMail = respText.data.Platinum.voiceMailCalls;
					statData[1].VoiceMailRTT = respText.data.Platinum.voiceMailRTTCalls;
					statData[1].Total = respText.data.ActivePlatinumCalls;

					//VIP专线
					statData[2].Normal = respText.data.VIP.normalCalls;
					statData[2].Satisfaction = respText.data.VIP.satisfactionCalls;
					statData[2].TransferIVR = respText.data.VIP.transferIVRCalls;
					statData[2].ConferenceIVR = respText.data.VIP.conferenceIVRCalls;
					statData[2].VoiceMail = respText.data.VIP.voiceMailCalls;
					statData[2].VoiceMailRTT = respText.data.VIP.voiceMailRTTCalls;
					statData[2].Total = respText.data.ActiveVIPCalls;

					//积分专线
					statData[3].Normal = respText.data.Point.normalCalls;
					statData[3].Satisfaction = respText.data.Point.satisfactionCalls;
					statData[3].TransferIVR = respText.data.Point.transferIVRCalls;
					statData[3].ConferenceIVR = respText.data.Point.conferenceIVRCalls;
					statData[3].VoiceMail = respText.data.Point.voiceMailCalls;
					statData[3].VoiceMailRTT = respText.data.Point.voiceMailRTTCalls;
					statData[3].Total = respText.data.ActivePointCalls;

					//合计
					statData[4].Normal = functionTotal['Normal'];
					statData[4].Satisfaction = functionTotal['Satisfaction'];
					statData[4].TransferIVR = functionTotal['TransferIVR'];
					statData[4].ConferenceIVR = functionTotal['ConferenceIVR'];
					statData[4].VoiceMail = functionTotal['VoiceMail'];
					statData[4].VoiceMailRTT = functionTotal['VoiceMailRTT'];
					statData[4].Total = functionTotal['Total'];

					statStore.loadData(statData);
				} else {
				}
			},
			failure: function(response,options) {
			}
		});
	}

	var fields = [
				   {name: 'ENTERTIME'},
				   {name: 'HUNGTIME'},
				   {name: 'SERVER'},
				   {name: 'CHANNEL'},
				   {name: 'ANI'},
				   {name: 'DNIS'},
				   {name: 'BUSINESSTYPE'},
				   {name: 'BUSINESSTYPE_NAME'},
				   {name: 'FUNCTIONTYPE'},
				   {name: 'FUNCTIONTYPE_NAME'},
				   {name: 'CUSTOMERTYPE'},
				   {name: 'CUSTOMERTYPE_NAME'},
				   {name: 'CARDNO'},
				   {name: 'DISPLAY_TIMES'},
				   {name: 'TIMES'},
				   {name: 'MENU_NAME'},
				   {name: 'MENU'},
				   {name: 'STATUS'},
				   {name: 'LAST_ACTIVE_TIME'}
				];

	Ext.override(Ext.grid.GridView, {  
		scrollTop : function() {  
			this.scroller.dom.scrollTop = 0;  
			this.scroller.dom.scrollLeft = 0;  
		},  
		scrollToTop : Ext.emptyFn  
	}); 

	Ext.onReady(function(){

		var store = new Ext.data.JsonStore({
			root: 'data',
			totalProperty: 'total',
			remoteSort: false,

			fields: fields,

			proxy: new Ext.data.HttpProxy({
				url: window.webRoot + 'LogServer/Calls/Active'
			})
		});

		store.setDefaultSort('ENTERTIME', 'asc');

		grid = new Ext.grid.GridPanel({
            region: 'center',
			store: store,
			border: false,
			title: '呼叫列表',
			columns: [
				new Ext.grid.RowNumberer(),
				{
					header   : '服务器',
					width    : .1,
					sortable : false,
					dataIndex: 'SERVER'
				},
				{
					header   : '端口号',
					width    : .1,
					sortable : false,
					dataIndex: 'CHANNEL'
				},
				{
					header   : '开始时间',
					width    : .1,
					sortable : false,
					dataIndex: 'ENTERTIME'
				},
				{
					header   : '持续时间',
					width    : .1,
					sortable : false,
					dataIndex: 'DISPLAY_TIMES'
				},
				{
					header   : '状态',
					width    : .1,
					sortable : false,
					renderer : showStatus,
					dataIndex: 'STATUS'
				},
				{
					header   : '主叫号码',
					width    : .1,
					sortable : false,
					dataIndex: 'ANI'
				},
				{
					header   : '被叫号码',
					width    : .1,
					sortable : false,
					dataIndex: 'DNIS'
				},
				{
					header   : '业务类型',
					width    : .1,
					sortable : false,
					renderer : showBusiness,
					dataIndex: 'BUSINESSTYPE_NAME'
				},
				{
					header   : '客户类型',
					width    : .1,
					sortable : false,
					dataIndex: 'CUSTOMERTYPE_NAME'
				},
				{
					header   : '进线类型',
					width    : .1,
					sortable : false,
					dataIndex: 'FUNCTIONTYPE_NAME'
				},
				{
					header   : '卡号',
					width    : .1,
					sortable : false,
					dataIndex: 'CARDNO'
				},
				{
					header   : '当前菜单',
					width    : .1,
					sortable : false,
					dataIndex: 'MENU_NAME'
				},
				{
					header   : '最后活动时间',
					width    : .1,
					sortable : false,
					dataIndex: 'LAST_ACTIVE_TIME'
				}
			],
			stripeRows: true,
			height: 600,
			width: '100%',
			viewConfig: {forceFit:true},
			loadMask: false
		});

		grid.addListener('rowdblclick', function(obj, e) {
			var rec = grid.getSelectionModel().getSelected();
			parent.logtab.add({
				title: rec.get('SERVER') + '/' + rec.get('CHANNEL') + '/' + rec.get('ENTERTIME'),
				iconCls: 'txtbtn',
				margins:'0 0 0 0',
				autoScroll:true,
				autoWidth:true,
				closable:true,
				html:'<iframe src="logserver-view.jsp?time=' + rec.get('ENTERTIME') + '&server=' + rec.get('SERVER') + '&channel=' + rec.get('CHANNEL') + '" border=0 width="100%" height="100%" frameborder="no" scrolling="auto"></iframe>'
			}).show();
		});

		statGrid = new Ext.grid.GridPanel({
			title: '业务呼叫统计',
			store: statStore,
			border: false,
			columns: [
				{
					header   : '业务类型',
					width    : .1,
					sortable : false,
					dataIndex: 'Business'
				},
				{
					header   : '正常进线',
					width    : .1,
					sortable : false,
					dataIndex: 'Normal'
				},
				{
					header   : '满意度',
					width    : .1,
					sortable : false,
					dataIndex: 'Satisfaction'
				},
				{
					header   : '转接IVR',
					width    : .1,
					sortable : false,
					dataIndex: 'TransferIVR'
				},
				{
					header   : '会议IVR',
					width    : .1,
					sortable : false,
					dataIndex: 'ConferenceIVR'
				},
				{
					header   : '语音留言',
					width    : .1,
					sortable : false,
					dataIndex: 'VoiceMail'
				},
				{
					header   : '语音留言RTT',
					width    : .1,
					sortable : false,
					dataIndex: 'VoiceMailRTT'
				},
				{
					header   : '总计',
					width    : .1,
					sortable : false,
					dataIndex: 'Total'
				}
			],
			region: 'center',
			stripeRows: true,
			height: 172,
			width: 600,
			viewConfig: {forceFit:true},
			loadMask: false
		});
		
		totalGrid = new Ext.grid.GridPanel({
			title: '呼叫统计',
			store: totalStore,
			border: false,
			columns: [
				{
					header   : '指标',
					width    : .1,
					sortable : false,
					dataIndex: 'key'
				},
				{
					header   : '值',
					width    : .1,
					sortable : false,
					dataIndex: 'value'
				}
			],
			region: 'west',
			stripeRows: true,
			height: 172,
			width: 400,
			viewConfig: {forceFit:true},
			loadMask: false
		});

		panel = new Ext.Panel({
			region: 'north',
			height: 172,
			width: '100%',
			border:false,
			layout:'border',
			collapsible: false,
			items:[totalGrid, statGrid]
		});

		window.setInterval(function() {
				store.reload(store.lastOptions);
				loadStat();
			}
		, 5000);

		var viewport = new Ext.Viewport({
			layout: 'border',
			autoHeight: true,
			border: false,
			items: [panel, grid]
		});

//		infotab.collapse(true);
	});
	</script>
</head>
</html>
