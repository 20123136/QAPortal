/**
 * @class Ext.app.qa.QASelectorGrid
 * @extends Ext.app.common.Grid
 * 座席列表。
 */
Ext.ns('Ext.app.qa');

Ext.app.qa.QASelectorGrid = Ext.extend(Ext.app.common.Grid, {
	name: 'qaSelector',
	autoScroll: true,
	border: false,
	stripeRows : true,
	loadMask: true,
	viewConfig: {
		forceFit:true
	},
	height: 420,
	width: '100%',
	hideHeaders: true,

	qaType: 1,
	qaGroupType: 'QUALITY',

	isQuery: false,
	
	view: new Ext.grid.GroupingView({
		forceFit:true,
		groupTextTpl: '{[values.rs[0].get("group1")]} ({[values.rs.length]} {[values.rs.length > 1 ? "Items" : "Item"]})'
	}),

	types: new Array(),
	
	readOnly: false,

	showPaging: false,

	showmode: '',

	unSelectedColor: Ext.isIE ? 'rgb(255,255,255)' : 'rgb(255, 255, 255)',
	
	onSelectedColor: Ext.isIE ? 'rgb(100,149,237)' : 'rgb(100, 149, 237)',
	
	onCheckedColor: Ext.isIE ? 'rgb(255,102,0)' : 'rgb(255, 102, 0)',

	initComponent : function(){
		var me = this;

		this.columns = [
			{
				header   : '序号',
				width    : .1,
				sortable : true,
				hidden	 : true,
				dataIndex: 'order'
			},
			{
				header   : '大类',
				width    : .1,
				sortable : true,
				hidden	 : true,
				dataIndex: 'group1'
			},
			{
				header   : '评分类2',
				width    : .3,
				sortable : true,
				dataIndex: 'group2'
			},
			{
				header   : '评分项1',
				width    : .2,
				sortable : true,
				dataIndex: 'item1'
			},
			{
				header   : '评分项2',
				width    : .2,
				sortable : true,
				dataIndex: 'item2'
			},
			{
				header   : '评分项3',
				width    : .2,
				sortable : true,
				dataIndex: 'item3'
			},
			{
				header   : '评分项4',
				width    : .2,
				sortable : true,
				dataIndex: 'item4'
			},
			{
				header   : '评分项5',
				width    : .2,
				sortable : true,
				dataIndex: 'item5'
			},
			{
				header   : '评分项6',
				width    : .2,
				sortable : true,
				dataIndex: 'item6'
			},
			{
				header   : '评分项7',
				width    : .2,
				sortable : true,
				dataIndex: 'item7'
			},
			{
				header   : '评分项8',
				width    : .2,
				sortable : true,
				dataIndex: 'item8'
			},
			{
				header   : '评分项9',
				width    : .2,
				sortable : true,
				dataIndex: 'item9'
			},
			{
				header   : '评分项10',
				width    : .2,
				sortable : true,
				dataIndex: 'item10'
			}
		];

		var reader = new Ext.data.JsonReader({
			root: 'data',
			totalProperty: 'total',
			remoteSort: false,

			fields: [
				{name: 'group1'},
				{name: 'group2'},
				{name: 'score'},
				{name: 'item1'},
				{name: 'item1id'},
				{name: 'item1Score'},
				{name: 'item2'},
				{name: 'item2id'},
				{name: 'item2Score'},
				{name: 'item3'},
				{name: 'item3id'},
				{name: 'item3Score'},
				{name: 'item4'},
				{name: 'item4id'},
				{name: 'item4Score'},
				{name: 'item5'},
				{name: 'item5id'},
				{name: 'item5Score'},
				{name: 'item6'},
				{name: 'item6id'},
				{name: 'item6Score'},
				{name: 'item7'},
				{name: 'item7id'},
				{name: 'item7Score'},
				{name: 'item8'},
				{name: 'item8id'},
				{name: 'item8Score'},
				{name: 'item9'},
				{name: 'item9id'},
				{name: 'item9Score'},
				{name: 'item10'},
				{name: 'item10id'},
				{name: 'item10Score'},
				{name: 'order'}
			]
		});

		this.on('viewready', function() {
			var itemIds = me.recData.get('qaItems');
			var itemIdStr = '';
			if(itemIds) {
				Ext.each(itemIds, function(itemId) {
					itemIdStr = itemIdStr + itemId + ';';
				});
			}

			var checkItemIds = me.recData.get('qaCheckItems');
			var checkItemIdStr = '';
			if(checkItemIds) {
				Ext.each(checkItemIds, function(itemId) {
					checkItemIdStr = checkItemIdStr + itemId + ';';
				});
			}

			var view = me.getView();
			var rows = me.getStore().getCount();
			var cols = me.getColumnModel().getColumnCount();

			var totalScore = 0, selectedScore = 0, selectedItem = 0, checkedScore = 0;

			var colflag = new Array();
			for(j=0; j<cols; j++) {
				colflag[j] = false;
				if(j > 1) me.getColumnModel().setHidden(j,false);
			}

			var checked = new Array();
			for(i=0; i<rows; i++) {
				var score = me.getStore().getAt(i).get('score');
				totalScore += score;
				checked = new Array();
				for(j=0; j<cols; j++) {
					var idx = me.getColumnModel().getDataIndex(j);
					var id = me.getStore().getAt(i).get(idx+'id');
					var name = me.getStore().getAt(i).get(idx);
					var itemScore = me.getStore().getAt(i).get(idx+'Score');
					if(id && id != 'null') {
						if(checkItemIdStr.indexOf(id) >= 0) {
							//alert('i=' + i + ';j=' + j);
							view.getCell(i, j).style.backgroundColor = me.onCheckedColor;
							checked['Checked'] = itemScore;
						}
						if(itemIdStr.indexOf(id) >= 0) {
							view.getCell(i, j).style.backgroundColor = me.onSelectedColor;
							selectedScore += itemScore;
							checked['Selected'] = itemScore;
							selectedItem++;
						}
						colflag[j] = true;
					}
				}
				if(checked['Checked']) {
					checkedScore += checked['Checked'];
				} else if(checked['Selected']) {
					checkedScore += checked['Selected'];
				}
			}
			for(j=0; j<cols; j++) {
				if(j > 2 && !colflag[j]) {
					me.getColumnModel().setHidden(j,true);
				}
			}
			Ext.getCmp('txtQAGradeComment').setValue(me.recData.get('qaComment'));
			if(Ext.getCmp('txtQAGradeCheckComment')) {
				Ext.getCmp('txtQAGradeCheckComment').setValue(me.recData.get('qaCheckComment'));
			}

			Ext.getDom('spanQAItemTotal').innerHTML = rows;
			Ext.getDom('spanQAItemSelected').innerHTML = selectedItem;
			Ext.getDom('spanQAScoreTotal').innerHTML = totalScore;
			Ext.getDom('spanQAScoreSelected').innerHTML = selectedScore;
			if(Ext.getDom('spanQAScoreTotal2')) {
				Ext.getDom('spanQAScoreTotal2').innerHTML = totalScore;
			}
			if(Ext.getDom('spanQAScoreChecked')) {
				Ext.getDom('spanQAScoreChecked').innerHTML = checkedScore;
			}
		});

		var groupType = me.recData.get('qaGroupType');
		
		var qaGroupType;
		
		console.log("groupType:"+this.recData.data.callType);
		if(this.recData.data.callType == 'in'){
			qaGroupType = 'd3d30b60-101d-45a0-833d-cafc4089eee7';
		}else if(this.recData.data.callType == 'out'){
			qaGroupType = '06a6d5f9-140f-4d39-acc6-818cfbd1067d';
		}else{
			qaGroupType = me.recData.get('qaGroupType');
		}

		this.store = new Ext.data.GroupingStore({
			reader: reader,
			proxy: new Ext.data.HttpProxy({
				url: window.webRoot + 'QAItemGroup/' + groupType + '/Selector'
			}),
//			sortInfo:{field:'order',direction: 'ASC'},
			groupField:'order'
		});

		this.store.on('beforeload', function(obj) {
			obj.removeAll();
			console.log(qaGroupType);
			obj.proxy.setUrl(window.webRoot + 'QAItemGroup/'+ qaGroupType + '/Selector', true);
//			obj.removeAll();
//			var name = me.getTopToolbar().find('name', 'txtAgentNo')[0].getValue(); 
//			var userName = me.getTopToolbar().find('name', 'txtUserName')[0].getValue(); 
//			var deptId = me.getTopToolbar().find('name', 'cmbDeptId')[0].getValue(); 
//			obj.baseParams = {'name': name, 'userName': userName, 'deptId': deptId, 'status': 0};
		});

		this.store.on('load', function(obj) {

			if(obj.getCount() == 0) {
				Ext.Msg.alert('评分失败', '没有查询到符合条件的质检组别！');
				return;
			}

			var itemIds = me.recData.get('qaItems');
			var itemIdStr = '';
			if(itemIds) {
				Ext.each(itemIds, function(itemId) {
					itemIdStr = itemIdStr + itemId + ';';
				});
			}

			var checkItemIds = me.recData.get('qaCheckItems');
			var checkItemIdStr = '';
			if(checkItemIds) {
				Ext.each(checkItemIds, function(itemId) {
					checkItemIdStr = checkItemIdStr + itemId + ';';
				});
			}

			var view = me.getView();
			var rows = me.getStore().getCount();
			var cols = me.getColumnModel().getColumnCount();

			var totalScore = 0, selectedScore = 0, selectedItem = 0, checkedScore = 0;

			var colflag = new Array();
			for(j=0; j<cols; j++) {
				colflag[j] = false;
				if(j > 1) me.getColumnModel().setHidden(j,false);
			}

			var checked = new Array();
			for(i=0; i<rows; i++) {
				var score = me.getStore().getAt(i).get('score');
				totalScore += score;
				checked = new Array();
				for(j=0; j<cols; j++) {
					var idx = me.getColumnModel().getDataIndex(j);
					var id = me.getStore().getAt(i).get(idx+'id');
					var name = me.getStore().getAt(i).get(idx);
					var itemScore = me.getStore().getAt(i).get(idx+'Score');
					if(id && id != 'null') {
						if(checkItemIdStr.indexOf(id) >= 0) {
							//alert('i=' + i + ';j=' + j);
							view.getCell(i, j).style.backgroundColor = me.onCheckedColor;
							checked['Checked'] = itemScore;
						}
						if(itemIdStr.indexOf(id) >= 0) {
							view.getCell(i, j).style.backgroundColor = me.onSelectedColor;
							selectedScore += itemScore;
							checked['Selected'] = itemScore;
							selectedItem++;
						}
						colflag[j] = true;
					}
				}
				if(checked['Checked']) {
					checkedScore += checked['Checked'];
				} else if(checked['Selected']) {
					checkedScore += checked['Selected'];
				}
			}
			for(j=0; j<cols; j++) {
				if(j > 2 && !colflag[j]) {
					me.getColumnModel().setHidden(j,true);
				}
			}
			Ext.getCmp('txtQAGradeComment').setValue(me.recData.get('qaComment'));
			if(Ext.getCmp('txtQAGradeCheckComment')) {
				Ext.getCmp('txtQAGradeCheckComment').setValue(me.recData.get('qaCheckComment'));
			}

			Ext.getDom('spanQAItemTotal').innerHTML = rows;
			Ext.getDom('spanQAItemSelected').innerHTML = selectedItem;
			Ext.getDom('spanQAScoreTotal').innerHTML = totalScore;
			Ext.getDom('spanQAScoreSelected').innerHTML = selectedScore;
			if(Ext.getDom('spanQAScoreTotal2')) {
				Ext.getDom('spanQAScoreTotal2').innerHTML = totalScore;
			}
			if(Ext.getDom('spanQAScoreChecked')) {
				Ext.getDom('spanQAScoreChecked').innerHTML = checkedScore;
			}
		});

		this.store.load();
//		if(this.types && this.types.length > 0) {
			
/*
			Ext.each(this.types, function(type) {
				toolbar.add(
					new Ext.form.Radio({
						boxLabel: type.name,
						name: 'qatype',
						value: type.value,
						width: 120,
						disabled: me.readOnly,
						listeners: 
							{'check': function(obj, checked) {
									if(checked) {
										me.qaType = type.value;
										me.store.removeAll();
										me.store.proxy.setUrl(window.webRoot + 'rest/qa/itemgroup/'+ me.qaType +'/' + me.qaGroupType + '/select', true);
										me.store.load();
									}
								}
							}
					})
				);
				toolbar.add('-');
			});
*/
//		}

		if(!this.isQuery) {
			var comments = new Array();
			if(this.showmode == 'Check') {
				comments.push(
					{
						xtype: 'fieldset',
						title: '评分内容',
						width: 385,
						autoHeight: true,
						items: [
							new Ext.form.TextArea({
								id: 'txtQAGradeComment',
								name: 'comment',
								hideLabel: true,
								style:'color:blue;',
								width: 350,
								height: 32,
								readOnly: me.readOnly
							})
						]
					}
				);
				comments.push(
					{
						xtype: 'fieldset',
						title: '复核内容',
						width: 385,
						autoHeight: true,
						items: [
							new Ext.form.TextArea({
								id: 'txtQAGradeCheckComment',
								name: 'checkComment',
								hideLabel: true,
								style:'color:blue;',
								width: 350,
								height: 32,
								readOnly: me.readOnly
							})
						]
					}
				);
			} else {
				comments.push(
					{
						xtype: 'fieldset',
						title: '评分内容',
						width: 775,
						autoHeight: true,
						items: [
							new Ext.form.TextArea({
								id: 'txtQAGradeComment',
								name: 'comment',
								hideLabel: true,
								style:'color:blue;',
								width: 750,
								height: 32,
								readOnly: me.readOnly
							})
						]
					}
				);
			}

			this.bbar = new Ext.Toolbar({
				height: 75,
				bodyStyle: 'padding-right:5px;',
				items: comments
			})
		}
		
		this.on('render', function(obj){
			var strHtml = '';
			if(me.showmode == 'Check') {
				strHtml = '<table width=' + obj.getWidth() + ' border="0" cellpadding="0" cellspacing="0" width="100%">' + 
								'<tr>' +
								'<td width=30% align=center>质检项（<span id=spanQAItemSelected style="color:#66CC00;">0</span>/<span id=spanQAItemTotal style="color:#CC3333;">0</span>）</td>' + 
								'<td width=30% align=center>分数（<span id=spanQAScoreSelected style="color:#66CC00;">0</span>/<span id=spanQAScoreTotal style="color:#CC3333;">0</span>）</td>' + 
								'<td width=30% align=center>复核分数（<span id=spanQAScoreChecked style="color:#66CC00;">0</span>/<span id=spanQAScoreTotal2 style="color:#CC3333;">0</span>）</td>' + 
								'</tr>' +
							   '</table>';
				Ext.getCmp('txtQAGradeComment').setReadOnly(true);
			} else {
				strHtml = '<table width=' + obj.getWidth() + ' border="0" cellpadding="0" cellspacing="0" width="100%">' + 
								'<tr>' +
								'<td width=50% align=center>质检项（<span id=spanQAItemSelected style="color:#66CC00;">0</span>/<span id=spanQAItemTotal style="color:#CC3333;">0</span>）</td>' + 
								'<td width=50% align=center>分数（<span id=spanQAScoreSelected style="color:#66CC00;">0</span>/<span id=spanQAScoreTotal style="color:#CC3333;">0</span>）</td>' + 
								'</tr>' +
							   '</table>';
			}
			var tbar1 = new Ext.Toolbar({
				items: [
					new Ext.form.Label({
						width: obj.getWidth(),
						html: strHtml
					})
				]
			});
			
			tbar1.render(obj.bbar);
		});

		this.on('cellclick', function(obj, row, col, e) {
			var idx = obj.getColumnModel().getDataIndex(col);
			var id = obj.getStore().getAt(row).get(idx+'id');
			var score = obj.getStore().getAt(row).get(idx+'Score');
			var selectedScore = parseInt(Ext.getDom('spanQAScoreSelected').innerHTML);
			var selectedItem = parseInt(Ext.getDom('spanQAItemSelected').innerHTML);
			var checkedScore = 0;
			if(Ext.getDom('spanQAScoreChecked')) {
				checkedScore = parseInt(Ext.getDom('spanQAScoreChecked').innerHTML);
			}
			//alert(obj.onSelectedColor.length);
			//alert(obj.onSelectedColor);
			var selectedRow = false;
			if(id && col > 1 && !me.readOnly && me.showmode != 'Check') {
				for(var i=0; i<obj.getColumnModel().getColumnCount();i++) {
					//alert('i=' + i + ';' + obj.getView().getCell(row, i).style.backgroundColor.toString() + ';' + obj.getView().getCell(row, i).style.backgroundColor.length);
					if(obj.getView().getCell(row, i).style.backgroundColor.toString() == obj.onSelectedColor) {
						//alert('ok1');
						var idx2 = obj.getColumnModel().getDataIndex(i);
						var score2 = obj.getStore().getAt(row).get(idx2+'Score');
						obj.getView().getCell(row, i).style.backgroundColor = obj.unSelectedColor;
						obj.getView().getCell(row, i).style.fontWeight = 'normal';
						selectedScore = selectedScore - score2;
						selectedRow = true;
					}
				}
				obj.getView().getCell(row, col).style.backgroundColor = obj.onSelectedColor;
				obj.getView().getCell(row, col).style.fontWeight = 'bold';
				selectedScore = selectedScore + score;
				
				Ext.getDom('spanQAScoreSelected').innerHTML = selectedScore;
				if(!selectedRow) {
					Ext.getDom('spanQAItemSelected').innerHTML = selectedItem + 1;
				}
			} else if(id && col > 1 && !me.readOnly && me.showmode == 'Check') {
				var checked = false;
				var selectScore = 0;
				for(var i=0; i<obj.getColumnModel().getColumnCount();i++) {
					if(obj.getView().getCell(row, i).style.backgroundColor == obj.onCheckedColor) {
						checked = true;
						var idx2 = obj.getColumnModel().getDataIndex(i);
						var score2 = obj.getStore().getAt(row).get(idx2+'Score');
						obj.getView().getCell(row, i).style.backgroundColor = obj.unSelectedColor;
						obj.getView().getCell(row, i).style.fontWeight = 'normal';
						checkedScore = checkedScore - score2;
					}
					if(obj.getView().getCell(row, i).style.backgroundColor == obj.onSelectedColor) {
						var idx2 = obj.getColumnModel().getDataIndex(i);
						selectScore = obj.getStore().getAt(row).get(idx2+'Score');
					}
				}
				if(!checked) {
					checkedScore = checkedScore - selectScore;
				}
				if(obj.getView().getCell(row, col).style.backgroundColor != obj.onSelectedColor) {
					obj.getView().getCell(row, col).style.backgroundColor = obj.onCheckedColor;
					obj.getView().getCell(row, col).style.fontWeight = 'bold';
					checkedScore = checkedScore + score;
				} else {
					checkedScore = checkedScore + selectScore;
				}
				
				if(Ext.getDom('spanQAScoreChecked')) {
					Ext.getDom('spanQAScoreChecked').innerHTML = checkedScore;
				}
			}
		});
		Ext.app.qa.QASelectorGrid.superclass.initComponent.call(this);
	},

	onRender: function(ct, position) {
        Ext.app.qa.QASelectorGrid.superclass.onRender.call(this, ct, position);
	},

	afterRender : function(){
 		Ext.app.qa.QASelectorGrid.superclass.afterRender.call(this);
	},

	reset: function() {
		var view = this.getView();
		var rows = this.getStore().getCount();
		var cols = this.getColumnModel().getColumnCount();
		for(i=0; i<rows; i++) {
			for(j=0; j<cols; j++) {
				if(view.getCell(i, j).style.backgroundColor == this.onSelectedColor || view.getCell(i, j).style.backgroundColor == this.onCheckedColor) {
					view.getCell(i, j).style.backgroundColor = this.unSelectedColor;
					view.getCell(i, j).style.fontWeight = 'normal';
				}
			}
		}
	},

	clearData: function() {
		this.getSelectionModel().clearSelections();
	},

	getKey: function() {
		var key = new Array();
		key.push('typeId');
		key.push('groupTypeId');
		key.push('item');
		if(!this.isQuery) {
			key.push('comment');
		}

		return key;
	},

	getVal: function() {
		var val = new Array();

		val.push(this.qaType);
		
		val.push(this.qaGroupType);

		var view = this.getView();
		var rows = this.getStore().getCount();
		var cols = this.getColumnModel().getColumnCount();
		var items = new Array();
		var score;
		for(i=0; i<rows; i++) {
			score = new Object();
			for(j=0; j<cols; j++) {
				var idx = this.getColumnModel().getDataIndex(j);
				if(view.getCell(i, j).style.backgroundColor == this.onCheckedColor) {
					score['checked'] = this.getStore().getAt(i).get(idx+'id');
				}
				if(view.getCell(i, j).style.backgroundColor == this.onSelectedColor) {
					score['selected'] = this.getStore().getAt(i).get(idx+'id');
				}
			}
			if(score['checked']) {
				items.push(score['checked']);
			} else if (score['selected']) {
				items.push(score['selected']);
			}
		}

		val.push(items);

		if(!this.isQuery) {
			val.push(Ext.getCmp('txtQAGradeComment').getValue());
			if(Ext.getCmp('txtQAGradeCheckComment')) {
				val.push(Ext.getCmp('txtQAGradeCheckComment').getValue());
			} else {
				val.push('');
			}
		}

		return val;
	},

	setVal: function(data) {
		var grid = this;

		if(this.rendered) {
			if(grid.qaGroupType == 'QUALITY') {
				var typeId = data.qaTypeId;
				Ext.each(grid.getTopToolbar().items.items, function(item) {
					if(item.value == typeId) {
						item.setValue(true);
					}
				});
				
				grid.getBottomToolbar().find('name', 'comment')[0].setValue(data.qaComment);
				grid.itemIds = data.qaItemIds;
			}
			if(grid.qaGroupType == 'GRADE') {
				var typeId = data.qaGradeTypeId;
				Ext.each(grid.getTopToolbar().items.items, function(item) {
					if(item.value == typeId) {
						item.setValue(true);
					}
				});
				
				grid.getBottomToolbar().find('name', 'comment')[0].setValue(data.qaGradeComment);
				grid.itemIds = data.qaGradeItemIds;
			}
			try{
				var view = grid.getView();
				var rows = grid.getStore().getCount();
				var cols = grid.getColumnModel().getColumnCount();
				for(i=0; i<rows; i++) {
					for(j=0; j<cols; j++) {
						var idx = grid.getColumnModel().getDataIndex(j);
						var id = grid.getStore().getAt(i).get(idx+'id');
						var name = grid.getStore().getAt(i).get(idx);
						if(id && id != 'null') {
							if(grid.itemIds.indexOf(id) >= 0) {
								view.getCell(i, j).style.backgroundColor = grid.onSelectedColor;
							}
						}
					}
				}
			} catch (e) {
			}
		}
	},

	getRawVal: function() {
		var names = new Array();
		
		var view = this.getView();
		var rows = this.getStore().getCount();
		var cols = this.getColumnModel().getColumnCount();
		for(i=0; i<rows; i++) {
			for(j=0; j<cols; j++) {
				var idx = this.getColumnModel().getDataIndex(j);
				var typeIdx = this.getColumnModel().getDataIndex(1);
				if(view.getCell(i, j).style.backgroundColor == this.onSelectedColor) {
					names.push(this.getStore().getAt(i).get(typeIdx)+ '[' + this.getStore().getAt(i).get(idx) + ']');
				};
			}
		}
		return names;
	},

	getTxt: function() {
		return this.fieldLabel;
	},

	getUXType: function() {
		return 'QASelectorGrid';
	}
});
