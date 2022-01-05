# `apify.cfc` Reference

#### `retrieveCfcStats()`

Returns internal stat tracking object with calls, requests, and rate limiting information.

#### `listActors( boolean my=false, numeric offset=0, numeric limit=0, boolean desc=false )`

Retrieves a list of actors. *[Endpoint docs](https://docs.apify.com/api/v2#/reference/actors/actor-collection/get-list-of-actors)*

#### `listActorTasks( numeric offset=0, numeric limit=0, boolean desc=false )`

Retrieves a list of tasks. *[Endpoint docs](https://docs.apify.com/api#/reference/actor-tasks/task-collection/get-list-of-tasks)*

#### `createActorTask( required string actId, required string name, struct options, struct input )`

Creates a new actor task. *[Endpoint docs](https://docs.apify.com/api/v2#/reference/actor-tasks/task-collection/create-task)*

#### `updateActorTask( required string actorTaskId, string actId, string name, struct options, struct input )`

Updates an actor task. *[Endpoint docs](https://docs.apify.com/api#/reference/actor-tasks/task-object/update-task)*

#### `getActorTaskById( required string actorTaskId )`

Retrieves an object that contains all the details about an actor task. *[Endpoint docs](https://docs.apify.com/api/v2#/reference/actor-tasks/task-object/get-task)*

#### `deleteActorTask( required string actorTaskId )`

Deletes an actor task by its id. *[Endpoint docs](https://docs.apify.com/api#/reference/actor-tasks/task-object/delete-task)*

#### `getActorTaskInput( required string actorTaskId )`

Retrieves the input of a given actor task. *[Endpoint docs](https://docs.apify.com/api#/reference/actor-tasks/task-input-object/get-task-input)*

#### `updateActorTaskInput( required string actorTaskId, required struct input )`

Updates the input of an actor task. *[Endpoint docs](https://docs.apify.com/api#/reference/actor-tasks/task-input-object/update-task-input)*

#### `listActorTaskRuns( required string actorTaskId, numeric offset=0, numeric limit=0, boolean desc=false, string status )`

Lists the runs for a specific task. *[Endpoint docs](https://docs.apify.com/api#/reference/actor-tasks/run-collection/get-list-of-task-runs)*

#### `runActorTask( required string actorTaskId, numeric timeout, numeric memory, string build, numeric waitForFinish, string webhooks, struct input={} )`

Runs an actor task and immediately returns without waiting for the run to finish. If input is provided for the payload body, it is used to override the default input for the task. *[Endpoint docs](https://docs.apify.com/api#/reference/actor-tasks/run-collection/run-task)*

#### `runActorTaskSynchronously( required string actorTaskId, numeric timeout, numeric memory, string build, string outputRecordKey, string webhooks, struct input={} )`

Runs an actor task and synchronously. This is supposed to return its output, but doesn't seem to actually do that. The run must finish in 300 seconds otherwise the API endpoint returns a timeout error. If input is provided for the payload body, it is used to override the default input for the task. *[Endpoint docs](https://docs.apify.com/api#/reference/actor-tasks/run-collection/run-task-synchronously-(post))*

#### `listUserRuns( numeric offset=0, numeric limit=0, boolean desc=false, string status )`

Retrieves a list of all runs for a user. *[Endpoint docs](https://docs.apify.com/api#/reference/actor-runs/run-collection/get-user-runs-list)*

#### `getRunById( required string runId )`

Retrieves an object that contains all the details about a run. *[Endpoint docs](https://docs.apify.com/api#/reference/actor-runs/run-object-and-its-storages)*

#### `abortRun( required string runId )`

Aborts a run and returns an object with details about it. *[Endpoint docs](https://docs.apify.com/api#/reference/actor-runs/abort-run/abort-run)*

#### `resurrectRun( required string runId )`

Resurrects a finished run and returns an object with details about it. *[Endpoint docs](https://docs.apify.com/api#/reference/actor-runs/resurrect-run/resurrect-run)*

#### `getRunLog( required string runId )`

Retrieves the log for a run. *[Endpoint docs](https://docs.apify.com/api#/reference/actor-runs/run-object-and-its-storages)*

#### `getRunKeyValueStore( required string runId )`

Retrieves details of the key-value store for a run. *[Endpoint docs](https://docs.apify.com/api#/reference/actor-runs/run-object-and-its-storages)*

#### `getRunKeyValueStoreKeys( required string runId )`

Retrieves the keys for a run's key-value store. *[Endpoint docs](https://docs.apify.com/api#/reference/actor-runs/run-object-and-its-storages)*

#### `getRunKeyValueStoreRecords( required string runId, required string recordKey )`

Retrieves the values for one of a run's key-value store keys. *[Endpoint docs](https://docs.apify.com/api#/reference/actor-runs/run-object-and-its-storages)*

#### `getRunDataset( required string runId )`

Retrieves details of the dataset for a run. *[Endpoint docs](https://docs.apify.com/api#/reference/actor-runs/run-object-and-its-storages)*

#### `getRunDatasetItems( required string runId, struct options={} )`

Retrieves details of the dataset for a run. The parameter `options` an object in which you can configure any of the available options for this endpoint. Read the docs to see the full range of options available. *[Endpoint docs](https://docs.apify.com/api#/reference/actor-runs/run-object-and-its-storages)*

#### `getRunRequestQueue( required string runId )`

Retrieves details of the request queue for a run. *[Endpoint docs](https://docs.apify.com/api#/reference/actor-runs/run-object-and-its-storages)*

#### `listSchedules( numeric offset=0, numeric limit=0, boolean desc=false )`

Retrieves a list of schedules. *[Endpoint docs](https://docs.apify.com/api#/reference/schedules/schedules-collection/get-list-of-schedules)*

#### `createSchedule( string name, boolean isEnabled, boolean isExclusive, string cronExpression, string timezone, string description, required array actions )`

Creates a new schedule with settings provided. The response is the created schedule object. *[Endpoint docs](https://docs.apify.com/api#/reference/schedules/schedules-collection/create-schedule)*

#### `createScheduleActor( required string actId, struct input, struct options, struct scheduleOptions={} )`

Convenience method for creating a schedule for an actor. Delegates the actual request to @createSchedule. The parameter `actId` is the id of the actor to be scheduled. The parameter `input` is an optional input struct used to override the actor input configuration when the schedule is run. The parameter `options` is optional, and provides options for the run. The parameter `scheduleOptions` is a struct that can include the options accepted by the @createSchedule method, such as `name` and `isEnabled`.

#### `createScheduleTask( required string actorTaskId, struct input, struct scheduleOptions={} )`

Convenience method for creating a schedule for an actor task. Delegates the actual request to @createSchedule. The parameter `actorTaskId` is the id of the actor task to be scheduled. The parameter `input` is an optional input struct used to override the task input configuration when the schedule is run. The parameter `scheduleOptions` is a struct that can include the options accepted by the @createSchedule method, such as `name` and `isEnabled`.

#### `updateSchedule( required string scheduleId, string name, boolean isEnabled, boolean isExclusive, string cronExpression, string timezone, string description, array actions )`

Updates a schedule. *[Endpoint docs](https://docs.apify.com/api#/reference/schedules/schedule-object/update-schedule)*

#### `updateScheduleActor( required string scheduleId, required string actId, struct input, struct options, struct scheduleOptions={} )`

Convenience method for updating a schedule and specifying a specific actor action. Delegates the actual request to @updateSchedule. The parameter `actId` is the id of the actor to be scheduled. The parameter `input` is an optional input struct used to override the actor input configuration when the schedule is run. The parameter `options` is optional, and provides options for the run. The parameter `scheduleOptions` is a struct that can include the options accepted by the @createSchedule method, such as `name` and `isEnabled`.

#### `updateScheduleTask( required string scheduleId, required string actorTaskId, struct input, struct scheduleOptions={} )`

Convenience method for updating a schedule and specifying a specific actor task action. Delegates the actual request to @updateSchedule. The parameter `actorTaskId` is the id of the actor task to be scheduled. The parameter `input` is an optional input struct used to override the task input configuration when the schedule is run. The parameter `scheduleOptions` is a struct that can include the options accepted by the @createSchedule method, such as `name` and `isEnabled`.

#### `getScheduleById( required string scheduleId )`

Retrieves an object that contains all the details about a schedule. *[Endpoint docs](https://docs.apify.com/api#/reference/schedules/schedule-object/get-schedule)*

#### `deleteSchedule( required string scheduleId )`

Deletes schedule by its id. *[Endpoint docs](https://docs.apify.com/api#/reference/schedules/schedule-object/delete-schedule)*

#### `getScheduleLog( required string scheduleId )`

Responds with HTTP status 302 to redirect to an URL containing the requested log. The log has a content type text/plain and it is encoded as gzip returned with appropriate HTTP headers. *[Endpoint docs](https://docs.apify.com/api#/reference/schedules/schedule-log/get-schedule-log)*

