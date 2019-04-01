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

	function showLevel(value, metaData, record, rowIndex, colIndex, store) {
		if(record.get('Level') == 'Normal') {
			metaData.attr = 'style="color:#008000;"';
			return '中';
		} else if (record.get('Level') == 'HIGH') {
			metaData.attr = 'style="color:#FF0000;"';
			return '高';
		}
		return value;
	}

	var fields_alert = [
				   {name: 'Time'},
				   {name: 'Alert'},
				   {name: 'Type'},
				   {name: 'Level'},
				   {name: 'Content'},
				   {name: 'LAST_ACTIVE_TIME'}
				];

	var fields_error = [
				   {name: 'Time'},
				   {name: 'Server'},
				   {name: 'Type'},
				   {name: 'Port'},
				   {name: 'Content'},
				   {name: 'LAST_ACTIVE_TIME'}
				];

	var fields_failed = [
				   {name: 'Time'},
				   {name: 'Server'},
				   {name: 'Type'},
				   {name: 'Port'},
				   {name: 'Content'},
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

		var store_alert = new Ext.data.JsonStore({
			root: 'data',
			totalProperty: 'total',
			remoteSort: false,

			fields: fields_alert,

			proxy: new Ext.data.HttpProxy({
				url: './alert.json'
			})
		});

		store_alert.setDefaultSort('Time', 'asc');

		store_alert.load();

		var store_error = new Ext.data.JsonStore({
			root: 'data',
			totalProperty: 'total',
			remoteSort: false,

			fields: fields_error,

			proxy: new Ext.data.HttpProxy({
				url: './error.json'
			})
		});

		store_error.setDefaultSort('Time', 'asc');

		store_error.load();

		var store_failed = new Ext.data.JsonStore({
			root: 'data',
			totalProperty: 'total',
			remoteSort: false,

			fields: fields_failed,

			proxy: new Ext.data.HttpProxy({
				url: './failed.json'
			})
		});

		store_failed.setDefaultSort('Time', 'asc');

		store_failed.load();

		/* 警告列表 Start */
		alertGrid = new Ext.grid.GridPanel({
            region: 'north',
			store: store_alert,
			border: false,
			title: '警告列表',
			columns: [
				new Ext.grid.RowNumberer(),
				{
					header   : '时间',
					width    : .1,
					sortable : false,
					dataIndex: 'Time'
				},
				{
					header   : '警告',
					width    : .2,
					sortable : false,
					dataIndex: 'Alert'
				},
				{
					header   : '类型',
					width    : .1,
					sortable : false,
					dataIndex: 'Type'
				},
				{
					header   : '等级',
					width    : .1,
					sortable : false,
					renderer : showLevel,
					dataIndex: 'Level'
				},
				{
					header   : '说明',
					width    : .3,
					sortable : false,
					dataIndex: 'Content'
				}
			],
			stripeRows: true,
			height: 160,
			width: '100%',
			viewConfig: {forceFit:true},
			loadMask: false
		});
		/* 警告列表 End */

		/* 异常列表 Start */
		errorGrid = new Ext.grid.GridPanel({
            region: 'center',
			store: store_error,
			border: false,
			title: '异常列表',
			columns: [
				new Ext.grid.RowNumberer(),
				{
					header   : '时间',
					width    : .1,
					sortable : false,
					dataIndex: 'Time'
				},
				{
					header   : '服务器',
					width    : .2,
					sortable : false,
					dataIndex: 'Server'
				},
				{
					header   : '类型',
					width    : .1,
					sortable : false,
					dataIndex: 'Type'
				},
				{
					header   : '端口号',
					width    : .1,
					sortable : false,
					dataIndex: 'Port'
				},
				{
					header   : '说明',
					width    : .3,
					sortable : false,
					dataIndex: 'Content'
				}
			],
			stripeRows: true,
			height: 160,
			width: '100%',
			viewConfig: {forceFit:true},
			loadMask: false
		});
		/* 异常列表 End */

		/* 错误列表 Start */
		failedGrid = new Ext.grid.GridPanel({
            region: 'south',
			store: store_failed,
			border: false,
			title: '错误列表',
			columns: [
				new Ext.grid.RowNumberer(),
				{
					header   : '时间',
					width    : .1,
					sortable : false,
					dataIndex: 'Time'
				},
				{
					header   : '服务器',
					width    : .2,
					sortable : false,
					dataIndex: 'Server'
				},
				{
					header   : '类型',
					width    : .1,
					sortable : false,
					dataIndex: 'Type'
				},
				{
					header   : '端口号',
					width    : .1,
					sortable : false,
					dataIndex: 'Port'
				},
				{
					header   : '说明',
					width    : .3,
					sortable : false,
					dataIndex: 'Content'
				}
			],
			stripeRows: true,
			height: 160,
			width: '100%',
			viewConfig: {forceFit:true},
			loadMask: false
		});
		/* 错误列表 End */
/*
		window.setInterval(function() {
				store.reload(store.lastOptions);
				loadStat();
			}
		, 5000);
*/
		var viewport = new Ext.Viewport({
			layout: 'border',
			autoHeight: true,
			border: false,
			items: [alertGrid, errorGrid, failedGrid]
		});

//		infotab.collapse(true);
	});
	</script>
</head>
</html>
