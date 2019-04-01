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
	<title>实时统计</title>

	<link rel="stylesheet" type="text/css" href="../css/ext-all.css" />

    <link rel="stylesheet" type="text/css" href="../css/common.css" />
    <link rel="stylesheet" type="text/css" href="../css/icon.css" />
    <link rel="stylesheet" type="text/css" href="../ux/css/DateTimePicker.css" />

	<script >
		var webRoot = '<%=webRoot%>';
	</script>

<script type="text/javascript" src="../js/ext-base.js"></script>
<script type="text/javascript" src="../js/ext-all.js"></script>
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

<script type="text/javascript">
	
	var chart;

	var maxCount = 20*6;

	var lastCalls = 0, calls = 0;

	var first = true;

	var timeArray = new Array();

	var pcallsArray = new Array();

	var callsArray = new Array();

	var series = [{
		type: 'spline',
		color:'#4572A7',
		name: '并发量',
		data: pcallsArray
	}, {
		type: 'column',
		color:'#80699B',
		name: '呼叫量',
		data: callsArray
	}];
	
	Ext.onReady(function(){

		var datastore_task = {
			run: function() {
				//store.load();
				//chart.series[0].addPoint(['100', '20'], true, false);
				//chart.series[1].addPoint(['100', '30'], true, false);
				if(first) {
					first = false;
					return;
				}

				Ext.Ajax.request({
					url: window.webRoot + 'LogServer/RealStat',
					success: function(response,options) {
						var respText = Ext.util.JSON.decode(response.responseText);
						if(respText.code == 'OK') {

							if(timeArray.length >= maxCount) {
								timeArray.shift();
							}
							timeArray.push(respText.data.TIME);

							if(pcallsArray.length >= maxCount) {
								pcallsArray.shift();
							}
							pcallsArray.push(respText.data.PARALLEL_CALLS);
							
							calls = respText.data.CALLS;
							if(lastCalls == 0) {
								calls = 0;
							} else {
								calls = calls - lastCalls;
							}
							
							lastCalls = respText.data.CALLS;

							if(callsArray.length >= maxCount) {
								callsArray.shift();
							}
							callsArray.push(calls);

							if(top.Ext.getCmp('tabApps').getActiveTab().title == '呼叫监控' && parent.logtab.getActiveTab().id == 'tabStatic') {
								chart.draw();
							}
						}
					},
					failure: function(response,options) {
					}
				});
			},
			interval: 5 * 1000
		};

		Ext.TaskMgr.start(datastore_task);

		Ext.QuickTips.init();

		chart = new Ext.ux.HighChart({
            region: 'center',
			series: series,
			title : 'VP 接入量实时统计',
			width : document.body.clientWidth,
			height : document.body.clientHeight,
			animShift: true,
			chartConfig : {
				chart : {
					defaultSeriesType : 'line',
					margin : [50, 150, 60, 80]
				},
				global: {
					useUTC: false
				},
				title : {
					text : 'AVP 监控',
					margin: 5,
					style : {
						color: '#0000FF',
						fontSize: '13px'
					}
				},
				subtitle : {
					text : '呼叫量及并发量实时统计',
					style : {
					}
				},
				xAxis : {
					categories: timeArray,
					labels: {
						formatter:function() {
							if(this.value > 1000000) {
								var vDate = new Date(this.value);
								var vHour = vDate.getHours() < 10 ? "0" + vDate.getHours() : vDate.getHours();
								var vMins = vDate.getMinutes() < 10 ? "0" + vDate.getMinutes() : vDate.getMinutes();
								var vSecs = vDate.getSeconds() < 10 ? "0" + vDate.getSeconds() : vDate.getSeconds();
								return vDate.getSeconds() < 5 || (vDate.getSeconds() < 35 && vDate.getSeconds() > 30) ? vHour + ":" + vMins + ":" + vSecs : "";
							}
						},
						rotation: -45,
						align: 'right',
						style: {
							fontSize: '11px',
							fontFamily: 'Verdana, sans-serif'
						}
					},
					title : {
						text : '时 间'
					}
				},
				yAxis : {
					title : {
						text : '数 量'
					},
					min: 0,
					allowDecimals:false
				},
				tooltip : {
					formatter : function() {
						if(this.x > 100000) {
							var vDate = new Date(this.x);
							return '<b>'
									+ this.series.name
									+ '</b><br/>'
									+ Highcharts.dateFormat('%Y-%m-%d %H:%M:%S', vDate)
									+ '</b><br/>'
									+ Highcharts.numberFormat(this.y, 0);
						}
					}
				},
				legend : {
					layout : 'vertical',
					style : {
						left : 'auto',
						bottom : 'auto',
						right : '10px',
						top : '100px'
					}
				}
			}
		});		

		var viewport = new Ext.Viewport({
			layout: 'border',
			autoHeight: true,
			border: false,
			items: [chart]
		});

//		infotab.collapse(true);
	});
	</script>
</head>
</html>
