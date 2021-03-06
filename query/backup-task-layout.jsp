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
    <title>录音备份</title>
 
    <link rel="stylesheet" type="text/css" href="../css/ext-all-notheme.css" />
    <link rel="stylesheet" type="text/css" href="../css/xtheme-gray.css" />
    <link rel="stylesheet" type="text/css" href="../css/icon.css" />
    <link rel="stylesheet" type="text/css" href="../css/common.css" />
 
    <script type="text/javascript" src="../js/ext-base.js"></script>
    <script type="text/javascript" src="../js/ext-all.js"></script>
    <script type="text/javascript" src="../js/ext-lang-zh_CN.js"></script>
    <script type="text/javascript" src="../ux/TabCloseMenu.js"></script>
    <script type="text/javascript">

	var assignTab;
	Ext.onReady(function(){

		/** 报表标签栏 Start */
		assignTab = new Ext.TabPanel({
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

		assignTab.add({   
			title: 'Step1: 设置任务',   
			iconCls: 'timebtn',                     
			margins:'0 0 0 0',   
			border: false,
			autoScroll:true,   
			autoWidth:true,   
			closable:false,   
			html:'<iframe name=tabStep0 src="backup-task-step0.jsp" width="100%" height="100%" frameborder="0" scrolling="auto"></iframe>'  
		}); 
		/** 报表标签栏 End */

        var viewport = new Ext.Viewport({
            layout: 'border',
			autoHeight: true,
			border: false,
            items: [assignTab]
		});	

		assignTab.setActiveTab(0);
	});	
	</script>
 
</head>
<body>
	<div id="setting-win" class="x-hidden"></div>
</body>
</html>
