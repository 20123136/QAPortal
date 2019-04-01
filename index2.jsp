<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
	response.setHeader("Pragma","No-cache");
	response.setHeader("Cache-Control","no-cache");
	response.setHeader("Expires","0");

	request.setCharacterEncoding("UTF-8");	
	
	String webRoot = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<html>
<head>
	<title>浦发IVR管理系统</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <link rel="stylesheet" type="text/css" href="./css/ext-all.css" />
    <link rel="stylesheet" type="text/css" href="./css/common.css" />
    <link rel="stylesheet" type="text/css" href="./css/icon.css" />
    
	<script >
		var webRoot = '<%=webRoot%>';
	</script>
	<script type="text/javascript" src="../Admin/js/jquery.min.js"></script>
    <script type="text/javascript" src="./js/ext-base.js"></script>
    <script type="text/javascript" src="./js/ext-all.js"></script>
    <script type="text/javascript" src="./ux/TabCloseMenu.js"></script>
	<script type="text/javascript" src="./js/ext-lang-zh_CN.js"></script>
	<script type="text/javascript" src="./js/func.js"></script>
	
	<script type="text/javascript" src="../Admin/ux/PagingMemoryProxy.js"></script>
	
	<script type="text/javascript" src="../Admin/js/highcharts3.0.5.src.js"></script>
	<!--<script type="text/javascript" src="../Admin/js/exporting3.0.5.src.js"></script>
	 ExtJS Plugin for Highcharts -->
	<script type="text/javascript" src="../Admin/js/Ext.ux.HighChart.js"></script>
	
	<script type="text/javascript" src="../Admin/ux/MultiSelect.js"></script>
    <script type="text/javascript" src="../Admin/ux/ItemSelector.js"></script>

	<script type="text/javascript">
	var win, form, panel;
	var warnWin, warnForm;
	var showColumnForm, showColumnWin;
	function go(name) {
		var tree = Ext.getCmp('tree-panel');
		tree.items.each(function(item) { 
			item.items.each(function(item) { 
				item.items.each(function(item) { 
					if(item.text == name) item.fireEvent('click')
				});
			});
		});
	}
	
	function goHome() {
		Ext.getCmp('tabApps').setActiveTab(0)
	}
	
	function pctChange(val){
        if(val > 0){
            return '<span style="color:green;">' + val + '%</span>';
        }else if(val < 0){
            return '<span style="color:red;">' + val + '%</span>';
        }
        return val;
    }
	
	

	Ext.onReady(function(){
	
		 var myData = [
			['3m Co',71.72,0.02,0.03,'9/1 12:00am'],
			['Alcoa Inc',29.01,0.42,1.47,'9/1 12:00am'],
			['Altria Group Inc',83.81,0.28,0.34,'9/1 12:00am'],
			['American Express Company',52.55,0.01,0.02,'9/1 12:00am'],
			['American International Group, Inc.',64.13,0.31,0.49,'9/1 12:00am'],
			['AT&T Inc.',31.61,-0.48,-1.54,'9/1 12:00am'],
			['Boeing Co.',75.43,0.53,0.71,'9/1 12:00am'],
			['Caterpillar Inc.',67.27,0.92,1.39,'9/1 12:00am'],
			['Citigroup, Inc.',49.37,0.02,0.04,'9/1 12:00am'],
			['E.I. du Pont de Nemours and Company',40.48,0.51,1.28,'9/1 12:00am'],
			['Exxon Mobil Corp',68.1,-0.43,-0.64,'9/1 12:00am'],
			['General Electric Company',34.14,-0.08,-0.23,'9/1 12:00am'],
			['General Motors Corporation',30.27,1.09,3.74,'9/1 12:00am'],
			['Hewlett-Packard Co.',36.53,-0.03,-0.08,'9/1 12:00am'],
			['Honeywell Intl Inc',38.77,0.05,0.13,'9/1 12:00am'],
			['Intel Corporation',19.88,0.31,1.58,'9/1 12:00am'],
			['International Business Machines',81.41,0.44,0.54,'9/1 12:00am'],
			['Johnson & Johnson',64.72,0.06,0.09,'9/1 12:00am'],
			['JP Morgan & Chase & Co',45.73,0.07,0.15,'9/1 12:00am'],
			['McDonald\'s Corporation',36.76,0.86,2.40,'9/1 12:00am'],
			['Merck & Co., Inc.',40.96,0.41,1.01,'9/1 12:00am'],
			['Microsoft Corporation',25.84,0.14,0.54,'9/1 12:00am'],
			['Pfizer Inc',27.96,0.4,1.45,'9/1 12:00am'],
			['The Coca-Cola Company',45.07,0.26,0.58,'9/1 12:00am'],
			['The Home Depot, Inc.',34.64,0.35,1.02,'9/1 12:00am'],
			['The Procter & Gamble Company',61.91,0.01,0.02,'9/1 12:00am'],
			['United Technologies Corporation',63.26,0.55,0.88,'9/1 12:00am'],
			['Verizon Communications',35.57,0.39,1.11,'9/1 12:00am'],
			['Wal-Mart Stores, Inc.',45.45,0.73,1.63,'9/1 12:00am']
		];
		
		var store = new Ext.data.Store({
			proxy: new Ext.ux.data.PagingMemoryProxy(myData),
			remoteSort:true,
			sortInfo: {field:'price', direction:'ASC'},
			reader: new Ext.data.ArrayReader({
				fields: [
				   {name: 'company'},
				   {name: 'price', type: 'float'},
				   {name: 'change', type: 'float'},
				   {name: 'pctChange', type: 'float'},
				   {name: 'lastChange', type: 'date', dateFormat: 'n/j h:ia'}
				]
			})
		});
		var userInfo_tpl = new Ext.Template([
			'<p style="padding: 10px 0px 0px 52px;">登录坐席:</font>&nbsp;394</p>',
			'<p style="padding: 5px 0px 0px 52px;">呼入振铃:&nbsp;4</p>',
			'<p style="padding: 5px 0px 0px 52px;">呼入通话:&nbsp;235</p>',
			'<p style="padding: 5px 0px 0px 52px;">呼出拨号:&nbsp;235</p>',
			'<p style="padding: 5px 0px 0px 52px;">呼出通话:&nbsp;0</p>',
			'<p style="padding: 5px 0px 0px 78px;">空闲:&nbsp;154</p>',
			'<p style="padding: 5px 0px 0px 65px;">后处理:&nbsp;0</p>',
			'<p style="padding: 5px 0px 0px 78px;">离席:&nbsp;12</p>',
			'<p style="padding: 5px 0px 0px 52px;">坐席总数:&nbsp;604</p>'
		]);
		
		var callOutInfo_tpl = new Ext.Template([
			'<p style="padding: 10px 0px 0px 39px;">累计呼出数:&nbsp;0</p>',
			'<p style="padding: 5px 0px 0px 13px;">累计呼出通话数:&nbsp;0</p>',
			'<p style="padding: 5px 0px 0px 0px;">平均呼出通话时长:&nbsp;00:00:00</p>',
			'<p style="padding: 5px 0px 0px 0px;">累计呼出通话时长:&nbsp;00:00:00</p>',
			'<p style="padding: 5px 0px 0px 39px;">呼出接通率:&nbsp;0%</p>'
		]);
		
		var callInInfo_tpl = new Ext.Template([
			'<p style="padding: 10px 0px 0px 39px;">累计呼入数:&nbsp;171038</p>',
			'<p style="padding: 5px 0px 0px 13px;">累计呼入通话数:&nbsp;163606</p>',
			'<p style="padding: 5px 0px 0px 39px;">呼入接通率:&nbsp;95%</p>',
			'<p style="padding: 5px 0px 0px 0px;">累计呼入通话时长:&nbsp;44700:50:52</p>',
			'<p style="padding: 5px 0px 0px 39px;">累计放弃数:&nbsp;7432</p>'
			
		]);
		var call_table = new Ext.grid.GridPanel({
					id: 'call_table',
					store: store,
					stripeRows: true,
					height: 320,
					width: '100%',
					viewConfig: {forceFit:true},
					loadMask: true,
					columns: [
						// new Ext.grid.RowNumberer(),
						{
							header   : '-',
							width    : 23,
							sortable : false,
							dataIndex: 'company',
							hidden: false
						},
						{
							header   : '状态',
							width    : 23,
							sortable : false,
							dataIndex: 'price'
							// renderer: function(val){
								// if(val > 30){
									// return '<span style="color:green;">' + val + '%</span>';
								// }else if(val < 20){
									// return '<span style="color:red;">' + val + '%</span>';
								// }
								// return val;
							// }
						},
						{
							header   : '分机号',
							width    : 23,
							sortable : false,
							dataIndex: 'company'
						},
						{
							header   : '坐席组',
							width    : 23,
							sortable : false,
							dataIndex: 'company'
						},
						{
							header   : '姓名',
							width    : 23,
							sortable : false,
							dataIndex: 'company'
						},
						{
							header   : '坐席ID',
							width    : 23,
							sortable : false,
							dataIndex: 'company'
						},
						{
							header   : '持续时长',
							width    : 23,
							sortable : false,
							dataIndex: 'company'
						},
						{
							header   : '主叫号码',
							width    : 23,
							sortable : false,
							dataIndex: 'company'
						},
						{
							header   : '被叫号码',
							width    : 23,
							sortable : false,
							dataIndex: 'company'
						},
						{
							header   : '离席原因',
							width    : 23,
							sortable : false,
							dataIndex: 'company'
						},
						{
							header   : '离席数',
							width    : 23,
							sortable : false,
							dataIndex: 'company'
						},
						{
							header   : '呼叫数',
							width    : 23,
							sortable : false,
							dataIndex: 'company'
						},
						{
							header   : '呼出通话数',
							width    : 23,
							sortable : false,
							dataIndex: 'company'
						},
						{
							header   : '呼出接通率',
							width    : 23,
							sortable : false,
							dataIndex: 'company'
						},
						{
							header   : '累计呼出数',
							width    : 23,
							sortable : false,
							dataIndex: 'company'
						},
						{
							header   : '呼入数',
							width    : 23,
							sortable : false,
							dataIndex: 'company'
						}
					]
				});
		
		var admin_table = new Ext.grid.GridPanel({
					id: 'admin_table',
					border: false,
					store: store,
					width: '100%',
					height:'100%',
					columns: [
						new Ext.grid.RowNumberer(),
						{
							header   : 'NO.',
							width    : 23,
							sortable : false,
							dataIndex: 'price'
						},{
							header   : '组名称',
							width    : 23,
							sortable : false,
						},{
							header   : '组描述',
							width    : 23,
							sortable : false,
						},{
							header   : '登陆数',
							width    : 23,
							sortable : false,
							// dataIndex: 'VIP'
						},{
							header   : '空闲数',
							width    : 23,
							sortable : false,
							dataIndex: 'price'
						},{
							header   : '离席数',
							width    : 23,
							sortable : false,
							dataIndex: 'price'
						},{
							header   : '呼入通话数',
							width    : 23,
							sortable : false,
							dataIndex: 'price'
						},{
							header   : '累计呼出数',
							width    : 23,
							sortable : false,
							dataIndex: 'price'
						},{
							header   : '累计呼出通话数',
							width    : 23,
							sortable : false,
							dataIndex: 'price'
						},{
							header   : '呼出接通率',
							width    : 23,
							sortable : false,
							dataIndex: 'price'
						},{
							header   : '累计呼出通话时长',
							width    : 23,
							sortable : false,
							dataIndex: 'price'
						}
					],
					stripeRows: true,
					height: 200,
					width: '100%',
					viewConfig: {forceFit:true},
					loadMask: true
				});

		var skill_table = new Ext.grid.GridPanel({
					id: 'skill_table',
						border: false,
					store: store,
					width: '100%',
					height:'100%',
					columns: [
						new Ext.grid.RowNumberer(),
						{
							header   : 'NO.',
							width    : 23,
							sortable : false,
							dataIndex: 'price'
						},{
							header   : 'ACDID',
							width    : 23,
							sortable : false,
							// dataIndex: 'Normal'
						},{
							header   : 'ACDm名称',
							width    : 23,
							sortable : false,
							// dataIndex: 'VIP'
						},{
							header   : '空闲数',
							width    : 23,
							sortable : false,
							// dataIndex: 'VIP'
						},{
							header   : '排队数',
							width    : 23,
							sortable : false,
							dataIndex: 'price'
						},{
							header   : '登陆数',
							width    : 23,
							sortable : false,
							dataIndex: 'price'
						}
					],
					stripeRows: true,
					height: 200,
					width: '100%',
					viewConfig: {forceFit:true},
					loadMask: true
				});

		var chart = new Ext.ux.HighChart({
			id: 'highChart_clume',
			title: 'VP 呼入量统计',
			width: 300,
			height: 225,
			animShift: true,
			xField: 'Time',
			series: [
				{
					type: 'column',
					dataIndex: 'Overall',
					color: '#4572A7',
					name: '接入',
					data: [50]
				}, {
					type: 'column',
					dataIndex: 'Normal',
					color: '#AA4643',
					name: '呼出',
					data: [30],
					visibility :"hidden"
				}, {
					type: 'column',
					dataIndex: 'VIP',
					color: '#89A54E',
					data: [60],
					name: '空闲'
				}, {
					type: 'column',
					// dataIndex: 'Platinum',
					data: [6],
					color: '#80699B',
					name: '后处理'
				}, {
					type: 'column',
					// dataIndex: 'Point',
					data: [2],
					color: '#3D96AE',
					name: '离席'
				}, {
					type: 'column',
					// dataIndex: 'Point',
					data: [20],
					color: '#3D96AE',
					name: '未登录'
				}
			],
			chartConfig : {
				chart : {
					defaultSeriesType : 'line',
				},
			    exporting: {
					url: window.webRoot + 'LogServer/Down',
					type:'image/png'//导出的文件类型
			    },
				title : {
					text : '坐席状态百分率图',
					style : {
						color: '#0000FF',
						fontSize: '11px'
					}
				},
				
				xAxis: {
					categories: ['状态']
				},
			
				yAxis : [{
					title : {
						text : '数 量 (%)',
						style : {
						color: '#0000FF',
						fontSize: '11px'
						}
					},
					formatter : function() {
						return this.y + '%'
					}
				}],
				tooltip : {
					formatter : function() {
						return '<b>'
							+ this.series.name
							+ '</b><br/>'
							+ this.y + '%' ;
					}
				},
				tooltip : {
				
				}
			}
		});	
		  
		
        var viewport = new Ext.Viewport({
            layout: 'border',
			autoHeight: true,
            items: [
				new Ext.BoxComponent({
					region: 'north',
					margins: '0 0 -3 0',
					height: 62,
					border: false,
					contentEl: 'layout-title'
				}), {
					region: 'west',
					width: 220,
					height:500,
					margins: '0 2 0 0',
					items:[
						{
							region: 'south',
							id: 'user-info',
							height:230,
							width: 220,
							title:"坐席状态统计",
							border:false,
							bodyStyle: {
								background: '#ffffff',
								padding: '7px',
								align: 'right',
								font: '10pt 仿宋'
							},
							collapsible: true
						},{
							region: 'south',
							id: 'callOut-info',
							height:160,
							width: 220,
							title:"今日呼出累计数据",
							iconCls: 'userinfo',
							border:false,
							bodyStyle: {
								background: '#ffffff',
								padding: '7px',
								font: '10pt 仿宋'
							},
							collapsible: true
						},{
							region: 'south',
							id: 'callInt-info',
							height:180,
							width: 220,
							title:"今日呼入累计数据",
							iconCls: 'userinfo',
							border:false,
							bodyStyle: {
								background: '#ffffff',
								padding: '7px',
								font: '10pt 仿宋'
							},
							collapsible: true
						}
					]
				},{
					region: 'center',
					width: '100%',
					height:500,
					xtype: 'tabpanel', // TabPanel itself has no title
					items:[
						new Ext.Panel({
							width: '100%', 
							id: 'center',
							title: '监控系统',
							items:[call_table,
								new Ext.Panel({
								width: '100%',
								height:300,
								align:'right',
								layout: 'table',
								items: [
									new Ext.TabPanel({
										activeTab: 0,
										xtype: 'tabpanel',
										id : 'TabPanel1',
										height: '100%',
										width: 850,
										height:300,
										items: [{
											title: '行政组',
											height: '100%',
											items:[admin_table]
										},{
											title: '技能组',
											items:[skill_table]
										}]
									})
									,new Ext.TabPanel({
										id : 'TabPanel2',
										height:'100%',
										width: 300,
										height:300,
										activeTab: 0,
										items: [{
											title: '坐席状态百分率图',
											items:[chart]
										}]
									})
								]	
							})
							]
						}),
					]
				}
			]
        });
		
		var sm = new Ext.grid.CheckboxSelectionModel();
	
		var skill_choose = new Ext.grid.GridPanel({
			id: 'skill_choose',
			border: false,
			store: store,
			width: '100%',
			height:'100%',
			selModel: sm,
			stripeRows: true,
			height: 280,
			viewConfig: {forceFit:true},
			loadMask: true,
			columns: [
				sm, 
				new Ext.grid.RowNumberer(),
				{
					header   : 'ACDID',
					width    : 23,
					sortable : false,
					dataIndex: 'price'
				},{
					header   : 'ACD名称',
					width    : 23,
					sortable : false,
					// dataIndex: 'Normal'
				}
			],
			buttons: [{
				text: '保&nbsp;存',
				handler: function() {
					if(form.form.isValid()) {
						var values = form.getForm().getValues();
						if(values.newpwd != values.renewpwd) {
							Ext.Msg.alert('输入错误', '两次输入的新密码不一致！');
						} else {
							form.form.submit({
								url: './rest/user/password',
								method: 'POST',
								params: {
									_method: 'PUT'
								},
								success: function(form, action) {
									Ext.Msg.alert('保存成功', '密码修改成功！');
									win.hide();
								},
								failure: function(form, action) {
									switch (action.failureType) {
										case Ext.form.Action.CLIENT_INVALID:
											Ext.Msg.alert('保存失败', '数据字段格式错误！');
											break
										case Ext.form.Action.CONNECT_FAILURE:
											Ext.Msg.alert('保存失败', '连接异常！');
											break
										case Ext.form.Action.SERVER_INVALID:
										   Ext.Msg.alert('保存失败', action.result.msg)
								   }
								},
								waitMsg: '数据保存中，请稍候...'
							});
						}
					} else {
						Ext.Msg.alert('提示', '请填写完整再提交！')
					}
				}
			},{
				text: '取&nbsp;消',
				handler: function() {
					win.hide();
				}
			}]
		});
	
		<!-- 技能组选择 start-->
		form = new Ext.FormPanel({
			frame:true,
			defaultType: 'textfield',
			items: [skill_choose],

			buttons: [{
				text: '保&nbsp;存',
				handler: function() {
					if(form.form.isValid()) {
						var values = form.getForm().getValues();
						if(values.newpwd != values.renewpwd) {
							Ext.Msg.alert('输入错误', '两次输入的新密码不一致！');
						} else {
							form.form.submit({
								url: './rest/user/password',
								method: 'POST',
								params: {
									_method: 'PUT'
								},
								success: function(form, action) {
									Ext.Msg.alert('保存成功', '密码修改成功！');
									win.hide();
								},
								failure: function(form, action) {
									switch (action.failureType) {
										case Ext.form.Action.CLIENT_INVALID:
											Ext.Msg.alert('保存失败', '数据字段格式错误！');
											break
										case Ext.form.Action.CONNECT_FAILURE:
											Ext.Msg.alert('保存失败', '连接异常！');
											break
										case Ext.form.Action.SERVER_INVALID:
										   Ext.Msg.alert('保存失败', action.result.msg)
								   }
								},
								waitMsg: '数据保存中，请稍候...'
							});
						}
					} else {
						Ext.Msg.alert('提示', '请填写完整再提交！')
					}
				}
			},{
				text: '取&nbsp;消',
				handler: function() {
					win.hide();
				}
			}]
		});
		
		win = new Ext.Window({
			width: 520,
			height:325,
			closeAction:'hide',
			modal: true,
			plain: true,
			iconCls: "addbtn",
			items: [form]
		});
		
		<!-- 技能组选择 end-->
		var hour = new Array();
		hour.push(1);
		hour.push(2);
		
		<!-- 显示列 start-->
		// chooseColumn
		var chooseColumn = new Ext.data.ArrayStore({
			data: [],
			fields: ['value','text'],
			sortInfo: {
				field: 'value',
				direction: 'ASC'
			}
		});
		
		var noChooseColumn = new Ext.data.ArrayStore({
			data: [['1','状态'],
				['2', '分机号'], ['3', '坐席'], ['4', '姓名'], ['5', 'Five'],
				['6', 'Six'], ['7', 'Seven'], ['8', 'Eight'], ['9', 'Nine']],
			fields: ['value','text'],
			sortInfo: {
				field: 'value',
				direction: 'ASC'
			}
		});
		
		showColumnForm = new Ext.form.FormPanel({
			title: '<div align="center">定制查询结果</div>',
			width: '100%',
			bodyStyle: 'padding:15px 10px 15px 10px;',
			items:[{
				xtype: 'itemselector',
				name: 'itemselector',
				iconUp:"up2.gif",
				iconDown:"down2.gif",
				iconLeft:"left2.gif",
				iconRight:"right2.gif",
				iconTop:"top2.gif",
				iconBottom:"bottom2.gif",
				drawUpIcon:false,
				drawDownIcon:false,
				drawLeftIcon:true,
				drawRightIcon:true,
				drawTopIcon:false,
				drawBotIcon:false,
				// fieldLabel: 'ItemSelector',
				imagePath: '../Admin/images/default/multiselect',
				multiselects: [{
					width: 230,
					height: 200,
					legend: '可提供:',
					store: chooseColumn,
					displayField: 'text',
					valueField: 'value'
				},{
					width: 230,
					height: 200,
					legend: '已选择:',
					store: noChooseColumn,
					displayField: 'text',
					valueField: 'value'
				}]
			}],
			buttonAlign:'center',  
			buttons: [{
				text: '<div align="center">Save</div>',
				handler: function(){
					if(showColumnForm.getForm().isValid()){
						chooseColumn.each(function(record) {
							Ext.getCmp('call_table').getColumnModel().setHidden(record.get('value'),false);
						});
						noChooseColumn.each(function(record) {
							Ext.getCmp('call_table').getColumnModel().setHidden(record.get('value'),true);
						});
					}
					showColumnWin.hide();
				}
			}]
		});

		showColumnWin = new Ext.Window({
			width:700,
			height:350,
			closeAction:'hide',
			iconCls: 'userinfo',
			modal: true,
			plain: true,
			items: [showColumnForm]
		});
		<!-- 显示列 end-->
		
		var cp = new Ext.ColorPalette({value:'993300'});  // initial selected color
		// cp.on('select', function(palette, selColor){
			// do something with selColor
		// });

		<!-- 告警设置 start-->
		
		var changeTime=new Ext.form.FormPanel({ 
			fieldLabel: '时刻/时长选择',
			title   : '<div align="center">时刻/时长选择</div>',
			width:'100%', 
			height:150, 
			bodyStyle: 'padding: 30px',
			labelAlign:'left', 
			layout:'form',   //warning
			labelWidth: 50,
			frame:true, 
			items: [{ 
				xtype: 'compositefield', 
				id:'phone', 
				labelWidth: 220, 
				items: [ 
					{
						width:          50,
						xtype:          'combo',
						mode:           'local',
						value:          '',
						triggerAction:  'all',
						forceSelection: true,
						editable:       false,
						// fieldLabel:     'Title',
						name:           'hour',
						// hiddenName:     'title',
						// displayField:   'name',
						valueField:     'value',
						store: ['00','01','02','03','04','05','06','07','08','09','10',
								'11','12','13','14','15','16','17','18','19','20',
								'21','22','23','24']
					},{ 
						xtype: 'displayfield', 
						value: '-' 
					},{
						width:          50,
						xtype:          'combo',
						mode:           'local',
						value:          '',
						triggerAction:  'all',
						forceSelection: true,
						editable:       false,
						// fieldLabel:     'Title',
						name:           'min',
						// hiddenName:     'title',
						// displayField:   'name',
						valueField:     'value',
						store: ['00','01','02','03','04','05','06','07','08','09','10',
								'11','12','13','14','15','16','17','18','19','20',
								'21','22','23','24','25','26','27','28','29','30',
								'31','32','33','34','35','36','37','38','39','40',
								'41','42','43','44','45','46','47','48','49','50',
								'51','52','53','54','55','56','57','58','59','60']
					},{ 
						xtype: 'displayfield', 
						value: '-' 
					},{
						width:          50,
						xtype:          'combo',
						mode:           'local',
						value:          '',
						triggerAction:  'all',
						forceSelection: true,
						editable:       false,
						// fieldLabel:     'Title',
						name:           'second',
						// hiddenName:     'title',
						// displayField:   'name',
						valueField:     'value',
						store: ['00','01','02','03','04','05','06','07','08','09','10',
								'11','12','13','14','15','16','17','18','19','20',
								'21','22','23','24','25','26','27','28','29','30',
								'31','32','33','34','35','36','37','38','39','40',
								'41','42','43','44','45','46','47','48','49','50',
								'51','52','53','54','55','56','57','58','59','60']
					} 
				] 
			}],
			buttonAlign:'center',  
			buttons: [{
				text: '保&nbsp;存',
				handler: function() {
				}
			}]			
			}); 
			
		var warForm2=new Ext.form.FormPanel({ 
			fieldLabel: '时刻/时长选择',
			title   : '<div align="center">时刻/时长选择</div>',
			width:'100%', 
			height:150, 
			bodyStyle: 'padding: 30px',
			labelAlign:'left', 
			layout:'form',   //warning
			labelWidth: 90,
			frame:true, 
			items: [{ 
				xtype: 'compositefield', 
				id:'phone', 
				labelWidth: 220, 
				items: [ 
					{
						xtype: 'textfield',
						name: 'callInTime',
						// defaults: {width: 30},
						width: 100,
						fieldLabel: '接入通话时限',
					},{	
						xtype: 'button',
						name: 'startDate',
						width: 20,
						iconCls: 'userinfo',
						onFocus:function(){ 
							var colorFieldId=this.id;
							var colorWin=new Ext.Window({
								border:false,
								closeAction:'hide',
								// closable:false,
								resizable:false,
								title:'时刻/时长选择',
								width:400,
								height:200,
								items:[f]
						   });
						   colorWin.show();
						}
					},{
						xtype: 'displayfield',
						value: '<p style="padding: 3px 10px 0px 30px;">颜色:</p>',
						width: 75,
						align: 'left'
					},{
						xtype: 'textfield',
						name: 'color',
						id: 'color',
						width: 100
					},{
						xtype: 'textfield',
						style:'cursor:hand; background:#000000',
						color:'#000000', //默认颜色
						bodyStyle: 'padding: 50px 0px 0px 20px',
						width:20,
						height:20,
						onFocus:function(){ 
						   var colorFieldId=this.id;
						   var colorWin=new Ext.Window({
							border:false,
							closeAction:'hide',
							closable:false,
							resizable:false,
							width:155,
							height:100,
							items:[new Ext.ColorPalette({
							 listeners:{
							  'select':function(palette, selColor){      
							   Ext.getDom(colorFieldId).style.background='#'+selColor;
							   Ext.getCmp("color").setValue(selColor);
							   colorWin.hide(); 
							  }
							 }
							})]
						   });
						   colorWin.x=this.getPosition()[0]+this.width
						   colorWin.y=this.getPosition()[1]; 
						   colorWin.show();
						},
					},{
						xtype: 'checkbox',
						// fieldLabel: 'Favorite Animals',
						// boxLabel: 'Dog',
						name: 'fav-animal-dog',
						checked: true,
						onFocus:function(){ 
							// this.c;
							// console.info(11);
						}
					}
				] 
			}],
			buttonAlign:'center',  
			buttons: [{
				text: '保&nbsp;存',
				handler: function() {
				}
			}]			
			}); 
	
		warForm = new Ext.FormPanel({
			width: '100%',
			title: '<div align="center">告警设置</div>',
			bodyStyle: 'padding: 20px 20px 0px 20px',
			// defaults: {width: 100},
			items: [{
				xtype: 'compositefield',
				layout:'column' ,
				height:25,
				// labelWidth: 195,
				// defaults: {width: 100},
				// width: 280,
				items: [{
						xtype: 'textfield',
						name: 'callInTime',
						// defaults: {width: 30},
						width: 100,
						fieldLabel: '接入通话时限',
					},{	
						xtype: 'button',
						name: 'startDate',
						width: 20,
						iconCls: 'userinfo',
						onFocus:function(){ 
							var colorFieldId=this.id;
							var colorWin=new Ext.Window({
								border:false,
								closeAction:'hide',
								// closable:false,
								resizable:false,
								title:'时刻/时长选择',
								width:400,
								height:200,
								items:[f]
						   });
						   colorWin.show();
						}
					},{
						xtype: 'displayfield',
						value: '<p style="padding: 3px 10px 0px 30px;">颜色:</p>',
						width: 75,
						align: 'left'
					},{
						xtype: 'textfield',
						name: 'color',
						id: 'color',
						width: 100
					},{
						xtype: 'textfield',
						style:'cursor:hand; background:#000000',
						color:'#000000', //默认颜色
						bodyStyle: 'padding: 50px 0px 0px 20px',
						width:20,
						height:20,
						onFocus:function(){ 
						   var colorFieldId=this.id;
						   var colorWin=new Ext.Window({
							border:false,
							closeAction:'hide',
							closable:false,
							resizable:false,
							width:155,
							height:100,
							items:[new Ext.ColorPalette({
							 listeners:{
							  'select':function(palette, selColor){      
							   Ext.getDom(colorFieldId).style.background='#'+selColor;
							   Ext.getCmp("color").setValue(selColor);
							   colorWin.hide(); 
							  }
							 }
							})]
						   });
						   colorWin.x=this.getPosition()[0]+this.width
						   colorWin.y=this.getPosition()[1]; 
						   colorWin.show();
						},
					},{
						xtype: 'checkbox',
						// fieldLabel: 'Favorite Animals',
						// boxLabel: 'Dog',
						name: 'fav-animal-dog',
						checked: true,
						onFocus:function(){ 
							// this.c;
							// console.info(11);
						}
					}
				]},	{
				xtype: 'compositefield',
				layout:'column' ,
				height:25,
				// labelWidth: 195,
				// defaults: {width: 100},
				// width: 280,
				items: [{
						xtype: 'textfield',
						name: 'callOutTime',
						width: 100,
						fieldLabel: '呼出通话时限',
					},{	
						xtype: 'button',
						name: 'startDate',
						width: 20,
						iconCls: 'userinfo',
						onFocus:function(){ 
							var colorFieldId=this.id;
							var colorWin=new Ext.Window({
								border:false,
								closeAction:'hide',
								closable:false,
								resizable:false,
								width:1000,
								height:400,
								items:[warForm]
						   });
						   colorWin.show();
						}
					},{
						xtype: 'displayfield',
						value: '<p style="padding: 3px 10px 0px 30px;">颜色:</p>',
						width: 75,
						align: 'left'
					},{
						xtype: 'textfield',
						name: 'color',
						id: 'color',
						width: 100
					},{
						xtype: 'textfield',
						style:'cursor:hand; background:#000000',
						color:'#000000', //默认颜色
						bodyStyle: 'padding: 50px 0px 0px 20px',
						width:20,
						height:20,
						onFocus:function(){ 
						   var colorFieldId=this.id;
						   var colorWin=new Ext.Window({
							border:false,
							closeAction:'hide',
							closable:false,
							resizable:false,
							width:155,
							height:100,
							items:[new Ext.ColorPalette({
							 listeners:{
							  'select':function(palette, selColor){      
							   Ext.getDom(colorFieldId).style.background='#'+selColor;
							   Ext.getCmp("color").setValue(selColor);
							   colorWin.hide(); 
							  }
							 }
							})]
						   });
						   colorWin.x=this.getPosition()[0]+this.width
						   colorWin.y=this.getPosition()[1]; 
						   colorWin.show();
						},
					},{
						xtype: 'checkbox',
						// fieldLabel: 'Favorite Animals',
						// boxLabel: 'Dog',
						name: 'fav-animal-dog',
						checked: true,
						onFocus:function(){ 
							// this.c;
							// console.info(11);
						}
					}
				]},	{xtype: 'compositefield',
				layout:'column' ,
				height:25,
				// labelWidth: 195,
				// defaults: {width: 100},
				// width: 280,
				items: [{
						xtype: 'textfield',
						name: 'callInTime',
						width: 100,
						fieldLabel: '接入通话时限',
					},{	
						xtype: 'button',
						name: 'startDate',
						width: 20,
						iconCls: 'userinfo',
						onFocus:function(){ 
							var colorFieldId=this.id;
							var colorWin=new Ext.Window({
								border:false,
								closeAction:'hide',
								closable:false,
								resizable:false,
								width:1000,
								height:400,
								items:[warForm]
						   });
						   colorWin.show();
						}
					},{
						xtype: 'displayfield',
						value: '<p style="padding: 3px 10px 0px 30px;">颜色:</p>',
						width: 75,
						align: 'left'
					},{
						xtype: 'textfield',
						name: 'color',
						id: 'color',
						width: 100
					},{
						xtype: 'textfield',
						style:'cursor:hand; background:#000000',
						color:'#000000', //默认颜色
						bodyStyle: 'padding: 50px 0px 0px 20px',
						width:20,
						height:20,
						onFocus:function(){ 
						   var colorFieldId=this.id;
						   var colorWin=new Ext.Window({
							border:false,
							closeAction:'hide',
							closable:false,
							resizable:false,
							width:155,
							height:100,
							items:[new Ext.ColorPalette({
							 listeners:{
							  'select':function(palette, selColor){      
							   Ext.getDom(colorFieldId).style.background='#'+selColor;
							   Ext.getCmp("color").setValue(selColor);
							   colorWin.hide(); 
							  }
							 }
							})]
						   });
						   colorWin.x=this.getPosition()[0]+this.width
						   colorWin.y=this.getPosition()[1]; 
						   colorWin.show();
						},
					},{
						xtype: 'checkbox',
						// fieldLabel: 'Favorite Animals',
						// boxLabel: 'Dog',
						name: 'fav-animal-dog',
						checked: true,
						onFocus:function(){ 
							// this.c;
							// console.info(11);
						}
					}
				]},	{xtype: 'compositefield',
				layout:'column' ,
				height:25,
				// labelWidth: 195,
				// defaults: {width: 100},
				// width: 280,
				items: [{
						xtype: 'textfield',
						name: 'callInTime',
						width: 100,
						fieldLabel: '接入通话时限',
					},{	
						xtype: 'button',
						name: 'startDate',
						width: 20,
						iconCls: 'userinfo',
						onFocus:function(){ 
							var colorFieldId=this.id;
							var colorWin=new Ext.Window({
								border:false,
								closeAction:'hide',
								closable:false,
								resizable:false,
								width:1000,
								height:400,
								items:[warForm]
						   });
						   colorWin.show();
						}
					},{
						xtype: 'displayfield',
						value: '<p style="padding: 3px 10px 0px 30px;">颜色:</p>',
						width: 75,
						align: 'left'
					},{
						xtype: 'textfield',
						name: 'color',
						id: 'color',
						width: 100
					},{
						xtype: 'textfield',
						style:'cursor:hand; background:#000000',
						color:'#000000', //默认颜色
						bodyStyle: 'padding: 50px 0px 0px 20px',
						width:20,
						height:20,
						onFocus:function(){ 
						   var colorFieldId=this.id;
						   var colorWin=new Ext.Window({
							border:false,
							closeAction:'hide',
							closable:false,
							resizable:false,
							width:155,
							height:100,
							items:[new Ext.ColorPalette({
							 listeners:{
							  'select':function(palette, selColor){      
							   Ext.getDom(colorFieldId).style.background='#'+selColor;
							   Ext.getCmp("color").setValue(selColor);
							   colorWin.hide(); 
							  }
							 }
							})]
						   });
						   colorWin.x=this.getPosition()[0]+this.width
						   colorWin.y=this.getPosition()[1]; 
						   colorWin.show();
						},
					},{
						xtype: 'checkbox',
						// fieldLabel: 'Favorite Animals',
						// boxLabel: 'Dog',
						name: 'fav-animal-dog',
						checked: true,
						onFocus:function(){ 
							// this.c;
							// console.info(11);
						}
					}
				]},	{xtype: 'compositefield',
				layout:'column' ,
				height:50,
				// labelWidth: 195,
				// defaults: {width: 100},
				// width: 280,
				items: [{
						xtype: 'textfield',
						name: 'callInTime',
						width: 100,
						fieldLabel: '接入通话时限',
					},{	
						xtype: 'button',
						name: 'startDate',
						width: 20,
						iconCls: 'userinfo',
						onFocus:function(){ 
							var colorFieldId=this.id;
							var colorWin=new Ext.Window({
								border:false,
								closeAction:'hide',
								closable:false,
								resizable:false,
								width:1000,
								height:400,
								items:[warForm]
						   });
						   colorWin.show();
						}
					},{
						xtype: 'displayfield',
						value: '<p style="padding: 3px 10px 0px 30px;">颜色:</p>',
						width: 75,
						align: 'left'
					},{
						xtype: 'textfield',
						name: 'color',
						id: 'color',
						width: 100
					},{
						xtype: 'textfield',
						style:'cursor:hand; background:#000000',
						color:'#000000', //默认颜色
						bodyStyle: 'padding: 50px 0px 0px 20px',
						width:20,
						height:20,
						onFocus:function(){ 
						   var colorFieldId=this.id;
						   var colorWin=new Ext.Window({
							border:false,
							closeAction:'hide',
							closable:false,
							resizable:false,
							width:155,
							height:100,
							items:[new Ext.ColorPalette({
							 listeners:{
							  'select':function(palette, selColor){      
							   Ext.getDom(colorFieldId).style.background='#'+selColor;
							   Ext.getCmp("color").setValue(selColor);
							   colorWin.hide(); 
							  }
							 }
							})]
						   });
						   colorWin.x=this.getPosition()[0]+this.width
						   colorWin.y=this.getPosition()[1]; 
						   colorWin.show();
						},
					},{
						xtype: 'checkbox',
						// fieldLabel: 'Favorite Animals',
						// boxLabel: 'Dog',
						name: 'fav-animal-dog',
						checked: true,
						onFocus:function(){ 
							// this.c;
							// console.info(11);
						}
					}
				]},
			
			],
			buttonAlign:'center',  
			buttons: [{
				text: '保&nbsp;存',
				handler: function() {
				}
			},{
				text: '取&nbsp;消',
				handler: function() {
					win.hide();
				}
			}]
		});
	
		warnWin = new Ext.Window({
			width: 550,
			height:300,
			closeAction:'hide',
			iconCls: 'userinfo',
			modal: true,
			plain: true,
			items: [warForm2]
		});
		<!-- 告警设置 end-->
		
		store.load({params:{start:0, limit:20}});
		userInfo_tpl.overwrite(Ext.getCmp('user-info').body);	
		callOutInfo_tpl.overwrite(Ext.getCmp('callOut-info').body);	
		callInInfo_tpl.overwrite(Ext.getCmp('callInt-info').body);	
		Ext.getCmp('center').show();
		
    });
	
	//技能组选择
	function skillGroup(title) {
		form.form.reset();
		win.setTitle(title);
		win.show();
	}
	//告警设置
	function warnGroup(title) {
		warForm.form.reset();
		warnWin.setTitle(title);
		warnWin.show();
	}
	
	//显示列
	function showColumn() {
		// showColumnForm.form.reset();
		showColumnWin.setTitle('显示列');
		showColumnWin.show();
	}
						
	function MenuOnMouseOver(obj) {
		Ext.get(obj).addClass("x-menu-item-active");
	}

	function MenuOnMouseOut(obj) {
		Ext.get(obj).removeClass("x-menu-item-active");
	}

	function doQuit() {
		Ext.Ajax.request({
			url: './rest/user/logout',
			success: function(response,options) {
				alert(1);
				userinfo_tpl.overwrite(Ext.getCmp('user-panel').body);
			},
			failure: function(response,options) {
				alert(12);
				userinfo_tpl.overwrite(Ext.getCmp('user-panel').body);
			}
		});
		top.document.location.href = './login.jsp';
	}

	function doChangePwd() {
		form.form.reset();
		win.show();
	}
    </script>
</head>
<body>
	<div id="layout-title">
		<table background="images/bg2.jpg" width="100%" border='0' cellpadding="0" cellspacing="0" height="57">
			<tr>
				<!--<td class="title" width="100px">
					&nbsp;&nbsp;<img src='./images/logo1.jpg'>
				</td>-->
				
				<td class="title" width="500px">
					&nbsp;&nbsp;<img src='./images/logo.jpg'>
				</td>
				
			  <td valign="middle" align="right" width="*">
				<TABLE cellpadding="0" cellspacing="0" height="57" border='0'>
				<TR style="padding-top:-14px">
				  <TD style="padding-top:-14px;padding-left:2px;"><a class="nav-link" href="#" onclick="warnGroup('告警设置','panel')">告警设置</a></TD>
				  <TD width="12px;">&nbsp;&nbsp;</TD>
				   <TD style="padding-top:-14px;padding-left:2px;"><a class="nav-link" href="#" onclick="showColumn()">显示列</a></TD>
				  <TD width="12px;">&nbsp;&nbsp;</TD>
				   <TD style="padding-top:-14px;padding-left:2px;"><a class="nav-link" href="#" onclick="skillGroup('技能组选择')">技能组选择</a></TD>
				  <TD width="12px;">&nbsp;&nbsp;</TD>
				   <TD style="padding-top:-24px;padding-left:2px;"><a class="nav-link" href="#" onclick="goHome()">行政组选择</a></TD>
				  <TD width="12px;">&nbsp;&nbsp;</TD>
				  <TD style="padding-top:-24px;padding-left:2px;"><a class="nav-link" href="#" onclick='doChangePwd()'>坐席组选择</a></TD>
				  <TD width="12px;">&nbsp;&nbsp;</TD>
				</TR>
				</TABLE>
			  </td>
			</tr>
		</table>
	</div> 
    <div id="west" class="x-hide-display"></div>
    <div id="tabs" class="x-hide-display"></div>
	<div id="adduser-win" class="x-hidden"></div>
</body>
</html>
