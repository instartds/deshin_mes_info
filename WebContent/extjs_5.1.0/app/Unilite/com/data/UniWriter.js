//@charset UTF-8
/**
 * 미정
 */
Ext.define('Unilite.com.data.UniWriter', {
	extend: 'Ext.data.writer.Json',
    alias: 'writer.uniWriter',
	writeAllFields: true,	//default false
	writeRecordId: true,	//default true
    write: function(request) {
        var operation = request.getOperation(),
            records = operation.getRecords() || [],
            len = records.length,
            data = [],
            i;

       	//server 로 보낼 data 처리
        for (i = 0; i < len; i++) {
        	if(operation.action == 'syncAll') {	//master form data (이미 dbFormat 으로 적용되어 있음)
        		data.push(records[i]);
        	}else{
            	data.push(this.getRecordData(records[i], operation));	//grid data format or serialize (date형) 
        	}
        }

        return this.writeRecords(request, data);
    }    
});
