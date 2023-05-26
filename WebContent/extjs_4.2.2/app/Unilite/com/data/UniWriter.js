//@charset UTF-8
/**
 * 미정
 */
Ext.define('Unilite.com.data.UniWriter', {
	extend: 'Ext.data.writer.Json',
    alias: 'writer.uniWriter',

    write: function(request) {
        var operation = request.operation,
            records   = operation.records || [],
            len       = records.length,
            i         = 0,
            data      = [];

        for (; i < len; i++) {
        	if(operation.action == 'syncAll') {
        		data.push(records[i]);
        	}else{
            	data.push(this.getRecordData(records[i], operation));
        	}
        }
        return this.writeRecords(request, data);
    },
    
    writeValue: function(data, field, record){
        var name = field[this.nameProperty],
            dateFormat = this.dateFormat || field.dateWriteFormat || field.dateFormat,
            value = record.get(field.name);

        // Allow the nameProperty to yield a numeric value which may be zero.
        // For example, using a field's numeric mapping to write an array for output.
        if (name == null) {
            name = field.name;
        }

        if (field.serialize) {
            data[name] = field.serialize(value, record);
        } else if (field.type === Ext.data.Types.DATE && dateFormat && Ext.isDate(value)) {
            data[name] = Ext.Date.format(value, dateFormat);
        } else if (field.type === Ext.data.Types.UNIDATE && dateFormat && Ext.isDate(value)) {	//UniDate 추가
            data[name] = Ext.Date.format(value, dateFormat);
        } else if (field.type === Ext.data.Types.UNIMONTH && dateFormat && Ext.isDate(value)) {	//UniMonth 추가
            data[name] = Ext.Date.format(value, dateFormat);
        } else {
            data[name] = value;
        }
    }
});
