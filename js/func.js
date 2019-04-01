
if  (!Ext.grid.GridView.prototype.templates) {       
    Ext.grid.GridView.prototype.templates = {};       
}       
Ext.grid.GridView.prototype.templates.cell =  new  Ext.Template(       
     '<td class="x-grid3-col x-grid3-cell x-grid3-td-{id} x-selectable {css}" style="{style}" tabIndex="0" {cellAttr}>' ,       
     '<div class="x-grid3-cell-inner x-grid3-col-{id}" {attr}>{value}</div>' ,       
     '</td>'       
); 

function IsNum(s)
{
    if (s!=null && s!="")
    {
        return !isNaN(s);
    }
    return false;
}

function getYearWeek(date){  
    var date2=new Date(date.getFullYear(), 0, 1);  
    var day1=date.getDay();  
    if(day1==0) day1=7;  
    var day2=date2.getDay();  
    if(day2==0) day2=7;  
    d = Math.round((date.getTime() - date2.getTime()+(day2-day1)*(24*60*60*1000)) / 86400000);    
    return Math.ceil(d /7)+1;   
}

function export2Excel(gridPanel, config) {
    if (gridPanel) {
        var tmpStore = gridPanel.getStore();
        var tmpExportContent = '';

        //以下处理分页grid数据导出的问题，从服务器中获取所有数据，需要考虑性能
        var tmpParam = Ext.ux.clone(tmpStore.lastOptions); //此处克隆了原网格数据源的参数信息

        if (tmpParam && tmpParam.params) {
            delete (tmpParam.params[tmpStore.paramNames.start]); //删除分页参数
            delete (tmpParam.params[tmpStore.paramNames.limit]);
        }
        var tmpAllStore = new Ext.data.GroupingStore({//重新定义一个数据源
            proxy: tmpStore.proxy,
            reader: tmpStore.reader
        });
        tmpAllStore.on('load', function (store) {
            config.store = store;
            tmpExportContent = gridPanel.getExcelXml(false, config); //此方法用到了一中的扩展
//            if (Ext.isIE || Ext.isSafari || Ext.isSafari2 || Ext.isSafari3) {//在这几种浏览器中才需要，IE8测试不能直接下载了
			var fd = Ext.get('frmDummy');  
			if (!fd) {  
                fd = Ext.DomHelper.append(Ext.getBody(),{
						tag:'form',
						method:'post',
						id:'frmDummy',
						action:'/QAPortal/Report/Download', 
						target:'_blank',
						name:'frmDummy',
						cls:'x-hidden',
						cn:[  
							{tag:'input',name:'exportContent',id:'exportContent',type:'hidden'}  
						]
					},true);  
            }  
            fd.child('#exportContent').set({value:tmpExportContent});  
            fd.dom.submit();
        });
        tmpAllStore.load(tmpParam); //获取所有数据
    }
}

function formatTimes(times) {
	var days = parseInt(times / (24*60*60));
	var hours = parseInt((times % (24*60*60)) / (60*60));
	var mins = parseInt((times % (60*60)) / 60);
	var secs = parseInt(times % 60);
	
	var str = "";
	if(days > 0) {
		str += days + "days ";
	}
	if(hours < 10) {
		str += "0" + hours + ":";
	} else {
		str += hours + ":";
	}
	if(mins < 10) {
		str += "0" + mins + ":";
	} else {
		str += mins + ":";
	}
	if(secs < 10) {
		str += "0" + secs;
	} else {
		str += secs;
	}

	return str;
}

function decodeArgs(str) {
	if(!str) return "";
	var keys = new Array();
	var args = str.split(';');
	for(var i=0; i<args.length; i++) {
		var args2 = args[i].split('=');
		if(args2.length > 1) {
			var key = args2[0];
			var val = args2[1];
			keys[key] = val;
		} else {
			var key = args2[0];
			keys[key] = '';
		}
	}
	return keys;
}

function encodeURL(url) {
	url = encodeURI(url);
	return url;
}

function decodeURL(url) {
	url = decodeURI(url);
	return url;
}

function formatDate(time) {
	if(time && time!= '') {
		var date = new Date();
		date.setTime(time);
		return date.format('Y-m-d h:i:s');
	} else {
		return '';
	}
}

/**
 * 设置Cookie
 * 
 * @param {} name
 * @param {} value
 */
function setCookie(name, value, minuts) {
	var argv = setCookie.arguments;
	var argc = setCookie.arguments.length;
	var expiration = new Date((new Date()).getTime() + minuts * 60000 * 60);
	document.cookie = name
			+ "="
			+ escape(value)
			+ "; expires=" + expiration
					.toGMTString();
}

/**
 * 获取Cookie
 * 
 * @param {} Name
 * @return {}
 */
function getCookie(Name) {
	var search = Name + "="
	if (document.cookie.length > 0) {
		offset = document.cookie.indexOf(search)
		if (offset != -1) {
			offset += search.length
			end = document.cookie.indexOf(";", offset)
			if (end == -1)
				end = document.cookie.length
			return unescape(document.cookie.substring(offset, end))
		} else
			return ""
	}
}

/**
 * 从缓存中清除Cookie
 * 
 * @param {} name
 */
function clearCookie(name) {
	var expdate = new Date();
	expdate.setTime(expdate.getTime() - (86400 * 1000 * 1));
	setCookie(name, "", expdate);
}

/**
 * 格式化数据
 * 
 * @param {} type
 * @param {} val
 */
function formatValue(type, val) {
	return eval('format'+type+'(\''+val+'\')');
}

/**
 * 格式化字符串
 * 
 * @param {} val
 */
function formatString(val) {
	return val;
}

/**
 * 格式化布尔变量
 * 
 * @param {} val
 */
function formatBoolean(val) {
	if(val) {
		return '是';
	} else {
		return '否';
	}
}

/**
 * 格式化字符串
 * 
 * @param {} val
 */
function formatInteger(val) {
	return val;
}

/**
 * 格式化字符串
 * 
 * @param {} val
 */
function formatDateTime(val) {
	if(val && val != '' && val != 'null' && val > 0) {
		var date = new Date();
		date.setTime(val);
		var seperator1 = "-";
		var seperator2 = ":";
		var month = date.getMonth() + 1;
		var strDate = date.getDate();
		if (month >= 1 && month <= 9) {
			month = "0" + month;
		}
		if (strDate >= 0 && strDate <= 9) {
			strDate = "0" + strDate;
		}
		var year = Ext.isIE ? date.getYear() : date.getYear() + 1900;

		var hour = date.getHours();
		if(hour < 10) {
			hour = "0" + hour;
		}

		var min = date.getMinutes();
		if(min < 10) {
			min = "0" + min;
		}
		
		var sec = date.getSeconds();
		if(sec < 10) {
			sec = "0" + sec;
		}

		var currentdate = year + seperator1 + month + seperator1 + strDate
				+ " " + hour + seperator2 + min
				+ seperator2 + sec;
		return currentdate;
	} else {
		return '';
	}
}

/**
 * 格式化时长
 * 
 * @param {} val
 */
function formatTimeLength(seconds) {
//	return seconds+'秒';
	var hh;
	var mm;
	var ss;
	//传入的时间为空或小于0
	if(seconds==null||seconds<0){
		return;
	}
	//得到小时
	hh=seconds/3600|0;
	seconds=parseInt(seconds)-hh*3600;
	if(parseInt(hh)<10){
		hh="0"+hh;
	}
	//得到分
	mm=seconds/60|0;
	//得到秒
	ss=parseInt(seconds)-mm*60;
	if(parseInt(mm)<10){
		mm="0"+mm;    
	}
	if(ss<10){
		ss="0"+ss;      
	}
	return hh+":"+mm+":"+ss;
}

/**
 * 格式化浮点型
 * 
 * @param {} val
 */
function formatFloat(val) {
	return val;
}

/**
 * 格式化比率型
 * 
 * @param {} val
 */
function formatRate(val) {
	return val + '%';
}

