	var win_print;
	var grid;
	var si;

	var loadMask;
	var cols = new Array();

	var needStat = false;

	var substore;

	var subIdx = 0;

	var playwin, qaWin, tableWin;

	var currentRec;

	var caseTypeStore;

	function findVariable(window, variable){
		if(window.parent[variable]){
			return window.parent[variable];
		}
		if(window.parent == window){
			return;
		}
		return findVariable(window.parent, variable);
	}

	var userInfo;
	try{
		userInfo = findVariable(window,'userInfo');
	}catch(e){

	}

	var Base64 = (function() {
		// Private property
		var keyStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

		// Private method for UTF-8 encoding
		function utf8Encode(string) {
			string = string.replace(/\r\n/g,"\n");
			var utftext = "";
			for (var n = 0; n < string.length; n++) {
				var c = string.charCodeAt(n);
				if (c < 128) {
					utftext += String.fromCharCode(c);
				}
				else if((c > 127) && (c < 2048)) {
					utftext += String.fromCharCode((c >> 6) | 192);
					utftext += String.fromCharCode((c & 63) | 128);
				}
				else {
					utftext += String.fromCharCode((c >> 12) | 224);
					utftext += String.fromCharCode(((c >> 6) & 63) | 128);
					utftext += String.fromCharCode((c & 63) | 128);
				}
			}
			return utftext;
		}

		// Public method for encoding
		return {
			encode : (typeof btoa == 'function') ? function(input) {
				return btoa(utf8Encode(input));
			} : function (input) {
				var output = "";
				var chr1, chr2, chr3, enc1, enc2, enc3, enc4;
				var i = 0;
				input = utf8Encode(input);
				while (i < input.length) {
					chr1 = input.charCodeAt(i++);
					chr2 = input.charCodeAt(i++);
					chr3 = input.charCodeAt(i++);
					enc1 = chr1 >> 2;
					enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
					enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
					enc4 = chr3 & 63;
					if (isNaN(chr2)) {
						enc3 = enc4 = 64;
					} else if (isNaN(chr3)) {
						enc4 = 64;
					}
					output = output +
					keyStr.charAt(enc1) + keyStr.charAt(enc2) +
					keyStr.charAt(enc3) + keyStr.charAt(enc4);
				}
				return output;
			}
		};
	})();

	Ext.override(Ext.grid.GridPanel, {
		getExcelXml: function(includeHidden, config) {
			var worksheet = this.createWorksheet(includeHidden, config);
			var totalWidth = this.getColumnModel().getTotalWidth(includeHidden);
			return '<xml version="1.0" encoding="utf-8">' +
				'<ss:Workbook xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:o="urn:schemas-microsoft-com:office:office">' +
				'<o:DocumentProperties><o:Title>' + config.title + '</o:Title></o:DocumentProperties>' +
				'<ss:ExcelWorkbook>' +
				'<ss:WindowHeight>' + worksheet.height + '</ss:WindowHeight>' +
				'<ss:WindowWidth>' + worksheet.width + '</ss:WindowWidth>' +
				'<ss:ProtectStructure>False</ss:ProtectStructure>' +
				'<ss:ProtectWindows>False</ss:ProtectWindows>' +
				'</ss:ExcelWorkbook>' +
				'<ss:Styles>' +
				'<ss:Style ss:ID="Default">' +
				'<ss:Alignment ss:Vertical="Top" ss:WrapText="1" />' +
				'<ss:Font ss:FontName="arial" ss:Size="10" />' +
				'<ss:Borders>' +
				'<ss:Border ss:Color="#e4e4e4" ss:Weight="1" ss:LineStyle="Continuous" ss:Position="Top" />' +
				'<ss:Border ss:Color="#e4e4e4" ss:Weight="1" ss:LineStyle="Continuous" ss:Position="Bottom" />' +
				'<ss:Border ss:Color="#e4e4e4" ss:Weight="1" ss:LineStyle="Continuous" ss:Position="Left" />' +
				'<ss:Border ss:Color="#e4e4e4" ss:Weight="1" ss:LineStyle="Continuous" ss:Position="Right" />' +
				'</ss:Borders>' +
				'<ss:Interior />' +
				'<ss:NumberFormat />' +
				'<ss:Protection />' +
				'</ss:Style>' +
				'<ss:Style ss:ID="title">' +
				'<ss:Borders />' +
				'<ss:Font />' +
				'<ss:Alignment ss:WrapText="1" ss:Vertical="Center" ss:Horizontal="Center" />' +
				'<ss:NumberFormat ss:Format="@" />' +
				'</ss:Style>' +
				'<ss:Style ss:ID="headercell">' +
				'<ss:Font ss:Bold="1" ss:Size="10" />' +
				'<ss:Alignment ss:WrapText="1" ss:Horizontal="Center" />' +
				'<ss:Interior ss:Pattern="Solid" ss:Color="#A3C9F1" />' +
				'</ss:Style>' +
				'<ss:Style ss:ID="even">' +
				'<ss:Interior ss:Pattern="Solid" ss:Color="#CCFFFF" />' +
				'</ss:Style>' +
				'<ss:Style ss:Parent="even" ss:ID="evendate">' +
				'<ss:NumberFormat ss:Format="yyyy-mm-dd" />' +
				'</ss:Style>' +
				'<ss:Style ss:Parent="even" ss:ID="evenint">' +
				'<ss:NumberFormat ss:Format="0" />' +
				'</ss:Style>' +
				'<ss:Style ss:Parent="even" ss:ID="evenfloat">' +
				'<ss:NumberFormat ss:Format="0.00" />' +
				'</ss:Style>' +
				'<ss:Style ss:ID="odd">' +
				'<ss:Interior ss:Pattern="Solid" ss:Color="#CCCCFF" />' +
				'</ss:Style>' +
				'<ss:Style ss:Parent="odd" ss:ID="odddate">' +
				'<ss:NumberFormat ss:Format="yyyy-mm-dd" />' +
				'</ss:Style>' +
				'<ss:Style ss:Parent="odd" ss:ID="oddint">' +
				'<ss:NumberFormat ss:Format="0" />' +
				'</ss:Style>' +
				'<ss:Style ss:Parent="odd" ss:ID="oddfloat">' +
				'<ss:NumberFormat ss:Format="0.00" />' +
				'</ss:Style>' +
				'</ss:Styles>' +
				worksheet.xml +
				'</ss:Workbook>';
		},

		createWorksheet: function(includeHidden, config) {
			// Calculate cell data types and extra class names which affect formatting
			var cellType = [];
			var cellTypeClass = [];
			var cm = this.getColumnModel();
			var totalWidthInPixels = 0;
			var colXml = '';
			var headerXml = '';
			var visibleColumnCountReduction = 0;
			var colCount = cm.getColumnCount();
			for (var i = 0; i < colCount; i++) {
				if ((cm.getDataIndex(i) != '')
					&& (includeHidden || !cm.isHidden(i))) {
					var w = cm.getColumnWidth(i)
					totalWidthInPixels += w;
					if (cm.getColumnHeader(i) === ""){
						cellType.push("None");
						cellTypeClass.push("");
						++visibleColumnCountReduction;
					}
					else
					{
						colXml += '<ss:Column ss:AutoFitWidth="1" ss:Width="' + w + '" />';
						headerXml += '<ss:Cell ss:StyleID="headercell">' +
							'<ss:Data ss:Type="String">' + cm.getColumnHeader(i) + '</ss:Data>' +
							'<ss:NamedCell ss:Name="Print_Titles" /></ss:Cell>';
						var fld = this.store.recordType.prototype.fields.get(cm.getDataIndex(i));

						switch(fld.type) {
							case "int":
								cellType.push("Number");
								cellTypeClass.push("int");
								break;
							case "float":
								cellType.push("Number");
								cellTypeClass.push("float");
								break;
							case "bool":
							case "boolean":
								cellType.push("String");
								cellTypeClass.push("");
								break;
							case "date":
								cellType.push("DateTime");
								cellTypeClass.push("date");
								break;
							default:
								cellType.push("String");
								cellTypeClass.push("");
								break;
						}
					}
				}
			}
			var visibleColumnCount = cellType.length - visibleColumnCountReduction;

			var result = {
				height: 9000,
				width: Math.floor(totalWidthInPixels * 30) + 50
			};

			// Generate worksheet header details.
			var t = '<ss:Worksheet ss:Name="' + config.title + '">' +
				'<ss:Names>' +
				'<ss:NamedRange ss:Name="Print_Titles" ss:RefersTo="=\'' + config.title + '\'!R1:R2" />' +
				'</ss:Names>' +
				'<ss:Table x:FullRows="1" x:FullColumns="1"' +
				' ss:ExpandedColumnCount="' + (visibleColumnCount + 2) +
				'" ss:ExpandedRowCount="' + (this.store.getCount() + 2) + '">' +
				colXml +
				'<ss:Row ss:Height="38">' +
				'<ss:Cell ss:StyleID="title" ss:MergeAcross="' + (visibleColumnCount - 1) + '">' +
				'<ss:Data xmlns:html="http://www.w3.org/TR/REC-html40" ss:Type="String">' +
				'<html:B>'+ config.title +'</html:B></ss:Data><ss:NamedCell ss:Name="Print_Titles" />' +
				'</ss:Cell>' +
				'</ss:Row>' +
				'<ss:Row ss:AutoFitHeight="1">' +
				headerXml +
				'</ss:Row>';

			// Generate the data rows from the data in the Store
			for (var i = 0, it = config.store, l = it.length; i < l; i++) {//this.store.data.items
				t += '<ss:Row>';
				var cellClass = (i & 1) ? 'odd' : 'even';
				r = it[i].data;
				var k = 0;
				for (var j = 0; j < colCount; j++) {
					if ((cm.getDataIndex(j) != '')
						&& (includeHidden || !cm.isHidden(j))) {
						var v = r[cm.getDataIndex(j)];

						if(cm.getDataIndex(j)=='ani'){
							v = r['displayAni'];
						}
						if(cm.getDataIndex(j)=='dnis'){
							v = r['displayDnis'];
						}

						if (cellType[k] !== "None") {
							t += '<ss:Cell ss:StyleID="' + cellClass + cellTypeClass[k] + '"><ss:Data ss:Type="' + cellType[k] + '">';
							if (cellType[k] == 'DateTime') {
								t += v.format('Y-m-d');
							} else {
								t += v;
							}
							t +='</ss:Data></ss:Cell>';
						}
						k++;
					}
				}
				t += '</ss:Row>';
			}

			result.xml = t + '</ss:Table>' +
				'<x:WorksheetOptions>' +
				'<x:PageSetup>' +
				'<x:Layout x:CenterHorizontal="1" x:Orientation="Landscape" />' +
				'<x:Footer x:Data="Page &amp;P of &amp;N" x:Margin="0.5" />' +
				'<x:PageMargins x:Top="0.5" x:Right="0.5" x:Left="0.5" x:Bottom="0.8" />' +
				'</x:PageSetup>' +
				'<x:FitToPage />' +
				'<x:Print>' +
				'<x:PrintErrors>Blank</x:PrintErrors>' +
				'<x:FitWidth>1</x:FitWidth>' +
				'<x:FitHeight>32767</x:FitHeight>' +
				'<x:ValidPrinterInfo />' +
				'<x:VerticalResolution>600</x:VerticalResolution>' +
				'</x:Print>' +
				'<x:Selected />' +
				'<x:DoNotDisplayGridlines />' +
				'<x:ProtectObjects>False</x:ProtectObjects>' +
				'<x:ProtectScenarios>False</x:ProtectScenarios>' +
				'</x:WorksheetOptions>' +
				'</ss:Worksheet>';
			return result;
		}
	});

	function getParamsStr() {
		var params = '';
		params += 'reportname=' + reportname + '&'
		params += 'tablename=' + tablename + '&'
		params += 'ds=' + ds + '&'
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

	function getParamsArray() {
		var params = new Array();

		params['reportname'] = reportname;
		params['tablename'] = tablename;
		params['ds'] = ds;

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
		var str = "<iframe frameborder='no' border=0 height='100%' width='100%' src='../play.html' scrolling='auto'></iframe>";
		return str;
	}
	Ext.onReady(function(){

		var sm = new Ext.grid.CheckboxSelectionModel();

		Ext.QuickTips.init();
		var colsObj = new Array();
		var attrs = new Array();
		colsObj.push(sm);

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
			totalProperty: 'total',
			remoteSort: true,
			idProperty: 'id',

			fields: fields,

			proxy: new Ext.data.HttpProxy({
				url: window.webRoot + 'Report/RecordDetails',
				method :'POST',
				timeout: 300000
			}),

			listeners: {
				'loadexception': function(proxy, options, response, e){
					var respText = Ext.util.JSON.decode(response.responseText);
					if(respText.code != 'OK') {
						Ext.Msg.alert('查询失败', respText.message + "（" + respText.code + "）");
					} else {
//						alert("ok！");
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

		store.setDefaultSort('beginTime', 'asc');

		store.on('beforeload', function(loader, node) {
			//部门（当前登录用户）
			loader.baseParams.deptName = userInfo.deptName;
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

		if(PRIVILEGE_REC_PLAY) {
			toolbar.addButton(new Ext.Toolbar.Button({
					id: 'btnPlay',
					text: '调听',
					iconCls: 'playbtn',
					listeners: {
						'click': function(obj, e) {
							var rec = grid.getSelectionModel().getSelected();
							currentRec = rec;
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

								var actions = new Array();

								actions.push(
									{
										id: 'btnDownload2',
										text: '下载录音',
										iconCls: 'downloadbtn',
										hidden: true,
										handler : function(obj, e) {
												Ext.getCmp('btnDownload').fireEvent('click');
											}
									}
								)

								actions.push(
									{
										text: '结束调听',
										iconCls: 'stopbtn',
										listeners: {
											'click' : function() {
												playwin.close();
											}
										}
									}
								)

								playwin = new Ext.Window({
									layout: 'anchor',
									width: 705,
									height: Ext.isIE ? 268 : 256,
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
										},
										'beforedestroy': function(obj) {
											if(qaWin) {
												qaWin.close();
											}
											if(tableWin) {
												tableWin.close();
											}
											clearInterval(si);
											var ua = navigator.userAgent.toLowerCase();
											var isOpera = ua.indexOf("opera") > -1;
											var isIE = !isOpera && ua.indexOf("msie") > -1;
											var len;
											window.frames["player"].stop();
										}
									},
									items:[
										new Ext.Panel({
											anchor: '100%',
											height: Ext.isIE ? 100 : 88,
											border: false,
	//										html: '<div id=divPlayer>' + createPlayWin(rec, file) + '</div>'
											html: "<iframe name='player' frameborder='no' border=0 height='100%' width='100%' src='../play.html' scrolling='auto'></iframe>"
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
													dataIndex: 'displayAni'
												},
												{
													header   : '被叫',
													width    : .3,
													sortable : true,
													dataIndex: 'displayDnis'
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
										})
									],
									buttons: [actions]
								});
								grid.getView().getRow(lineno).style.backgroundColor='#80FE8E';
								playwin.show();
							}
						}
					}
				})
			);
			toolbar.addSeparator();
		}

		if(PRIVILEGE_REC_DOWNLOAD) {
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
								downloadwin = new Ext.Window({
									layout: 'anchor',
									width: 560,
									height:150,
									closeAction:'close',
									modal: true,
									plain: true,
									title: '下载录音',
									iconCls: 'playbtn',
									items:[
										new Ext.Panel({
											anchor: '100%',
											height: 88,
											border: false,
											html: "<iframe name='download' frameborder='no' border=0 height='100%' width='100%' src='../download.html' scrolling='auto'></iframe>"
										})
									],
									buttons: [
										{
											id: 'btnDownloadStatus',
											text: '下载中请稍候',
											iconCls: 'loadingbtn',
											hidden: true,
											listeners: {
												'click' : function() {
												}
											}
										},
										{
											text: '关&nbsp;&nbsp;闭',
											iconCls: 'stopbtn',
											listeners: {
												'click' : function() {
													downloadwin.close();
												}
											}
										}
									]
								});
								downloadwin.show();
							}
						}
					}
				})
			);
			toolbar.addSeparator();
		}


		/*if (PRIVILEGE_REC_EXPORT) {
				toolbar.addButton(new Ext.Toolbar.Button(
								{
									id : 'btnExport',
									text : '导出',
									iconCls : 'excelbtn',
									listeners : {
										'click' : function(obj, e) {
											// if(!grid.getSelectionModel().getSelected()){
											// Ext.Msg.alert('提示','您还没有选择哦！');
											// }else{

											// Ext.Msg.alert('提示','数据大于5000条请选择csv格式！');
											Ext.Msg
													.show({
														title : '提示',
														msg : '数据大于5000条请选择csv格式，是否继续？',
														buttons : Ext.Msg.YESNOCANCEL,
														fn : function(btn, text) {
															if (btn == "yes") {
																Ext.Msg.hide();
																var exportwin = new Ext.Window(
																		{
																			layout : 'anchor',
																			width : 560,
																			height : 150,
																			closeAction : 'close',
																			modal : true,
																			plain : true,
																			title : '导出记录',
																			iconCls : 'excelbtn',
																			items : [ new Ext.Panel(
																					{
																						anchor : '100%',
																						height : 88,
																						border : false,
																						html : "<iframe name='export' frameborder='no' border=0 height='100%' width='100%' src='../export_1.html' scrolling='auto'></iframe>"
																					}) ],
																			buttons : [ {
																				text : '关&nbsp;&nbsp;闭',
																				iconCls : 'stopbtn',
																				listeners : {
																					'click' : function() {
																						exportwin
																								.close();
																					}
																				}
																			} ]
																		});
																//	}
																		exportwin.show();
															} else {
																Ext.Msg.hide();
															}
														}
													});
										}
									}
							}));
				toolbar.addSeparator();
			}*/

		grid = new Ext.grid.GridPanel({
            region: 'center',
			iconCls: 'gridbtn',
			store: store,
			tbar: toolbar,
			border: false,
			columns: colsObj,
			stripeRows: true,
			selModel: sm,
			viewConfig: {
				forceFit: true,
				enableRowBody:true,
				getRowClass: function(rec, idx, params, store) {
					return getRecordRowClass(rec, idx, params, store);
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
		if(PRIVILEGE_REC_PLAY) {
			grid.addListener('rowdblclick', function(obj, e) {
							Ext.getCmp('btnPlay').fireEvent('click');
						});
		}
		/** 列表双击操作 End */

		/** 列表右键点击菜单 Start */
		var rightClick = new Ext.menu.Menu();
			if(PRIVILEGE_REC_PLAY) {
				rightClick.add({
					text : '调听',
					iconCls : 'playbtn',
					handler : function(obj, e) {
							Ext.getCmp('btnPlay').fireEvent('click');
						}
				});
			}
			if(PRIVILEGE_REC_DOWNLOAD) {
				rightClick.add({
					text : '下载',
					iconCls : 'downloadbtn',
					handler : function(obj, e) {
							Ext.getCmp('btnDownload').fireEvent('click');
						}
				});
			}
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

			/*if(PRIVILEGE_REC_EXPORT) {
				rightClick.addSeparator();
				rightClick.add({
					text : '导出',
					iconCls : 'excelbtn',
					handler : function(obj, e) {
							Ext.getCmp('btnExport').fireEvent('click');
						}
				});
			}*/

		grid.addListener('rowcontextmenu', function(client, rowIndex, e) {
			e.preventDefault();
            rightClick.showAt(e.getXY());
			grid.getSelectionModel().selectRow(rowIndex);

		});
		/** 列表右键点击菜单 End */
//		parent.doReport(store);

		store.baseParams = getParamsArray();

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

	});
