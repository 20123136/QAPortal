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
	var timeTypeValue = 'Day';
	var defaultBeginTime ;
	var defaultEndTime ;

	var xCount = 0;

	Ext.onReady(function(){

		var store = new Ext.data.JsonStore({
			root: 'data',
			totalProperty: 'total',
			remoteSort: false,

			fields: [ 
				{ name: 'Time', type: 'datetime', mapping :'Time'},
				{ name: 'Normal', type: 'int' , mapping :'Normal'},
				{ name: 'VIP', type: 'int' , mapping :'VIP'},
				{ name: 'Platinum', type: 'int' , mapping :'Platinum'},
				{ name: 'Point', type: 'int' , mapping :'Point'},
				{ name: 'Overall', type: 'int', mapping :'Overall' }
			],

			proxy: new Ext.data.HttpProxy({
				url: window.webRoot + 'LogServer/Report/Max'
			})
		});

		store.load();

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
					type: 'line',
					dataIndex: 'Overall',
					color: '#4572A7',
					name: '总呼叫量'
				}, {
					type: 'line',
					dataIndex: 'Normal',
					color: '#AA4643',
					name: '金普卡专线'
				}, {
					type: 'line',
					dataIndex: 'VIP',
					color: '#89A54E',
					name: 'VIP专线'
				}, {
					type: 'line',
					dataIndex: 'Platinum',
					color: '#80699B',
					name: '白金专线'
				}, {
					type: 'line',
					dataIndex: 'Point',
					color: '#3D96AE',
					name: '积分专线'
				}
			],
			chartConfig : {
				chart : {
					defaultSeriesType : 'line',
					margin : [50, 150, 60, 80]
				},
				title : {
					text : 'AVP 报表',
					margin: 5,
					style : {
						color: '#0000FF',
						fontSize: '13px'
					}
				},
				subtitle : {
					text : '并发量统计报表'
				},
				xAxis : [{
					title : {
						text : '时 间'
					},
					labels: {
						rotation: -45,
						align: 'right',
						style: {
							fontSize: '11px',
							fontFamily: 'Verdana, sans-serif'
						},
						formatter: function() {
							if(this.value > 100000) {
								var vDate = new Date(this.value);
								if(timeTypeValue =='Day'){
									return Highcharts.dateFormat('%Y-%m-%d', this.value);
								} else if(timeTypeValue =='Hour') {
									if(vDate.getHours() % 4 == 0) {
										return Highcharts.dateFormat('%H:%M', this.value);
									} else {
										return "";
									}
								} else if(timeTypeValue =='Min') {
									if(vDate.getMinutes() % 30 == 0) {
										return Highcharts.dateFormat('%H:%M', this.value);
									} else {
										return "";
									}
								}
//								return Highcharts.dateFormat('%Y-%m-%d %H:%M:%S', this.value); // clean, unformatted number for year
								xCount++;
							} else {
								return '';
							}
						}
					}
				}],
				yAxis : [{
					title : {
						text : '数 量'
					},
					min: 0,
					allowDecimals:false
				}],
				tooltip : {
					formatter : function() {
						if(timeTypeValue =='Day'){
							return '<b>'
								+ this.series.name
								+ '</b><br/>'
								+ Highcharts.dateFormat('%Y-%m-%d ', this.x)
								+ '</b><br/>'
								+ Highcharts.numberFormat(this.y, 0);
						} else {
							return '<b>'
								+ this.series.name
								+ '</b><br/>'
								+ Highcharts.dateFormat('%Y-%m-%d %H:%M:00', this.x)
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
		  
		series = chart1.series;
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
						dataIndex: 'Time',
						renderer: function (val) {
							if(timeTypeValue =='Day'){   
								return Ext.util.Format.date(new Date(parseInt(val)),'Y-m-d')
							} else if(timeTypeValue =='Hour') {
								return Ext.util.Format.date(new Date(parseInt(val)),'Y-m-d H:00:00')
							} else if(timeTypeValue =='Min') {
								return Ext.util.Format.date(new Date(parseInt(val)),'Y-m-d H:i:00')
							}
						}
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
				// autoHeight: false,
				height: 424,
				width: '100%',
				viewConfig: {forceFit:true},
				loadMask: true
			});
		
		var tabs2 = new Ext.TabPanel({
				region: 'center',	
				border: false,			
				activeTab: 0,
				width:'100%',
				height:'100%',
				plain:true,
				// defaults:{autoScroll: true},
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
		defaultBeginTime = new Date().add(Date.DAY, -30);
		defaultBeginTime.setHours(0);
		defaultBeginTime.setMinutes(0);
		defaultBeginTime.setSeconds(0);
		defaultEndTime = new Date();
		defaultEndTime.setHours(23);
		defaultEndTime.setMinutes(59);
		defaultEndTime.setSeconds(59);
		
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
					id: 'DefaultTime',
					bodyStyle:'padding:4px 0px 0px 0px',
					width: 320,
					height: 65,
					defaults: {width: 180},
					items: [
						new Ext.form.DateField({
							fieldLabel: '开始时间',
							name:'startTime',
							id: 'startTime',
							format: 'Y-m-d H:i:s',
							value:defaultBeginTime,
							enableKeyEvents: true,
							clearCls:'allow-float',
							allowBlank:false,
							listeners:{    //鼠标事件
								change : function(textfield, val, val2){ 
									if(timeTypeValue == 'Day'){
										val = val.add(Date.DAY, 30);
										val.setHours(23);
										val.setMinutes(59);
										val.setSeconds(59);
										Ext.getCmp("endTime").setValue(val);
									} else if(timeTypeValue == 'Hour' || timeTypeValue == 'Min'){
										val.setHours(23);
										val.setMinutes(59);
										val.setSeconds(59);
										Ext.getCmp("endTime").setValue(val);
									}
								}
							}
						}),	new Ext.form.DateField({
							fieldLabel: '结束时间',
							name:'endTime',
							id: 'endTime',
							value:defaultEndTime,
							format: 'Y-m-d H:i:s',
							enableKeyEvents: true,
							clearCls:'allow-float',
							allowBlank:false
							// listeners:{    //鼠标事件
								// change : function(textfield, val, val2){ 
									// if(timeTypeValue == 'Hour' || timeTypeValue == 'Min'){
										// Ext.getCmp("startTime").setValue(val);
										// val.setHours(23);
										// val.setMinutes(59);
										// val.setSeconds(59);
										// Ext.getCmp("endTime").setValue(val);
									// }
								// }
							// }
						})
					]
				}),
				'-',
				new Ext.FormPanel({
					labelWidth: 65,
					frame: true,
					bodyStyle:'padding:4px 0px 0',
					width: 330,
					height: 65,
					defaults: {width: 240},
					defaultType: 'datefield',
					items: [
					{
						xtype: 'radiogroup',
						fieldLabel: '报表类型',
						clearCls:'allow-float',
						id: 'timeType',
						items: [
							{boxLabel: '日报表', name: 'rb-auto', inputValue: 'Day' , checked: true,
							  listeners:{    //鼠标事件
									'check' : function(textfield, checked){        
										if(checked){   //点击时触发 
											timeTypeValue = 'Day';
											defaultBeginTime = Ext.getCmp('startTime').getValue();
											defaultEndTime = defaultBeginTime.add(Date.DAY, 30);
											defaultEndTime.setHours(23);
											defaultEndTime.setMinutes(59);
											defaultEndTime.setSeconds(59);
											Ext.getCmp("endTime").setValue(defaultEndTime)
										}
									}
								}
							},
							{boxLabel: '时报表', name: 'rb-auto', inputValue: 'Hour',
							  listeners:{    //鼠标事件
									'check' : function(textfield, checked){        
										if(checked ){   //点击时触发 
											timeTypeValue = 'Hour';
											defaultBeginTime = Ext.getCmp('startTime').getValue();
											defaultEndTime = defaultBeginTime;
											defaultEndTime.setHours(23);
											defaultEndTime.setMinutes(59);
											defaultEndTime.setSeconds(59);
											Ext.getCmp("endTime").setValue(defaultEndTime);
										}
									}
								}
							},
							{boxLabel: '15分钟报表', name: 'rb-auto', inputValue: 'Min',
							  listeners:{    //鼠标事件
									'check' : function(textfield, checked){        
										if(checked){   //点击时触发 
											timeTypeValue = 'Min';
											defaultBeginTime = Ext.getCmp('startTime').getValue();
											defaultEndTime = defaultBeginTime;
											defaultEndTime.setHours(23);
											defaultEndTime.setMinutes(59);
											defaultEndTime.setSeconds(59);
											Ext.getCmp("endTime").setValue(defaultEndTime);
										}
									}
								}
							}
						]
					}]
				}),
				'-',
				new Ext.FormPanel({
					labelWidth: 65,
					frame: true,
					bodyStyle:'padding:4px 0px 0',
					width: 330,
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
							clearCls:'allow-float',
							columns: 3,
							items: [
								{ boxLabel: '总呼叫量', name: 'rb', inputValue: 'Overall', clearCls:'allow-float', checked: true},
								{ boxLabel: 'VIP专线', name: 'rb', inputValue: 'VIP', clearCls:'allow-float', checked: false},
								{ boxLabel: '积分专线', name: 'rb', inputValue: 'Point', clearCls:'allow-float', checked: false},
								{ boxLabel: '金普卡专线', name: 'rb', inputValue: 'Normal', clearCls:'allow-float', checked: true },
								{ boxLabel: '白金专线', name: 'rb', inputValue: 'Platinum', clearCls:'allow-float', checked: false }
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
								xCount = 0;
								store.removeAll();
								tabs2.setActiveTab(0);
								store.load();
							}
						}
				})	
			],
			 items:[tabs2]
		});
			
		store.on('beforeload', function(loader, node) {
			var startTime = Ext.getCmp('startTime').getRawValue();
			var endTime = Ext.getCmp('endTime').getRawValue();
			//报表类型
			var timeType = Ext.getCmp('timeType').items;	
			for (var i = 0; i < timeType.length; i++) {    
				if (timeType.itemAt(i).checked) {    				
					timeTypeValue = timeType.itemAt(i).inputValue;
				}    
			}
					
			//业务类型
			var typeValue = Ext.getCmp('type').items;		
			var type = '';		
			chart1.addSeries(series, true);
			var group = new Array();
			for (var i = 0; i < typeValue.length; i++) {  
				type = typeValue.itemAt(i).inputValue;
				if (typeValue.itemAt(i).checked) {  
					group[type] = true;
					Ext.getCmp('call_table').getColumnModel().setHidden(i+2, false)	
				} else {
					group[type] = false;
					Ext.getCmp('call_table').getColumnModel().setHidden(i+2, true);
				}
			}
			
			for (var i = chart1.series.length - 1; i >= 0; i--) {  
				type = chart1.series[i].dataIndex;
				if(!group[type]){
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
