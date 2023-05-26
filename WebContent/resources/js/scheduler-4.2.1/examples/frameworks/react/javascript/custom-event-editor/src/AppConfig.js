/**
 * Application configuration
 */
const schedulerConfig = {
    resourceImagePath : 'users/',

    viewPreset  : 'hourAndDay',
    barMargin   : 5,
    startDate   : new Date(2017, 1, 7, 8),
    endDate     : new Date(2017, 1, 7, 18),
    crudManager : {
        autoLoad  : true,
        transport : {
            load: {
                url : 'data/data.json'
            }
        }
    },

    // Columns in scheduler
    columns: [
        {
            type  : 'resourceInfo',
            text  : 'Staff',
            width : 130
        },
        {
            text  : 'Type',
            field : 'role',
            width : 130
        }
    ]
};

export { schedulerConfig };
