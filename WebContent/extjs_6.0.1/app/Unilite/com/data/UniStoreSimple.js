//@charset UTF-8
/**
 * Unilite용 Simple Store (JSpopup용)
 * 
 */
Ext.define('Unilite.com.data.UniStoreSimple', {
    extend: 'Unilite.com.data.UniAbstractStore',
    alias: 'store.uniStoreSimple',
    
    requires: [
    	'Ext.data.proxy.Direct', 
    	'Unilite.com.UniAppManager'
    ],
 
    uniOpt: {
        isMaster:   false,       // 버튼과 상태 바에 메시지 전송 여부 
        editable:   false,      // 수정 가능 여부
        deletable:  false,      // 삭제 가능 여부 
        useNaviBtn: false,      // prev/next 버튼 사용 여부
        state: {'btnDelete': false}             // 상태-tab이동시 사용 
    },	
    constructor: function(config){
        var me = this;
        config = Ext.apply({}, config);
        me.callParent(arguments);

    } // constructor
    
}); // Ext.define