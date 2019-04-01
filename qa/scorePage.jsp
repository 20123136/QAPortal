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
    <title>评分页</title>

    <link rel="stylesheet" type="text/css" href="../css/ext-all-notheme.css" />
    <link rel="stylesheet" type="text/css" href="../css/xtheme-gray.css" />
    <link rel="stylesheet" type="text/css" href="../css/icon.css" />
    <link rel="stylesheet" type="text/css" href="../ux/css/Spinner.css" />
    <style type=text/css>
        /* style rows on mouseover */
        .x-grid3-row-over .x-grid3-cell-inner {
            font-weight: bold;
        }

        .titletext {
            font-weight: bold;
        }
	
    .new1x-fieldset{border:0px solid #B5B8C8;padding:5px;margin-bottom:5px;display:block;}
	</style>
	<script >
		var webRoot = '<%=webRoot%>';
	</script>

    <script type="text/javascript" src="../js/ext-base.js"></script>
    <script type="text/javascript" src="../js/ext-all-debug.js"></script>
    <script type="text/javascript" src="../js/ext-lang-zh_CN.js"></script>
    <script type="text/javascript" src="../js/ext-ui-combo-pagesize.js"></script>
	<script type="text/javascript" src="../ux/FieldLabeler.js"></script>
    <script type="text/javascript" src="../ux/FieldReplicator.js"></script>
    <script type="text/javascript">
	var pagesize = 25;
	var tabCount = 1;

	var ConditionFields = new Array();

	var QueryConditionFields = new Array();
	
	var QAConditionFields = new Array();
	
		
	var data = [['hello', 55, 22, 'nana'], ['hello', 55, 22, 'nana'],
	['hello', 55, 22, 'nana']
	 
	];
	
	var radioGroup2 = {
			xtype: 'fieldset',
			autoHeight: true,
			labelWidth: 15,
			//width: 250,
			//height:40,
			items: [{
				xtype: 'radiogroup',
				width: 160,
				//height:40,
				items: [
					{boxLabel: '商谈组', name: 'rb-auto', inputValue: 1,checked: true},
					{boxLabel: '顾客不满组', name: 'rb-auto', inputValue: 2}
				]
			}]
		};
 
		var store = new Ext.data.ArrayStore({
			fields : [{
				name : 'company'
				}, {
				name : 'percent'
				}, {
				name : 'shiyongliang'
				}, {
				name : 'beizhu'
				}]
		});
		var gridPanels = new Ext.grid.GridPanel({
			//title : '用户列表展示',
			width : '100%',
			height : 200,
			store : store,
			// viewConfig : {
			// forceFit : true
			// // 所有的列平铺gridpanel面板
			// },
			enableHdMenu: false,
			//hideHeaders:true,
			columnLines:false,
			cm : new Ext.grid.ColumnModel({
				columns : [{
					id : 'company',
					width: 160,
					header : "<table width='200'	border='0'   ><tr><td height=80 width: 160>基本礼仪</td></tr><tr ><td height=80  >服务态度<hr/></td></tr><tr ><td >服务技巧</td></tr><tr ><td >业务处理</td></tr><tr ><td >亿<hr/></td></tr></table>",
					dataIndex : ''
					 
				}, {
					id : 'percent',
					header : "<table><tr><td colspan=5 height=19   style='border-right:0px;text-align:center;height:14.25pt;'></td></tr><tr ><td>百</td><td >十</td><td >元</td><td >角</td><td >分</td></tr></table>",
					dataIndex : 'percent'
				}, {
					header : '时间使用量',
					dataIndex : 'shiyongliang'
					}, {
					header : '备注',
					dataIndex : 'beizhu'
				}]
			})
		})
		store.loadData(data);

	
	Ext.onReady(function(){
	
		var radioGroup5  = {
			xtype: 'fieldset',
			autoHeight: true,
			labelWidth: 1,
			baseCls:"new1x-fieldset",              
			width: '100%',
			items: [{
				xtype: 'textarea',
				fieldLabel: 'Message text',
				hideLabel: true,
				height:80,
				cols:6,
				name: 'msg',
				//flex: 1,  // Take up all *remaining* vertical space
				preventScrollbars : false,
				width: '99.8%'
			}]
		};
		
		var form = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			labelWidth: 55,
			layout: {
				type: 'vbox',
				align: 'stretch'  // Child items are stretched to full width
			},
			defaults: {
				xtype: 'textfield'
			},

			items: [{
				xtype: 'combo',
				store: ['test@example.com', 'someone-else@example.com' ],
				plugins: [ Ext.ux.FieldReplicator, Ext.ux.FieldLabeler ],
				fieldLabel: 'Send To',
				name: 'to'
			},{
				plugins: [ Ext.ux.FieldLabeler ],
				fieldLabel: 'Subject',
				name: 'subject'
			}, {
				xtype: 'textarea',
				fieldLabel: 'Message text',
				hideLabel: true,
				name: 'msg',
				flex: 1  // Take up all *remaining* vertical space
			}]
		});
	
		var radioGroup = {
			xtype: 'fieldset',
			autoHeight: true,
			labelWidth: 15,
			//width: 250,
			//height:40,
			items: [{
				xtype: 'radiogroup',
				width: 160,
				
				//height:40,
				items: [
					{boxLabel: '商谈组', name: 'rb-auto', inputValue: 1,checked: true},
					{boxLabel: '顾客不满组', name: 'rb-auto', inputValue: 2}
				]
			},{
					xtype: 'panel',
					html  : "<table width='100%' style = 'border:solid 1px #B5B8C8'	  ><tr  ><td style = ' border-top:0;border-right: 1px #B5B8C8 solid ;border-bottom:1px #B5B8C8 solid ;border-left:0;'height='25' rowspan='2'>基本礼仪</td><td height='25' style = ' border-top:0;border-right: 1px #B5B8C8 solid ;border-bottom:1px #B5B8C8 solid ;border-left:0;' >礼貌用语[P1]</td><td style = ' border-top:0;border-right: 0;border-bottom:1px #B5B8C8 solid ;border-left:0;' height='25' ><input type='radio' name='radioP1' value='nochoose' checked='checked' />不选 <input type='radio' name='radioP1' value='6' />6分<input type='radio' name='radioP1' value='3' />3分<input type='radio' name='radioP1' value='0' />0分</td></tr><tr ><td style = ' border-top:0;border-right: 1px #B5B8C8 solid ;border-bottom:1px #B5B8C8 solid ;border-left:0;' height='25'  >语速/发音[P2]</td><td style = ' border-top:0;border-right: 0;border-bottom:1px #B5B8C8 solid ;border-left:0;' height='25' ><input type='radio' name='radioP2' value='nochoose' checked='checked' />不选 <input type='radio' name='radioP2' value='4' />4分<input type='radio' name='radioP2' value='2' />2分<input type='radio' name='radioP2' value='0' />0分</td></tr><tr ><td style = ' border-top:0;border-right: 1px #B5B8C8 solid ;border-bottom:1px #B5B8C8 solid ;border-left:0;' height='25'  rowspan='2'>服务态度</td><td style = ' border-top:0;border-right: 1px #B5B8C8 solid ;border-bottom:1px #B5B8C8 solid ;border-left:0;' height='25' >亲切度[P3]</td><td style = ' border-top:0;border-right: 0 ;border-bottom:1px #B5B8C8 solid ;border-left:0;' height='25' ><input type='radio' name='radioP3' value='nochoose' checked='checked' />不选 <input type='radio' name='radioP3' value='20' />20分<input type='radio' name='radioP3' value='16' />16分<input type='radio' name='radioP3' value='10' />10分<input type='radio' name='radioP3' value='5' />5分<input type='radio' name='radioP3' value='0' />0分<input type='radio' name='radioP3' value='-10' />-10分</td></tr><tr ><td style = ' border-top:0;border-right: 1px #B5B8C8 solid ;border-bottom:1px #B5B8C8 solid ;border-left:0;' height='25' >耐心度[P4]</td><td style = ' border-top:0;border-right: 0;border-bottom:1px #B5B8C8 solid ;border-left:0;' height='25' ><input type='radio' name='radioP4' value='nochoose' checked='checked' />不选 <input type='radio' name='radioP4' value='10' />10分<input type='radio' name='radioP4' value='6' />6分<input type='radio' name='radioP4' value='3' />3分<input type='radio' name='radioP4' value='0' />0分</td></tr><tr ><td style = ' border-top:0;border-right: 1px #B5B8C8 solid ;border-bottom:1px #B5B8C8 solid ;border-left:0;' height='75' rowspan='3' >服务技巧</td><td style = ' border-top:0;border-right: 1px #B5B8C8 solid ;border-bottom:1px #B5B8C8 solid ;border-left:0;' height='25' >说明力[P5]</td><td style = ' border-top:0;border-right: 0 ;border-bottom:1px #B5B8C8 solid ;border-left:0;' height='25' ><input type='radio' name='radioP5' value='nochoose' checked='checked' />不选 <input type='radio' name='radioP5' value='15' />15分<input type='radio' name='radioP5' value='10' />10分<input type='radio' name='radioP5' value='5' />5分<input type='radio' name='radioP5' value='0' />0分</td></tr><tr ><td style = ' border-top:0;border-right: 1px #B5B8C8 solid ;border-bottom:1px #B5B8C8 solid ;border-left:0;' height='25' >积极性[P6]</td><td style = ' border-top:0;border-right: 0;border-bottom:1px #B5B8C8 solid ;border-left:0;' height='25'  ><input type='radio' name='radioP6' value='nochoose' checked='checked' />不选 <input type='radio' name='radioP6' value='10' />10分<input type='radio' name='radioP6' value='5' />5分<input type='radio' name='radioP6' value='0' />0分</td></tr><tr ><td style = ' border-top:0;border-right: 1px #B5B8C8 solid ;border-bottom:1px #B5B8C8 solid ;border-left:0;' height='25' >迅速性[P7]</td><td style = ' border-top:0;border-right: 0 ;border-bottom:1px #B5B8C8 solid ;border-left:0;' height='25' ><input type='radio' name='radioP7' value='nochoose' checked='checked' />不选 <input type='radio' name='radioP7' value='10' />10分<input type='radio' name='radioP7' value='5' />5分<input type='radio' name='radioP7' value='0' />0分</td></tr><tr ><td style = ' border-top:0;border-right: 1px #B5B8C8 solid ;border-bottom:0  ;border-left:0;' height='25' rowspan='2'   >业务处理</td><td style = ' border-top:0;border-right: 1px #B5B8C8 solid ;border-bottom:1px #B5B8C8 solid ;border-left:0;' height='25' >准确性[P8]</td><td style = ' border-top:0;border-right: 0 ;border-bottom:1px #B5B8C8 solid ;border-left:0;' height='25' ><input type='radio' name='radioP8' value='nochoose' checked='checked' />不选 <input type='radio' name='radioP8' value='20' />20分<input type='radio' name='radioP8' value='10' />10分<input type='radio' name='radioP8' value='0' />0分<input type='radio' name='radioP8' value='-10' />-10分</td></tr><tr ><td style = ' border-top:0;border-right: 1px #B5B8C8 solid ;border-bottom:0 ;border-left:0;' height='25'  >电算[P9]</td><td style = ' border-top:0;border-right: 0 ;border-bottom:0 ;border-left:0;' height='25' ><input type='radio' name='radioP9' value='nochoose' checked='checked' />不选 <input type='radio' name='radioP9' value='10' />10分<input type='radio' name='radioP9' value='5' />5分<input type='radio' name='radioP9' value='0' />0分</td></tr></table>",
				}]
		};
		
		var radioGroup2  = {
			xtype: 'fieldset',
			autoHeight: true,
			labelWidth: 1,
			baseCls:"new1x-fieldset",              
			width: '100%',
			items: [{ 
						xtype: 'displayfield', 
						height: 10,
						value: '评定内容' 
					}]
		};
		
		var radioGroup3 = {
			xtype: 'fieldset',
			autoHeight: true,
			//labelWidth: 115,
			//width: 250,
			
			width: '100%',
			items: [{
				xtype: 'textarea',
				fieldLabel: 'Message text',
				hideLabel: true,
				height:80,
				cols:6,
				name: 'msg',
				//flex: 1,  // Take up all *remaining* vertical space
				preventScrollbars : false,
				width: '99.8%'
			}]
		};
		var radioGroup4 = {
			xtype: 'fieldset',
			autoHeight: true,
			//labelWidth: 115,
			//width: 250,
			height:40,
			width: '100%',
			buttonAlign:'center',  
			buttons: [{
				text: '保&nbsp;存',
				handler: function() {
				var chkObjs = document.getElementsByName("student");
                for(var i=0;i<chkObjs.length;i++){
                    if(chkObjs[i].checked){
                        chk = i;
						alert(i);
                        break;
                    }
                }
				//alert(Ext.getCmp("student").getValue());
				}
			},{
				text: '关&nbsp;闭',
				handler: function() {
					win.hide();
				}
			},{
				text: '删&nbsp;除',
				disabled:true,
				handler: function() {
					win.hide();
				}
			}]
		};
	
		new Ext.Viewport({
			//align:'right',
			items: [
			radioGroup,radioGroup2,radioGroup3,radioGroup4],
			renderTo: Ext.getBody()
		});
	
		
	});
	</script>

</head>
<body>
	<div id="save-win" class="x-hidden"></div>
</body>
</html>
