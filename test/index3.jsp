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
	<title>东方CJ -- 录音查询及质检系统</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <link rel="stylesheet" type="text/css" href="../css/ext-all-notheme.css" />
    <link rel="stylesheet" type="text/css" href="../css/xtheme-gray.css" />
    <link rel="stylesheet" type="text/css" href="../css/common.css" />
    <link rel="stylesheet" type="text/css" href="../css/icon.css" />
    <link rel="stylesheet" type="text/css" href="./Ext.ux.tot2ivn.VrTabPanel.css" />
    
	<script >
		var webRoot = '<%=webRoot%>';
	</script>
    <script type="text/javascript" src="../js/ext-base.js"></script>
    <script type="text/javascript" src="../js/ext-all.js"></script>
    <script type="text/javascript" src="../ux/TabCloseMenu.js"></script>
	<script type="text/javascript" src="../js/ext-lang-zh_CN.js"></script>
	<script type="text/javascript" src="../js/func.js"></script>
	<script type="text/javascript" src="./Ext.ux.tot2ivn.VrTabPanel.js"></script>

	<script type="text/javascript">

	Ext.onReady(function(){
		var tabs = new Ext.ux.tot2ivn.VrTabPanel ({
			renderTo: 'tabs1',
			width: 450,
			activeTab: 0,
			border: 0,
			items: [
				{
					xtype: 'textarea',
					anchor: '100%',
					height: 400,
					border: 0,
					value: 'plain_content',
					title: 'tab1',
					name: 'plain_content',
					hiddenName: 'plain_content'
				},
				{
					xtype: 'textarea',
					anchor: '100%',
					height: 400,
					border: 0,
					value: 'plain_content2',
					title: 'tab1',
					name: 'plain_content',
					hiddenName: 'plain_content'
				}
			]
		});
		
        var viewport = new Ext.Viewport({
            layout: 'border',
            items: [tabs]
        });
    });
    </script>
</head>
<body>
    <div id="tabs1"></div>
</body>
</html>
