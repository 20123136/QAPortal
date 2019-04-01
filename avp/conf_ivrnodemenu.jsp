<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Expires", "0");

	request.setCharacterEncoding("UTF-8");

	String webRoot = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";

%>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>IVR菜单节点映射</title>

	<link rel="stylesheet" type="text/css" href="../css/ext-all.css" />
    
    <link rel="stylesheet" type="text/css" href="../css/common.css" />
    <link rel="stylesheet" type="text/css" href="../css/icon.css" />

	<script >
		var webRoot = '<%=webRoot%>';
	</script>

<script type="text/javascript" src="../js/ext-base.js"></script>
<script type="text/javascript" src="../js/ext-all-debug.js"></script>
<script type="text/javascript" src="../js/ext-lang-zh_CN.js"></script>
<script type="text/javascript" src="../js/ext-ui-combo-pagesize.js"></script>
<script type="text/javascript" src="../js/app/common/ComboBox.js"></script>

<script type="text/javascript">
	var curId = 0;
	var pagesize = 25;
	var grid;
	var win;
	var form1;
	var form3;
	var form4;
	var form6;
	var form8;
	var form12;
	var form13;
	var gridPanel_Type1;
	var gridPanel_Type6;
	var gridPanel_Type8;
	var gridPanel_Type12;
	var gridPanel_Type13;
	var win1;
	var win3;
	var win4;
	var win6;
	var win8;
	var win12;
	var win13;

	var fields = [
				   {name: 'id'},
				   {name: 'type'},
				   {name: 'comment'},
				   {name: 'status'},
				   {name: 'lastModified'},
				   {name: 'keyLength'},
				   {name: 'funcName'}
				];

	Ext.onReady(function(){
		var businessTypeStore = new Ext.data.ArrayStore({
            fields: [{
                        name : "value"
                    }, {
                        name : "name"
                    }],
			data: [['A', '所有业务'], ['N', '800金普卡业务'], ['V', '白金业务'],['P', '积分业务'], ['W', '英文业务']]
        });
		
		var store = new Ext.data.JsonStore({
			root: 'data',
			totalProperty: 'total',
			remoteSort: false,

			fields: fields,
			
			proxy: new Ext.data.HttpProxy({
				url: window.webRoot + 'IVRNodes'
			})
		});
		
		var testStore1 = new Ext.data.ArrayStore( {
		    autoDestroy: true,
		    storeId: 'myStore1',
		    idIndex: 0,  
		    fields: [
		       {name: 'nodeId'},
		       {name: 'voxId'},
		       {name: 'key'},
		       {name: 'desc'},
		       {name: 'status'}
		    ]
		
		});
		
		var testStore3 = new Ext.data.ArrayStore( {
		    autoDestroy: true,
		    storeId: 'myStore3',
		    idIndex: 0,  
		    fields: [
		       {name: 'voxId'},
		       {name: 'nextNodeId'}
		    ]
		
		});
		
		var testStore4 = new Ext.data.ArrayStore({
			autoDestroy: true,
		    storeId: 'myStore4',
		    idIndex: 0,  
		    fields: [
		       {name: 'transferType'},
		       {name: 'skillId'} 
		    ]
		});
		
		
		var testStore6 = new Ext.data.ArrayStore( {
		    autoDestroy: true,
		    storeId: 'myStore6',
		    idIndex: 0,  
		    fields: [
			   {name: 'msgId'},
		       {name: 'respCode'},
		       {name: 'msgContent'},
		       {name: 'desc'},
		       {name: 'status'}
		    ]
		
		});
		
		var testStore8 = new Ext.data.ArrayStore( {
		    autoDestroy: true,
		    storeId: 'myStore8',
		    idIndex: 0,  
		    fields: [
				{name: 'nodeId'},
   				{name: 'respCode'},
 		      	{name: 'desc'},
 		       	{name: 'status'}
		    ]
		
		});
		
		var testStore12 = new Ext.data.ArrayStore( {
		    autoDestroy: true,
		    storeId: 'myStore12',
		    idIndex: 0,  
		    fields: [
	            {name: 'id'},
	            {name: 'language'},
   				{name: 'key'},
	            {name: 'voxId'},
   				{name: 'promptTimes'},
			    {name: 'desc'}
		    ]
		
		});
		
		var testStore13 = new Ext.data.ArrayStore( {
		    autoDestroy: true,
		    storeId: 'myStore13',
		    idIndex: 0,  
		    fields: [
				{name: 'nodeId'},
   				{name: 'value'},
 		        {name: 'type'},
 		        {name: 'desc'},
 		        {name: 'status'}
		    ]
		
		});
		
		store.setDefaultSort('id', 'asc');
		
		var toolbarHelp = new Ext.Toolbar({
			width: '100%'
		});
		
		toolbarHelp.addButton(
			new Ext.form.DisplayField({
				fieldLabel: '',
				style: {align: 'right'},
				html:"&nbsp;&nbsp;<font color='#FF9900'>*</font>&nbsp;&nbsp;<font color='#646464'>IVR菜单结构页面显示的是IVR菜单结构配置信息</font>"
			})
		);

		var toolbar = new Ext.Toolbar({
			width: '100%'
		});

		toolbar.addButton(
			new Ext.Toolbar.Button({
				id: 'btnRefresh',
				text: '刷新',
				iconCls: 'refreshbtn',
				listeners: {
					'click': function(obj, e) {
						grid.getStore().reload();
					}
				}
			})
		);
		toolbar.addSeparator()
		
		toolbar.addButton(new Ext.Toolbar.Button({
				id: 'btnAdd',
				text: '添加',
				iconCls: 'confaddbtn',
				listeners: {
					'click': function(obj, e) {
						var winAdd = new Ext.Window({
							layout:'fit',
							width: 550,
							height:450,
							closeAction:'hide',
							modal: false,
							plain: true,
							items: [formAdd],
							buttons: [{
						    	text: '关闭',
					    		handler: function() {
									winAdd.hide();
								}
						    }]
						});
						
						winAdd.setTitle("添加菜单结构");
						winAdd.setIconClass("confaddbtn");
						formAdd.form.reset();
						winAdd.show(this);
						
					}
				}
			})
		);
		toolbar.addSeparator()
		
		toolbar.addButton(
			new Ext.Toolbar.Button({
				id: 'btnInfomation',
				text: '详细',
				disabled: false,
				iconCls: 'confeditbtn',
				listeners: {
					'click': function(obj, e) {
						var rec = grid.getSelectionModel().getSelected();
		
						if(!rec) {
							Ext.Msg.alert('查询菜单结构详细', '请选择要查看的菜单记录！');
						} else {
							//菜单播报节点
							if(rec.json.type=='1'){
								//alert('id = '+ rec.json.id + ',comment = ' + rec.json.comment + ', type = ' + rec.json.type + ',status=' + rec.json.status);
								testStore1.removeAll(true);
								for(var i=0; i<rec.json.subNode.length; i++){
									testStore1.add(
										new testStore1.recordType({
												nodeId: rec.json.subNode[i].nodeId,
												key: rec.json.subNode[i].key,
												voxId: rec.json.subNode[i].voxId,
												desc: rec.json.subNode[i].desc
										})
									);
								};
								Ext.getCmp('label11').setText(rec.json.id);
								Ext.getCmp('label12').setText(rec.json.comment);
								Ext.getCmp('label13').setText('菜单播报节点');
								
								var valStatus = rec.json.status;
								if(valStatus=='0'){
									valStatus='开放';
								} else if(valStatus=='1') { 
									valStatus='不开放';
								} else if(valStatus=='2') { 
									valStatus='不使用';
								}
								Ext.getCmp('label14').setText(valStatus);
								
								win1.add(form1);
								win1.setTitle("IVR_MENUCFG_"+rec.json.id+".xml 配置详细");
								win1.setIconClass("confeditbtn");
								form1.form.reset();
								form1.form.setValues(testStore1);
								win1.show(this);
							}
							
							//播放语言节点
							if(rec.json.type=='3'){
								testStore3.removeAll(true);
								testStore3.add(
									new testStore3.recordType({
											voxId: rec.json.voxId,
											nextNodeId: rec.json.nextNodeId,
									})
								);
								Ext.getCmp('label31').setText(rec.json.id);
								Ext.getCmp('label32').setText(rec.json.comment);
								Ext.getCmp('label33').setText('播报语音节点');
								var valStatus = rec.json.status;
								if(valStatus=='0'){
									valStatus='开放';
								} else if(valStatus=='1') { 
									valStatus='不开放';
								} else if(valStatus=='2') { 
									valStatus='不使用';
								}
								Ext.getCmp('label34').setText(valStatus);
								
								win3.add(form3);
								win3.setTitle("IVR_MENUCFG_"+rec.json.id+".xml 配置详细");
								win3.setIconClass("confeditbtn");							
								form3.form.reset();
								form3.form.setValues(testStore3);
								win3.show(this);
							}
							
							//转人工坐席
							if(rec.json.type=='4'){
								testStore4.removeAll(true);
								
								testStore4.add(
									new testStore4.recordType({
										transferType: rec.json.transferType,
										skillId: rec.json.skillId
									})
								);
								Ext.getCmp('label41').setText(rec.json.id);
								Ext.getCmp('label42').setText(rec.json.comment);
								Ext.getCmp('label43').setText('转人工坐席');
								var valStatus = rec.json.status;
								if(valStatus=='0'){
									valStatus='开放';
								} else if(valStatus=='1') {
									valStatus='不开放';
								} else if(valStatus=='2') { 
									valStatus='不使用';
								}
								Ext.getCmp('label44').setText(valStatus);
								
								win4.add(form4);
								win4.setTitle("IVR_MENUCFG_"+rec.json.id+".xml 配置详细");
								win4.setIconClass("confeditbtn");							
								form4.form.reset();
								form4.form.setValues(testStore4);
								win4.show(this);
							}
							
							//会议IVR过程节点
							if(rec.json.type=='6'){
								testStore6.removeAll(true);
								for(var i=0; i<rec.json.message.length; i++){
									testStore6.add(
										new testStore6.recordType({
												msgId: rec.json.message[i].msgId,	
												respCode: rec.json.message[i].respCode,
												msgContent: rec.json.message[i].msgContent,
												desc: rec.json.message[i].desc
										})
									);
								};
								
								Ext.getCmp('label61').setText(rec.json.id);
								Ext.getCmp('label62').setText(rec.json.comment);
								Ext.getCmp('label63').setText('会议IVR过程节点');
								var valStatus = rec.json.status;
								if(valStatus=='0'){
									valStatus='开放';
								} else if(valStatus=='1') { 
									valStatus='不开放';
								} else if(valStatus=='2') { 
									valStatus='不使用';
								}
								Ext.getCmp('label64').setText(valStatus);
								Ext.getCmp('label65').setText(rec.json.funcName);
								
								win6.add(form6);
								win6.setTitle("IVR_MENUCFG_"+rec.json.id+".xml 配置详细");
								win6.setIconClass("confeditbtn");						
								form6.form.reset();
								form6.form.setValues(testStore6);
								win6.show(this);
							} 
							
							//过程节点
							if(rec.json.type=='8'){
								testStore8.removeAll(true);
								for(var i=0; i<rec.json.response.length; i++){
									testStore8.add(
										new testStore8.recordType({
												nodeId: rec.json.response[i].nodeId,   
											    respCode: rec.json.response[i].respCode,
											    desc: rec.json.response[i].desc
										})
									);
								};
								Ext.getCmp('label81').setText(rec.json.id);
								Ext.getCmp('label82').setText(rec.json.comment);
								Ext.getCmp('label83').setText('过程节点');
								var valStatus = rec.json.status;
								if(valStatus=='0'){
									valStatus='开放';
								} else if(valStatus=='1') { 
									valStatus='不开放';
								} else if(valStatus=='2') { 
									valStatus='不使用';
								}
								Ext.getCmp('label84').setText(valStatus);
								Ext.getCmp('label85').setText(rec.json.funcName);
								
								win8.add(form8);
								win8.setTitle("IVR_MENUCFG_"+rec.json.id+".xml 配置详细");
								win8.setIconClass("confeditbtn");						
								form8.form.reset();
								form8.form.setValues(testStore8);
								win8.show(this);
							} 
							
							//菜单播报节点
							if(rec.json.type=='12'){
								testStore12.removeAll(true); 
								for(var i=0; i<rec.json.subNode.length; i++){
									testStore12.add(
										new testStore12.recordType({   
												id: rec.json.subNode[i].id,
												language: rec.json.subNode[i].language,
												key: rec.json.subNode[i].key,
												voxId: rec.json.subNode[i].voxId,
												promptTimes: rec.json.subNode[i].promptTimes,
												desc: rec.json.subNode[i].desc
										})
									);
								};
								Ext.getCmp('label121').setText(rec.json.id);
								Ext.getCmp('label122').setText(rec.json.comment);
								Ext.getCmp('label123').setText('菜单播报节点');
								var valStatus = rec.json.status;
								if(valStatus=='0'){
									valStatus='开放';
								} else if(valStatus=='1') { 
									valStatus='不开放';
								} else if(valStatus=='2') { 
									valStatus='不使用';
								}
								Ext.getCmp('label124').setText(valStatus);
								Ext.getCmp('label125').setText(rec.json.keyLength);
								
								win12.add(form12);
								win12.setTitle("IVR_MENUCFG_"+rec.json.id+".xml 配置详细");
								win12.setIconClass("confeditbtn");							
								form12.form.reset();
								form12.form.setValues(testStore12);
								win12.show(this);
							}
							
							//判断节点
							if(rec.json.type=='13'){
								testStore13.removeAll(true);
								for(var i=0; i<rec.json.subNode.length; i++){
									testStore13.add(
										new testStore13.recordType({
												nodeId: rec.json.subNode[i].nodeId,   
											    value: rec.json.subNode[i].value,
											    type: rec.json.subNode[i].type,
											    desc: rec.json.subNode[i].desc
										})
									);
								};	
								Ext.getCmp('label131').setText(rec.json.id);
								Ext.getCmp('label132').setText(rec.json.comment);
								Ext.getCmp('label133').setText('判断节点');
								var valStatus = rec.json.status;
								if(valStatus=='0'){
									valStatus='开放';
								} else if(valStatus=='1') { 
									valStatus='不开放';
								} else if(valStatus=='2') { 
									valStatus='不使用';
								}
								Ext.getCmp('label134').setText(valStatus);
								Ext.getCmp('label135').setText(rec.json.key);
								Ext.getCmp('label136').setText(rec.json.defaultNodeId);
								
								win13.add(form13);
								win13.setTitle("IVR_MENUCFG_"+rec.json.id+".xml 配置详细");
								win13.setIconClass("confeditbtn");						
								form13.form.reset();
								form13.form.setValues(testStore13);
								win13.show(this);
							}
						}
					}
				}
			})
		);
		
		
		/**/
		gridPanel_Type1 = new Ext.grid.GridPanel({
	        region: 'center',
			store: testStore1,
			border: false,
			
			columns:[
					{
						header   : '子节点编号',
						width    : .1,
						sortable : true, 
						name: 'nodeId'
					},
					{
						header   : '语音文件编号',
						width    : .1,
						sortable : true, 
						name: 'voxId'
					},
					{
						header   : '按键值 ',
						width    : .1,
						sortable : true, 
						name: 'key'
					},{
						header   : '子节点描述',
						width    : .1,
						sortable : true, 
						name: 'desc'
					}
			],
			height: 280,
			width: '100%',
			viewConfig: {forceFit:true}, 
			loadMask: true
		});
		
		gridPanel_Type6 = new Ext.grid.GridPanel({
            region: 'center',
			store: testStore6,
			border: false,
			
			columns:[
					{
						header   : '消息编号 ',
						width    : .1,
						sortable : true, 
						name: 'msgId'
					},{
						header   : '返回码',
						width    : .1,
						sortable : true, 
						name: 'respCode'
					},
					{
						header   : '消息描述 ',
						width    : .1,
						sortable : true, 
						name: 'msgContent'
					},{
						header   : '子节点描述',
						width    : .1,
						sortable : true, 
						name: 'desc'
					}
			],
			height: 280,
			width: '100%',
			viewConfig: {forceFit:true}, 
			loadMask: true
		});
		
		gridPanel_Type8 = new Ext.grid.GridPanel({
            region: 'center',
			store: testStore8,
			border: false,
			
			columns:[
					{
						header   : 'j节点编号',
						width    : .1,
						sortable : true, 
						name: 'nodeId'
					},
					{
						header   : '返回值 ',
						width    : .1,
						sortable : true, 
						name: 'respCode'
					},{
						header   : '子节点描述',
						width    : .1,
						sortable : true, 
						name: 'desc'
					}
			],
			height: 280,
			width: '100%',
			viewConfig: {forceFit:true}, 
			loadMask: true
		});
		
		gridPanel_Type12 = new Ext.grid.GridPanel({
	        region: 'center',
			store: testStore12,
			border: false,
			
			columns:[
					{
						header   : '子节点编号',
						width    : .1,
						sortable : true, 
						name: 'id'
					},
					{
						header   : '语种',
						width    : .1,
						sortable : true, 
						name: 'language',
						renderer:function(val, meta)
						{
							switch (val) {
						     case '1':
							     return '中文';
							     break;
						     case '2':
							     return '英文';
							     break;
						     case '3':
							     return '日文';
							     break;
							}
							return val;
						}
						
					},
					{
						header   : '按键值 ',
						width    : .1,
						sortable : true, 
						name: 'key'
					},
					{
						header   : '语音文件编号 ',
						width    : .1,
						sortable : true, 
						name: 'voxId'
					},
					{
						header   : 'PROMPTS ',
						width    : .1,
						sortable : true, 
						name: 'promptTimes'
					},{
						header   : '子节点描述',
						width    : .1,
						sortable : true, 
						name: 'desc'
					}
			],
			height: 280,
			width: '100%',
			viewConfig: {forceFit:true}, 
			loadMask: true
		});
		
		gridPanel_Type13 = new Ext.grid.GridPanel({
            region: 'center',
			store: testStore13,
			border: false,
			
			columns:[
					{
						header   : '子节点编号',
						width    : .1,
						sortable : true, 
						name: 'nodeId'
					},
					{
						header   : '返回值 ',
						width    : .1,
						sortable : true, 
						name: 'value'
					},{
						header   : '子节点类型',
						width    : .1,
						sortable : true, 
						name: 'type'
					},{
						header   : '子节点描述',
						width    : .1,
						sortable : true, 
						name: 'desc'
					}
			],
			height: 280,
			width: '100%',
			viewConfig: {forceFit:true}, 
			loadMask: true
		});

		//添加
		formAdd = new Ext.FormPanel({
			labelWidth: 100,
			frame: true,
			width: 120,
			defaultType: 'textfield',
			
			items: [
			        {
						xtype: 'combo',
						fieldLabel: '菜单节点类型',
						id: 'cmbNodeType',
						name: 'nodeType',
						width: 140,
						store : businessTypeStore,
						valueField : 'value',
						displayField : 'name',
						mode: 'local',
						typeAhead: true,
						forceSelection: true,
						editable: false,
						triggerAction: 'all',
						selectOnFocus:true,
						allowBlank:true,
						
						listeners: 
						{'keypress': function(obj, e) {
								if (e.getKey() == e.ENTER) { 
									Ext.getCmp('selectNodeType').fireEvent('click');   
								}
							}
						}
					},
					new Ext.Toolbar.Button({
						id: 'selectNodeType',
						text: '确定',
						listeners: 
							{'click': function(obj, e) {
									store.removeAll();
									store.load({params:{start:0, limit:pagesize}});
								}
							}
					}),{
						fieldLabel: '节点编号(*)',
						name: 'id',
						width: 380,
						allowBlank:false
					},{
						fieldLabel: '菜单节点类型(*)',
						name: 'type',
						width: 380,
						allowBlank:false
					},{
						fieldLabel: '节点编号(*)',
						name: 'nodeId',
						width: 380,
						allowBlank:false
					},{
						fieldLabel: '语音文件(*)',
						name: 'voxId',
						width: 380,
						allowBlank:false
					}
					
				],	
		});
		
		form1 = new Ext.FormPanel({
			labelWidth: 100,
			frame: true,
			width: 120,
			defaultType: 'label',
			
			items: [
					{
						fieldLabel: '菜单节点编号',
						id: 'label11',
						style:"position:relative;top:3px;",
						width: 380
					},{
						fieldLabel: '节点名称',
						id: 'label12',
						style:"position:relative;top:3px;",
						width: 380
					},
					{
						fieldLabel: '节点类型',
						id: 'label13',
						style:"position:relative;top:3px;",
						width: 380
					},
					{
						fieldLabel: '节点状态',
						id: 'label14',
						style:"position:relative;top:3px;",
						width: 380						
					},
					gridPanel_Type1
				]
		
		});
		
		form3 = new Ext.FormPanel({
			labelWidth: 100,
			frame: true,
			width: 120,
			defaultType: 'label',
			
			items: [
					{
						fieldLabel: '菜单节点编号',
						id: 'label31',
						style:"position:relative;top:3px;",
						width: 380
					},{
						fieldLabel: '节点名称',
						id: 'label32',
						style:"position:relative;top:3px;",
						width: 380
					},
					{
						fieldLabel: '节点类型',
						id: 'label33',
						style:"position:relative;top:3px;",
						width: 380
					},
					{
						fieldLabel: '节点状态',
						id: 'label34',
						style:"position:relative;top:3px;",
						width: 380						
					},
					new Ext.grid.GridPanel({
			            region: 'center',
						store: testStore3,
						border: false,
						
						columns:[
								{
									header   : '语音文件编号',
									width    : .1,
									sortable : true, 
									name: 'voxId'
								},
								{
									header   : '下一个节点编号 ',
									width    : .1,
									sortable : true, 
									name: 'nextNodeId'
								}
						],
						height: 280,
						width: '100%',
						viewConfig: {forceFit:true}, 
						loadMask: true
					})
				]
		
		});
		
		form4 = new Ext.FormPanel({
			labelWidth: 100,
			frame: true,
			width: 120,
			defaultType: 'label',
			
			items: [
					{
						fieldLabel: '菜单节点编号',
						id: 'label41',
						style:"position:relative;top:3px;",
						width: 380
					},{
						fieldLabel: '节点名称',
						id: 'label42',
						style:"position:relative;top:3px;",
						width: 380
					},
					{
						fieldLabel: '节点类型',
						id: 'label43',
						style:"position:relative;top:3px;",
						width: 380
					},
					{
						fieldLabel: '节点状态',
						id: 'label44',
						style:"position:relative;top:3px;",
						width: 380						
					},
					new Ext.grid.GridPanel({
			            region: 'center',
						store: testStore4,
						border: false,
						
						columns:[
								{
									header   : '转接类型',
									width    : .1,
									sortable : true, 
									name: 'transferType'
								},
								{
									header   : '转接技能组 ',
									width    : .1,
									sortable : true, 
									name: 'skillId'
								}
						],
						height: 280,
						width: '100%',
						viewConfig: {forceFit:true}, 
						loadMask: true
					})
				]
		
		});
		
		form6 = new Ext.FormPanel({
			labelWidth: 100,
			frame: true,
			width: 120,
			defaultType: 'label',
			
			items: [
					{
						fieldLabel: '菜单节点编号',
						id: 'label61',
						style:"position:relative;top:3px;",
						width: 380
					},{
						fieldLabel: '节点名称',
						id: 'label62',
						style:"position:relative;top:3px;",
						width: 380
					},
					{
						fieldLabel: '节点类型',
						id: 'label63',
						style:"position:relative;top:3px;",
						width: 380
					},
					{
						fieldLabel: '节点状态',
						id: 'label64',
						style:"position:relative;top:3px;",
						width: 380						
					},
					{
						fieldLabel: '过程节点名称',
						id: 'label65',
						style:"position:relative;top:3px;",
						width: 380						
					},
					
					gridPanel_Type6
				]
		
		});
		
		form8 = new Ext.FormPanel({
			labelWidth: 100,
			frame: true,
			width: 120,
			defaultType: 'label',
			
			items: [
					{
						fieldLabel: '菜单节点编号',
						id: 'label81',
						style:"position:relative;top:3px;",
						width: 380
					},{
						fieldLabel: '节点名称',
						id: 'label82',
						style:"position:relative;top:3px;",
						width: 380
					},
					{
						fieldLabel: '节点类型',
						id: 'label83',
						style:"position:relative;top:3px;",
						width: 380
					},
					{
						fieldLabel: '节点状态',
						id: 'label84',
						style:"position:relative;top:3px;",
						width: 380						
					},
					{
						fieldLabel: '过程节点名称',
						id: 'label85',
						style:"position:relative;top:3px;",
						width: 380						
					},
					
					gridPanel_Type8
				]
		
		});
		
		form12 = new Ext.FormPanel({
			labelWidth: 100,
			frame: true,
			width: 120,
			defaultType: 'label',
			
			items: [
					{
						fieldLabel: '菜单节点编号',
						id: 'label121',
						style:"position:relative;top:3px;",
						width: 380
					},{
						fieldLabel: '节点名称',
						id: 'label122',
						style:"position:relative;top:3px;",
						width: 380
					},
					{
						fieldLabel: '节点类型',
						id: 'label123',
						style:"position:relative;top:3px;",
						width: 380
					},
					{
						fieldLabel: '节点状态',
						id: 'label124',
						style:"position:relative;top:3px;",
						width: 380						
					},
					{
						fieldLabel: '用户按键长度',
						id: 'label125',
						style:"position:relative;top:3px;",
						width: 380						
					},
					gridPanel_Type12
				]
		
		});
		
		form13 = new Ext.FormPanel({
			labelWidth: 100,
			frame: true,
			width: 120,
			defaultType: 'label',
			
			items: [
					{
						fieldLabel: '菜单节点编号',
						id: 'label131',
						style:"position:relative;top:3px;",
						width: 380
					},{
						fieldLabel: '节点名称',
						id: 'label132',
						style:"position:relative;top:3px;",
						width: 380
					},
					{
						id: 'label133',
						fieldLabel: '节点类型',
						style:"position:relative;top:3px;",
						width: 380
					},
					{
						fieldLabel: '节点状态',
						id: 'label134',
						style:"position:relative;top:3px;",
						width: 380
					},
					{
						fieldLabel: '变量名称',
						id: 'label135',
						style:"position:relative;top:3px;",
						width: 380
					},
					{
						fieldLabel: '默认跳转节点',
						id: 'label136',
						style:"position:relative;top:3px;",
						width: 380
					},
					gridPanel_Type13
				]
		
		});
		
		//var sm = new Ext.grid.CheckboxSelectionModel();

		grid = new Ext.grid.GridPanel({
            region: 'center',
			tbar: toolbarHelp,
			store: store,
			border: false,
			//selModel: sm,
			columns: [
				//sm, 
				new Ext.grid.RowNumberer(), 
				{
					header   : '菜单节点编号', 
					width    : .1, 
					sortable : true, 
					dataIndex: 'id'
				},
				{
					header   : '业务类型', 
					width    : .1, 
					sortable : true, 
					dataIndex: 'id',
					renderer:function(val, meta)
					{
						var typeCode = val.substring(0, 1);
						
						switch (typeCode) {
					     case 'P':
						     return '积分专线';
						     break;
					     case 'V':
						     return '白金专线';
						     break;
					     case 'W':
						     return '英文专线';
						     break;
						}
						return '800金普卡线';
					}
				},
				{
					header   : '名称', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'comment'
				},
				{
					header   : '节点类型',	
					width    : .1,
					sortable : true,
					dataIndex: 'type',
					renderer:function(val, meta)
					{
						switch (val) {
					     case 1:
						     return '菜单播报节点';
						     break;
					     case 2:
						     return '返回父节点';
						     break;
					     case 3:
						     return '播放语音节点';
						     break;
					     case 4:
						     return '转人工服务';
						     break;
					     case 6:
					    	 return '过程节点';
					    	 break;
					     case 8:
					    	 return '过程节点';
					    	 break;
					     case 12:
					    	 return '菜单播报节点';
					    	 break;
					     case 13:
					    	 return '判断节点';
					    	 break;
					     case 14:
					    	 return '挂机节点';
					    	 break;
					     }
					     return '<img src= "../images/icons/fam/exclamation.png" />';

					}
					
				},
				{
					header   : '是否可用', 
					width    : .1, 
					sortable : true, 
					dataIndex: 'status',
					renderer:function(val, meta)
					{
						switch (val) {
						case 0:
							return '<img src= "../images/icons/fam/accept.png" />';
							break;
						}
						return '<img src= "../images/icons/fam/cross.gif" />';
					}	
				},
				{
					header   : 'IVR过程节点名', 
					width    : .2, 
					sortable : true, 
					dataIndex: 'funcName',
					renderer:function(val, meta)
					{
						switch (val) {
						case '':
							return '<img src="../images/default/grid/drop-no.gif" />';
							break;
						}
						return val;
					}	
				}
			],
			stripeRows: true,
			height: 600,
			width: '100%',
			viewConfig: {forceFit:true}, 
			loadMask: true,
			listeners : {
				'render' : function() {
					toolbar.render(this.tbar);
				}
            },
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
						Ext.getCmp('btnInfomation').fireEvent('click'); 
					});    
		/** 列表双击操作 End */

		
		//右击列表中记录，显示可操作属性
		/*
		var rightClick = new Ext.menu.Menu();
			rightClick.add({
				text : '节点详细',
				iconCls : 'confeditbtn',
				handler : function(obj, e) {
						Ext.getCmp('').fireEvent('click'); 
					}
			});
		
		grid.addListener('rowcontextmenu', function(client, rowIndex, e) {
			e.preventDefault();
            rightClick.showAt(e.getXY());
		});
		*/
		/*
		查询
		*/
		
		var panel_query = new Ext.Panel({
			layout: 'border',
			region: 'center',
			autoScroll:false,
			iconCls: 'searchbtn',
			border: false,
			tbar: [
				'菜单节点编号:&nbsp;&nbsp;',
				new Ext.form.TextField({
					id: 'id',
					enableKeyEvents: true,
					width: 140,
					allowBlank:true,
					listeners: 
						{'keypress': function(obj, e) {
								if (e.getKey() == e.ENTER) { 
									Ext.getCmp('btnSearch').fireEvent('click');   
								}   
							}
						}
				}),
				'-',
				'名称:&nbsp;&nbsp;',
				new Ext.form.TextField({
					id: 'comment',
					enableKeyEvents: true,
					width: 140,
					allowBlank:true,
					listeners: 
						{'keypress': function(obj, e) {
								if (e.getKey() == e.ENTER) { 
									Ext.getCmp('btnSearch').fireEvent('click');   
								}
							}
						}
				}),
				'-',
				'业务类型:&nbsp;&nbsp;',
				{
					xtype: 'combo',
					fieldLabel: '业务类型',
					id: 'cmbBusinessType',
					name: 'businessType',
					width: 140,
					store : businessTypeStore,
					valueField : 'value',
					displayField : 'name',
					mode: 'local',
					typeAhead: true,
					forceSelection: true,
					editable: false,
					triggerAction: 'all',
					selectOnFocus:true,
					allowBlank:true,
					
					listeners: 
					{'keypress': function(obj, e) {
							if (e.getKey() == e.ENTER) { 
								Ext.getCmp('btnSearch').fireEvent('click');   
							}
						}
					}
				},
				'-',
				new Ext.Toolbar.Button({
					id: 'btnSearch',
					iconCls: 'searchbtn',
					text: '查询',
					listeners: 
						{'click': function(obj, e) {
								store.removeAll();
								store.load({params:{start:0, limit:pagesize}});
							}
						}
				}),
				'-'
			],
			items: grid
		
		});
		
		store.load({params:{start:0, limit:pagesize}});
		
		store.on('beforeload', function(loader, node) {
			var nodeCode = Ext.getCmp('id').getValue();
			var nodeName = Ext.getCmp('comment').getValue();
			var cmbBusinessType = Ext.getCmp('cmbBusinessType').getValue();
			
			store.baseParams = {nodeCode:nodeCode, nodeName:nodeName, cmbBusinessType:cmbBusinessType};
		});
		
		/*
		查询end
		*/
		
		
		var viewport = new Ext.Viewport({
			layout: 'border',
			autoHeight: true,
			border: false,
			items: [panel_query]
		});	
		

		win1 = new Ext.Window({
			layout:'fit',
			width: 550,
			height:450,
			closeAction:'hide',
			modal: false,
			plain: true,
			buttons: [{
		    	text: '关闭',
	    		handler: function() {
					win1.hide();
				}
		    }]
		});

		win3 = new Ext.Window({
			layout:'fit',
			width: 550,
			height:450,
			closeAction:'hide',
			modal: true,
			plain: true,
			buttons: [{
		    	text: '关闭',
	    		handler: function() {
					win3.hide();
				}
		    }]
		});
		
		win4 = new Ext.Window({
			layout:'fit',
			width: 550,
			height:450,
			closeAction:'hide',
			modal: true,
			plain: true,
			buttons: [{
		    	text: '关闭',
	    		handler: function() {
					win4.hide();
				}
		    }]
		});

		win6 = new Ext.Window({
			layout:'fit',
			width: 550,
			height:450,
			closeAction:'hide',
			modal: true,
			plain: true,
			buttons: [{
		    	text: '关闭',
	    		handler: function() {
					win6.hide();
				}
		    }]
		});
		
		win8 = new Ext.Window({
			layout:'fit',
			width: 550,
			height:450,
			closeAction:'hide',
			modal: true,
			plain: true,
			buttons: [{
		    	text: '关闭',
	    		handler: function() {
					win8.hide();
				}
		    }]
		});
		
		win12 = new Ext.Window({
			layout:'fit',
			width: 550,
			height:450,
			closeAction:'hide',
			modal: true,
			plain: true,
			buttons: [{
		    	text: '关闭',
	    		handler: function() {
					win12.hide();
				}
		    }]
		});
		
		win13 = new Ext.Window({
			layout:'fit',
			width: 550,
			height:450,
			closeAction:'hide',
			modal: true,
			plain: true,
			buttons: [{
		    	text: '关闭',
	    		handler: function() {
					win13.hide();
				}
		    }]
		});
		

	});	
	
	
	</script>
</head>
</html>
