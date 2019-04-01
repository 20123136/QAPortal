



	
var Colmuns = [	
	
	new Ext.app.common.ColmunField({

		boxLabel: 'ID',

		name: 'qaRecordId',

		value: 'qaRecordId',

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

		boxLabel: '案例属性',

		width: 60,

		name: 'qaCaseAttribute',

		value: 'qaCaseAttribute',

		colType: 'String',

		locked: true,

		checked: true,

		hidden: false,

		disabled: false,

		sortable: true,

		group: false,

		groupKey: '',

		groupSize: 0,

		renderer: function(v, p, record, rowIndex){
			if(v == '1') {
				return '<font color=red>优秀</font>';
			} else if(v == '2') {
				return '<font color=green>合格</font>';
			} else if(v == '3') {
				return '<font color=gray>不合格</font>';
			} else {
				return '';
			}
		}

	})

	,

	new Ext.app.common.ColmunField({

		boxLabel: '座席名称',

		width: 60,

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

		boxLabel: '部门',

		width: 60,

		name: 'agentDeptName',

		value: 'agentDeptName',

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

		boxLabel: '部门Id',

		name: 'agentDeptId',

		value: 'agentDeptId',

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

		boxLabel: '通话时间',

		name: 'displayLength',

		value: 'displayLength',

		colType: 'TimeLength',

		locked: false,

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

		boxLabel: '通话时间',

		width: 60,

		name: 'length',

		value: 'length',

		colType: 'TimeLength',

		checked: true,
		
		locked: true,

		hidden: false,

		disabled: false,

		sortable: true,

		group: false,

		groupKey: '',

		groupSize: 0,

		renderer: function(v, p, record, rowIndex){
			return record.get('displayLength');
		}

	})

	,

	new Ext.app.common.ColmunField({

		boxLabel: '质检状态',

		width: 60,

		name: 'qaStatus',

		value: 'qaStatus',

		colType: 'String',

		locked: true,

		checked: true,

		hidden: false,

		disabled: false,

		sortable: true,

		group: false,

		groupKey: '',

		groupSize: 0,

		renderer: function(v, p, record, rowIndex){
			if(v == 'COMPLETED') {
				return '<font color=#66CC00>已质检</font>';
			} else if(v == 'UPDATED') {
				return '<font color=#CC3333>已更改</font>';
			} else if(v == 'CHECKED') {
				return '<font color=#FF6600>已复核</font>';
			} else if(v == 'ASSIGNED') {
				return '<font color=#6699CC>已分配</font>';
			} else if(v == 'APPEALED') {
				return '<font color=#660033>申诉中</font>';
			} else if(v == 'IDLE') {
				return '<font color=#C0C0C0>未质检</font>';
			} else {
				return v;
			}
		}

	}),

	new Ext.app.common.ColmunField({

		boxLabel: '评分',

		width: 40,

		name: 'qaScore',

		value: 'qaScore',

		colType: 'Integer',

		locked: true,

		checked: true,

		hidden: false,

		disabled: false,

		sortable: true,

		group: false,

		groupKey: '',

		groupSize: 0

	}),

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

		width: 60,

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

		boxLabel: '通话开始时间',

		width: 130,

		name: 'beginTime',

		value: 'beginTime',

		colType: 'DateTime',

		checked: true,

		locked: false,

		hidden: false,

		disabled: true,

		sortable: true,

		group: false,

		groupKey: '',

		groupSize: 0,

		renderer: function(v, p, record, rowIndex){
			return formatDateTime(v);
		}

	})

	,

	new Ext.app.common.ColmunField({

		boxLabel: '通话结束时间',

		width: 130,

		name: 'endTime',

		value: 'endTime',

		colType: 'DateTime',

		checked: true,

		hidden: false,

		disabled: false,

		sortable: true,

		group: false,

		groupKey: '',

		groupSize: 0,

		renderer: function(v, p, record, rowIndex){
			return formatDateTime(v);
		}

	})

	,

	new Ext.app.common.ColmunField({

		boxLabel: '主叫号码',

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

		width: 100,

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

		width: 100,

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

		boxLabel: '质检员',

		width: 60,

		name: 'qaUserName',

		value: 'qaUserName',

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

		boxLabel: '质检员ID',

		name: 'qaUserId',

		value: 'qaUserId',

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

		boxLabel: '质检记录ID',

		name: 'qaRecordId',

		value: 'qaRecordId',

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

		boxLabel: '质检项列表',

		width: 120,

		name: 'qaItems',

		value: 'qaItems',

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

		boxLabel: '复核项列表',

		width: 120,

		name: 'qaCheckItems',

		value: 'qaCheckItems',

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

		boxLabel: '评分内容',

		name: 'qaComment',

		value: 'qaComment',

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

		boxLabel: '复核内容',

		name: 'qaCheckComment',

		value: 'qaCheckComment',

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
		width: 130,

		boxLabel: '质检时间',

		name: 'qaTime',

		value: 'qaTime',

		colType: 'String',

		locked: false,

		checked: true,

		hidden: false,

		disabled: false,

		sortable: true,

		group: false,

		groupKey: '',

		groupSize: 0,

		renderer: function(v, p, record, rowIndex){
			return formatDateTime(v);
		}

	}),

	new Ext.app.common.ColmunField({
		width: 130,

		boxLabel: '分配时间',

		name: 'qaAssignTime',

		value: 'qaAssignTime',

		colType: 'String',

		locked: false,

		checked: true,

		hidden: false,

		disabled: false,

		sortable: true,

		group: false,

		groupKey: '',

		groupSize: 0,

		renderer: function(v, p, record, rowIndex){
			return formatDateTime(v);
		}

	}),

	new Ext.app.common.ColmunField({
		width: 130,

		boxLabel: '计划质检时间',

		name: 'qaPlannedTime',

		value: 'qaPlannedTime',

		colType: 'String',

		locked: false,

		checked: true,

		hidden: false,

		disabled: false,

		sortable: true,

		group: false,

		groupKey: '',

		groupSize: 0

	}),

	new Ext.app.common.ColmunField({

		boxLabel: '案例状态',

		name: 'qaCaseStatus',

		value: 'qaCaseStatus',

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

		boxLabel: '案例提交者',

		name: 'qaCaseUserId',

		value: 'qaCaseUserId',

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

		boxLabel: '质检项类型',

		name: 'qaGroupType',

		value: 'qaGroupType',

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