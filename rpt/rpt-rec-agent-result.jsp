<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
	response.setHeader("Pragma","No-cache");
	response.setHeader("Cache-Control","no-cache");
	response.setHeader("Expires","0");

	request.setCharacterEncoding("UTF-8");	

	String webRoot = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";

	String type = request.getParameter("type");
	if(type == null || type.equals("")) {
		type = "Day";
	}
%>
<html> 
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>录音统计报表(按坐席)-结果</title>
 
    <link rel="stylesheet" type="text/css" href="../css/ext-all-notheme.css" />
    <link rel="stylesheet" type="text/css" href="../css/xtheme-gray.css" />

    <link rel="stylesheet" type="text/css" href="../css/icon.css" />
    <link rel="stylesheet" type="text/css" href="../css/common.css" />
	<script >
		var webRoot = '<%=webRoot%>';
	</script>
 
    <script type="text/javascript" src="../js/ext-base-debug.js"></script>
    <script type="text/javascript" src="../js/ext-all-debug.js"></script>
    <script type="text/javascript" src="../js/ext-lang-zh_CN.js"></script>
    <script type="text/javascript" src="../js/ext-ui-combo-pagesize.js"></script>
    <script type="text/javascript" src="../ux/ColumnHeaderGroup.js"></script>
    <script type="text/javascript" src="../ux/ExportExcel.js"></script>

	<script type="text/javascript" src="../js/func.js"></script>

	<script type="text/javascript">
	var curId = 0;
	var pagesize = 500;
	var grid;

/* 	var fields = [
				   {name:'beginTime'},
				   {name:'count'},
				   {name:'inCount'},
				   {name:'outCount'},
				   {name:'callLength5'},
				   {name:'callLength15'},
				   {name:'callLength30'},
				   {name:'callLength60'},
				   {name:'callLengthOver'}
				];
 */

	function showTimes(v, p, rec, rowIndex) {
		if(!rec.get('isStat')) {
			return formatTimes(v);
		} else {
			return '<b>' + formatTimes(v) + '</b>';
		}
	}

	function showAvgTimes(v, p, rec, rowIndex) {
		if(!rec.get('isStat')) {
			var avg = rec.get('finishedCount') > 0 ? parseInt(rec.get('finishedCallTime') / rec.get('finishedCount')) : 0;
			return formatTimes(avg);
		} else {
			return '<b>' + formatTimes(v) + '</b>';
		}
	}


	function showUserCount(v, p, rec, rowIndex) {
		if(v > 0) {
			return '<a href=# onclick=\'doViewUserStatus("' + rec.get('no') + '","' + rec.get('executeLogId') + ')\'>' + v + '</a>';
		} else {
			return v;
		}
	}

	function showTotal(v, p, rec, rowIndex) {
		if(v > 0) {
			return '<a href=# onclick=\'doViewDetail("' + rec.get('no') + '","' + rec.get('executeLogId') + '","Total")\'>' + v + '</a>';
		} else {
			return v;
		}
	}

	function showComplete(v, p, rec, rowIndex) {
		if(v > 0) {
			return '<a href=# onclick=\'doViewDetail("' + rec.get('no') + '","' + rec.get('executeLogId') + '", "Complete")\'>' + v + '</a>';
		} else {
			return v;
		}
	}

	function showUncomplete(v, p, rec, rowIndex) {
		if(v > 0) {
			return '<a href=# onclick=\'doViewDetail("' + rec.get('no') + '","' + rec.get('executeLogId') + '", "Uncomplete")\'>' + v + '</a>';
		} else {
			return v;
		}
	}

	function doViewDetail(taskNo, logId, status) {
		parent.tabs.add({
			title: '明细记录(' + taskNo + ')',
			iconCls: 'commentsbtn',
			margins:'0 0 0 0',
			autoScroll:true,
			autoWidth:true,
			closable:true,
			html:'<iframe src="assign-task-detail-list.jsp?taskNo=' + taskNo + '&logId=' + logId + '&status=' + status + '" border=0 width="100%" height="100%" frameborder="no" scrolling="auto"></iframe>'
		}).show();
	}

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

	function getParamsArray() {
		var params = new Array();

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

	var Conditions = cacheCondition(); 
	var Colmuns = searchTab.Colmuns;

	Ext.onReady(function(){
		
		Ext.QuickTips.init();
		var colsObj = new Array();
		var attrs = new Array();
		

		for(var i=0; i<Colmuns.length; i++) {
			if(Colmuns[i].checked && !Colmuns[i].hidden) {
				attrs = new Array();
				if(Colmuns[i].width) {
					attrs['width'] = Colmuns[i].width;
				}
				if(Colmuns[i].renderer) {
					attrs['renderer'] = Colmuns[i].renderer;
				}
				if(Colmuns[i].locked) {
					attrs['locked'] = true;
				} else {
					attrs['locked'] = false;
				}
				
				attrs['header'] = Colmuns[i].boxLabel;
				attrs['sortable'] = Colmuns[i].sortable;
				attrs['dataIndex'] = Colmuns[i].value;

				colsObj.push(new Ext.grid.Column(attrs));
			}
		}
		
		var fields = new Array();
		fields.push(new Ext.data.Field({
			name : 'idx'
		}));
		fields.push(new Ext.data.Field({
			name : 'subidx'
		}));
		for(var i=0; i<Colmuns.length; i++) {
			if(Colmuns[i].checked) {
				fields.push(new Ext.data.Field({
					name : Colmuns[i].value
				}));
			}
		}
		
		var store = new Ext.data.JsonStore({
			root: 'data',
			//totalProperty: 'total',
			//idProperty: 'id',
			remoteSort: true,

			fields: fields,
			
			proxy: new Ext.data.HttpProxy({
				url: window.webRoot + 'Report/Record/Agent/<%=type%>',
				timeout: 300000
			}),

			listeners: {
				'loadexception': function(proxy, options, response, e){
					var respText = Ext.util.JSON.decode(response.responseText);
					if(respText.code != 'OK') {
						Ext.Msg.alert('查询失败', respText.message + "（" + respText.code + "）");
					} else {
					}
				}
			}
		});

		/** Start 汇总标题 */
		var groupColsObj =  [
			{header: '&nbsp;', colspan: 1, align: 'center'},
			{header: '座席信息', colspan: 1, align: 'center'}
		]

		/** End 汇总标题 */

		var toolbar = new Ext.Toolbar({
			width: '100%'
		});

		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnReflash',
				text: '刷新',
				iconCls: 'refreshbtn',
				listeners: {
					'click': function(obj, e) {
						store.reload(store.lastOptions);
					}
				}
			})
		);
		toolbar.addSeparator();

		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnPrint',
				text: '打印',
				iconCls: 'printbtn',
				listeners: {
					'click': function(obj, e) {
						window.print();
					}
				}
			})
		);
		toolbar.addSeparator();
 
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnExport',
				text: '导出',
				iconCls: 'excelbtn',
				listeners: {
					'click': function(obj, e) {
						exportwin = new Ext.Window({
							layout: 'anchor',
							width: 560,
							height:150,
							closeAction:'close',
							modal: true,
							plain: true,
							title: '导出记录',
							iconCls: 'excelbtn',
							items:[
								new Ext.Panel({
									anchor: '100%',
									height: 88,
									border: false,
									html: "<iframe name='export' frameborder='no' border=0 height='100%' width='100%' src='../export.html' scrolling='auto'></iframe>"
								})
							],
							buttons: [
								{
									text: '关&nbsp;&nbsp;闭',
									iconCls: 'stopbtn',
									listeners: {
										'click' : function() {
											exportwin.close();
										}
									}
								}
							]
						});
						exportwin.show();
					}
				}
			})
		);
		toolbar.addSeparator();

		grid = new Ext.grid.GridPanel({
            region: 'center',
			store: store,
			border: false,
			//plugins: new Ext.ux.grid.ColumnHeaderGroup({
			//		rows: [groupColsObj]
			//}),
 			/* columns: [
				{
					header   : '开始时间', 
					width    : .2, 
					sortable : false, 
					dataIndex: 'beginTime'
				},
			   {
			       header   : '总数量', 
			       width    : .2, 
			       sortable : false, 
				   dataIndex: 'count'
	        	},
			 	{
					header   : '呼入量', 
					width    : .2, 
					sortable : false, 
					dataIndex: 'inCount'
				},
				{
					header   : '呼出量', 
					width    : .2, 
					sortable : false, 
					dataIndex: 'outCount'
				},
				{
					header   : '通话时间小于5s数', 
					width    : .2, 
					sortable : false, 
					dataIndex: 'callLength5'
				},
				{
					header   : '通话时间小于15s数', 
					width    : .2, 
					sortable : false,
					dataIndex: 'callLength15',
				},
				{
					header   : '通话时间小于30s数', 
					width    : .2, 
					sortable : false, 
					dataIndex: 'callLength30',
				},
				{
					header   : '通话时间小于60s数', 
					width    : .2, 
					sortable : false, 
					dataIndex: 'callLength60'
				},
				{
					header   : '通话时间大于60s数', 
					width    : .3, 
					sortable : false, 
					dataIndex: 'callLengthOver'
				}
			/*	{
					header   : '合格案例提交数', 
					width    : .2, 
					sortable : false, 
					dataIndex: 'caseCount2'
				},
				{
					header   : '不合格案例提交数', 
					width    : .2, 
					sortable : false, 
					dataIndex: 'caseCount3'
				},
				{
					header   : '总提交数', 
					width    : .2, 
					sortable : false, 
					dataIndex: 'caseTotal'
				} 
			], 
			*/		
			columns: colsObj,
			stripeRows: true,
			height: 600,
			width: '100%',
			viewConfig: {forceFit:true}, 
			fbar: toolbar,
			loadMask: true
		});

		store.setDefaultSort('beginTime', 'asc');
		
		store.on('beforeload', function(obj, node) {
			obj.baseParams = getParamsArray();
		}); 

		/* store.on('load', function(obj, node) {
			var stat = new Array();
			//计算总计
			var value;
			obj.each(function(rec) {
				for(key in rec.data) {
					value = rec.data[key];
					if(IsNum(value)) {
						if(!stat[key]) {
							stat[key] = 0;
						}
						stat[key] += value;
					}
				}
			});

		 	var p = new Ext.data.Record({
				isStat: true,
				agentNo: '<b><font color=\'green\'>总计:</font></b>',
				agentName: '&nbsp;',
				agentDeptName: '&nbsp;',
				finishedCount: '<b>' + (stat['finishedCount'] ? stat['finishedCount'] : '0') + '</b>',
				unfinishedCount: '<b>' + (stat['unfinishedCount'] ? stat['unfinishedCount'] : '0') + '</b>',
				finishedCallTime: (stat['finishedCallTime'] ? stat['finishedCallTime'] : '0'),
				avgFinishedCallTime: (stat['finishedCount'] && stat['finishedCount'] > 0 ? stat['finishedCallTime'] / stat['finishedCount'] : '0'),
				caseCount1: '<b>' + (stat['caseCount1'] ? stat['caseCount1'] : '0') + '</b>',
				caseCount2: '<b>' + (stat['caseCount2'] ? stat['caseCount2'] : '0') + '</b>',
				caseCount3: '<b>' + (stat['caseCount3'] ? stat['caseCount3'] : '0') + '</b>',
				caseTotal: '<b>' + (stat['caseTotal'] ? stat['caseTotal'] : '0') + '</b>'
			});
			
			var n = obj.getCount();
			obj.insert(n, p);
			obj.commitChanges();
			grid.getView().getRow(n).style.backgroundColor = '#DCDCDC';
		}); */
		 
		store.load({params:{start:0, limit:pagesize}});

        var viewport = new Ext.Viewport({
            layout: 'border',
			autoHeight: true,
			border: false,
            items: [grid]
		});	

	});	
	</script>
 
</head>
<body>
	<div id="adduser-win" class="x-hidden"></div>
</body>
</html>
