<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
	response.setHeader("Pragma","No-cache");
	response.setHeader("Cache-Control","no-cache");
	response.setHeader("Expires","0");

	request.setCharacterEncoding("UTF-8");	
	
	String rpt = request.getParameter("rpt");

	String reportname = request.getParameter("reportname") == null? "" : request.getParameter("reportname");
	String tablename = request.getParameter("tablename") == null? "" : request.getParameter("tablename");
 	String ds = request.getParameter("ds") == null? "" : request.getParameter("ds");

	String refresh = request.getParameter("refresh") == null? "" : request.getParameter("refresh");

	String webRoot = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";

	String pageSize = "25";
%>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>录音查询</title>
 
    <link rel="stylesheet" type="text/css" href="../css/ext-all-notheme.css" />
    <link rel="stylesheet" type="text/css" href="../css/xtheme-gray.css" />

    <link rel="stylesheet" type="text/css" href="../css/icon.css" />

    <style type=text/css>
        /* style rows on mouseover */
        .x-grid3-row-over .x-grid3-cell-inner {
            font-weight: bold;
        }

		.x-grid-record-played{
			background: #d6ffd2;
		}
    </style>
 
    <script type="text/javascript" src="../js/ext-base.js"></script>
    <script type="text/javascript" src="../js/ext-all.js"></script>
    <script type="text/javascript" src="../js/ext-lang-zh_CN.js"></script>
	<script type="text/javascript" src="../js/ext-ui-combo-pagesize.js"></script>
	<script >
		var webRoot = '<%=webRoot%>';
	</script>
    <script type="text/javascript">
	var win_print;
	var pagesize = <%=pageSize%>;
	var grid;
	var si;
	var favoritewin, favoriteForm;

	var cols = new Array();

	var searchTab = parent.frames['searchTab'];

	var Conditions = new Array();
	var needStat = false;

	var substore;

	var subIdx = 0;

	Ext.Ajax.timeout = 900000;

	var contentfields = [
				   {name: 'speaker'},
				   {name: 'content'},
				   {name: 'beginTime'},
				   {name: 'endTime'}
				];
	
	var contentstore = new Ext.data.JsonStore({
		root: 'data',
		totalProperty: 'total',
		idProperty: 'id',
		remoteSort: true,

		fields: contentfields,
		
		proxy: new Ext.data.HttpProxy({
			url: window.webRoot + 'ASR/analyze'
		})
	}); 

	contentstore.setDefaultSort('beginTime', 'asc');
	
	contentstore.on('beforeload', function(loader, node) {
		var rec = grid.getSelectionModel().getSelected();
		contentstore.baseParams = {path:rec.get('fileName')};
	});

	function setAutoRefresh(refresh, store) {
		if(refresh) {
			window.setInterval(function() {
					store.reload(store.lastOptions);
				}
			, refresh);
		}
	}

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

	function getParamsStr() {
		var params = '';
		params += 'reportname=<%=reportname%>&'
		params += 'tablename=<%=tablename%>&'
		params += 'ds=<%=ds%>&'
		for(var i=0; i<Conditions.length; i++) {
			var key = Conditions[i].key;
			var val = Conditions[i].val;

			if(typeof key == 'object') {
				for(var j=0; j<key.length; j++) {
					params += key + "=" + val[j] + "&";
				}
			} else {
				if(typeof val == 'object') {
					for(var j=0; j<val.length; j++) {
						params += key + "=" + val[j] + "&";
					}
				} else {
					params += key + "=" + val + "&";
				}
			}
		}
		return params;
	}

	function getRecParamsStr(rec) {
		var params = '';
		params += 'voxpath=' + rec.get('filepath');
		params += '&ucid=' + rec.get('ucid');
		params += '&extno=' + rec.get('ext_no');
		params += '&rectime=' + rec.get('begin_time');
		params += '&endtime=' + rec.get('end_time');
		params += '&ani=' + rec.get('ani');
		params += '&dnis=' + rec.get('dnis');
		params += '&calltime=' + rec.get('call_time');
		params += '&calltypename=' + rec.get('call_type_name');
		params += '&filepath=' + rec.get('filepath');
		params += '&recusername=' + rec.get('user_name');
		params += '&databasename=' + rec.get('database_name');
		return params;
	}

	function getParamsArray() {
		var params = new Array();

		params['reportname'] = '<%=reportname%>';
		params['tablename'] = '<%=tablename%>';
		params['ds'] = '<%=ds%>';

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

	function checkPlayState() {
		var player = document.getElementById("player");
		if(player) {
			if(player.playState == 0 || player.playState == 1) {

				subIdx++;
				if(substore.getCount() <= subIdx) {
					return;
				}
				
				player.parentNode.removeChild(player);

				substore.each(function(subrec){
					if(subrec.get('subidx') == subIdx) {
						if(document.getElementById("subflag_" + subrec.get('subidx'))) {
							document.getElementById("subflag_" + subrec.get('subidx')).src = '../images/icons/fam/resultset_next.png';
						}
						Ext.Ajax.request({
							url: '../json/record.do?method=play',
							success: function(res) {
								var respText = Ext.decode(res.responseText); 
								var file = respText.respMessage;
								document.getElementById("divPlayer").innerHTML = createPlayWin(subrec, file);
							},
							failure: function(res) {
								var respText = Ext.decode(res.responseText);   
								Ext.Msg.alert('调听失败', respText.respMessage + "（" + respText.respCode + "）");
							},
							method: 'POST', 
							timeout: 300000,
							params: getRecParamsStr(subrec)
						});
					} else {
						if(document.getElementById("subflag_" + subrec.get('subidx'))) {
							document.getElementById("subflag_" + subrec.get('subidx')).src = '../images/icons/fam/tick.png';
						}
					}
				});

			}
		}
	}

	function createPlayWin(rec, file) {
		var str = "";
		str += "<object id=player width='100%' height='65' classid='CLSID:6BF52A52-394A-11d3-B153-00C04F79FAA6' codebase='http://activex.microsoft.com/activex/controls/mplayer/en/nsmp2inf.cab#Version=7.0' align='top' border='0' type='application/x-oleobject'>";
		str += "<param name='URL' value='" + file + "'>";
		str += "<param name='EnableTracker' value='1'>";
		str += "<param name='uiMode' value='full'>";
		str += "<param name='EnableContextMenu' value='1'>";
		str += "<param name='volume' value='100'>";
		str += "<embed src='" + file + "' align='top' border='0' width='98%' height='65' type='application/x-mplayer2' pluginspage='http://www.microsoft.com/isapi/redir.dll?prd=windows&amp;sbp=mediaplayer&amp;ar=media&amp;sba=plugin&amp;' showcontrols='1' showpositioncontrols='1' showaudiocontrols='1' showtracker='1' showdisplay='0' showstatusbar='1' autosize='0' showgotobar='0' showcaptioning='0' autostart='1' autorewind='0' animationatstart='0' transparentatstart='0' allowscan='1' enablecontextmenu='1' clicktoplay='0' invokeurls='1' defaultframe='datawindow'>";
		str += "</embed>";
		str += "</object>";
		return str;
	}

	function createPlayWin2(rec, file) {
		var str = "<iframe frameborder='no' border=0 height='100%' width='100%' src='play.html' scrolling='auto'></iframe>";
		return str;
	}

	function logRecord(type, rec) {
//		Ext.Ajax.request({
//			url: '../json/record.do?method=log',
//			method: 'POST', 
//			timeout: 3000,
//			params: getRecParamsStr(rec)
//		});
	}

	Ext.onReady(function(){

		Ext.QuickTips.init();
		
		Conditions = cacheCondition();

		var colsObj = new Array();
/*
		colsObj.push(new Ext.grid.Column({
			header: '',
			width: 45,
			dataIndex: 'idx',
			sortable: false,
			renderer : function(v, p, record, rowIndex){
				try	{
					if(record.get('subidx') > 0) {
						p.style = 'color:#00CC00';
						return record.get('idx') + "-" + record.get('subidx')
					} else {
						p.style = 'color:#0000FF';
						return record.get('idx')
					}
				} catch (e)	{
					p.style = 'color:#0000FF';
					return record.get('idx')
				}
			}
		}));
*/
		for(var i=0; i<searchTab.Colmuns.length; i++) {
			if(searchTab.Colmuns[i].checked && !searchTab.Colmuns[i].hidden) {
				if(searchTab.Colmuns[i].renderer) {
					colsObj.push(new Ext.grid.Column({
						header   : searchTab.Colmuns[i].boxLabel, 
						sortable : searchTab.Colmuns[i].sortable, 
						dataIndex: searchTab.Colmuns[i].value,
						renderer : searchTab.Colmuns[i].renderer
					}));
				} else {
					colsObj.push(new Ext.grid.Column({
						header   : searchTab.Colmuns[i].boxLabel, 
						sortable : searchTab.Colmuns[i].sortable, 
						dataIndex: searchTab.Colmuns[i].value
					}));
				}
			}
		}
		
		var fields = new Array();
		fields.push(new Ext.data.Field({
			name : 'idx'
		}));
		fields.push(new Ext.data.Field({
			name : 'subidx'
		}));
		for(var i=0; i<searchTab.Colmuns.length; i++) {
			if(searchTab.Colmuns[i].checked) {
				fields.push(new Ext.data.Field({
					name : searchTab.Colmuns[i].value
				}));
			}
		}

		var store = new Ext.data.JsonStore({
			root: 'data',
			totalProperty: 'total',
			remoteSort: true,

			fields: fields,
			
			proxy: new Ext.data.HttpProxy({
				url: window.webRoot + 'Report/RecordDetails',
				timeout: 300000
			}),

			listeners: {
				'loadexception': function(proxy, options, response, e){
					var respText = Ext.util.JSON.decode(response.responseText);
					if(respText.code != 'OK') {
						Ext.Msg.alert('查询失败', respText.message + "（" + respText.code + "）");
					} else {
//						alert("ok1");
//						store.reload({params:{start:0, limit:pagesize}});
					}
				},
				'load': function(store, records, options) {
					if(needStat && records.length > 1) {
						grid.getView().addRowClass(0,'titlerow');
					}
				}
			}
		});

		store.on('beforeload', function(loader, node) {
			loader.baseParams.start = 0;
			loader.baseParams.limit = pagesize;
		});

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
				id: 'btnPlay',
				text: '调听',
				iconCls: 'playbtn',
				listeners: {
					'click': function(obj, e) {
						var rec = grid.getSelectionModel().getSelected();
						var lineno = grid.getSelectionModel().lastActive;
						if(!rec) {
							Ext.Msg.alert('调听录音', '请选择要调听的录音！');
						} else {
							var file = "http://127.0.0.1:8080/QAVoice/" + rec.get('fileName');

							substore = new Ext.data.JsonStore({
								autoDestroy: true,
								fields: fields
							});

							subIdx = rec.get('subidx');

							store.each(function(rec2){
								if(rec.get('id') == rec2.get('id')) {
									substore.add(rec2);
								}
							});

							playwin = new Ext.Window({
								layout: 'anchor',
								width: 705,
								height:480,
								closeAction:'close',
								modal: true,
								plain: true,
								title: '调听录音',
								iconCls: 'playbtn',
								listeners: {
									'afterrender': function(obj) {
										var ua = navigator.userAgent.toLowerCase();
										var isOpera = ua.indexOf("opera") > -1;
										var isIE = !isOpera && ua.indexOf("msie") > -1;
										if(isIE) {
											si = setInterval(checkPlayState, 1000);
										}
									},
									'beforedestroy': function(obj) {
										clearInterval(si);
										var ua = navigator.userAgent.toLowerCase();
										var isOpera = ua.indexOf("opera") > -1;
										var isIE = !isOpera && ua.indexOf("msie") > -1;
										var len;
										if(isIE) {
											len = parseInt(document.getElementById("player").controls.currentPosition);
										} else {
											len = 0;
										}
									}
								},
								items:[
									new Ext.Panel({
										anchor: '100%',
										height: 88,
										border: false,
//										html: '<div id=divPlayer>' + createPlayWin(rec, file) + '</div>'
										html: "<iframe name='player' frameborder='no' border=0 height='100%' width='100%' src='play.html' scrolling='auto'></iframe>"
									}),
									new Ext.grid.GridPanel({
										anchor: '100%',
										height: 102,
										store: substore,
										border: false,
										columns: [
											{
												header   : '',
												width    : .1,
												sortable : false,
												dataIndex: 'status',
												renderer : function(v, p, record, rowIndex){
													if(record.get('subidx') == rec.get('subidx')) {
														return '<img id=subflag_' + record.get('subidx') + ' src="../images/icons/fam/resultset_next.png"/>';
													} else {
														return '<img id=subflag_' + record.get('subidx') + ' src="../images/icons/fam/tick.png"/>';
													}
												}
											},
											{
												header   : '开始时间',
												width    : .3,
												sortable : true,
												dataIndex: 'beginTime'
											},
											{
												header   : '结束时间',
												width    : .3,
												sortable : true,
												dataIndex: 'endTime'
											},
											{
												header   : '主叫',
												width    : .3,
												sortable : true,
												dataIndex: 'ani'
											},
											{
												header   : '被叫',
												width    : .3,
												sortable : true,
												dataIndex: 'dnis'
											},
											{
												header   : '分机',
												width    : .2,
												sortable : false,
												dataIndex: 'extNo'
											}
										],
										stripeRows: true,
										viewConfig: {forceFit:true},
										loadMask: true
									}),
									new Ext.grid.GridPanel({
										title: '语音内容',
										anchor: '100%',
										height: 220,
										store: contentstore,
										hideHeaders: true,
										border: false,
										columns: [
											{
												width    : '100%',
												sortable : false,
												dataIndex: 'content',
												renderer: function(v, p, record, rowIndex){
													if(record.get('speaker') == 'Agent') {
														return '<font color=red>' + record.get('speaker') + '</font>:' + v;
													} else {
														return '<font color=blue>' + record.get('speaker') + '</font>:' + v;
													}
												}
											}
										],
										stripeRows: true,
										viewConfig: {forceFit:true},
										loadMask: true,
										listeners: 
											{'rowdblclick': function(obj, e) {
													var sentence = obj.getSelectionModel().getSelected();
													window.frames["player"].play(sentence.get('beginTime'));
												}
											}
									})
/*
									new Ext.Panel({
										title: '语音内容',
										anchor: '100%',
										height: 190,
										border: false,
//										html: '<div id=divPlayer>' + createPlayWin(rec, file) + '</div>'
										html: "<div id=divVoxContent>The metadata should be at the start of the encoded data, since the Flash solution must have the metadata in order to begin playling. The option for this varies from encoder to encoder, but usually refers to optimizing for either web or streaming. This 3rd party link might help if you are having problems with the metadata: MetaData Mover</div>"
									})
*/
								],
								buttons: [{
									text: '收&nbsp;藏',
									handler: function() {
										//favoriteForm.form.reset();
/*
										Ext.getCmp('txtRecUcid').setValue(rec.get('ucid'));
										Ext.getCmp('txtRecTime').setValue(rec.get('begin_time'));
										Ext.getCmp('txtRecExtNo').setValue(rec.get('ext_no'));
										Ext.getCmp('txtRecEndTime').setValue(rec.get('end_time'));
										Ext.getCmp('txtAni').setValue(rec.get('ani'));
										Ext.getCmp('txtDnis').setValue(rec.get('dnis'));
										Ext.getCmp('txtCallType').setValue(rec.get('call_type_name'));
										Ext.getCmp('txtLength').setValue(rec.get('call_time'));
										Ext.getCmp('txtRecUserName').setValue(rec.get('user_name'));
										Ext.getCmp('txtFilePath').setValue(rec.get('filepath'));
										Ext.getCmp('txtDatabaseName').setValue(rec.get('database_name'));
										Ext.getCmp('txtRecComment').setValue('');
*/
										Ext.getCmp('radioPublic').enable();
										favoritewin.show();
s										}
								},{
									text: '关&nbsp;闭',
									handler: function() {
										playwin.close();
									}
								}]
							});
							grid.getView().getRow(lineno).style.backgroundColor='#80FE8E'
							logRecord(1,rec);
							playwin.show();
						}
					}
				}
			})
		);
		toolbar.addSeparator();
 
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnDownload',
				text: '下载',
				iconCls: 'downloadbtn',
				listeners: {
					'click': function(obj, e) {
						var rec = grid.getSelectionModel().getSelected();
						if(!rec) {
							Ext.Msg.alert('下载录音', '请选择要下载的录音！');
						} else {
							var myMask = new Ext.LoadMask(grid.getEl(), {msg:"下载中请等待..."});
							myMask.show();
							Ext.Ajax.request({
								url: '../data/play.json',
								success: function(res) {
									myMask.hide();
									var respText = Ext.decode(res.responseText);   
									if(respText.respCode != '000') {
										Ext.Msg.alert('下载失败', respText.respMessage + "（" + respText.respCode + "）");
									} else {
										window.location.href = '../download.jsp?file=' + respText.respMessage;
									}
									logRecord(2,rec);
								},
								failure: function(res) {
									myMask.hide();
									var respText = Ext.decode(res.responseText);   
									Ext.Msg.alert('下载失败', respText.respMessage + "（" + respText.respCode + "）");
								},
								method: 'POST', 
								timeout: 300000,
								params: getRecParamsStr(rec)
							});
						}
					}
				}
			})
		);
		toolbar.addSeparator();
		
		var exportMenu = new Ext.menu.Menu(); 

		exportMenu.add({
				id: 'btnExportExcel',
				text: 'Excel文档',
				iconCls: 'excelbtn',
				listeners: {
					'click': function(obj, e) {
						var total = store.getTotalCount();
						if(total > 50000) {
							Ext.Msg.alert('提示', "需要下载的数据量过大（大于50000条记录），请采用CSV格式下载。");
						} else {
							var myMask = new Ext.LoadMask(grid.getEl(), {msg:"导出中请等待..."});
							myMask.show();
							Ext.Ajax.request({
								url: '../json/report.do?method=<%=rpt%>&export=xls',
								success: function(res) {
									myMask.hide();
									var respText = Ext.decode(res.responseText);   
									if(respText.respCode != '000') {
										Ext.Msg.alert('导出失败', respText.respMessage + "（" + respText.respCode + "）");
									} else {
										window.location.href = '../download.jsp?file=' + respText.respMessage;
									}
								},
								failure: function(res) {
									myMask.hide();
									var respText = Ext.decode(res.responseText);   
									Ext.Msg.alert('导出失败', respText.respMessage + "（" + respText.respCode + "）");
								},
								method: 'POST', 
								timeout: 300000,
								params: getParamsStr()
							});
						}
					}
				}
		});

		exportMenu.add({
				id: 'btnExportCSV',
				text: 'CSV文档',
				iconCls: 'csvbtn',
				listeners: {
					'click': function(obj, e) {
						var myMask = new Ext.LoadMask(grid.getEl(), {msg:"导出中请等待..."});
						myMask.show();
						Ext.Ajax.request({
							url: '../json/report.do?method=<%=rpt%>&export=csv',
							success: function(res) {
								myMask.hide();
								var respText = Ext.decode(res.responseText);   
								if(respText.respCode != '000') {
									Ext.Msg.alert('导出失败', respText.respMessage + "（" + respText.respCode + "）");
								} else {
									window.location.href = '../download.jsp?file=' + respText.respMessage;
								}
							},
							failure: function(res) {
								myMask.hide();
								var respText = Ext.decode(res.responseText);   
								Ext.Msg.alert('导出失败', respText.respMessage + "（" + respText.respCode + "）");
							},
							method: 'POST', 
							timeout: 300000,
							params: getParamsStr()
						});
//						alert(store.data.length);
//						export2Excel(parent.document.title, store, cols);
					}
				}
		});

		toolbar.add({
			text : '导出',
			iconCls : 'exportbtn',
			menu: exportMenu
		});
		toolbar.addSeparator()

		grid = new Ext.grid.GridPanel({
            region: 'center',
			iconCls: 'gridbtn',
			store: store,
			tbar: toolbar,
			border: false,
			columns: colsObj,
			stripeRows: true,
			viewConfig: {
				forceFit: true,
				getRowClass: function(rec, idx, params, store) {
					if(rec.get('played') == 1) {
						return 'x-grid-record-played';
					}
				}
			}, 
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

		/** 列表双击操作 Start */
			grid.addListener('rowdblclick', function(obj, e) {
							Ext.getCmp('btnPlay').fireEvent('click'); 
						});    
		/** 列表双击操作 End */

		/** 列表右键点击菜单 Start */
		var rightClick = new Ext.menu.Menu();
			rightClick.add({
				text : '调听',
				iconCls : 'playbtn',
				handler : function(obj, e) {
						Ext.getCmp('btnPlay').fireEvent('click'); 
					}
			});
			rightClick.add({
				text : '下载',
				iconCls : 'downloadbtn',
				handler : function(obj, e) {
						Ext.getCmp('btnDownload').fireEvent('click'); 
					}
			});
			rightClick.addSeparator();
			rightClick.add({
				text : '刷新',
				iconCls : 'refreshbtn',
				handler : function(obj, e) {
						Ext.getCmp('btnReflash').fireEvent('click'); 
					}
			});
			rightClick.add({
				text : '打印',
				iconCls : 'printbtn',
				handler : function(obj, e) {
						Ext.getCmp('btnPrint').fireEvent('click'); 
					}
			});
			rightClick.addSeparator();
			rightClick.add({
				text : '导出',
				iconCls : 'exportbtn',
				menu: exportMenu
			});
		grid.addListener('rowcontextmenu', function(client, rowIndex, e) {
			e.preventDefault();
            rightClick.showAt(e.getXY());
			grid.getSelectionModel().selectRow(rowIndex);

		});
		/** 列表右键点击菜单 End */	  
//		parent.doReport(store);

		store.baseParams = getParamsArray();

		var loadMask;
		
		store.load();

		store.on('load', function(loader, node) {
			loadMask.hide();
		});

		store.on('loadexception', function(loader, node) {
			loadMask.hide();
		});

		grid.on('afterrender', function(grid) {
			loadMask = new Ext.LoadMask(grid.getEl(), {msg:"查询中请等待..."});
			loadMask.show();
		});

		grid.on('render', function(grid) {
			var store = grid.getStore();  
			var view = grid.getView();  
			grid.tip = new Ext.ToolTip({  
			   target: view.mainBody,  
			   delegate: '.x-grid3-row',  
			   trackMouse: true,  
			   anchor: 'left',  
			   renderTo: document.body,  
			   listeners: {  
					beforeshow: function(tip) {  
						var rowIndex = view.findRowIndex(tip.triggerElement);  
						var rec = store.getAt(rowIndex);  
						if(rec.get('played') == 1) {  
							tip.body.dom.innerHTML =  '上一次调听时间为&nbsp;<font color=#ffb771>' + rec.get('log_play_time') + '</font>, 调听人为&nbsp;<font color=#ffb771>' + rec.get('log_user_name') +'</font>';
						} else {
							tip.body.dom.innerHTML = '';
							return false;
						}
					}  
			   }  
			});  
		});

		var favoriteForm = new Ext.FormPanel({
			labelWidth: 75,
			frame:true,
			width: 350,
			defaults: {width: 230},
			defaultType: 'textfield',

			items: [
				{
					id: 'txtRecComment',
					fieldLabel: '备注',
					name: 'comment',
					height: 40,
					xtype: 'textarea'
				},{
					id: 'txtRecUcid',
					fieldLabel: 'UCID',
					name: 'ucid',
					hidden:true
				},{
					id: 'txtRecTime',
					fieldLabel: '录音开始时间',
					name: 'rectime',
					hidden:true
				},{
					id: 'txtRecEndTime',
					fieldLabel: '录音结束时间',
					name: 'recendtime',
					hidden:true
				},{
					id: 'txtAni',
					fieldLabel: '主叫',
					name: 'ani',
					hidden:true
				},{
					id: 'txtDnis',
					fieldLabel: '被叫',
					name: 'dnis',
					hidden:true
				},{
					id: 'txtCallType',
					fieldLabel: '呼叫类型',
					name: 'calltype',
					hidden:true
				},{
					id: 'txtLength',
					fieldLabel: '时长',
					name: 'calltime',
					hidden:true
				},{
					id: 'txtRecUserName',
					fieldLabel: '录音记录用户',
					name: 'recuser',
					hidden:true
				},{
					id: 'txtRecExtNo',
					fieldLabel: '分机号码',
					name: 'extno',
					hidden:true
				},{
					id: 'txtFilePath',
					fieldLabel: '文件路径',
					name: 'filepath',
					hidden:true
				},{
					id: 'txtDatabaseName',
					fieldLabel: '数据源名称',
					name: 'databasename',
					hidden:true
				},{
					id: 'txtScope2',
					fieldLabel: '文件路径',
					name: 'scope2',
					hidden:true
				},{
					xtype: 'checkboxgroup',
					fieldLabel: '类型',
					defaultType: 'radio',
					name: 'scope',
					items: [
						{boxLabel: '私有', name: 'scope', value: '1', checked: true},
						{id: 'radioPublic', boxLabel: '共有', name: 'scope', value: '2', disabled: true}
					]
				}
			],

			buttons: [
			{
				text: '保&nbsp;存',
				handler: function() {
					if(Ext.getCmp('radioPublic').getValue()) {
						Ext.getCmp('txtScope2').setValue('on');
					}
					favoriteForm.form.submit({
						url: '../json/record.do?method=favorite',
						success: function(form, action) {
							Ext.Msg.alert('收藏成功', '录音记录收藏成功！');
							favoritewin.hide();
						},
						failure: function(form, action) {
							Ext.Msg.alert('收藏失败', '录音记录收藏失败！');
						},
						waitMsg: '数据保存中，请稍候...'
					});
				}
			},{
				text: '取&nbsp;消',
				handler: function() {
					favoritewin.hide();
				}
			}]
		});

		favoritewin = new Ext.Window({
			applyTo:'favorite-win',
			layout:'fit',
			width: 350,
			height:160,
			closeAction:'hide',
			modal: true,
			plain: true,
			title: "收藏录音记录",
			iconCls: "favoritebtn",
			items: [favoriteForm]
		});

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
<div id="favorite-win" class="x-hidden"></div>
</body>
</html>
