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
    <title>座席被抽检量统计报表-结果</title>
 
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

	var fields = [
				   {name: 'agentId'},
				   {name: 'agentNo'},
				   {name: 'agentName'},
				   {name: 'agentDeptId'},
				   {name: 'agentDeptName'},
				   {name: 'total'},
				   {name: 'idleCount'},
				   {name: 'completedCount'},
				   {name: 'updatedCount'},
				   {name: 'checkedCount'},
				   {name: 'assignedCount'},
				   {name: 'appealedCount'},
				   {name: 'finishedCount'},
				   {name: 'unfinishedCount'},
				   {name: 'assignedCallTime'},
				   {name: 'avgAssignedCallTime'},
				   {name: 'finishedCallTime'},
				   {name: 'avgFinishedCallTime'},
				   {name: 'caseTotal'},
				   {name: 'caseCount1'},
				   {name: 'caseCount2'},
				   {name: 'caseCount3'},
				   {name: 'caseCheckedCount1'},
				   {name: 'caseCheckedCount2'},
				   {name: 'caseCheckedCount3'}
				];


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

	Ext.onReady(function(){
		var store = new Ext.data.JsonStore({
			root: 'data',
			totalProperty: 'total',
			idProperty: 'id',
			remoteSort: true,

			fields: fields,
			
			proxy: new Ext.data.HttpProxy({
				url: window.webRoot + 'Report/QARecord/AgentStat'
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

		var sm = new Ext.grid.CheckboxSelectionModel();

		/** Start 汇总标题 */
		var groupColsObj =  [
			{header: '&nbsp;', colspan: 1, align: 'center'},
			{header: '座席信息', colspan: 3, align: 'center'},
			{header: '抽检统计', colspan: 3, align: 'center'},
			{header: '典型案例统计', colspan: 4, align: 'center'}
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
			plugins: new Ext.ux.grid.ColumnHeaderGroup({
					rows: [groupColsObj]
			}),
			columns: [
				new Ext.grid.RowNumberer(), 
				{
					header   : '座席编号', 
					width    : .2, 
					sortable : false, 
					dataIndex: 'agentNo'
				},
				{
					header   : '座席名称', 
					width    : .2, 
					sortable : false, 
					dataIndex: 'agentName'
				},
				{
					header   : '座席组', 
					width    : .2, 
					sortable : false, 
					dataIndex: 'agentDeptName'
				},
				{
					header   : '被抽检数', 
					width    : .2, 
					sortable : false, 
					dataIndex: 'finishedCount'
				},
				{
					header   : '被抽检时长', 
					width    : .2, 
					sortable : false,
					dataIndex: 'finishedCallTime',
					renderer : showTimes
				},
				{
					header   : '平均被抽检时长', 
					width    : .2, 
					sortable : false, 
					dataIndex: 'avgFinishedCallTime',
					renderer : showAvgTimes
				},
				{
					header   : '优秀案例提交数', 
					width    : .2, 
					sortable : false, 
					dataIndex: 'caseCount1'
				},
				{
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
			stripeRows: true,
			height: 600,
			width: '100%',
			viewConfig: {forceFit:true}, 
			fbar: toolbar,
			loadMask: true
		});

		store.on('beforeload', function(obj, node) {
			obj.baseParams = getParamsArray();
		});

		store.on('load', function(obj, node) {
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
		});
		
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
