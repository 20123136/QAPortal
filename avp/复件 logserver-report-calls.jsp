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
<script type="text/javascript" src="../js/highcharts.js"></script>
<!-- ExtJS Plugin for Highcharts -->
<script type="text/javascript" src="../js/Ext.ux.HighChart.js"></script>
<script type="text/javascript" src="../js/highcharts.src.js"></script>

<script type="text/javascript">
	var pagesize = 50;
	var grid;
	var chart1;

	Ext.onReady(function(){

		var store = new Ext.data.JsonStore({
			root: 'data',
			totalProperty: 'total',
			remoteSort: false,

			fields: [ 
				{ name: 'Time', type: 'String'},
				{ name: 'Normal', type: 'int' },
				{ name: 'VIP', type: 'int' },
				{ name: 'Platinum', type: 'int' },
				{ name: 'Point', type: 'int' },
				{ name: 'Overall', type: 'int' }
			],

			proxy: new Ext.data.HttpProxy({
				url: window.webRoot + 'LogServer/Report/Calls' 
			})
		});

		store.load();

		// Ext.QuickTips.init();	

		var chart1 = new Ext.ux.HighChart({
			id: 'highChart_clume',
			title: 'VP 呼入量统计',
			width:'100%',
			autoHeight: '100%',
			border: false,
			// height: 424,
			layout: 'border',
			region: 'center',
			store: store,
			animShift: true,
			xField: 'Time',
			series: [
				{
					type: 'column',
					dataIndex: 'Overall',
					name: '总呼叫量'
				}, {
					type: 'column',
					dataIndex: 'Normal',
					name: '金普卡专线',
					id: 'normal'
				}, {
					type: 'column',
					dataIndex: 'VIP',
					name: 'VIP专线'
				}, {
					type: 'column',
					dataIndex: 'Platinum',
					name: '白金专线'
				}, {
					type: 'column',
					dataIndex: 'Point',
					name: '积分专线'
				}
			],
			chartConfig : {
				chart : {
					defaultSeriesType : 'line',
					margin : [50, 150, 60, 80]
				},
				title : {
					text : 'VP',
					style : {
						margin : '10px 100px 0 0' // center
													// it
					}
				},
				subtitle : {
					text : '呼入量统计',
					style : {
						margin : '0 100px 0 0' // center
												// it
					}
				},
				xAxis : [{
					title : {
						text : '时间'
					},
					labels: {
						rotation: -45,
						align: 'right',
						style: {
							fontSize: '11px',
							fontFamily: 'Verdana, sans-serif'
						}
					}
				}],
				yAxis : [{
					title : {
						text : '数量'
					}
				}],
				tooltip : {
					formatter : function() {
						return '<b>'
								+ this.series.name
								+ '</b><br/>'
								+ Highcharts.dateFormat('%Y-%m-%d %H:%M:%S', this.x)
								+ '</b><br/>'
								+ Highcharts.numberFormat(this.y, 0);
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
		  
		grid = new Ext.grid.GridPanel({
				id: 'call_table',
				region: 'center',		
				store: store,
				border: false,
				columns: [
					new Ext.grid.RowNumberer(),
					{
						header   : '时间',
						width    : .2,
						sortable : false,
						dataIndex: 'Time'
					},
					{
						header   : '总呼叫量',
						width    : .2,
						sortable : false,
						dataIndex: 'Overall'
					},
					{
						header   : '金普卡专线',
						width    : .2,
						sortable : false,
						dataIndex: 'Normal'
					},
					{
						header   : 'VIP专线',
						width    : .2,
						sortable : false,
						dataIndex: 'VIP'
					},
					{
						header   : '白金专线',
						width    : .2,
						sortable : false,
						dataIndex: 'Platinum'
					},
					{
						header   : '积分专线',
						width    : .2,
						sortable : false,
						dataIndex: 'Point'
					}
				],
				stripeRows: true,
				autoHeight: '100%',
				// height: 424,
				width: '100%',
				viewConfig: {forceFit:true},
				loadMask: true,

				bbar: new Ext.PagingToolbar({
					plugins: [new Ext.ui.plugins.ComboPageSize({ addToItem: false, prefixText: '每页', postfixText: '条'})],
					pageSize: pagesize,
					store: store,
					displayInfo: true,
					displayMsg: '当前显示第 <font color="blue">{0}</font> 到 <font color="blue">{1}</font> 条记录， 共 <font color="blue">{2}</font> 条记录',
					emptyMsg: "无记录"
				})
			});
		
		var tabs2 = new Ext.TabPanel({
				region: 'center',	
				border: false,			
				activeTab: 0,
				width:'100%',
				height:'100%',
				plain:true,
				defaults:{autoScroll: true},
				items:[{
						title: '图表显示',
						items:[chart1]
					},{
						title: '列表显示',
						items:[grid]
					}
				]
			});
		
		/** 移除为空的业务类型 */
		
		/** 查询 Start */
		var panel_query = new Ext.Panel({
			id: 'panel_query_id',
			layout: 'border',
			region: 'center', 
			autoScroll:false,
			iconCls: 'searchbtn',
			border: false,
			tbar: [		
				new Ext.FormPanel({
					labelWidth: 65,
					frame: true,
					bodyStyle:'padding:4px 0px 0px 4px',
					width: 300,
					height: 65,
					defaults: {width: 175},
					defaultType: 'datefield',
					items: [
						new Ext.form.DateField({
							fieldLabel: '开始时间',
							name:'startTime',
							id: 'startTime',
							format: 'Y-m-d H:i:s',
							enableKeyEvents: true,
							allowBlank:false,
						}),	new Ext.form.DateField({
							fieldLabel: '结束时间',
							name:'endTime',
							id: 'endTime',
							format: 'Y-m-d H:i:s',
							enableKeyEvents: true,
							allowBlank:false,
						})
					]
				}),
				'-',
				new Ext.FormPanel({
					labelWidth: 55,
					frame: true,
					bodyStyle:'padding:4px 0px 0',
					width: 320,
					height: 65,
					defaults: {width: 240},
					defaultType: 'datefield',
					items: [
					{
						xtype: 'radiogroup',
						fieldLabel: '报表类型',
						id: 'timeType',
						items: [
							{boxLabel: '日报表', name: 'rb-auto', inputValue: 'Day'},
							{boxLabel: '时报表', name: 'rb-auto', inputValue: 'Hour', checked: true},
							{boxLabel: '15分钟报表', name: 'rb-auto', inputValue: 'Min'}
							
						]
					}]
				}),
				'-',
				new Ext.FormPanel({
					labelWidth: 55,
					frame: true,
					bodyStyle:'padding:4px 0px 0',
					width: 300,
					height: 65,
					defaults: {width: 240},
					defaultType: 'checkbox',
					fieldLabel: 'Multi-Column (horizontal)',
					xtype: 'fieldset',
					//autoHeight: true,		
					items: [
						{
							xtype: 'checkboxgroup',
							fieldLabel: '业务类型',
							id: 'type',
							name: 'type',				
							columns: 3,
							items: [
								{ boxLabel: '总呼叫量', name: 'rb', inputValue: 'total' , checked: true},
								{ boxLabel: 'VIP专线', name: 'rb', inputValue: 'vip' , checked: true},
								{ boxLabel: '积分专线', name: 'rb', inputValue: 'point' , checked: true},
								{ boxLabel: '金普卡专线', name: 'rb', inputValue: 'normal', checked: true },
								{ boxLabel: '白金专线', name: 'rb', inputValue: 'platinum', checked: true }
							]
						}
					]
				}),
				'-',
				new Ext.Toolbar.Button({
					id: 'btnSearch',
					iconCls: 'searchbtn',
					height: 65,
					text: '查询',
					listeners: 
						{'click': function(obj, e) {
								store.removeAll();
								store.load();
							}
						}
				})	
			],
			 items:[tabs2]
		});
			
		series = chart1.series;
		store.on('beforeload', function(loader, node) {
			var startTime = Ext.getCmp('startTime').getValue();
			var endTime = Ext.getCmp('endTime').getValue();
			
			//报表类型
			var timeType = Ext.getCmp('timeType').items;	
			var timeTypeValue;
			for (var i = 0; i < timeType.length; i++) {    
				if (timeType.itemAt(i).checked) {    				
					timeTypeValue = timeType.itemAt(i).inputValue;
				}    
			}
					
			//业务类型
			var typeValue = Ext.getCmp('type').items;		
			var type = '';		
			chart1.addSeries(series,true);
			var group = new Array();
			for (var i = 0; i < typeValue.length; i++) {  
				if (typeValue.itemAt(i).checked) {  
					type += ';' + typeValue.itemAt(i).inputValue;
					group.push(i);
					Ext.getCmp('call_table').getColumnModel().setHidden(i+2, false)	
				} else {
					Ext.getCmp('call_table').getColumnModel().setHidden(i+2, true);
					// var chart = Ext.getCmp('highChart_clume').highcharts();
					// var chart = chart1.highcharts();
					// chart1.removeAllSeries();
					group.push(5);
					 // chart1.removeSerie(i,true);
					// Ext.getCmp('highChart_clume').chartConfig.series[1].hide()
				}
			}
			
			for (var i = 4; i > -1; i--) {  
				if(group[i]==5){
					chart1.removeSerie(i,true);
				}
			}
			
			store.baseParams = {startTime:startTime, endTime:endTime, timeTypeValue:timeTypeValue, type:type}
		});
		/** 查询 End */	
	
		var viewport = new Ext.Viewport({
				layout: 'border',
				region : 'center',
				autoHeight: true,
				border: false,				
				items: [panel_query]
		});			
//		infotab.collapse(true);
	});
	</script>
</head>
</html>
