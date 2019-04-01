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
	<title>日志查询</title>

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
<script type="text/javascript">
	var curId = 0;
	var win;
	var pagesize = 50;
	var grid;
	var form;
	var actiontype = "";
	
	var cookiePageSize = getCookie('wilcom.logserver.pagesize');
	if(cookiePageSize) {
		pagesize = cookiePageSize;
	}

	var fields = [
				   {name: 'ENTERTIME'},
				   {name: 'HUNGTIME'},
				   {name: 'SERVER'},
				   {name: 'SERVER_DISPLAY'},
				   {name: 'CHANNEL'},
				   {name: 'CHANNEL_DISPLAY'},
				   {name: 'GROUP'},
				   {name: 'GROUP_DISPLAY'},
				   {name: 'ANI'},
				   {name: 'ANI_DISPLAY'},
				   {name: 'DNIS'},
				   {name: 'DNIS_DISPLAY'},
				   {name: 'AREACODE'},
				   {name: 'AREACODE_DISPLAY'},
				   {name: 'UCID'},
				   {name: 'UCID_DISPLAY'},
				   {name: 'CALLID'},
				   {name: 'CALLID_DISPLAY'},
				   {name: 'BUSINESSTYPE'},
				   {name: 'BUSINESSTYPE_NAME'},
				   {name: 'FUNCTIONTYPE'},
				   {name: 'FUNCTIONTYPE_NAME'},
				   {name: 'CUSTOMERTYPE'},
				   {name: 'CUSTOMERTYPE_NAME'},
				   {name: 'CARDNO'},
				   {name: 'CARDNO_DISPLAY'},
				   {name: 'IDCARD'},
				   {name: 'IDCARD_DISPLAY'},
				   {name: 'IDCARDTYPE'},
				   {name: 'IDCARDTYPE_DISPLAY'},
				   {name: 'DISPLAY_TIMES'},
				   {name: 'TIMES'},
				   {name: 'SKILLNO'},
				   {name: 'SKILLNO_DISPLAY'}
				];

	Ext.onReady(function(){
		var store = new Ext.data.JsonStore({
			root: 'data',
			totalProperty: 'total',
			remoteSort: false,

			fields: fields,

			proxy: new Ext.data.HttpProxy({
				url: window.webRoot + 'LogServer/Calls'
			})
		});

		store.setDefaultSort('ENTERTIME', 'asc');

		grid = new Ext.grid.GridPanel({
            region: 'center',
			store: store,
			border: false,
			columns: [
				new Ext.grid.RowNumberer(),
				{
					header   : '开始时间',
					width    : .1,
					sortable : false,
					dataIndex: 'ENTERTIME'
				},
				{
					header   : '主叫号码',
					width    : .1,
					sortable : false,
					dataIndex: 'ANI_DISPLAY'
				},
				{
					header   : '业务类型',
					width    : .1,
					sortable : false,
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
					dataIndex: 'CARDNO_DISPLAY'
				},
				{
					header   : '证件号码',
					width    : .1,
					sortable : false,
					dataIndex: 'IDCARD_DISPLAY'
				},
				{
					header   : '时长',
					width    : .1,
					sortable : false,
					dataIndex: 'DISPLAY_TIMES'
				},
				{
					header   : '服务器',
					width    : .1,
					sortable : false,
					dataIndex: 'SERVER_DISPLAY'
				},
				{
					header   : '端口号',
					width    : .1,
					sortable : false,
					dataIndex: 'CHANNEL_DISPLAY'
				}
			],
			stripeRows: true,
			height: 600,
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
			
		store.load({params:{start:0, limit:pagesize}});
		
		store.on('load', function(loader) {
			var size = grid.getBottomToolbar().pageSize;
			setCookie("wilcom.logserver.pagesize",size, 240);
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

		/** 查询 Start */
		var defaultBeginTime = new Date();
		defaultBeginTime.setHours(0);
		defaultBeginTime.setMinutes(0);
		defaultBeginTime.setSeconds(0);
		var defaultEndTime = new Date();
		defaultEndTime.setHours(23);
		defaultEndTime.setMinutes(59);
		defaultEndTime.setSeconds(59);
		var panel_query = new Ext.Panel({
            layout: 'border',
			region: 'center', 
			autoScroll:false,
			iconCls: 'searchbtn',
			border: false,
			tbar: [
				'开始时间:&nbsp;&nbsp;',
				new Ext.form.DateField({
					id: 'qryBeginTime',
					format: 'Y-m-d H:i:s',
					enableKeyEvents: true,
					width: 168,
					allowBlank:false,
					value: defaultBeginTime,
					listeners: 
						{'keypress': function(obj, e) {
								if (e.getKey() == e.ENTER) { 
									Ext.getCmp('btnSearch').fireEvent('click');   
								}   
							}
						}
				}),
				'-',
				'结束时间:&nbsp;&nbsp;',
				new Ext.form.DateField({
					id: 'qryEndTime',
					format: 'Y-m-d H:i:s',
					enableKeyEvents: true,
					width: 168,
					allowBlank:false,
					value: defaultEndTime,
					listeners: 
						{'keypress': function(obj, e) {
								if (e.getKey() == e.ENTER) { 
									Ext.getCmp('btnSearch').fireEvent('click');   
								}   
							}
						}
				}),
				'-',
				'关键字:&nbsp;&nbsp;',
				new Ext.form.TextField({
					id: 'qryKey',
					enableKeyEvents: true,
					width: 300,
					allowBlank:false,
					emptyText: '主叫/被叫/卡号/证件号/通道号（支持模糊查询）',
					listeners: 
						{'keypress': function(obj, e) {
								if (e.getKey() == e.ENTER) { 
									Ext.getCmp('btnSearch').fireEvent('click');   
								}   
							}
						}
				}),
				'-',
				new Ext.Toolbar.Button({
					id: 'btnSearch',
					iconCls: 'searchbtn',
					text: '查询',
					listeners: 
						{'click': function(obj, e) {
								store.removeAll();
								store.load({params:{start:0, limit:pagesize}});
							}
						}
				}),
				'-'
			],
			items: grid
		});
 
		store.on('beforeload', function(loader, node) {
			var beginTime = Ext.getCmp('qryBeginTime').getValue();
			var endTime = Ext.getCmp('qryEndTime').getValue();
			var key = Ext.getCmp('qryKey').getValue();

			if(beginTime == "") {
				Ext.Msg.alert('查询错误', '查询开始时间不能为空！');
				Ext.getCmp('qryBeginTime').focus();
				return false;
			}

			if(endTime == "") {
				Ext.Msg.alert('查询错误', '查询结束时间不能为空！');
				Ext.getCmp('qryEndTime').focus();
				return false;
			}

			if(beginTime > endTime) {
				Ext.Msg.alert('查询错误', '查询开始时间不能大于查询结束时间！');
				Ext.getCmp('qryBeginTime').focus();
				return false;
			}

			if(key == "") {
				Ext.Msg.alert('查询错误', '关键字不能为空！');
				Ext.getCmp('qryKey').focus();
				return false;
			}

			store.baseParams = {beginTime:beginTime, endTime:endTime, key:key};
		});
		/** 查询 End */

		var viewport = new Ext.Viewport({
			layout: 'border',
			autoHeight: true,
			border: false,
			items: [panel_query]
		});

//		infotab.collapse(true);
	});
	</script>
</head>
</html>
