



	
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

		boxLabel: '案例属性',

		width: 60,

		name: 'qaCaseAttribute',

		value: 'qaCaseAttribute',

		colType: 'String',

		checked: true,

		hidden: false,

		disabled: false,

		locked: true,

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

		boxLabel: '质检员',

		width: 80,

		name: 'qaUserName',

		value: 'qaUserName',

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

		boxLabel: '评分',

		width: 60,

		name: 'qaScore',

		value: 'qaScore',

		colType: 'Integer',

		checked: true,

		locked: true,

		hidden: false,

		disabled: false,

		sortable: true,

		group: false,

		groupKey: '',

		groupSize: 0,

		renderer: function(v, p, record, rowIndex){
			return record.get('displayQaScore');
		}

	}),

	new Ext.app.common.ColmunField({

		boxLabel: '评分',

		width: 60,

		name: 'displayQaScore',

		value: 'displayQaScore',

		colType: 'Integer',

		checked: true,

		locked: false,

		hidden: true,

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

	new Ext.app.common.ColmunField({

		boxLabel: '结束时间',

		width: 150,

		name: 'endTime',

		value: 'endTime',

		colType: 'DateTime',

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

		boxLabel: '通话时间',

		width: 80,

		name: 'length',

		value: 'length',

		colType: 'TimeLength',

		checked: true,

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

		boxLabel: '通话时间',

		name: 'displayLength',

		value: 'displayLength',

		colType: 'TimeLength',

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

		boxLabel: '质检时间',

		name: 'qaTime',

		value: 'qaTime',

		colType: 'String',

		checked: true,

		hidden: false,

		disabled: false,

		sortable: true,

		group: false,

		groupKey: '',

		groupSize: 0

	}),

	new Ext.app.common.ColmunField({

		boxLabel: '申诉理由',

		name: 'qaAppealReason',

		value: 'qaAppealReason',

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

		boxLabel: '复核员ID',

		name: 'qaCheckUserId',

		value: 'qaCheckUserId',

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

		boxLabel: '复核员',

		name: 'qaCheckUserName',

		value: 'qaCheckUserName',

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

		boxLabel: '复核时间',

		name: 'qaCheckTime',

		value: 'qaCheckTime',

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

		boxLabel: '复核质检项列表',

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

	})

]