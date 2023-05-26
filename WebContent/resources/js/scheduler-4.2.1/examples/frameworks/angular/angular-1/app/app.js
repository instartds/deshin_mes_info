/* eslint-disable no-useless-call */
const app = window.angular.module('scheduler', []);

// custom error handler - throws the exception
app.config(function($provide) {
    $provide.decorator('$exceptionHandler', function() {
        return function(exception) {
            throw exception;
        };
    });
});

app.controller('schedulerForm', ['$scope', '$filter', function($scope, $filter) {
    $scope.barMargin = 5;
    $scope.selectedEvent = undefined;

    $scope.$on('paint', function(event, params) {
        $scope.instance = params.source;
    });

    $scope.$on('eventselectionchange', function(event, params) {
        $scope.selectedEvent = params.selected[0];
        $scope.$apply();
    });

    $scope.barMarginChange = function() {
        $scope.instance.barMargin = $scope.barMargin;
    };

    $scope.onAddEventClick = function() {
        const
            scheduler = $scope.instance,
            startDate = new Date(scheduler.startDate.getTime()),
            endDate   = new Date(startDate.getTime()),
            resource  = scheduler.resourceStore.first;

        if (!resource) {
            bryntum.scheduler.Toast.show('There is no resource available');
            return;
        }

        endDate.setHours(endDate.getHours() + 1);

        scheduler.eventStore.add({
            resourceId : resource.id,
            startDate  : startDate,
            endDate    : endDate,
            name       : 'New event',
            eventType  : 'Meeting'
        });
    };

    $scope.onRemoveEventClick = function() {
        $scope.selectedEvent && $scope.selectedEvent.remove();
        $scope.selectedEvent = undefined;
    };
}]);

app.directive('scheduler', function($http) {
    return {
        restrict : 'E',
        scope    : {
            elementId  : '@id',
            startDate  : '@startdate',
            endDate    : '@enddate',
            viewPreset : '@viewpreset'
        },
        controller : function($scope, $compile, $http) {

            $scope.initScheduler = function() {
                const me = $scope;

                me.instance = new bryntum.scheduler.Scheduler({
                    appendTo          : me.elementId,
                    columns           : [{ type : 'resourceInfo', text : 'Staff', field : 'name' }],
                    startDate         : new Date(me.startDate),
                    endDate           : new Date(me.endDate),
                    viewPreset        : me.viewPreset,
                    barMargin         : 5,
                    resourceImagePath : 'resources/users/',
                    resources         : [
                        { id : 'a', name : 'Arcady', role : 'Core developer' },
                        { id : 'b', name : 'Dave', role : 'Tech Sales' },
                        { id : 'c', name : 'Henrik', role : 'Sales' },
                        { id : 'd', name : 'Linda', role : 'Core developer' },
                        { id : 'e', name : 'Maxim', role : 'Developer & UX' },
                        { id : 'f', name : 'Mike', role : 'CEO' },
                        { id : 'g', name : 'Lee', role : 'CTO' }
                    ],
                    events : [
                        {
                            resourceId : 'a',
                            name       : 'Meeting #1',
                            startDate  : '2018-02-07 11:00',
                            endDate    : '2018-02-07 14:00',
                            location   : 'Some office',
                            eventType  : 'Meeting'
                        },
                        {
                            resourceId : 'b',
                            name       : 'Meeting #2',
                            startDate  : '2018-02-07 12:00',
                            endDate    : '2018-02-07 15:00',
                            location   : 'Home office',
                            eventType  : 'Meeting'
                        },
                        {
                            resourceId : 'c',
                            name       : 'Meeting #3',
                            startDate  : '2018-02-07 13:00',
                            endDate    : '2018-02-07 16:00',
                            location   : 'Customer office',
                            eventType  : 'Meeting'
                        },
                        {
                            resourceId : 'd',
                            name       : 'Meeting #4',
                            startDate  : '2018-02-07 09:00',
                            endDate    : '2018-02-07 11:00',
                            location   : 'Some office',
                            eventType  : 'Meeting'
                        },
                        {
                            resourceId : 'e',
                            name       : 'Appointment #1',
                            startDate  : '2018-02-07 10:00',
                            endDate    : '2018-02-07 12:00',
                            location   : 'Home office',
                            type       : 'Dental',
                            eventType  : 'Appointment'
                        },
                        {
                            resourceId : 'f',
                            name       : 'Appointment #2',
                            startDate  : '2018-02-07 11:00',
                            endDate    : '2018-02-07 13:00',
                            location   : 'Customer office',
                            type       : 'Medical',
                            eventType  : 'Appointment'
                        },
                        {
                            resourceId : 'g',
                            name       : 'Appointment #3',
                            startDate  : '2018-02-07 14:00',
                            endDate    : '2018-02-07 17:00',
                            location   : 'Home office',
                            type       : 'Medical',
                            eventType  : 'Appointment'
                        },
                        {
                            resourceId : 'h',
                            name       : 'Appointment #4',
                            startDate  : '2018-02-07 15:00',
                            endDate    : '2018-02-07 18:00',
                            location   : 'Customer office',
                            type       : 'Dental',
                            eventType  : 'Appointment'
                        }
                    ],

                    // Listeners, will relay events
                    listeners : {
                        catchAll : function(event) {
                            // Uncomment this line to log events being emitted to console
                            //console.log(event.type);
                            me.$emit.call(me, event.type, event);
                        },
                        thisObj : me
                    }
                });
            };
        },
        link : function($scope, $element, $attrs, $controller) {
            $scope.initScheduler();
        }
    };
});
