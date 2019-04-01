<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
	response.setHeader("Pragma","No-cache");
	response.setHeader("Cache-Control","no-cache");
	response.setHeader("Expires","0");

	request.setCharacterEncoding("UTF-8");

	String rpt = request.getParameter("rpt");
%>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>查询日志</title>
 
    <link rel="stylesheet" type="text/css" href="../css/ext-all.css" />
    <link rel="stylesheet" type="text/css" href="../css/icon.css" />
  
    <script type="text/javascript" src="../js/ext-base.js"></script>
    <script type="text/javascript" src="../js/ext-all.js"></script>
    <script type="text/javascript" src="../js/ext-lang-zh_CN.js"></script>
    <script type="text/javascript" src="../ux/TabCloseMenu.js"></script>
    <script type="text/javascript">

	var logtab;
	Ext.onReady(function(){

		/** 报表标签栏 Start */
		logtab = new Ext.TabPanel({
			enableTabScroll:true,
			defaults: {autoScroll:true},
			region: 'center',
			border: false,
			plugins: new Ext.ux.TabCloseMenu({
				closeTabText: '关闭当前页签',
				closeOtherTabsText: '关闭其它页签',
				closeAllTabsText: '关闭所有页签'
			})
		});

		logtab.add({   
			title: '查询', 
			id: 'tabSearch',
			iconCls: 'logbtn',                     
			margins:'0 0 0 0',   
			border: false,
			autoScroll:true,   
			autoWidth:true,   
			closable:false,   
			html:'<iframe name=searchTab src="logserver-list.jsp" width="100%" height="100%" frameborder="0" scrolling="auto"></iframe>'  
		}); 
		/** 报表标签栏 End */

        var viewport = new Ext.Viewport({
            layout: 'border',
			border: false,
			items: [logtab]
		});	

		Ext.getCmp("tabSearch").show();
	});	
	</script>
 
</head>
</html>
