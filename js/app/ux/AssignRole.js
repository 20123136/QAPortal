Ext.ns('Ext.app.ux');

Ext.app.ux.AssignRole = Ext.extend(Ext.Window, {
	title : '分配角色',
	layout : 'fit',
	width : 570,
	height : 320,
	iconCls: 'dispatchbtn',
	draggable : true,
	modal : true,
	frame : true,
	resizable : true,

	initComponent : function() {
		var me = this;
		var isForm;

		var fromStore = new Ext.data.JsonStore({
			root: 'data',
			totalProperty: 'total',
			idProperty: 'id',

			autoLoad: true,

			fields: ['id','name'],
			proxy: new Ext.data.HttpProxy({
				url: window.webRoot + 'rest/roles'
			}),
			
			listeners: 
				{'load': function(obj, recs, opts) {
						if(me.users && me.users.length == 1) {
							Ext.Ajax.request({
								url: window.webRoot + 'rest/user/' + me.users[0].get('id') + '/roles',
								success: function(response){
									var ids = new Array();
									var val = Ext.util.JSON.decode(response.responseText);
									if(val.code == 'OK'){
										Ext.each(val.data, function(role) {
											ids.push(role.id);
										});
										isForm.getForm().findField('itemselector').setValue(ids);
									}
								}
							});
						}
					}
				}
		});

		var toStore = new Ext.data.ArrayStore({
			data: [],
			fields: ['id','name']
		});

		var isForm = new Ext.form.FormPanel({
			bodyStyle: 'padding:10px;',
			hideLabels: true,
			border: false,
			items:[{
				xtype: 'itemselector',
				name: 'itemselector',
				imagePath: '../ux/images/',
				multiselects: [{
					width: 250,
					height: 200,
					store: fromStore,
					displayField: 'name',
					valueField: 'id'
				},{
					width: 250,
					height: 200,
					store: toStore,
					displayField: 'name',
					valueField: 'id'
				}]
			}],

		});

		this.items = [isForm];
		
		this.buttons = [
			{
				text: '保存',
				handler: function(){
					var ids = isForm.getForm().findField('itemselector').getValue().split(',');

					for(var i=0; i<me.users.length; i++) {
						Ext.Ajax.request({
							url: window.webRoot + 'rest/user/' + me.users[i].get('id') + '/roles',
							params: {
								_method: 'PUT',
								roleid: ids
							},
							success: function(response,options) {
								var respText = Ext.util.JSON.decode(response.responseText);
								if(respText.code != 'OK') {
									Ext.Msg.alert('分配角色失败', respText.message + "（" + respText.code + "）");
								} else {
									Ext.Msg.alert('分配角色成功', '角色已分配！');
								}
							},
							failure: function(response,options) {
								Ext.Msg.alert('分配角色失败', '分配角色失败！');
							}
						});
					}
					me.close();	
				}
			},{
				text: '取消',
				handler: function() {
					me.close();				
				}
			}
		];

		Ext.app.ux.AssignRole.superclass.initComponent.apply(this, arguments);
	}
	
});