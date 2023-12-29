#Using calendars

##Introduction

Ext Gantt is very flexible in defining the availability time for your tasks and resources.
Every task (or resource) may have own *calendar*, specifying the time when they can be performed (or can work) accurate to minutes.
In turn, calendars may form hierarchical structures, every next layer of which may adjust the rules, defined in the previous layers.
In the same time, if you don't need that level of precision and control, few base options will configure the default behavior for everything.

##Project calendar and basic features

Project calendar is a "main" instance of the {@link Gnt.data.Calendar} class, that affects whole project and defines global rules,
for example what week days are weekends. It can be instantiated as any other Ext class and provided either to the {@link Gnt.data.TaskStore taskStore}
or to the {@link Gnt.panel.Gantt gantt panel} (the first option is preferable):

    var taskStore   = new Gnt.data.TaskStore({
        calendar    : new Gnt.data.Calendar({ ... })
    })
    // or
    var ganttPanel  = new Gnt.panel.Gantt({
        calendar    : new Gnt.data.Calendar({ ... }),
    })

And when using [CRUD manager](#!/guide/gantt_crud_manager) with {@link Gnt.data.CalendarManager calendar manager} the project calendar will be set automatically:

    var taskStore   = new Gnt.data.TaskStore({
        calendarManager : new Gnt.data.CalendarManager({ ... })
    })

    var crud = new Gnt.data.CrudManager({
        // task store will get its calendar right after calendarManager loading
        taskStore : taskStore,
        ...
    })

Calendar has various options, most important of them:

- {@link Gnt.data.Calendar#daysPerMonth daysPerMonth}, {@link Gnt.data.Calendar#daysPerWeek daysPerWeek}, {@link Gnt.data.Calendar#hoursPerDay hoursPerDay} This group of
options defines the conversion rules for duration and effort. They are needed, because certain duration units can not be converted to some other units unambiguously.
For example a task with 1 month duration may mean 30, 31 or may be 28 days. A 1 day taks may be 8 hours task or 10 hours, depending how long is your working day. For such conversions
calendar uses these options. **Please note**, that for backward compatibility reasons {@link Gnt.data.Calendar} is configured with `hoursPerDay=24, daysPerWeek=7, daysPerMonth=30` setting.
For usual business time conversion rules (8 hours per day, etc), use {@link Gnt.data.calendar.BusinessTime}
- {@link Gnt.data.Calendar#defaultAvailability defaultAvailability} This option defines the time within the day, when the work can be performed.
- {@link Gnt.data.Calendar#weekendsAreWorkdays weekendsAreWorkdays} Boolean option, indicating whether weekends should be considered as working days and included in the
task durations.

Calendar and its options defines the data calculations. Some other options related to the weekends and holidays:

- {@link Gnt.panel.Gantt#highlightWeekends highlightWeekends} `true` to highlight the weekends and holidays
- {@link Gnt.data.TaskStore#skipWeekendsDuringDragDrop skipWeekendsDuringDragDrop} `true` to skip the weekends and holidays during drag and drop operations (move/resize).

##Calendar manager

There is a {@link Gnt.data.CalendarManager} class that implements a centralized storage of all the calendars related to the project.
Each record put into {@link Gnt.data.CalendarManager} instance, except the root node, is automatically gets linked to its {@link Gnt.data.Calendar calendar instance}
which can be retrieved by {@link #getCalendar} method.

    var calendarManager = Ext.create('Gnt.data.CalendarManager');

    ...

    // and here we do the same using {@link Gnt.model.Calendar} {@link Gnt.model.Calendar#getCalendar getCalendar} method.
    var calendar = calendarManager.getById('general').getCalendar();

    // gets calendar instance having calendar Id equal to 'general'
    calendar = calendarManager.getCalendar('general');

When you add a new record a new calendar is automatically gets created:

    // append new record to the calendar manager
    var record = calendarManager.getRootNode().appendChild({
        leaf                : true,
        Name                : 'General II',
        DaysPerMonth        : 30,
        DaysPerWeek         : 7,
        HoursPerDay         : 24,
        WeekendsAreWorkdays : true,
        WeekendFirstDay     : 6,
        WeekendSecondDay    : 0,
        DefaultAvailability : [ '00:00-24:00' ]
    });

    // get newly created calendar to calendar2 variable
    var calendar2 = record.getCalendar();

Calendar manager is also able to work together with [CRUD manager](#!/guide/gantt_crud_manager) which means that all calendars can be loaded by a single request.
Please read [Calendar CRUD](#!/guide/gantt_calendars-section-4) chapter for details.

##Advanced features

### Individual days

Previous section was describing the basic features of calendars and was mostly talking about weekends. Now lets see how we can create an arbitrary day off in the calendar.

Internally, calendar is presented with the subclass of the Ext.data.Store and can be loaded with the collection of {@link Gnt.model.CalendarDay} instances. Every day instance
can be of different type (see `Type` field of the {@link Gnt.model.CalendarDay}):

- "Day override". Represents a certain date in the calendar, for example 2013/01/10. This type of days has the highest priority.
- "Week day override" sometimes called "week override" or "non-standard week". Represents a week day within certain time span,
for example - all Mondays in between 2013/01/10 and 2013/02/10, inclusive. This type has the next level of priority.
- "Week day". Represents a certain week day in the calendar, for example - all Mondays. It has the lowest priority among all the "special" days, but still
overrides the value of {@link Gnt.data.Calendar#defaultAvailability defaultAvailability} config option for that day.

Every calendar day instance also has the `Availability` field. It defines the working time for that day instance, for example : `[ '08:00-12:00', '13:00-17:00' ]`

So, to create a holiday in the calendar or adjust the working time for some day - add an appropriate calendar day instance to it:

    var calendar    = new Gnt.data.Calendar({
        defaultAvailability : [ '08:00-12:00', '13:00-17:00' ]
    })

    calendar.add([
        // a concrete date
        {
            Date            : new Date(2013, 0, 1),
            Name            : 'New year',
            Cls             : 'app-calendar-newyear'
        },
        {
            Date            : new Date(2013, 0, 5),
            Name            : 'Working Saturday',
            Cls             : 'app-calendar-workingsaturday',
            IsWorkingDay    : true,
            Availability    : [ '08:00-12:00', '13:00-16:00' ]
        },
        // a week day, increasing the working time on Monday on 1 hour
        {
            Weekday         : 1,
            Name            : 'All Mondays',
            Cls             : 'app-calendar-monday',
            Availability    : [ '07:00-12:00', '13:00-17:00' ]
        }
    ])

Note that you can specify that some weekend day is actually working day, using `IsWorkingDay` field. In such cases `Availability` field is still required, or gantt won't schedule any tasks on that day.

"Week day overrides" consists from several days and also requires the presence of the "main day", for their creation its recommended to use according API in the calendar:
{@link Gnt.data.Calendar#addNonStandardWeek addNonStandardWeek}, {@link Gnt.data.Calendar#removeNonStandardWeek removeNonStandardWeek}.

You can visually edit the content of the calendar using {@link Gnt.widget.calendar.Calendar} widget.

### Assigning individual calendars to task and resources

Task and resources may have their own calendars. If calendar is assigned to the task, in defines the time, when task can be performed.
If calendar is assigned to the resource, in defines the time, when resource can perform the tasks.

**Important**. If some task has no own calendar and has assigned resources, then it will use the calendars of the resources to determine the time when it can be performed.
Such task can be performed at the moment X, when at least one assigned resource has working time at that moment.
If some task has own calendar and has assigned resources, then it will use the *intersection* of the working time from own calendar and the calendars of its resources to determine the time when it can be performed.
Such task can be performed at the moment X, when at least one assigned resource has working time at that moment and that moment is "working" in own calendar of the task.

To be assignable, calendar need to have an unique {@link Gnt.data.Calendar#calendarId calendarId} property:

    var calendar1   = new Gnt.data.Calendar({
        calendarId      : 'calendar1'
    })

The value of this property can be provided as the `CalendarId` field of the {@link Gnt.model.Task} or {@link Gnt.model.Resource}.

### Parent-child relations between calendars

Calendars may form a tree-like structures, using parent-child relation. The parent of the calendar can be specified with the {@link Gnt.data.Calendar#parent parent} property, or later
changed with the {@link Gnt.data.Calendar#setParent setParent} method:

    var calendar2   = new Gnt.data.Calendar({
        parent          : 'calendar1',
        calendarId      : 'calendar2'
    })

    var calendar3   = new Gnt.data.Calendar({
        calendarId      : 'calendar2'
    })

    calendar2.setParent(calendar3);

Child calendar will "inherit" from parent "day overrides", "week days", "week day overrides" and even `defaultAvailability/weekendsAreWorkdays` configs.
Own calendar day instances, falling on the same dates with the calendar days from parent calendar will of course override them.

Please note, that `defaultAvailability/weekendsAreWorkdays` configs are inherited in case they were not provided when instatiating the calendar
and default values were used. If you need to override any of these configs - provide the value to the calendar, even if its the same as default value:

    var childCalendar   = new Gnt.data.Calendar({
        parent                  : 'calendar1',
        // explicitly providing the value (even that `false` is default)
        // to override this config from parent
        weekendsAreWorkdays     : false
    })


You can use this feature for example like this. Main project calendar will contain "global" holidays (national holidays) and all other calendars of tasks and resources can be its children.
Then calendars of tasks and resources can only contain few days, specific for that task/resource and there's no need to re-define all the holidays.


##Calendar CRUD

When using the calendars with some individual days off ("day overrides") always store the `Duration` field in the database. Moreover, it is recommended that you store
*only* `StartDate` and `Duration`, and *not* store the `EndDate` in the DB.

There are two approaches to interact with a server when it comes to calendars:

- classic _per-store_ approach
- CRUD manager usage

### Classic _per-store_ approach

This method relies on a classic _Sencha_ provided proxy classes when user has to define a proxy for each individual store to give it ability to interact with a server.
So in our case user will have to do it for each calendar instance he plans to deal with.

For performance and consistency reasons, it is recommended to load all your calendars **before** the other stores and task store **after** them.
Otherwise what will happen is that after calendar will be loaded, (keep in mind that network latency is unpredictable and that may happen with arbitrary delay)
gantt will need to adjust all tasks according to it. When updating the task, gantt needs the information about its assignments and dependencies,
so other stores should be already loaded. The correct order to load the data:

1. Calendars (including setting the "calendarId" property).
2. Resource store, assignment store, dependencies store in any order
3. Task store.

There's no need to delay the loading of the task store. You can start several requests simultaneously, but put the data in the stores in the correct order. The other option
is to make the initial loading package to contain all data.

The easiest way to edit the data in the calendar is to use the special widget: {@link Gnt.widget.calendar.Calendar}

### CRUD manager usage

Another option is to use a [CRUD manager](#!/guide/gantt_crud_manager) with a {@link Gnt.data.CalendarManager calendar manager}.
This binding will allow to load ** all the project calendars ** by a single batch request together with other project related stores (and changes persisting will be done by one request as well).
In this case you don't need to worry about such things as loading order or individual calendars creation.
A [CRUD manager](#!/guide/gantt_crud_manager) is aware of correct loading order and
a {@link Gnt.data.CalendarManager calendar manager} will create all the project calendars properly.

    // centralized store of all the project calendars
    var calendarManager = Ext.create('Gnt.data.CalendarManager');

    var taskStore = Ext.create('Gnt.data.TaskStore', {
        calendarManager : calendarManager,
        resourceStore   : resourceStore,
        dependencyStore : dependencyStore,
        assignmentStore : assignmentStore
    });

    // centralized store of all the project stores
    // will automatically load calendarManager, resourceStore, dependencyStore,
    // assignmentStore and taskStore stores by a single batch request
    var crudManager = Ext.create('Gnt.data.CrudManager', {
        taskStore       : taskStore,
        ...
    });

##Cheatsheet

Now lets review various scenarios and how you can configure your project for them:

1) **Requirements:** You are only interested in days for your tasks. Start time (12:00, 18:30 etc), end time doesn't matter in your case, only the date (2013/01/01, 2013/02/07).
You would like to *exclude* the weekends from tasks duration and only count working time.

**Solution:** Use plain {@link Gnt.data.Calendar} instance, with possibly adjusted duration conversion parameters.

2) **Requirements:** You are only interested in days for your tasks. Start time (12:00, 18:30 etc), end time doesn't matter in your case, only the date (2013/01/01, 2013/02/07).
You would like to *include* the weekends to the tasks duration and count any time.

**Solution:** Use plain {@link Gnt.data.Calendar} instance, with possibly adjusted duration conversion parameters. Set {@link Gnt.data.Calendar#weekendsAreWorkdays weekendsAreWorkdays} to `true`

3) **Requirements:** You are only interested in days for your tasks. Start time (12:00, 18:30 etc), end time doesn't matter in your case, only the date (2013/01/01, 2013/02/07).
You would like to *exclude* the weekends from tasks duration and only count working time. You would like to define some holidays, that will be global and that should be excluded
from the working time as well.

**Solution:** Use plain {@link Gnt.data.Calendar} instance, with possibly adjusted duration conversion parameters. Add the "day overrides" to it - one for each holiday.

4) **Requirements:** Start time and end time matters in your case, you would like to be precise (like, Task1 starts at 2013/01/01 15:00).
You would like to *exclude* the weekends and non-working time from tasks duration and only count working time. You need to define the working time for every day.
Certain week days or days in the calendar may have different working time. Certain tasks or resources may have own rules for working time.

**Solution:** Use {@link Gnt.data.calendar.BusinessTime} instance, with possibly adjusted duration conversion parameters. Add the "day overrides" to it - one for each holiday.
Add additional calendar instances (with "calendarId" property defined) for every task and resource that needs own calendar (consider using parent-child relation between them and project calendar). Make use of
{@link Gnt.widget.calendar.Calendar} for editing calendar content.
