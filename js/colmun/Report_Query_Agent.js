



	
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

		boxLabel: '座席',

		width: 50,

		name: 'agentNo',

		value: 'agentNo',

		colType: 'String',

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

		boxLabel: '开始时间',

		width: 100,

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

		width: 100,

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

		boxLabel: '总数',

		width:40,

		name: 'count',

		value: 'count',

		colType: 'int',

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

		boxLabel: '呼入量',
		
		width:40,

		name: 'inCount',

		value: 'inCount',

		colType: 'int',

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

		boxLabel: '呼出量',

		width: 40,

		name: 'outCount',

		value: 'outCount',

		colType: 'int',

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

		boxLabel: '通话长度不足5s',
		
		width:80,

		name: 'callLength_5L',

		value: 'callLength5L',

		colType: 'int',

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

		boxLabel: '通话长度不足15s',

		width: 80,

		name: 'callLength_15L',

		value: 'callLength15L',

		colType: 'int',

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

		boxLabel: '通话长度不足30s',

		width: 80,

		name: 'callLength_30L',

		value: 'callLength30L',

		colType: 'int',

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

		boxLabel: '通话长度不足60s',

		width: 80,

		name: 'callLength_60L',

		value: 'callLength60L',

		colType: 'int',

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

		boxLabel: '通话长度大于60s',

		width: 80,

		name: 'callLength_60M',

		value: 'callLength60M',

		colType: 'int',

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

		boxLabel: '通话长度大于300s',

		width: 80,

		name: 'callLength_300M',

		value: 'callLength300M',

		colType: 'int',

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

		boxLabel: '通话长度大于3600s',

		width: 80,

		name: 'callLength_3600M',

		value: 'callLength3600M',

		colType: 'int',

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

		boxLabel: '通话总时长(秒)',

		width: 80,

		name: 'callLengthTotal',

		value: 'callLengthTotal',

		colType: 'int',

		checked: false,

		hidden: false,

		disabled: false,

		sortable: true,

		group: false,

		groupKey: '',

		groupSize: 0


	})


]