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
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>质检查询</title>

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
	
	 <style type="text/css"> 
	 .x-grid3-row td,.x-grid3-summary-row td{ 
        line-height:15px;//控制GRID单元格高度 
		vertical-align:top;//单元格垂直居中 
		border-right: 0px solid #eceff6 !important;//控制表格列线 
		border-left: 0px solid #eceff6 !important;//控制表格列线 
		border-top: 0px solid #eceff6 !important;//控制表格行线 
        } 
    </style> 
	
	<script >
		var webRoot = '<%=webRoot%>';
	</script>

    <script type="text/javascript" src="../js/ext-base.js"></script>
    <script type="text/javascript" src="../js/ext-all-debug.js"></script>
    <script type="text/javascript" src="../js/ext-lang-zh_CN.js"></script>
    <script type="text/javascript" src="../js/ext-ui-combo-pagesize.js"></script>
    <script type="text/javascript" src="../ux/Spinner.js"></script>
    <script type="text/javascript" src="../ux/SpinnerField.js"></script>
	<script type="text/javascript" src="../ux/PagingMemoryProxy.js"></script>
	<script type="text/javascript" src="../ux/MultiSelect.js"></script>
    <script type="text/javascript" src="../ux/ItemSelector.js"></script>
	<script type="text/javascript" src="../ux/FieldLabeler.js"></script>
    <script type="text/javascript" src="../ux/FieldReplicator.js"></script>

    <script type="text/javascript">

	var tabCount = 1;

	var ConditionFields = new Array();

	var QueryConditionFields = new Array();
	
	var QAConditionFields = new Array();
	
	Ext.onReady(function(){
	// store = new Ext.data.JsonStore({
			// root: 'data',
			// totalProperty: 'total',
			// remoteSort: false,

			// fields: fields,
			// proxy: new Ext.data.HttpProxy({
				// url: window.webRoot + 'Voices/1'
			// })

		// });
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
		
		store.setDefaultSort('no', 'asc');
		store.load();
		Ext.QuickTips.init();	

		var grid = new Ext.grid.GridPanel({
			width: 240,
			height: 500,
			//autoHeight:true 
			frame: false,
			title: '质检',
			iconCls: 'setting',
			enableHdMenu: false,
			hideHeaders:true,
			columnLines:false,
			store : new Ext.data.ArrayStore({
							id: 0,
							fields: [
								'no',
								'id',
								'name'
							],
							data: [
							[1,'<img src=<%=webRoot%>images/icons/fam/feed.png>&nbsp;&nbsp;&nbsp;','通用'],  
							[2,'<img src=<%=webRoot%>images/icons/fam/feed.png>&nbsp;&nbsp;&nbsp;','录音查询'],  
							[3,'<img src=<%=webRoot%>images/icons/fam/feed.png>&nbsp;&nbsp;&nbsp;','质检']]
						}),   
			cm : new Ext.grid.ColumnModel([   
				{  
					//iconCls: 'setting' ,	
					dataIndex:'id',  
					width:25,  
				},  
				{  
					//iconCls: 'setting' ,	
					dataIndex:'name',  
					width:210,  
				}  
			])
		});

		var form = new Ext.form.FormPanel({
			//region:'center',
			title: '质检配置',
			iconCls: 'setting',
			bodyStyle: 'padding:15px',
			width: 950,
			height: 500,
			border: true,
			//bodyStyle: 'border-width:0 1px 1px 0;',
			defaults: {
				msgTarget: 'qtip'
			},
			items: [
				{
					xtype: 'fieldset',
					labelWidth: 100,
					title: '列表',
					width: 700,
					collapsible: true,
					items :[{
						xtype: 'spinnerfield',
						fieldLabel: '默认每页记录数',
						id: 'txtFaxMaxCount',
						name: 'faxMaxCount',
						value: 25,
						width: 200,
						allowBlank:false
					}]
				},
				{
					xtype: 'fieldset',
					labelWidth: 100,
					title: '角色',
					width: 700,
					collapsible: true,
					items :[new Ext.form.ComboBox({
						fieldLabel: '质检*',
						typeAhead: true,
						triggerAction: 'all',
						lazyRender:true,
						mode: 'local',
						width: 520,
						store: new Ext.data.ArrayStore({
							id: 0,
							fields: [
								'myId',
								'displayText'
							],
							data: [[1, 'item1'], [2, 'item2']]
						}),
						valueField: 'myId',
						displayField: 'displayText'
					}),new Ext.form.ComboBox({
						typeAhead: true,
						fieldLabel: '质检组长*',
						width: 520,
						triggerAction: 'all',
						lazyRender:true,
						mode: 'local',
						store: new Ext.data.ArrayStore({
							id: 1,
							fields: [
								'myId',
								'displayText'
							],
							data: [[1, 'item1'], [2, 'item2']]
						}),
						//store: store,
						valueField: 'myId',
						displayField: 'displayText'
					}),new Ext.form.ComboBox({
						typeAhead: true,
						fieldLabel: '质检管理员*',
						width: 520,
						triggerAction: 'all',
						lazyRender:true,
						mode: 'local',
						store: new Ext.data.ArrayStore({
							id: 2,
							fields: [
								'myId',
								'displayText'
							],
							data: [[1, 'item1'], [2, 'item2']]
						}),
						// store: store,
						valueField: 'myId',
						displayField: 'displayText'
					}),{
						xtype: 'combo',
						width: 520,
						store: ['test@example.com', 'someone-else@example.com' ],
						plugins: [ Ext.ux.FieldReplicator, Ext.ux.FieldLabeler ],
						fieldLabel: 'Send To',
						name: 'to'
					}]
				}
			],
			buttonAlign:'right',  
			buttons: [
				{
					text: '确&nbsp;&nbsp;定',
					style: {
						marginBottom: '10px',//距底部高度
						marginLeft:'10px',//距左边宽度
						marginRight:'20px',//距右边宽度
						marginTop:'10px'
					},
					handler: function() {
					}
				},
				{
					text: '取&nbsp;&nbsp;消',
					style: {
						marginBottom: '10px',//距底部高度
						marginLeft:'10px',//距左边宽度
						marginRight:'50px',//距右边宽度
						marginTop:'10px'
					},
					handler: function() {
						document.location.href = '../blank.jsp';
					}

				}
			]
        });
		
		
		new Ext.Viewport({
			//layout: 'border',
			//border: false,
			align:'right',
			items: [
				new Ext.Panel({
					width: '100%',
					height:'100%',
					align:'right',
					layout: 'table',
					items: [
						grid,form
					]	
				})
			],
			renderTo: Ext.getBody()
		});
	
	});
	</script>

</head>
<body>
	<div id="save-win" class="x-hidden"></div>
</body>
</html>
