



	
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

	}),
	
	new Ext.app.common.ColmunField({

		boxLabel: '质检状态',

		name: 'qaStatus',

		value: 'qaStatus',

		colType: 'String',

		checked: true,

		hidden: true,

		disabled: true,

		sortable: true,

		group: false,

		groupKey: '',

		groupSize: 0

	}),
	
	new Ext.app.common.ColmunField({

		boxLabel: '录音记录ID',

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

		width: 70,

		name: 'qaCaseAttribute',

		value: 'qaCaseAttribute',

		colType: 'String',

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

		boxLabel: '座席编号',

		width: 60,

		name: 'agentNo',

		value: 'agentNo',

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

		boxLabel: '座席名称',

		width: 80,

		name: 'agentName',

		value: 'agentName',

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

		hidden: true,

		disabled: false,

		sortable: true,

		group: false,

		groupKey: '',

		groupSize: 0

	})

	,

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

		boxLabel: '分机号',

		width: 60,

		name: 'extNo',

		value: 'extNo',

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

		boxLabel: '类型',

		name: 'callType',

		value: 'callType',

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

		boxLabel: '类型',

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

		groupSize: 0,

		renderer: function(v, p, record, rowIndex){
			if(record.get('callType') == 'in') {
				return '<font color=#66CC00>' + v + '</font>';
			} else if(record.get('callType') == 'out') {
				return '<font color=#CC3333>' + v + '</font>';
			} else {
				return v;
			}
		}
	})

	,

	new Ext.app.common.ColmunField({

		boxLabel: '起始时间',

		width: 150,

		name: 'beginTime',

		value: 'beginTime',

		colType: 'DateTime',

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

		boxLabel: '结束时间',

		width: 150,

		name: 'endTime',

		value: 'endTime',

		colType: 'DateTime',

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

		width: 80,

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

		boxLabel: '通话时间',

		name: 'length',

		value: 'length',

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

		name: 'ani',

		value: 'ani',

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

		boxLabel: '主叫号码',

		width: 120,

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

		hidden: true,

		disabled: false,

		sortable: true,

		group: false,

		groupKey: '',

		groupSize: 0

	}),

	new Ext.app.common.ColmunField({

		boxLabel: '被叫号码',

		width: 120,

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

		boxLabel: '类型ID',
		
		name: 'qaCaseType',

		value: 'qaCaseType',

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

		boxLabel: '类型',
		
		width: 260,

		name: 'qaCaseTypeName',

		value: 'qaCaseTypeName',

		colType: 'String',

		checked: true,

		hidden: false,

		disabled: false,

		sortable: false,

		group: false,

		groupKey: '',

		groupSize: 0

	}),

	new Ext.app.common.ColmunField({

		boxLabel: '质检时间',

		width: 60,

		name: 'qaTime',

		value: 'qaTime',

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

		boxLabel: '评分',

		width: 60,

		name: 'qaScore',

		value: 'qaScore',

		colType: 'Integer',

		checked: true,

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

		boxLabel: '提交者ID',

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

		boxLabel: '提交人',
		
		width: 60,

		name: 'qaCaseUserName',

		value: 'qaCaseUserName',

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

		boxLabel: '提交时间',
		
		width: 120,

		name: 'qaCaseSubmitTime',

		value: 'qaCaseSubmitTime',

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

		boxLabel: '提交理由',
		
		width: 180,

		name: 'qaCaseReason',

		value: 'qaCaseReason',

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

		boxLabel: '审核者',
		
		width: 60,

		name: 'qaCaseCheckUserName',

		value: 'qaCaseCheckUserName',

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

		boxLabel: '审核时间',
		
		width: 120,

		name: 'qaCaseCheckTime',

		value: 'qaCaseCheckTime',

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

		boxLabel: '审核理由',
		
		width: 180,

		name: 'qaCaseCheckReason',

		value: 'qaCaseCheckReason',

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

		boxLabel: '案例状态',

		width: 60,

		name: 'qaCaseStatus',

		value: 'qaCaseStatus',

		colType: 'String',

		checked: true,

		hidden: false,

		disabled: false,

		sortable: true,

		group: false,

		groupKey: '',

		groupSize: 0,

		renderer: function(v, p, record, rowIndex){
			if(v == 'SUBMIT') {
				return '<font color=#66CC00>已提交</font>';
			} else if(v == 'UPDATED') {
				return '<font color=#CC3333>已更改</font>';
			} else if(v == 'CHECKED') {
				return '<font color=#FF6600>已审核</font>';
			} else if(v == 'REJECTED') {
				return '<font color=#FF0000>已拒绝</font>';
			} else if(v == 'IDLE') {
				return '<font color=#C0C0C0>未提交</font>';
			} else {
				return v;
			}
		}
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

		boxLabel: '座席',
		
		width: 80,

		name: 'agentName',

		value: 'agentName',

		colType: 'String',

		checked: true,

		hidden: false,

		disabled: false,

		sortable: true,

		group: false,

		groupKey: '',

		groupSize: 0,

		renderer: function(v, p, record, rowIndex){
			if(record.get('qaStatus') == 'CHECKED' || record.get('qaStatus') == 'APPEALED') {
				return v;
			} else {
				return v;
			}
		}

	})

]