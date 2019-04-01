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
    <title>我的质检</title>
 
    <link rel="stylesheet" type="text/css" href="../css/ext-all-notheme.css" />
    <link rel="stylesheet" type="text/css" href="../css/xtheme-gray.css" />
    <link rel="stylesheet" type="text/css" href="../ux/css/DateTimePicker.css" />

    <style type=text/css>
        /* style rows on mouseover */
        .x-grid3-row-over .x-grid3-cell-inner {
            font-weight: bold;
        }

		.x-grid-record-private{
			background: #d6ffd2;
		}
        .titletext {
            font-weight: bold;
        }

        .titlerow {
			border-color:#000000;
			background-color:#D1EEEE;
            font-weight: bold;
        }

		.settingbtn {
			background-image:url("../images/icons/fam/cog_edit.png");
		}
		.searchbtn {
			background-image:url("../images/default/dd/qry.gif");
		}
		.gridbtn {
			background-image:url("../images/icons/fam/grid.png");
		}
		.rptbtn {
			background-image:url("../images/icons/fam/report.png");
		}
		.printbtn {
			background-image:url("../images/icons/fam/printer.png");
		}
		.excelbtn {
			background-image:url("../images/icons/fam/page_excel.png");
		}
		.csvbtn {
			background-image:url("../images/icons/fam/page_attach.png");
		}
		.refreshbtn {
			background-image:url("../images/icons/fam/arrow_refresh.png");
		}
		.playbtn {
			background-image:url("../images/icons/fam/cd_go.png");
		}
		.downloadbtn {
			background-image:url("../images/icons/fam/drive_disk.png");
		}
		.favoritebtn {
			background-image:url("../images/icons/fam/basket_put.png");
		}
		.exportbtn {
			background-image:url("../images/icons/fam/database_go.png");
		}
		.qualitybtn {
			background-image:url("../images/icons/fam/award_star_silver_1.png") !important;
		}

		.gradebtn {
			background-image:url("../images/icons/fam/award_star_silver_2.png") !important;
		}

		.tablebtn {
			background-image:url("../images/icons/fam/page_attach.png") !important;
		}

    </style>
 	<script >
		var webRoot = '<%=webRoot%>';
	</script>

    <script type="text/javascript" src="../js/ext-base.js"></script>
    <script type="text/javascript" src="../js/ext-all.js"></script>
    <script type="text/javascript" src="../js/ext-lang-zh_CN.js"></script>
    <script type="text/javascript" src="../ux/DateTimeField.js"></script>
    <script type="text/javascript" src="../js/app/common/DateTime.js"></script>
    <script type="text/javascript" src="../js/app/rec/BeginTimeField.js"></script>
    <script type="text/javascript" src="../js/app/rec/EndTimeField.js"></script>
    <script type="text/javascript" src="../js/app/common/TextField.js"></script>
    <script type="text/javascript" src="../js/app/ux/DictSelector.js"></script>
    <script type="text/javascript" src="../js/app/common/Grid.js"></script>
    <script type="text/javascript" src="../js/app/common/Window.js"></script>
    <script type="text/javascript" src="../js/app/qa/QASelectorGrid.js"></script>
    <script type="text/javascript" src="../js/app/qa/QASelectorWindow.js"></script>
    <script type="text/javascript">
	var win_print;
	var pagesize = 25;
	var grid;
	var si;
	var favoritewin, favoriteForm;

	function getRecParamsStr(rec) {
		var params = '';
		params += 'voxpath=' + rec.get('filepath');
		params += '&ucid=' + rec.get('ucid');
		params += '&extno=' + rec.get('extno');
		params += '&rectime=' + rec.get('begin_time');
		params += '&endtime=' + rec.get('end_time');
		params += '&ani=' + rec.get('ani');
		params += '&dnis=' + rec.get('dnis');
		params += '&calltime=' + rec.get('call_time');
		params += '&calltypename=' + rec.get('call_type_name');
		params += '&filepath=' + rec.get('filepath');
		params += '&databasename=' + rec.get('database_name');
		return params;
	}

	function createPlayWin(rec, file) {
		var str = "";
		str += "<object id=player width='100%' height='65' classid='CLSID:6BF52A52-394A-11d3-B153-00C04F79FAA6' codebase='http://activex.microsoft.com/activex/controls/mplayer/en/nsmp2inf.cab#Version=7.0' align='top' border='0' type='application/x-oleobject'>";
		str += "<param name='URL' value='../tmp/" + file + "'>";
		str += "<param name='EnableTracker' value='1'>";
		str += "<param name='uiMode' value='full'>";
		str += "<param name='EnableContextMenu' value='1'>";
		str += "<param name='volume' value='100'>";
		str += "<embed src='../tmp/" + file + "' align='top' border='0' width='98%' height='65' type='application/x-mplayer2' pluginspage='http://www.microsoft.com/isapi/redir.dll?prd=windows&amp;sbp=mediaplayer&amp;ar=media&amp;sba=plugin&amp;' showcontrols='1' showpositioncontrols='1' showaudiocontrols='1' showtracker='1' showdisplay='0' showstatusbar='1' autosize='0' showgotobar='0' showcaptioning='0' autostart='1' autorewind='0' animationatstart='0' transparentatstart='0' allowscan='1' enablecontextmenu='1' clicktoplay='0' invokeurls='1' defaultframe='datawindow'>";
		str += "</embed>";
		str += "</object>";
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

		var fields = [
				   {name: 'id'},
				   {name: 'ucid'},
				   {name: 'recTime'},
				   {name: 'extNo'},
				   {name: 'ani'},
				   {name: 'dnis'},
				   {name: 'fileName'},
				   {name: 'beginTime'},
				   {name: 'endTime'},
				   {name: 'callTypeName'},
				   {name: 'callTime'},
				   {name: 'accessTime'},
				   {name: 'user_name'},
				   {name: 'user_id'},
				   {name: 'rec_user_name'},
				   {name: 'rec_user_id'},
				   {name: 'idx'},
				   {name: 'subidx'}
				];

		var store = new Ext.data.JsonStore({
			root: 'data',
			totalProperty: 'totalCount',
			idProperty: 'id',
			remoteSort: false,

			fields: fields,
			
			proxy: new Ext.data.HttpProxy({
				url: '../data/self.json'
			}),

			listeners: {
				'loadexception': function(proxy, options, response, e){
					var respText = Ext.util.JSON.decode(response.responseText);
					if(respText.respCode != '000') {
						Ext.Msg.alert('查询失败', respText.respMessage + "（" + respText.respCode + "）");
					} else {
					}
				}
			}
		});

		store.setDefaultSort('id', 'desc');
		
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
				text: '质检',
				iconCls: 'playbtn',
				listeners: {
					'click': function(obj, e) {
						var rec = grid.getSelectionModel().getSelected();
						var lineno = grid.getSelectionModel().lastActive;
						if(!rec) {
							Ext.Msg.alert('质检录音', '请选择要质检的录音！');
						} else {
							var myMask = new Ext.LoadMask(grid.getEl(), {msg:"质检中请等待..."});
							myMask.show();
							Ext.Ajax.request({
								url: '../data/play.json',
								success: function(res) {
									myMask.hide();
									var respText = Ext.decode(res.responseText);   
									if(respText.respCode != '000') {
										Ext.Msg.alert('质检失败', respText.respMessage + "（" + respText.respCode + "）");
										grid.getView().getRow(lineno).style.backgroundColor='#FF908E'
									} else {
										var file = respText.respMessage;

										substore = new Ext.data.JsonStore({
											autoDestroy: true,
											fields: fields
										});

										subIdx = rec.get('subidx');

										store.each(function(rec2){
											if(rec.get('idx') == rec2.get('idx')) {
												substore.add(rec2);
											}
										});

										playwin = new Ext.Window({
											layout: 'border',
											width: 650,
											height:260,
											closeAction:'close',
											modal: true,
											plain: true,
											title: '质检录音',
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
													region: 'north', 
													width: 650,
													height: 70,
													border: false,
													html: '<div id=divPlayer>' + createPlayWin(rec, file) + '</div>'
												}),
												new Ext.grid.GridPanel({
													region: 'center', 
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
													height: 190,
													width: '100%',
													viewConfig: {forceFit:true},
													loadMask: true
												})
											],
											buttons: [{
												text: '等级评定',
												iconCls: 'gradebtn',
												listeners: {
													'click' : function() {
														Ext.Ajax.request({
															url: window.webRoot + 'data/qa_item_GRADE.json',
															success: function(res) {
																myMask.hide();
																var respText = Ext.decode(res.responseText); 
																if(respText.code == 'OK') {
																	var qaWin = new Ext.app.qa.QASelectorWindow({
																		width: 720,
																		height:435,
																		title: "等级评定",
																		types: respText.data,
																		groupTypeId: 'GRADE',
																		readOnly: false,
																		userId: '0',
																		recData: rec,
																		iconCls: 'gradebtn',
																		ownerObj: grid
																	});
																	qaWin.show();
																} else {
																	Ext.Msg.alert('查询失败', respText.message + "（" + respText.code + "）");
																}
															},
															failure: function(res) {
																myMask.hide();
																var respText = Ext.decode(res.responseText);   
																Ext.Msg.alert('查询失败', respText.message + "（" + respText.code + "）");
															},
															method: 'POST'
														});
													}
												}
											},{
												text: '分数评定',
												iconCls: 'qualitybtn',
												listeners: {
													'click' : function() {
														var readOnly = rec.get('qaUserId') && rec.get('qaUserId') != '0' ? true : false;
														var isUpdate = rec.get('qaUserId') && rec.get('qaUserId') != '0' ? false : true;
														Ext.Ajax.request({
															url: window.webRoot + 'data/qa_item_GRADE.json',
															success: function(res) {
																myMask.hide();
																var respText = Ext.decode(res.responseText); 
																if(respText.code == 'OK') {
																	var qaWin = new Ext.app.qa.QASelectorWindow({
																		width: 720,
																		height:435,
																		title: "分数评定",
																		types: respText.data,
																		groupTypeId: 'QUALITY',
																		readOnly: false,
																		userId: '0',
																		recData: rec,
																		iconCls: 'qualitybtn',
																		ownerObj: grid
																	});
																	qaWin.show();
																} else {
																	Ext.Msg.alert('查询失败', respText.message + "（" + respText.code + "）");
																}
															},
															failure: function(res) {
																myMask.hide();
																var respText = Ext.decode(res.responseText);   
																Ext.Msg.alert('查询失败', respText.message + "（" + respText.code + "）");
															},
															method: 'POST'
														});
													}
												}
											},{
												text: '表单开具',
												iconCls: 'tablebtn',
												listeners: {
													'click' : function() {
														tableForm.form.reset();
														if (rec.get('recId')) {
															tableForm.find('name', 'recId')[0].setValue(rec.get('recId'));
														} else {
															tableForm.find('name', 'recId')[0].setValue(rec.get('id'));
														}
														tableForm.find('name', 'dataSource')[0].setValue(rec.get('dataSource'));
														tableForm.find('name', 'recUserId')[0].setValue(rec.get('recUserId'));
														tableForm.find('name', 'userId')[0].setValue('0');
														tableWin.show();
													}
												}
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
									//;
								},
								failure: function(res) {
									myMask.hide();
									var respText = Ext.decode(res.responseText);   
									grid.getView().getRow(lineno).style.backgroundColor='#FF908E'
									Ext.Msg.alert('质检失败', respText.respMessage + "（" + respText.respCode + "）");
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
								url: '../json/record.do?method=play',
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

		grid = new Ext.grid.GridPanel({
            region: 'center',
			iconCls: 'gridbtn',
			store: store,
			tbar: toolbar,
			border: false,
			columns: [
				new Ext.grid.RowNumberer(), 
				{
					header   : '系统ID', 
					width    : .1, 
					sortable : true, 
					dataIndex: 'id'
				},
				{
					header   : '客户编号', 
					width    : .1, 
					sortable : true, 
					dataIndex: 'customerId'
				},
				{
					header   : '座席名称', 
					width    : .1, 
					sortable : true, 
					dataIndex: 'agentName'
				},
				{
					header   : '部门', 
					width    : .1, 
					sortable : true, 
					dataIndex: 'deptName'
				},
				{
					header   : '分机号码', 
					width    : .1, 
					sortable : true, 
					dataIndex: 'extNo'
				},
				{
					header   : '呼叫类型', 
					width    : .1, 
					sortable : true, 
					dataIndex: 'callTypeName'
				},
				{
					header   : '开始时间', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'beginTime'
				},
				{
					header   : '结束时间', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'endTime'
				},
				{
					header   : '主叫', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'ani'
				},
				{
					header   : '被叫', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'dnis'
				},
				{
					header   : '时长', 
					width    : .1, 
					sortable : true, 
					dataIndex: 'callTime'
				},
				{
					header   : '评级', 
					width    : .1, 
					sortable : true, 
					dataIndex: 'qa'
				},
				{
					header   : '评分', 
					width    : .1, 
					sortable : true, 
					dataIndex: 'grade'
				},
				{
					header   : '质检时间', 
					width    : .1, 
					sortable : true, 
					dataIndex: 'qaTime'
				}
			],
			stripeRows: true,
			viewConfig: {
				forceFit: true,
				getRowClass: function(rec, idx, params, store) {
//					if(rec.get('scope') == 1) {
//						return 'x-grid-record-private';
//					}
				}
			}, 
			loadMask: true,
			bbar: new Ext.PagingToolbar({
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
				text : '质检',
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
		grid.addListener('rowcontextmenu', function(client, rowIndex, e) {
			e.preventDefault();
            rightClick.showAt(e.getXY());
			grid.getSelectionModel().selectRow(rowIndex);

		});
		/** 列表右键点击菜单 End */	  
//		parent.doReport(store);

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

/*
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
						tip.body.dom.innerHTML =  '时&nbsp;&nbsp;&nbsp;&nbsp;间:&nbsp;<font color=#ffb771>' + rec.get('access_time') + '</font><br>质检人:&nbsp;<font color=#ffb771>' + rec.get('user_name') +'</font>';
					}  
			   }  
			});  
		});
*/

		/** 查询 Start */
		var panel_query = new Ext.Panel({
            layout: 'border',
			region: 'center', 
			autoScroll:false,
			iconCls: 'searchbtn',
			border: false,
			tbar: [
				'-',
				'开始时间:&nbsp;&nbsp;',
				new Ext.app.rec.BeginTimeField({
					id: 'qryBeginTime',
					name: 'beginTime',
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
				new Ext.app.rec.EndTimeField({
					id: 'qryEndTime',
					name: 'endTime',
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
				new Ext.app.common.TextField({
					id: 'qryKey',
					width: 200,
					fieldLabel: '关键字',
					emptyText: '主叫/被叫/分机号码/座席编号/座席名称/客户编号（支持模糊查询）',
					name: 'key'
				}),
				'-',
				'状态:&nbsp;&nbsp;',
				new Ext.app.ux.DictSelector({
					width: 100,
					dictType: 'QA_STATUS',
					fieldLabel: '状态',
					name: 'qaStatus',
					showEmpty: true
				}),
				'-',
				new Ext.Toolbar.Button({
					id: 'btnSearch',
					iconCls: 'searchbtn',
					text: '查询',
					listeners: 
						{'click': function(obj, e) {
								tree.fireEvent('beforeload', tree.getRootNode());
								tree.getLoader().load(tree.getRootNode())
							}
						}
				}),
				'-'
			],
			items: grid
		});
		/** 查询 End */


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
					id: 'txtRecExtNo',
					fieldLabel: '分机号码',
					name: 'extno',
					hidden:true
				},{
					xtype: 'checkboxgroup',
					fieldLabel: '类型',
					defaultType: 'radio',
					name: 'scope',
					items: [
						{boxLabel: '私有', name: 'scope', value: '1', checked: true},
						{boxLabel: '共有', name: 'scope', value: '2'}
					]
				}
			],

			buttons: [
			{
				text: '保&nbsp;存',
				handler: function() {
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
            items: [panel_query]
		});	
	});	
	</script>
 
</head>
<body>
<div id="favorite-win" class="x-hidden"></div>
</body>
</html>
