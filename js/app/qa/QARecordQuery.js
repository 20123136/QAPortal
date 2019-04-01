	var win_print;
	var grid;
	var si;
	var playwin, qaWin, tableWin;
	var appealForm;

	var loadMask;
	var cols = new Array();

	var needStat = false;

	var substore;

	var subIdx = 0;

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
			for (var i = 0, it = this.store.data.items, l = it.length; i < l; i++) {
				t += '<ss:Row>';
				var cellClass = (i & 1) ? 'odd' : 'even';
				r = it[i].data;
				var k = 0;
				for (var j = 0; j < colCount; j++) {
					if ((cm.getDataIndex(j) != '')
						&& (includeHidden || !cm.isHidden(j))) {
						var v = r[cm.getDataIndex(j)];
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

	function updateCaseData(rec) {
		Ext.Ajax.request({
			url: window.webRoot + 'QACase/GetByRecord/' + rec.get('recId'),
			success: function(res) {
				var respText = Ext.decode(res.responseText);
				if(respText.code == 'OK') {
					/*
					if(respText.data.userId){
						rec.set('qaCaseUserId', respText.data.userId);
					} else {
						rec.set('qaCaseUserId', '');
					}
					if(respText.data.status) {
						rec.set('qaCaseStatus', respText.data.status);
					} else {
						rec.set('qaCaseStatus', 'IDLE');
					}
					if(respText.data.attribute) {
						rec.set('qaCaseAttribute', respText.data.attribute);
					} else {
						rec.set('qaCaseAttribute', '');
					}

					grid.getStore().loadData(rec, true);
					*/

					var pgbar = grid.getBottomToolbar();
					var activePage = Math.ceil((pgbar.cursor + pgbar.pageSize) / pgbar.pageSize);
					var start = (activePage - 1) * pgbar.pageSize;
					grid.getStore().load({params:{start:start, limit:pagesize}});

					//更新按钮状态
					updateButton(rec);
				}
			},
			failure: function(res) {
			},
			method: 'GET',
			timeout: 3000
		});
	}

	function loadCaseData(form, rec) {
		Ext.Ajax.request({
			url: window.webRoot + 'QACase/GetByRecord/' + rec.get('recId'),
			success: function(res) {
				var respText = Ext.decode(res.responseText);
				if(respText.code == 'OK' && respText.data) {
					//设置案例属性
					var obj = form.find('name', 'rgAttribute')[0];
					Ext.each(obj.items.items, function(item){
						if(respText.data.attribute == item.value) {
							item.setValue(true);
						} else {
							item.setValue(false);
						}
					});

					//设置案例大类
					var obj = form.find('name', 'cbgCaseType0')[0];
					var selected;
					Ext.each(obj.items.items, function(item){
						selected = false;
						Ext.each(respText.data.types, function(type) {
							if(type == item.value) {
								selected = true;
							}
						});
						if(selected) {
							item.setValue(true);
						} else {
							item.setValue(false);
						}
					});

					//设置案例类型
					var obj = form.find('name', 'cbgCaseType')[0];
					var selected;
					Ext.each(obj.items.items, function(item){
						selected = false;
						Ext.each(respText.data.types, function(type) {
							if(type == item.value) {
								selected = true;
							}
						});
						if(selected) {
							item.setValue(true);
						} else {
							item.setValue(false);
						}
					});

					//提交原因
					form.find('name', 'reason')[0].setValue(respText.data.reason);

					//审核理由
					form.find('name', 'checkReason')[0].setValue(respText.data.checkReason);
				}
			},
			failure: function(res) {
			},
			method: 'GET',
			timeout: 3000
		});
	}

	function updateButton(rec) {
		var obj, obj2, obj3, obj4;

		/** 下载录音按钮 Start */
		obj = Ext.getCmp('btnDownload2');
		if(PRIVILEGE_REC_DOWNLOAD) {
			obj.show();
		} else {
			obj.hide();
		}
		/** 下载录音按钮 End */

		/** 提交申诉按钮 Start */
		obj = Ext.getCmp('btnAppealed');
		if(rec.get('qaStatus') == 'COMPLETED' || rec.get('qaStatus') == 'UPDATED') {
			//已完成质检且未审核的录音记录可以申诉
			if(rec.get('agentId') == userInfo.userId) {
				//如果录音属于当前用户，则可以申诉
				obj.enable();
				obj.show();
			} else {
				//不是当前用户的录音不能申诉
				obj.hide();
			}
		} else if(rec.get('qaStatus') == 'APPEALED') {
			//已申诉的录音记录
			if(rec.get('agentId') == userInfo.userId) {
				//如果录音属于当前用户，则不可以申诉，但显示申诉按钮
				obj.disable();
				obj.show();
			} else {
				//不是当前用户的录音不能申诉
				obj.hide();
			}
		} else {
			obj.hide();
		}
		/** 提交申诉按钮 End */

		/** 质检评分按钮 Start */
		var status = getQAGradeButtonStatus(rec);
		obj = Ext.getCmp('btnQAGrade');
		obj2 = Ext.getCmp('btnQAGradeView');
		obj3 = Ext.getCmp('btnQAGradeCheck');
		obj4 = Ext.getCmp('btnQAGradeCheckedView');
		if(status == 'None') {
			//None: 无功能，不显示按钮
			obj.hide();
			obj2.hide();
			obj3.hide();
			obj4.hide();
		} else if(status == 'Grade') {
			//Submit: 可以提交，显示按钮‘提交案例’，案例窗口数据清空
			obj.setText('质检评分');
			obj.show();
			obj2.hide();
			obj3.hide();
			obj4.hide();
		} else if(status == 'Update') {
			//Update: 修改评分，显示按钮‘修改案例’，案例窗口显示当前案例信息，可修改
			obj.setText('修改评分');
			obj.show();
			obj2.hide();
			obj3.hide();
			obj4.hide();
		} else if(status == 'View') {
			//View: 查看评分结果，显示按钮‘查看案例’，案例窗口显示当前案例信息，不可修改
			obj.setText('质检详情');
			obj.hide();
			obj2.show();
			obj3.hide();
			obj4.hide();
		} else if(status == 'CheckedView') {
			//View: 查看评分结果，显示按钮‘查看案例’，案例窗口显示当前案例信息，不可修改
			obj.setText('质检详情');
			obj.hide();
			obj2.hide();
			obj3.hide();
			obj4.show();
		} else if(status == 'Check') {
			//Check: 复核评分结果，显示按钮‘复核评分’，案例窗口显示当前案例信息，不可修改
			obj.setText('复核评分');
			obj.hide();
			obj2.hide();
			obj3.show();
			obj4.hide();
		}
		/** 提交案例按钮 End */

		/** 提交案例按钮 Start */
		var status = getCaseSubmitButtonStatus(rec);
		obj = Ext.getCmp('btnCaseSubmit');
		if(status == 'None') {
			//None: 无功能，不显示按钮
			obj.hide();
		} else if(status == 'Submit') {
			//Submit: 可以提交，显示按钮‘提交案例’，案例窗口数据清空
			obj.setText('提交案例');
			obj.showmode = 'Submit';
			obj.show();
		} else if(status == 'Update') {
			//Update: 修改案例，显示按钮‘修改案例’，案例窗口显示当前案例信息，可修改
			obj.setText('修改案例');
			obj.showmode = 'Update';
			obj.show();
		} else if(status == 'View') {
			//View: 查看案例，显示按钮‘查看案例’，案例窗口显示当前案例信息，不可修改
			obj.setText('案例详情');
			obj.showmode = 'View';
			obj.show();
		} else if(status == 'Check') {
			//Check: 审核案例，显示按钮‘审核案例’，案例窗口显示当前案例信息，可修改
			obj.setText('审核案例');
			obj.showmode = 'Check';
			obj.show();
		}
		/** 提交案例按钮 End */

		/** 审核案例按钮 Start */
/*
		obj = Ext.getCmp('btnCaseCheck');
		if(PRIVILEGE_CASE_CHECK && (rec.get('qaCaseStatus') == 'SUBMIT' || rec.get('qaCaseStatus') == 'UPDATED')) {
			//如果当前用户拥有审核案例权限，且当前记录已提交案例则显示‘审核案例’按钮
			obj.setText('审核案例');
			tableWin.setTitle("审核案例");
			tableForm.enable();
			obj.show();
		} else {
			//其它情况隐藏‘审核案例’按钮
			obj.hide();
		}
*/
		/** 审核案例按钮 End */
	}

	//获得质检评分按钮的当前可操作状态
	//Grade: 可以评分，显示按钮‘质检评分’，评分窗口数据清空
	//Update: 修改评分，显示按钮‘修改评分’，评分窗口显示当前评分信息，可修改
	//View: 查看评分结果，显示按钮‘质检明细’，评分窗口显示当前评分信息，不可修改
	//None: 无功能，不显示按钮
	function getQAGradeButtonStatus(rec) {
		var status = rec.get('qaStatus');
		var userId = rec.get('qaUserId');

		if(status == 'APPEALED') {
			if(PRIVILEGE_QA_CHECK) {
				//如果用户具有复核权限，则可以复核申诉中的质检记录
				return 'Check';
			} else {
				//其它情况显示按钮
				return 'View';
			}
		}

		if(status == 'CHECKED') {
			if(PRIVILEGE_QA_VIEW_DETAIL || PRIVILEGE_QA_GRADE) {
				//如果质检已经完成审核，则只能查看
				return 'CheckedView';
			} else {
				return 'None';
			}
		}

		if(status == 'IDLE') {
			if(PRIVILEGE_QA_GRADE) {
				//如果录音未质检，且具有质检权限，则显示质检评分按钮
				return 'Grade';
			} else {
				//其它情况不显示按钮
				return 'None';
			}
		}

		if(status == 'ASSIGNED') {
			if(PRIVILEGE_QA_GRADE && userId == userInfo.userId) {
				//如果录音已分配，当前用户有质检权限且就是分配的质检员，则显示质检评分按钮
				return 'Grade';
			} else {
				//其它情况不显示按钮
				return 'None';
			}
		}

		if(status == 'COMPLETED' || status == 'UPDATED') {
			//如果质检评分已经提交，则判断提交人是否是当前用户
			if(PRIVILEGE_QA_GRADE) {
				//拥有提交案例权限
				if(userId == userInfo.userId) {
					//案例提交者是当前用户，则可以更改
					return 'Update';
				} else {
					//当前用户不是案例提交者，则只能查看
					return 'View';
				}
			} else {
				if(PRIVILEGE_QA_VIEW_DETAIL) {
					//当前用户有质检查看权限
					return 'View';
				} else {
					//当前用户没有质检查看权限
					return 'None';
				}
			}
		}

		if(PRIVILEGE_QA_GRADE) {
			return 'Grade';
		} else {
			//其它情况不显示按钮
			return 'None';
		}
	}

	//获得质检案例的当前可操作状态
	//Submit: 可以提交，显示按钮‘提交案例’，案例窗口数据清空
	//Update: 修改案例，显示按钮‘修改案例’，案例窗口显示当前案例信息，可修改
	//View: 查看案例，显示按钮‘查看案例’，案例窗口显示当前案例信息，不可修改
	//None: 无功能，不显示按钮
	function getCaseSubmitButtonStatus(rec) {
		var caseStatus = rec.get('qaCaseStatus');
		var caseUserId = rec.get('qaCaseUserId');

		if(rec.get('qaStatus') == 'IDLE' //未质检记录不能提交案例
			|| rec.get('qaStatus') == 'ASSIGNED' //已分配但未质检记录不能提交案例
			){
			return 'None';
		}

		if(caseStatus == 'CHECKED' || caseStatus == 'REJECTED') {
			//如果案例已经完成审核，则只能查看
			return 'View';
		}

		if(caseStatus == 'IDLE') {
			if(PRIVILEGE_CASE_SUBMIT) {
				//如果案例未提交过，且具有提交案例权限，则显示可提交
				return 'Submit';
			} else {
				//其它情况不显示按钮
				return 'None';
			}
		}

		if(caseStatus == 'SUBMIT' || caseStatus == 'UPDATED') {
			//如果案例已经提交，则判断提交人是否是当前用户
			if(PRIVILEGE_CASE_SUBMIT) {
				//拥有提交案例权限
				if(caseUserId == userInfo.userId) {
					//案例提交者是当前用户，则可以更改
					return 'Update';
				} else {
					//当前用户不是案例提交者，则只能查看
					return 'View';
				}
			} else {
				//当前用户不是案例提交者，则只能查看
				return 'View';
			}
		}

		if(PRIVILEGE_CASE_SUBMIT) {
			return 'Submit';
		} else {
			//其它情况不显示按钮
			return 'None';
		}
	}

	function disableCaseForm(form, disabled) {
		//提交属性
		var obj = form.find('name', 'rgAttribute')[0];
		Ext.each(obj.items.items, function(item){
			item.el.dom.disabled = disabled;
		});

		//案例大类
		var obj = form.find('name', 'cbgCaseType0')[0];
		Ext.each(obj.items.items, function(item){
			item.el.dom.disabled = disabled;
		});

		//案例类型
		var obj = form.find('name', 'cbgCaseType')[0];
		Ext.each(obj.items.items, function(item){
			item.el.dom.disabled = disabled;
		});

		//提交原因
		form.find('name', 'reason')[0].setReadOnly(disabled);

		//审核理由
		form.find('name', 'checkReason')[0].setReadOnly(disabled);
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

	function showCaseWindow(showmode, rec) {
		/** 提交案例 START */
		//var rec = grid.getSelectionModel().getSelected();

		//质检项类型
		var groupTypeId = rec.get('qaGroupType');

		var caseTypes1 = new Array();
		caseTypeStore.each(function(record){
			if(record.get('groupTypeId') == groupTypeId && record.get('fatherId') == '0') {
				caseTypes1.push(new Ext.form.Checkbox({
					boxLabel: record.get('name'),
					name: 'types',
					value: record.get('id')
				}));
			}
		});

		if(caseTypes1.length == 0) {
			caseTypes1.push(new Ext.form.Checkbox({
				disabled: true,
				boxLabel: '无选项',
				name: 'types',
				value: ''
			}));
		}

		var caseTypes2 = new Array();
		caseTypeStore.each(function(record){
			if(record.get('groupTypeId') == groupTypeId && record.get('fatherId') != '0') {
				caseTypes2.push(new Ext.form.Checkbox({
					boxLabel: record.get('name'),
					name: 'types',
					value: record.get('id')
				}));
			}
		});

		if(caseTypes2.length == 0) {
			caseTypes2.push(new Ext.form.Checkbox({
				disabled: true,
				boxLabel: '无选项',
				name: 'types',
				value: ''
			}));
		}

		var tableForm = new Ext.FormPanel({
			labelWidth: 120,
			width: '100%',
			frame: true,
			defaults: {width: 680},

			items: [
				{
					xtype: 'fieldset',
					title: '案例属性',
					width: 680,
					autoHeight: true,
					collapsed: false,
					collapsible: true,
					items: [
						{
							name: 'rgAttribute',
							xtype: 'radiogroup',
							hideLabel: true,
							items: [
								{boxLabel: '优秀', name: 'attribute', value: 1},
								{boxLabel: '合格', name: 'attribute', value: 2},
								{boxLabel: '不合格', name: 'attribute', value: 3}
							],
							listeners: {
								'change': function(group, radio) {
									Ext.each(group.items.items, function(item) {
										if(item.getValue()) {
											Ext.getDom(item.getId()).nextSibling.style.color = 'blue';
										} else {
											Ext.getDom(item.getId()).nextSibling.style.color = 'black';
										}
									});
								}
							}
						}
					]
				},{
					xtype: 'fieldset',
					title: '质检信息',
					width: 680,
					autoHeight: true,
					collapsed: true,
					collapsible: true,
					items: [
						{
							border: false,
							width: 680,
							html: '<table width=666 align=center border="0" cellpadding="0" cellspacing="0" width="100%">' +
									'<tr>' +
									'<td width=115 align=left>座&nbsp;&nbsp;席&nbsp;&nbsp;&nbsp;&nbsp;: </td>' +
									'<td width=210 align=left><span style="color:blue;">' + rec.get('agentName') + '</span></td>' +
									'<td width=115 align=left>通话时长: </td>' +
									'<td width=210 align=left><span style="color:blue;">' + rec.get('displayLength') + '</span></td>' +
									'</tr>' +
									'<tr>' +
									'<td width=115 align=left>评分时间: </td>' +
									'<td width=210 align=left><span style="color:blue;">' + rec.get('qaTime') + '</span></td>' +
									'<td width=115 align=left>评分成绩: </td>' +
									'<td width=210 align=left><span style="color:blue;">' + rec.get('qaScore') + '</span></td>' +
									'</tr>' +
								   '</table>'
						}
					]
				},{
					xtype: 'fieldset',
					title: '案例大类',
					width: 680,
					autoHeight: true,
					collapsed: false,
					collapsible: true,
					defaultType: 'checkbox',
					items: [
						{
							name: 'cbgCaseType0',
							xtype: 'checkboxgroup',
							hideLabel: true,
							columns: 5,
							items: caseTypes1,
							listeners: {
								'change': function(group, cbs) {
									Ext.each(group.items.items, function(item) {
										if(item.getValue()) {
											Ext.getDom(item.getId()).nextSibling.style.color = 'blue';
										} else {
											Ext.getDom(item.getId()).nextSibling.style.color = 'black';
										}
									});
								}
							}
						}
					]
				},{
					xtype: 'fieldset',
					title: '案例类型',
					width: 680,
					autoHeight: true,
					collapsed: false,
					collapsible: true,
					defaultType: 'checkbox',
					items: [
						{
							name: 'cbgCaseType',
							xtype: 'checkboxgroup',
							hideLabel: true,
							columns: 5,
							items: caseTypes2,
							listeners: {
								'change': function(group, cbs) {
									Ext.each(group.items.items, function(item) {
										if(item.getValue()) {
											Ext.getDom(item.getId()).nextSibling.style.color = 'blue';
										} else {
											Ext.getDom(item.getId()).nextSibling.style.color = 'black';
										}
									});
								}
							}
						}
					]
				},{
					xtype: 'fieldset',
					title: '提交理由',
					width: 680,
					autoHeight: true,
					collapsed: false,
					collapsible: true,
					items: [
						{
							xtype: 'textarea',
							width: 650,
							hideLabel: true,
							style:'color:blue;',
							height: 36,
							name: 'reason'
						}
					]
				},{
					xtype: 'fieldset',
					title: '审核理由',
					width: 680,
					autoHeight: true,
					collapsed: false,
					collapsible: true,
					items: [
						{
							xtype: 'textarea',
							width: 650,
							hideLabel: true,
							style:'color:blue;',
							height: 36,
							name: 'checkReason'
						}
					]
				}
			]
		});

		var title = '';
		if(showmode == 'Submit') {
			title = '提交案例';
		} else if(showmode == 'Update') {
			title = '修改案例';
		} else if(showmode == 'View') {
			title = '案例详情';
		} else if(showmode == 'Check') {
			title = '审核案例';
		}

		tableWin = new Ext.Window({
			width: 720,
			height:485,
			closeAction:'close',
			modal: true,
			plain: true,
			title: title,
			iconCls: "tablebtn",
			items: [tableForm],
			recData: rec,
			buttons: [{
				text: '返回调听页面',
				handler: function() {
					if(playwin && playwin.isVisible()) {
						playwin.toFront();
					}
				}
			},{
				text:'确认',
				handler: function(){
					if(showmode == 'View') {
						tableWin.hide();
						return;
					}
					var vals = tableForm.form.getValues();
					var params = '';
					//var rec = grid.getSelectionModel().getSelected();
					var rec = tableWin.recData;

					//设置录音记录ID
					params += 'recId=' + rec.get('recId');

					//检查案例属性
					var attributes = tableForm.find('name', 'rgAttribute')[0];
					var attribute = null;
					Ext.each(attributes.items.items, function(item){
						if(item.getValue()) {
							attribute = item.value;
						}
					});
					if(!attribute) {
						Ext.Msg.alert('提示', '请选择案例属性！');
						return;
					}

					params += '&attribute=' + attribute;

					//检查案例大类
					var types = tableForm.find('name', 'cbgCaseType0')[0];
					var typeSelected = false;
					Ext.each(types.items.items, function(item){
						if(item.getValue()) {
							typeSelected = true;
							params += '&types=' + item.value;
						}
					});
					if(!typeSelected) {
						Ext.Msg.alert('提示', '请选择案例大类！');
						return;
					}

					//检查案例类型
					var types = tableForm.find('name', 'cbgCaseType')[0];
					var typeSelected = false;
					Ext.each(types.items.items, function(item){
						if(item.getValue()) {
							typeSelected = true;
							params += '&types=' + item.value;
						}
					});
					if(!typeSelected) {
						Ext.Msg.alert('提示', '请选择案例类型！');
						return;
					}

					if(vals.reason) {
						params += '&reason=' + vals.reason;
					} else {
						params += '&reason=';
					}

					if(vals.checkReason) {
						params += '&checkReason=' + vals.checkReason;
					} else {
						params += '&checkReason=';
					}

					Ext.Ajax.request({
						url: window.webRoot + 'QACase',
						success: function(response,options) {
							var respText = Ext.util.JSON.decode(response.responseText);
							if(respText.code == 'OK') {
								Ext.Msg.alert('保存成功', '提交案例成功！');
								updateCaseData(rec);
								tableWin.hide();
							} else {
								Ext.Msg.alert('保存失败', respText.message + "（" + respText.code + "）");
							}
						},
						failure: function(response,options) {
							Ext.Msg.alert('保存失败', '连接异常！');
						},
						method: 'POST',
						params: params
					});
				}
			},{
				text: '取消',
				handler: function(){
					tableWin.hide();
				}
			}]
		});

		tableWin.on('show', function(obj) {
			//var rec = grid.getSelectionModel().getSelected();
			var rec = obj.recData;

			if(showmode == 'View') {
				var caseStatus = rec.get('qaCaseStatus');
				if(caseStatus == 'CHECKED') {
					tableForm.find('name', 'checkReason')[0].ownerCt.show();
				} else {
					tableForm.find('name', 'checkReason')[0].ownerCt.hide();
				}
				disableCaseForm(tableForm, true);
			} else if (showmode == 'Submit' || showmode == 'Update') {
				tableForm.find('name', 'checkReason')[0].ownerCt.hide();
				disableCaseForm(tableForm, false);
			} else if (showmode == 'Check') {
				tableForm.find('name', 'checkReason')[0].ownerCt.show();
				disableCaseForm(tableForm, false);
			} else {
				tableForm.find('name', 'checkReason')[0].ownerCt.show();
				disableCaseForm(tableForm, true);
			}

			loadCaseData(tableForm, rec);
		});

		tableWin.show();
	}

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
			totalProperty: 'total',
			remoteSort: true,
			idProperty: 'qaRecordId',

			fields: fields,

			proxy: new Ext.data.HttpProxy({
				url: window.webRoot + 'Report/QARecord',
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

		store.setDefaultSort('beginTime', 'asc');

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
								if(rec.get('qaRecordId') == rec2.get('qaRecordId')) {
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
									id: 'btnAppealed',
									text: '提交申诉',
									iconCls: 'helpbtn',
									hidden: true,
									handler : function(obj, e) {
										appealForm.form.reset();
										appealWin.show();
									}
								}
							)
							//已审核质检记录不能再次质检评分
							//如果当前记录未被质检，或者已经质检且质检员与当前用户一致则可以进行质检操作
							actions.push(
								{
									id: 'btnQAGrade',
									text: '质检评分',
									iconCls: 'gradebtn',
									hidden: true,
									listeners: {
										'click' : function(obj) {
											if(qaWin && qaWin.isVisible()) {
												qaWin.toFront();
											} else {
												qaWin = new Ext.app.qa.QASelectorWindow({
													width: 820,
													height:485,
													title: obj.getText(),
													types: objGroupTypes,
													groupTypeId: rec.get('qaGroupType'),
													readOnly: false,
													recData: rec,
													iconCls: 'gradebtn',
													ownerObj: grid
												});
												qaWin.show();
											}
										}
									}
								}
							);

							//必须是已质检记录才可以查看质检结果
							//如果当前记录已被质检，且质检员与当前用户不一致则只能进行查询质检结果
							//拥有质检查询权限的用户也可以查看质检结果
							actions.push(
								{
									id: 'btnQAGradeView',
									text: '评分结果',
									iconCls: 'gradebtn',
									hidden: true,
									listeners: {
										'click' : function(obj) {
											if(qaWin && qaWin.isVisible()) {
												qaWin.toFront();
											} else {
												qaWin = new Ext.app.qa.QASelectorWindow({
													width: 820,
													height:485,
													title: obj.getText(),
													types: objGroupTypes,
													groupTypeId: rec.get('qaGroupType'),
													readOnly: true,
													recData: rec,
													iconCls: 'gradebtn',
													ownerObj: grid
												});
												qaWin.show();
											}
										}
									}
								}
							);

							//复核评分
							//必须是申诉中的记录才可以复核评分
							//拥有复核评分权限的用户也可以进行复核评分
							actions.push(
								{
									id: 'btnQAGradeCheck',
									text: '复核评分',
									iconCls: 'keybtn',
									hidden: true,
									listeners: {
										'click' : function(obj) {
											if(qaWin && qaWin.isVisible()) {
												qaWin.toFront();
											} else {
												qaWin = new Ext.app.qa.QASelectorWindow({
													width: 820,
													height:485,
													title: obj.getText(),
													types: objGroupTypes,
													groupTypeId: rec.get('qaGroupType'),
													readOnly: false,
													recData: rec,
													iconCls: 'keybtn',
													showmode: 'Check',
													ownerObj: grid
												});
												qaWin.show();
											}
										}
									}
								}
							);

							//必须是已复核记录才可以查看质检结果
							actions.push(
								{
									id: 'btnQAGradeCheckedView',
									text: '评分结果',
									iconCls: 'gradebtn',
									hidden: true,
									listeners: {
										'click' : function(obj) {
											if(qaWin && qaWin.isVisible()) {
												qaWin.toFront();
											} else {
												qaWin = new Ext.app.qa.QASelectorWindow({
													width: 820,
													height:485,
													title: obj.getText(),
													types: objGroupTypes,
													groupTypeId: rec.get('qaGroupType'),
													readOnly: true,
													showmode: 'Check',
													recData: rec,
													iconCls: 'gradebtn',
													ownerObj: grid
												});
												qaWin.show();
											}
										}
									}
								}
							);

							actions.push(
								{
									id: 'btnCaseSubmit',
									text: '提交案例',
									iconCls: 'tablebtn',
									hidden: true,
									listeners: {
										'click' : function(obj) {
											if(tableWin && tableWin.isVisible()) {
												tableWin.toFront();
											} else {
												showCaseWindow(obj.showmode, rec);
											}
										}
									}
								}
							);
/*

							actions.push(
								{
									id: 'btnCaseCheck',
									text: '审核案例',
									iconCls: 'keybtn',
									hidden: true,
									listeners: {
										'click' : function() {
											tableForm.form.reset();
											tableWin.show();
										}
									}
								}
							);
*/
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

										//更新按钮状态
										updateButton(rec);
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
												dataIndex: 'beginTime',
												renderer: function(v, p, record, rowIndex){
													return formatDateTime(v);
												}
											},
											{
												header   : '结束时间',
												width    : .3,
												sortable : true,
												dataIndex: 'endTime',
												renderer: function(v, p, record, rowIndex){
													return formatDateTime(v);
												}
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
							grid.getView().getRow(lineno).style.backgroundColor='#80FE8E'
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
/*
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
*/
		grid = new Ext.grid.GridPanel({
            region: 'center',
			iconCls: 'gridbtn',
			store: store,
			tbar: toolbar,
			border: false,
			colModel: new Ext.ux.grid.LockingColumnModel(colsObj),
			stripeRows: true,
			viewConfig: {
				forceFit: true,
				enableRowBody:true,
				getRowClass: function(rec, idx, params, store) {
					return getRecordRowClass(rec, idx, params, store);
				}
			},
			loadMask: true,
			view: new Ext.ux.grid.LockingGridView({syncHeights: true}),
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
/*
			rightClick.addSeparator();
			rightClick.add({
				text : '导出',
				iconCls : 'exportbtn',
				menu: exportMenu
			});
*/
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

		/** 申诉 START */
		appealForm = new Ext.FormPanel({
			labelWidth: 75,
			frame: true,
			width: 420,
			defaultType: 'textfield',
			items: [
				{
					xtype: 'fieldset',
					title: '申诉理由',
					width: 420,
					autoHeight: true,
					collapsed: false,
					collapsible: true,
					items: [
						{
							xtype: 'textarea',
							id: 'txtAppealReason',
							width: 390,
							hideLabel: true,
							style:'color:blue;',
							height: 86,
							name: 'appealReason'
						}
					]
				}
			],

			buttons: [{
				text: '提&nbsp;交',
				handler: function() {
					if(appealForm.form.isValid()) {
						var values = appealForm.getForm().getValues();
						if(!values.appealReason) {
							Ext.Msg.alert('申诉失败', '请填写申诉理由！');
						} else {
							var rec = grid.getSelectionModel().getSelected();
							//console.log(rec);
							appealForm.form.submit({
								url: webRoot + 'QARecord/Appealed/' + rec.get('qaRecordId'),
								method: 'POST',
								params: {
									_method: 'PUT'
								},
								success: function(form, action) {
									Ext.Msg.alert('申诉成功', '申诉请求已提交！');
									/*
									rec.set('qaStatus', 'APPEALED');
									rec.set('qaAppealReason', values.appealReason);
									grid.getStore().loadData(rec, true);
									*/

									var pgbar = grid.getBottomToolbar();
									var activePage = Math.ceil((pgbar.cursor + pgbar.pageSize) / pgbar.pageSize);
									var start = (activePage - 1) * pgbar.pageSize;
									grid.getStore().load({params:{start:start, limit:pagesize}});

									//更新按钮状态
									updateButton(rec);
									appealWin.hide();
								},
								failure: function(form, action) {
									switch (action.failureType) {
										case Ext.form.Action.CLIENT_INVALID:
											Ext.Msg.alert('申诉失败', '数据字段格式错误！');
											break;
										case Ext.form.Action.CONNECT_FAILURE:
											Ext.Msg.alert('申诉失败', '连接异常！');
											break;
										case Ext.form.Action.SERVER_INVALID:
										   Ext.Msg.alert('申诉失败', action.result.msg);
								   }
								},
								waitMsg: '数据保存中，请稍候...'
							});
						}
					} else {
						Ext.Msg.alert('提示', '请填写完整再提交！');
					}
				}
			},{
				text: '取&nbsp;消',
				handler: function() {
					appealWin.hide();
				}
			}]
		});

		appealWin = new Ext.Window({
			layout:'fit',
			width: 450,
			height:230,
			closeAction:'hide',
			modal: true,
			plain: true,
			title: "提交申诉",
			iconCls: "helpbtn",
			items: [appealForm]
		});
		/** 申诉 END */

		caseTypeStore = new Ext.data.JsonStore({
			root: 'data',
			totalProperty: 'total',
			idProperty: 'id',
			remoteSort: false,

			fields: [
				   {name: 'id'},
				   {name: 'name'},
				   {name: 'fatherId'},
				   {name: 'desc'},
				   {name: 'groupTypeId'},
				   {name: 'status'}
				],

			restful: true,
			proxy: new Ext.data.HttpProxy({
				url: window.webRoot + 'QAItemGroup/CaseTypes'
			})
		});

		caseTypeStore.setDefaultSort('fatherId', 'asc');

		caseTypeStore.load();

		/** 提交案例 END */

		//查询质检组别
		groupTypeStore = new Ext.data.JsonStore({
			root: 'data',
			totalProperty: 'total',
			idProperty: 'id',
			remoteSort: false,

			fields: [
				   {name: 'id'},
				   {name: 'name'},
				   {name: 'value'}
				],

			restful: true,
			proxy: new Ext.data.HttpProxy({
				url: window.webRoot + 'Dicts/Type/QA_ITEM_GROUP'
			})
		});

		groupTypeStore.setDefaultSort('name', 'asc');

		groupTypeStore.load();

		objGroupTypes = new Array();

		groupTypeStore.on('load', function() {
			groupTypeStore.each(function(record){
				objGroupTypes.push({
					name: record.get('name'),
					value: record.get('value')
				});
			});
		});
	});
