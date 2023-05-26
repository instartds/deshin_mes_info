//@charset UTF-8
/**
 * unilite용 확장된 모델 class
 */
Ext.define('Unilite.com.data.UniTreeModel', {
	extend: 'Ext.data.Model',
    alternateClassName: 'Unilite.data.TreeModel',
    
    
    
    /**
     *  @cfg {} pks Primary Keys 들을 정의 
     */
    pks : [],
    
    /**
     * 새로운 레코드인지 판단 true : 신규 레코드 (DB에서 가져온 것이 아님 !)
     * @return {}
     */
    isNew : function() {
    	var me = this;
    	return me.phantom;
    }/*,
    idgen: {
         type: 'sequential',
         seed: 1000,
         prefix: 'ID_'
     }*/
}); // Ext.define