<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
	response.setHeader("Pragma","No-cache");
	response.setHeader("Cache-Control","no-cache");
	response.setHeader("Expires","0");

	request.setCharacterEncoding("UTF-8");	
	
	String rootPath = request.getContextPath();
	String webRoot = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + rootPath + "/";
%>
<html>
<head>
	<title>服务管理</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <link rel="stylesheet" type="text/css" href="../css/ext-all-notheme.css" />
    <link rel="stylesheet" type="text/css" href="../css/xtheme-gray.css" />
    
    <style type="text/css">
    .settings {
        background-image:url("../images/icons/fam/folder_wrench.png");
    }
	.conf {
        background-image:url("../images/icons/fam/cog.png");
	}

   </style>
    <script type="text/javascript" src="../js/ext-base.js"></script>
    <script type="text/javascript" src="../js/ext-all.js"></script>
    <script type="text/javascript" src="../ux/TabCloseMenu.js"></script>

	<script type="text/javascript" src="../js/ext-lang-zh_CN.js"></script>

	<script type="text/javascript">
	var win, form;

	Ext.onReady(function(){
 	
		Ext.QuickTips.init();
		
		var treePanel = new Ext.tree.TreePanel({
			title: 'Service',
			iconCls: 'sys',
			region:'west',
			split: false,
			autoScroll: true,
			width: 240,
			height: '100%',

			// tree-specific configs:
			rootVisible: false,
			lines: false,
			useArrows: true,

			loader: new Ext.tree.TreeLoader({
				dataUrl:'service_items.json'
			}),

			root: new Ext.tree.AsyncTreeNode()
		});

		treePanel.on('click', function(n){
			var sn = this.selModel.selNode || {}; // selNode is null on initial selection
			if(n.leaf && n.id != sn.id){  // ignore clicks on folders and currently selected node 
				document.getElementById("frmContent").src = n.id + ".jsp";
			}
		});

		var contentPanel = new Ext.Panel({
			region:'center',
			html: '<iframe id=frmContent frameborder="no" border=0 height="100%" width="100%" src="../blank.jsp" scrolling="auto"></iframe>',
			autoScroll: true
		});

		new Ext.Viewport({
			layout: 'border',
			title: 'Ext Layout Browser',
			border: false,
			items: [
				treePanel,
				contentPanel
			],
			renderTo: Ext.getBody()
		});

    });

    </script>
</head>
<body>
</body>
</html>
