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
    <title>QA成绩汇总（按个人）-结果</title>
 
    <link rel="stylesheet" type="text/css" href="../css/ext-all-notheme.css" />
    <link rel="stylesheet" type="text/css" href="../css/xtheme-gray.css" />

    <link rel="stylesheet" type="text/css" href="../css/icon.css" />
    <link rel="stylesheet" type="text/css" href="../css/common.css" />
	<link rel="stylesheet" type="text/css" href="../ux/css/LockingGridView.css" />

	<script >
		var webRoot = '<%=webRoot%>';
	</script>
 
    <script type="text/javascript" src="../js/ext-base-debug.js"></script>
    <script type="text/javascript" src="../js/ext-all-debug.js"></script>
    <script type="text/javascript" src="../js/ext-lang-zh_CN.js"></script>
    <script type="text/javascript" src="../js/ext-ui-combo-pagesize.js"></script>
    <script type="text/javascript" src="../ux/ColumnHeaderGroup.js"></script>
	<script type="text/javascript" src="../ux/LockingGridView.js"></script>
    <script type="text/javascript" src="../ux/ExportExcel.js"></script>

	<script type="text/javascript" src="../js/func.js"></script>

	<script type="text/javascript">
	var curId = 0;
	var pagesize = 500;
	var grid;


	function showPassRate(v, p, rec, rowIndex) {
		if(!rec.get('isStat')) {
			var rate = rec.get('finishedCount') > 0 ? 100 * rec.get('countOver60') / rec.get('finishedCount') : 0.00;
			return rate.toFixed(2) + '%';
		} else {
			return v;
		}
	}

	function showScore(v, p, rec, rowIndex) {
		if(!rec.get('isStat')) {
			return v? v.toFixed(2) : '0.00';
		} else {
			return v;
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

	var groupTypeId = searchTab.ConditionFields[3].getValue();

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

		var itemGroups = parent.itemGroups;
		var t;
		/** Start 汇总标题 */
		var groupColsObj = new Array();
		//序号
		groupColsObj.push(
			{header: '&nbsp;', colspan: 1, align: 'center'}
		);
		//座席信息
		groupColsObj.push(
			{header: '&nbsp;', colspan: 1, align: 'center'}
		);
		//总计
		groupColsObj.push(
			{header: '总计', colspan: 3, align: 'center'}
		);
		//质检类(大类)
		Ext.each(itemGroups, function(group) {
			if(group.groupTypeId == groupTypeId) {
				t = new Object();
				t['header'] = group.text;
				t['colspan'] = group.children.length;
				t['align'] = 'center';
				groupColsObj.push(t);
			}
		});
		/** End 汇总标题 */

		/** Start 动态标题 */
		var colsObj = new Array();
		//序号
		colsObj.push(
			new Ext.grid.RowNumberer({width: 30, locked	 : true})
		);
		//座席组
		colsObj.push(
			{
				header   : '座席组', 
				width    : 90, 
				sortable : false, 
				locked	 : true,
				dataIndex: 'agentDeptName'
			}
		);
		//总分
		colsObj.push(
			{
				header   : '平均得分', 
				width    : 60, 
				sortable : false, 
				locked	 : true,
				dataIndex: 'avgScore',
				renderer : showScore
			}
		);
		//评分次数
		colsObj.push(
			{
				header   : '评分次数', 
				width    : 60, 
				sortable : false, 
				locked	 : true,
				dataIndex: 'times'
			}
		);
		//排名
		colsObj.push(
			{
				header   : '排名', 
				width    : 60, 
				sortable : false, 
				locked	 : true,
				dataIndex: 'rank'
			}
		);
		//质检类
		Ext.each(itemGroups, function(group) {
			Ext.each(group.children, function(group2) {
				if(group2.groupTypeId == groupTypeId) {
					t = new Object();
					t['header'] = group2.text;
					t['width'] = 75;
					t['sortable'] = false;
					t['dataIndex'] = group2.id + '-AvgValue';
					t['renderer'] = showScore;
					colsObj.push(t);
				}
			});
		});
		/** End 动态标题 */

		/** Start 字段名 */
		var fields = new Array();

		fields = [
				   {name: 'agentDeptId'},
				   {name: 'agentDeptName'},
				   {name: 'avgScore'},
				   {name: 'times'},
				   {name: 'rank'}
				];
		//质检类
		Ext.each(itemGroups, function(group) {
			Ext.each(group.children, function(group2) {
				t = new Object();
				t['name'] = group2.id + '-AvgValue';
				fields.push(t);
			});
		});
		/** End 字段名 */

		var store = new Ext.data.JsonStore({
			root: 'data',
			totalProperty: 'total',
			idProperty: 'id',
			remoteSort: false,

			fields: fields,
			
			proxy: new Ext.data.HttpProxy({
				url: window.webRoot + 'Report/QARecord/DeptScoreStat',
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
		
		store.setDefaultSort('rank', 'asc');

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
			columns: colsObj,
			stripeRows: false,
			height: 600,
			width: '100%',
			fbar: toolbar,
			loadMask: true
		});

		store.on('beforeload', function(obj, node) {
			obj.baseParams = getParamsArray();
		});

		store.on('load', function(obj, node) {
			var stat = new Array();
			//计算总分
			var totalScore = 0;
			var groupScore = new Object();
			Ext.each(itemGroups, function(group) {
				Ext.each(group.children, function(group2) {
					totalScore += group2.value;
					groupScore[group2.id] = group2.value;
				});
			});

			//计算达成比率
			var value;
			var newObjs = new Array();
			var newObj;
			var avgScore, rate;
			obj.each(function(rec) {
				newObj = new Object();
				avgScore = rec.get('avgScore') ? rec.get('avgScore') : 0;
				rate = avgScore / totalScore * 100;
				newObj = {
					isStat: true,
					agentDeptName: '<b><font color=\'green\'>（达成比率）</font></b>',
					avgScore: '<b>' + rate.toFixed(2) + '%</b>',
					times: '&nbsp;',
					rank: '&nbsp;'
				};

				Ext.each(itemGroups, function(group) {
					Ext.each(group.children, function(group2) {
						key = group2.id + '-AvgValue';
						newObj[key] = '<b>' + (rec.get(key) * 100 / groupScore[group2.id]).toFixed(2) + '%</b>';
					});
				});
				newObjs.push(newObj);
			});

			var p;
			for(var i=0; i<newObjs.length; i++) {
				p = new Ext.data.Record(newObjs[i]);
				obj.insert(2*i+1, p);
				grid.getView().getRow(2*i+1).style.backgroundColor = '#DCDCDC';
			}

			//添加总分标准行
			var fields = new Object();

			fields = {
				isStat: true,
				agentDeptName: '<b><font color=\'green\'>（总分标准）</font></b>',
				avgScore: '<b>' + totalScore + '</b>',
				times: '&nbsp;',
				rank: '&nbsp;'
			};

			Ext.each(itemGroups, function(group) {
				Ext.each(group.children, function(group2) {
					key = group2.id + '-AvgValue';
					fields[key] = '<b>' + group2.value + '</b>';
				});
			});
			
			var p = new Ext.data.Record(fields);
			
			obj.insert(0, p);

			obj.commitChanges();

			grid.getView().refresh();
			
			grid.getView().getRow(0).style.backgroundColor = '#FFFF00';
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
