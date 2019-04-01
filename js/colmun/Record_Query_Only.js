
var Colmuns = [

	new Ext.app.common.ColmunField({

		boxLabel: 'ID',

		name: 'id',

		value: 'id',

		colType: 'String',

		checked: true,

		hidden: true,

		disabled: true,

		sortable: true,

		group: false,

		groupKey: '',

		groupSize: 0

	})

	,

	new Ext.app.common.ColmunField({

		boxLabel: 'RecID',

		name: 'recId',

		value: 'recId',

		colType: 'String',

		checked: true,

		hidden: true,

		disabled: true,

		sortable: true,

		group: false,

		groupKey: '',

		groupSize: 0

	})

	,

	new Ext.app.common.ColmunField({

		boxLabel: '文件名',

		name: 'fileName',

		value: 'fileName',

		colType: 'String',

		checked: true,

		hidden: true,

		disabled: true,

		sortable: true,

		group: false,

		groupKey: '',

		groupSize: 0

	})

	,

	new Ext.app.common.ColmunField({

		boxLabel: '座席名称',

		width: 80,

		name: 'agentName',

		value: 'agentName',

		colType: 'String',

		locked: true,

		checked: true,

		hidden: false,

		disabled: false,

		sortable: true,

		group: false,

		groupKey: '',

		groupSize: 0

	})

	,

	new Ext.app.common.ColmunField({

		boxLabel: '座席ID',

		name: 'agentId',

		value: 'agentId',

		colType: 'String',

		checked: true,

		hidden: true,

		disabled: false,

		sortable: true,

		group: false,

		groupKey: '',

		groupSize: 0

	})

	,

	new Ext.app.common.ColmunField({

		boxLabel: '部门',

		width: 80,

		name: 'deptName',

		value: 'deptName',

		colType: 'String',

		checked: true,

		locked: true,

		hidden: false,

		disabled: false,

		sortable: true,

		group: false,

		groupKey: '',

		groupSize: 0

	}),

	new Ext.app.common.ColmunField({

		boxLabel: '部门Id',

		name: 'deptId',

		value: 'deptId',

		colType: 'String',

		checked: true,

		hidden: true,

		disabled: false,

		sortable: true,

		group: false,

		groupKey: '',

		groupSize: 0

	})

	,

	new Ext.app.common.ColmunField({

		boxLabel: '座席编号',

		width: 60,

		name: 'agentNo',

		value: 'agentNo',

		colType: 'String',

		checked: true,

		hidden: false,

		disabled: false,

		sortable: true,

		group: false,

		groupKey: '',

		groupSize: 0

	})

	,

	new Ext.app.common.ColmunField({

		boxLabel: '分机号',

		width: 60,

		name: 'extNo',

		value: 'extNo',

		colType: 'String',

		checked: true,

		hidden: false,

		disabled: false,

		sortable: true,

		group: false,

		groupKey: '',

		groupSize: 0

	})

	,

	new Ext.app.common.ColmunField({

		boxLabel: '呼叫类型',

		name: 'callType',

		value: 'callType',

		colType: 'String',

		checked: true,

		hidden: false,

		disabled: true,

		sortable: true,

		group: false,

		groupKey: '',

		groupSize: 0,

		renderer: function(v, p, record, rowIndex){
			if(record.get('callType') == 'in') {
				return '<font color=#66CC00>' + record.get('displayCallType') + '</font>';
			} else if(record.get('callType') == 'out') {
				return '<font color=#CC3333>' + record.get('displayCallType') + '</font>';
			} else {
				return v;
			}
		}

	})

	,

	new Ext.app.common.ColmunField({

		boxLabel: '呼叫类型',

		width: 60,

		name: 'displayCallType',

		value: 'displayCallType',

		colType: 'String',

		checked: true,

		hidden: true,

		disabled: false,

		sortable: true,

		group: false,

		groupKey: '',

		groupSize: 0
	})

	,

	new Ext.app.common.ColmunField({

		boxLabel: '起始时间',

		width: 150,

		name: 'beginTime',

		value: 'beginTime',

		colType: 'DateTime',

		checked: true,

		hidden: false,

		disabled: true,

		sortable: true,

		group: false,

		groupKey: '',

		groupSize: 0

	})

	,
/*
	new Ext.app.common.ColmunField({

		boxLabel: '结束时间',

		width: 150,

		name: 'endTime',

		value: 'endTime',

		colType: 'DateTime',

		checked: false,

		hidden: false,

		disabled: false,

		sortable: true,

		group: false,

		groupKey: '',

		groupSize: 0

	})

	,

	new Ext.app.common.ColmunField({

		boxLabel: '通话时间(秒)',

		width: 80,

		name: 'length',

		value: 'length',

		colType: 'String',

		checked: false,

		hidden: false,

		disabled: false,

		sortable: true,

		group: false,

		groupKey: '',

		groupSize: 0

//		renderer: function(v, p, record, rowIndex){
//			return record.get('displayLength');
//		}

	})
,

	new Ext.app.common.ColmunField({

		boxLabel: '通话时间',

		name: 'displayLength',

		value: 'displayLength',

		colType: 'TimeLength',

		checked: false,

		hidden: false,

		disabled: false,

		sortable: true,

		group: false,

		groupKey: '',

		groupSize: 0

	})

	,*/

   new Ext.app.common.ColmunField({

		boxLabel: '主叫号码',

		width: 110,

		name: 'ani',

		value: 'ani',

		colType: 'String',

		checked: true,

		hidden: false,

		disabled: false,

		sortable: true,

		group: false,

		groupKey: '',

		groupSize: 0,

		renderer: function(v, p, record, rowIndex){
			return record.get('displayAni');
		}

	})

	,

	new Ext.app.common.ColmunField({

		boxLabel: '主叫号码',

		width: 110,

		name: 'displayAni',

		value: 'displayAni',

		colType: 'String',

		checked: true,

		hidden: true,

		disabled: false,

		sortable: true,

		group: false,

		groupKey: '',

		groupSize: 0

	})

	,

	new Ext.app.common.ColmunField({

		boxLabel: '被叫号码',

		width: 110,

		name: 'dnis',

		value: 'dnis',

		colType: 'String',

		checked: true,

		hidden: false,

		disabled: false,

		sortable: true,

		group: false,

		groupKey: '',

		groupSize: 0,

		renderer: function(v, p, record, rowIndex){
			return record.get('displayDnis');
		}

	}),

	new Ext.app.common.ColmunField({

		boxLabel: '被叫号码',

		width: 110,

		name: 'displayDnis',

		value: 'displayDnis',

		colType: 'String',

		checked: true,

		hidden: true,

		disabled: false,

		sortable: true,

		group: false,

		groupKey: '',

		groupSize: 0

	}),

	new Ext.app.common.ColmunField({

		boxLabel: '录音编号',

		width: 160,

		name: 'callId',

		value: 'callId',

		colType: 'String',

		checked: true,

		hidden: false,

		disabled: false,

		sortable: true,

		group: false,

		groupKey: '',

		groupSize: 0

	})


]
