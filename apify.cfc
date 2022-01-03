/**
* apifycfc
* Copyright 2021  Matthew J. Clemente, John Berquist
* Licensed under MIT (https://mit-license.org)
*/
component displayname="apifycfc"  {

    variables._apifycfc_version = '0.0.0';

    public any function init(
        string apify_token = '',
        string baseUrl = "https://api.apify.com/v2",
        boolean includeRaw = false,
        numeric httpTimeout = 360,
        numeric maxRetries = 8,
        boolean doNotRetryTimeouts = false,
        boolean debug = false
    ) {

        structAppend( variables, arguments );

        if( debug ){
		      variables.stdout = createObject( "java", "java.lang.System" ).out;
          _debug( "Apifycfc init", arguments );
        }

        //map sensitive args to env variables or java system props
        var secrets = {
            'apify_token': 'APIFY_TOKEN'
        };
        var system = createObject( 'java', 'java.lang.System' );

        for ( var key in secrets ) {
            //arguments are top priority
            if ( variables[ key ].len() ) {
                continue;
            }

            //check environment variables
            var envValue = system.getenv( secrets[ key ] );
            if ( !isNull( envValue ) && envValue.len() ) {
                variables[ key ] = envValue;
                continue;
            }

            //check java system properties
            var propValue = system.getProperty( secrets[ key ] );
            if ( !isNull( propValue ) && propValue.len() ) {
                variables[ key ] = propValue;
            }
        }

        //declare file fields to be handled via multipart/form-data **Important** this is not applicable if payload is application/json
        variables.fileFields = [];

        variables.stats = {
          "calls": 0,
          "requests": 0,
          "rateLimitErrors": []
        }
        // initial value in each slot is 0
        while( variables.stats.rateLimitErrors.len() < maxRetries ){
          variables.stats.rateLimitErrors.append(0);
      }
        variables.RATE_LIMIT_EXCEEDED_STATUS_CODE = 429;

        return this;
    }

    /**
    * @hint Returns internal stat tracking object with calls, requests, and rate limiting information
    */
    public struct function retrieveCfcStats() {
      _debug( "#getFunctionCalledName()#" );
      return variables.stats;
    }

    /**
    * @docs https://docs.apify.com/api/v2#/reference/actors/actor-collection/get-list-of-actors
    * @hint Retrieves a list of actors
    */
    public struct function listActors( boolean my = false, numeric offset = 0, numeric limit = 0, boolean desc = false ) {
      var params = parseSortArgs( arguments );
      return apiCall( 'GET', '/acts', params );
    }

    /**
    * @docs https://docs.apify.com/api#/reference/actor-tasks/task-collection/get-list-of-tasks
    * @hint Retrieves a list of tasks
    */
    public struct function listActorTasks( numeric offset = 0, numeric limit = 0, boolean desc = false ) {
      var params = parseSortArgs( arguments );
      return apiCall( 'GET', '/actor-tasks', params );
    }

    /**
    * @docs https://docs.apify.com/api/v2#/reference/actor-tasks/task-collection/create-task
    * @hint Creates a new actor task
    */
    public struct function createActorTask( required string actId, required string name, struct options, struct input ) {
      var payload = {
        "actId": actId,
        "name": name
      };
      if( !isNull( options ) ){
        payload["options"] = options;
      }
      if( !isNull( input ) ){
        payload["input"] = input;
      }
      return apiCall( 'POST', '/actor-tasks', {}, payload );
    }

    /**
    * @docs https://docs.apify.com/api#/reference/actor-tasks/task-object/update-task
    * @hint Updates an actor task
    */
    public struct function updateActorTask( required string actorTaskId, string actId, string name, struct options, struct input ) {
      var payload = {};
      if( !isNull( actId ) ){
        payload["actId"] = actId;
      }
      if( !isNull( name ) ){
        payload["name"] = name;
      }
      if( !isNull( options ) ){
        payload["options"] = options;
      }
      if( !isNull( input ) ){
        payload["input"] = input;
      }
      return apiCall( 'PUT', '/actor-tasks/#actorTaskId#', {}, payload );
    }

    /**
    * @docs https://docs.apify.com/api/v2#/reference/actor-tasks/task-object/get-task
    * @hint Retrieves an object that contains all the details about an actor task.
    */
    public struct function getActorTaskById( required string actorTaskId ) {
      return apiCall( 'GET', '/actor-tasks/#actorTaskId#' );
    }

    /**
    * @docs https://docs.apify.com/api#/reference/actor-tasks/task-object/delete-task
    * @hint Deletes an actor task by its id
    */
    public struct function deleteActorTask( required string actorTaskId ) {
      return apiCall( 'DELETE', '/actor-tasks/#actorTaskId#' );
    }

    /**
    * @docs https://docs.apify.com/api#/reference/actor-tasks/task-input-object/get-task-input
    * @hint Retrieves the input of a given actor task
    */
    public struct function getActorTaskInput( required string actorTaskId ) {
      return apiCall( 'GET', '/actor-tasks/#actorTaskId#/input' );
    }

    /**
    * @docs https://docs.apify.com/api#/reference/actor-tasks/task-input-object/update-task-input
    * @hint Updates the input of an actor task
    */
    public struct function updateActorTaskInput( required string actorTaskId, required struct input ) {
      return apiCall( 'PUT', '/actor-tasks/#actorTaskId#/input', {}, input );
    }

    /**
    * @docs https://docs.apify.com/api#/reference/actor-tasks/run-collection/get-list-of-task-runs
    * @hint Lists the runs for a specific task
    */
    public struct function listActorTaskRuns( required string actorTaskId, numeric offset = 0, numeric limit = 0, boolean desc = false, string status ) {
      var params = parseSortArgs( arguments );
      return apiCall( 'GET', '/actor-tasks/#actorTaskId#/runs', params );
    }

    /**
    * @docs https://docs.apify.com/api#/reference/actor-tasks/run-collection/run-task
    * @hint Runs an actor task and immediately returns without waiting for the run to finish. If input is provided for the payload body, it is used to override the default input for the task.
    */
    public struct function runActorTask(
      required string actorTaskId,
      numeric timeout,
      numeric memory,
      string build,
      numeric waitForFinish,
      string webhooks,
      struct input = {}
    ) {
      var params = {};
      if( !isNull( timeout ) ){
        params["timeout"] = timeout;
      }
      if( !isNull( memory ) ){
        params["memory"] = memory;
      }
      if( !isNull( build ) ){
        params["build"] = build;
      }
      if( !isNull( waitForFinish ) ){
        params["waitForFinish"] = waitForFinish;
      }
      if( !isNull( webhooks ) ){
        params["webhooks"] = webhooks;
      }
      return apiCall( 'POST', '/actor-tasks/#actorTaskId#/runs', params, input );
    }

    /**
    * @docs https://docs.apify.com/api#/reference/actor-tasks/run-collection/run-task-synchronously-(post)
    * @hint Runs an actor task and synchronously. This is supposed to return its output, but doesn't seem to actually do that. The run must finish in 300 seconds otherwise the API endpoint returns a timeout error. If input is provided for the payload body, it is used to override the default input for the task.
    */
    public struct function runActorTaskSynchronously(
      required string actorTaskId,
      numeric timeout,
      numeric memory,
      string build,
      string outputRecordKey,
      string webhooks,
      struct input = {}
    ) {
      var params = {};
      if( !isNull( timeout ) ){
        params["timeout"] = timeout;
      }
      if( !isNull( memory ) ){
        params["memory"] = memory;
      }
      if( !isNull( build ) ){
        params["build"] = build;
      }
      if( !isNull( outputRecordKey ) ){
        params["outputRecordKey"] = outputRecordKey;
      }
      if( !isNull( webhooks ) ){
        params["webhooks"] = webhooks;
      }
      return apiCall( 'POST', '/actor-tasks/#actorTaskId#/run-sync', params, input );
    }

    /**
    * @docs https://docs.apify.com/api#/reference/actor-runs/run-collection/get-user-runs-list
    * @hint Retrieves a list of all runs for a user.
    */
    public struct function listUserRuns( numeric offset = 0, numeric limit = 0, boolean desc = false, string status ) {
      var params = parseSortArgs( arguments );
      return apiCall( 'GET', '/actor-runs', params );
    }

    /**
    * @docs https://docs.apify.com/api#/reference/actor-runs/run-object-and-its-storages
    * @hint Retrieves an object that contains all the details about a run.
    */
    public struct function getRunById( required string runId ) {
      return apiCall( 'GET', '/actor-runs/#runId#' );
    }

    /**
    * @docs https://docs.apify.com/api#/reference/actor-runs/abort-run/abort-run
    * @hint Aborts a run and returns an object with details about it.
    */
    public struct function abortRun( required string runId ) {
      return apiCall( 'POST', '/actor-runs/#runId#/abort' );
    }

    /**
    * @docs https://docs.apify.com/api#/reference/actor-runs/resurrect-run/resurrect-run
    * @hint Resurrects a finished run and returns an object with details about it.
    */
    public struct function resurrectRun( required string runId ) {
      return apiCall( 'POST', '/actor-runs/#runId#/resurrect' );
    }

    /**
    * @docs https://docs.apify.com/api#/reference/actor-runs/run-object-and-its-storages
    * @hint Retrieves the log for a run
    */
    public struct function getRunLog( required string runId ) {
      return apiCall( 'GET', '/actor-runs/#runId#/log' );
    }

    /**
    * @docs https://docs.apify.com/api#/reference/actor-runs/run-object-and-its-storages
    * @hint Retrieves details of the key-value store for a run
    */
    public struct function getRunKeyValueStore( required string runId ) {
      return apiCall( 'GET', '/actor-runs/#runId#/key-value-store' );
    }

    /**
    * @docs https://docs.apify.com/api#/reference/actor-runs/run-object-and-its-storages
    * @hint Retrieves the keys for a run's key-value store
    */
    public struct function getRunKeyValueStoreKeys( required string runId ) {
      return apiCall( 'GET', '/actor-runs/#runId#/key-value-store/keys' );
    }

    /**
    * @docs https://docs.apify.com/api#/reference/actor-runs/run-object-and-its-storages
    * @hint Retrieves the values for one of a run's key-value store keys
    */
    public struct function getRunKeyValueStoreRecords( required string runId, required string recordKey ) {
      return apiCall( 'GET', '/actor-runs/#runId#/key-value-store/records/#recordKey#' );
    }

    /**
    * @docs https://docs.apify.com/api#/reference/actor-runs/run-object-and-its-storages
    * @hint Retrieves details of the dataset for a run
    */
    public struct function getRunDataset( required string runId ) {
      return apiCall( 'GET', '/actor-runs/#runId#/dataset' );
    }

    /**
    * @docs https://docs.apify.com/api#/reference/actor-runs/run-object-and-its-storages
    * @hint Retrieves details of the dataset for a run
    * @options an object in which you can configure any of the available options for this endpoint. Read the docs to see the full range of options available.
    */
    public struct function getRunDatasetItems( required string runId, struct options = {} ) {
      return apiCall( 'GET', '/actor-runs/#runId#/dataset/items', options );
    }

    /**
    * @docs https://docs.apify.com/api#/reference/actor-runs/run-object-and-its-storages
    * @hint Retrieves details of the request queue for a run
    */
    public struct function getRunRequestQueue( required string runId ) {
      return apiCall( 'GET', '/actor-runs/#runId#/request-queue' );
    }

    /**
    * @docs https://docs.apify.com/api#/reference/schedules/schedules-collection/get-list-of-schedules
    * @hint Retrieves a list of schedules
    */
    public struct function listSchedules( numeric offset = 0, numeric limit = 0, boolean desc = false ) {
      var params = parseSortArgs( arguments );
      return apiCall( 'GET', '/schedules', params );
    }

    // PRIVATE FUNCTIONS
    private struct function parseSortArgs( required struct args ){
      var params = {};
      if( args.keyExists( 'my' ) && args.my ){
        params['my'] = args.my;
      }
      if( args.keyExists( 'offset' ) && args.offset ){
        params['offset'] = args.offset;
      }
      if( args.keyExists( 'limit' ) && args.limit ){
        params['limit'] = args.limit;
      }
      if( args.keyExists( 'desc' ) && args.desc ){
        params['desc'] = args.desc;
      }
      if( args.keyExists( 'status' ) && len(args.status) ){
        params['status'] = args.status;
      }
      return params;
    }

    private struct function apiCall(
        required string httpMethod,
        required string path,
        struct queryParams = { },
        any payload = '',
        struct headers = { }
    ) {
        variables.stats.calls++;
        var fullApiPath = variables.baseUrl & path;
        var requestHeaders = getBaseHttpHeaders();
        requestHeaders.append( headers, true );

        var requestStart = getTickCount();

        var apiResponse = attemptHttpRequest( httpMethod = httpMethod, path = fullApiPath, queryParams = queryParams, headers = requestHeaders, payload = payload );

        // we'll append the rest to this later
        var result = {
            'responseTime' = getTickCount() - requestStart
        };

        var parsedFileContent = {};

        // Handle response based on mimetype
        var mimeType = apiResponse.mimetype ?: requestHeaders[ 'Content-Type' ];

        if ( mimeType == 'application/json' && isJson( apiResponse.fileContent ) ) {
            parsedFileContent = deserializeJSON( apiResponse.fileContent );
        } else if ( mimeType.listLast( '/' ) == 'xml' && isXml( apiResponse.fileContent ) ) {
            parsedFileContent = xmlToStruct( apiResponse.fileContent );
        } else {
            parsedFileContent = apiResponse.fileContent;
        }

        //can be customized by API integration for how errors are returned
        //if ( result.statusCode >= 400 ) {}

        //stored in data, because some responses are arrays and others are structs
        result[ 'data' ] = parsedFileContent;
        result[ 'statusCode' ] = apiResponse.statusCode;
        result[ 'statusText' ] = apiResponse.statusText;
        result[ 'headers' ] = apiResponse.headers;

        if ( variables.includeRaw ) {
            result[ 'raw' ] = {
                'method' : ucase( httpMethod ),
                'path' : fullApiPath,
                'params' : parseQueryParams( queryParams ),
                'payload' : parseBody( payload ),
                'response' : apiResponse.fileContent
            };
        }

        return result;
    }

    private any function attemptHttpRequest(
      required string httpMethod,
      required string path,
      struct queryParams = { },
      struct headers = { },
      any payload = ''
    ) {
      _debug( "#getFunctionCalledName()#", arguments );
      var attempts = 0;
      var response = {};
      while (attempts < variables.maxRetries) {
        attempts++;

        // no try/catch here, for now... I don't think it's needed, since we should be able to handle everything with the response from the cfhttp request (which will include error information, if needed)
        response = makeHttpRequest( httpMethod = httpMethod, path = path, queryParams = queryParams, headers = headers, payload = payload );

        if( _isStatusOk(response.statusCode) ){
          _debug( "ApifyApi request succeeded in #attempts# attempts" );
          return response;
        }

        if( _isRateLimitError(response.statusCode) ) {
          _debug( "ApifyApi request encountered a rate limit status code." );
          _addRateLimitError(attempts);
        }

        if( !_isRetryableError( response ) ){
          return response;
        }

        // exponential back off! But not after the last failure
        if( attempts != variables.maxRetries ){
          var backoff = attempts^2*1000;
          _debug( "ApifyApi request failed. Attempt #attempts# of #variables.maxRetries#. Will be retried after #backoff#ms" );
          sleep( backoff );
        }
      }
      // if we end up here, we've failed
      _debug( "ApifyApi request retry limit reached: #variables.maxRetries# attempts failed." );
      throw( type="ApifyApiError", message="Retry limit reached: #variables.maxRetries# attempts failed." );
    }

    private struct function getBaseHttpHeaders() {
        return {
            'Accept' : 'application/json',
            'Content-Type' : 'application/json',
            'Authorization' : 'Bearer #variables.apify_token#',
            'User-Agent' : 'apifycfc/#variables._apifycfc_version# (ColdFusion)'
        };
    }

    private any function makeHttpRequest(
        required string httpMethod,
        required string path,
        struct queryParams = { },
        struct headers = { },
        any payload = ''
    ) {
        variables.stats.requests++;
        var result = '';

        var fullPath = path & ( !queryParams.isEmpty()
            ? ( '?' & parseQueryParams( queryParams, false ) )
            : '' );

        cfhttp(
          url = fullPath,
          method = httpMethod,
          result = 'result',
          timeout = variables.httpTimeout,
          getasbinary = queryParams?.attachment ?: 'auto'
        ) {

            if ( isJsonPayload( headers ) ) {

                var requestPayload = parseBody( payload );
                if ( isJSON( requestPayload ) ) {
                    cfhttpparam( type = "body", value = requestPayload );
                }

            } else if ( isFormPayload( headers ) ) {

                headers.delete( 'Content-Type' ); //Content Type added automatically by cfhttppparam

                for ( var param in payload ) {
                    if ( !variables.fileFields.contains( param ) ) {
                        cfhttpparam( type = 'formfield', name = param, value = payload[ param ] );
                    } else {
                        cfhttpparam( type = 'file', name = param, file = payload[ param ] );
                    }
                }

            }

            //handled last, to account for possible Content-Type header correction for forms
            var requestHeaders = parseHeaders( headers );
            for ( var header in requestHeaders ) {
                cfhttpparam( type = "header", name = header.name, value = header.value );
            }

        }
        return _normalizeHttpResponse(result);
    }

    private struct function _normalizeHttpResponse( required struct result ){
      var statusCode = val( result.statuscode );
      var normalizedResponse = {
        'statusCode' = statusCode,
        'statusText' = statusCode ? listRest( result.statuscode, " " ) : result.statuscode,
        'charset' = result.charset ?: "UTF-8",
        'filecontent' = result.filecontent,
        'headers' = result.responseheader
      }
      if( result.keyExists( 'mimetype' ) ){
        normalizedResponse['mimetype'] = result.mimetype;
      }
      return normalizedResponse;
    }

    /**
    * @hint convert the headers from a struct to an array
    */
    private array function parseHeaders( required struct headers ) {
        var sortedKeyArray = headers.keyArray();
        sortedKeyArray.sort( 'textnocase' );
        var processedHeaders = sortedKeyArray.map(
            function( key ) {
                return { name: key, value: trim( headers[ key ] ) };
            }
        );
        return processedHeaders;
    }

    /**
    * @hint converts the queryparam struct to a string, with optional encoding and the possibility for empty values being pass through as well
    */
    private string function parseQueryParams( required struct queryParams, boolean encodeQueryParams = true, boolean includeEmptyValues = true ) {
        var sortedKeyArray = queryParams.keyArray();
        sortedKeyArray.sort( 'text' );

        var queryString = sortedKeyArray.reduce(
            function( queryString, queryParamKey ) {
                var encodedKey = encodeQueryParams
                    ? encodeUrl( queryParamKey )
                    : queryParamKey;
                if ( !isArray( queryParams[ queryParamKey ] ) ) {
                    var encodedValue = encodeQueryParams && len( queryParams[ queryParamKey ] )
                        ? encodeUrl( queryParams[ queryParamKey ] )
                        : queryParams[ queryParamKey ];
                } else {
                    var encodedValue = encodeQueryParams && ArrayLen( queryParams[ queryParamKey ] )
                        ?  encodeUrl( serializeJSON( queryParams[ queryParamKey ] ) )
                        : queryParams[ queryParamKey ].toList();
                    }
                return queryString.listAppend( encodedKey & ( includeEmptyValues || len( encodedValue ) ? ( '=' & encodedValue ) : '' ), '&' );
            }, ''
        );

        return queryString.len() ? queryString : '';
    }

    private string function parseBody( required any body ) {
        if ( isStruct( body ) || isArray( body ) ) {
            return serializeJson( body );
        } else if ( isJson( body ) ) {
            return body;
        } else {
            return '';
        }
    }

    private string function encodeUrl( required string str, boolean encodeSlash = true ) {
        var result = replacelist( urlEncodedFormat( str, 'utf-8' ), '%2D,%2E,%5F,%7E', '-,.,_,~' );
        if ( !encodeSlash ) {
            result = replace( result, '%2F', '/', 'all' );
        }
        return result;
    }

    /**
    * @hint helper to determine if body should be sent as JSON
    */
    private boolean function isJsonPayload( required struct headers ) {
        return headers[ 'Content-Type' ] == 'application/json';
    }

    /**
    * @hint helper to determine if body should be sent as form params
    */
    private boolean function isFormPayload( required struct headers ) {
        return arrayContains( [ 'application/x-www-form-urlencoded', 'multipart/form-data' ], headers[ 'Content-Type' ] );
    }

    /**
    *
    * Based on an (old) blog post and UDF from Raymond Camden
    * https://www.raymondcamden.com/2012/01/04/Converting-XML-to-JSON-My-exploration-into-madness/
    *
    */
    private struct function xmlToStruct( required any x ) {

        if ( isSimpleValue( x ) && isXml( x ) ) {
            x = xmlParse( x );
        }

        var s = {};

        if ( xmlGetNodeType( x ) == "DOCUMENT_NODE" ) {
            s[ structKeyList( x ) ] = xmlToStruct( x[ structKeyList( x ) ] );
        }

        if ( structKeyExists( x, "xmlAttributes" ) && !structIsEmpty( x.xmlAttributes ) ) {
            s.attributes = {};
            for ( var item in x.xmlAttributes ) {
                s.attributes[ item ] = x.xmlAttributes[ item ];
            }
        }

        if ( structKeyExists( x, 'xmlText' ) && x.xmlText.trim().len() ) {
            s.value = x.xmlText;
        }

        if ( structKeyExists( x, "xmlChildren" ) ) {

            for ( var xmlChild in x.xmlChildren ) {
                if ( structKeyExists( s, xmlChild.xmlname ) ) {

                    if ( !isArray( s[ xmlChild.xmlname ] ) ) {
                        var temp = s[ xmlChild.xmlname ];
                        s[ xmlChild.xmlname ] = [ temp ];
                    }

                    arrayAppend( s[ xmlChild.xmlname ], xmlToStruct( xmlChild ) );

                } else {

                    if ( structKeyExists( xmlChild, "xmlChildren" ) && arrayLen( xmlChild.xmlChildren ) ) {
                            s[ xmlChild.xmlName ] = xmlToStruct( xmlChild );
                    } else if ( structKeyExists( xmlChild, "xmlAttributes" ) && !structIsEmpty( xmlChild.xmlAttributes ) ) {
                        s[ xmlChild.xmlName ] = xmlToStruct( xmlChild );
                    } else {
                        s[ xmlChild.xmlName ] = xmlChild.xmlText;
                    }

                }

            }
        }

        return s;
    }

    /**
   * Ported from official apify package: https://github.com/apify/apify-client-js/blob/master/src/http_client.ts
   * Handles all unexpected errors that can happen, but are not
   * Apify API typed errors. E.g. network errors, timeouts and so on.
   */
    private boolean function _isStatusOk( required numeric status_code ) {
      return status_code >= 200 && status_code < 300;
    }

    private boolean function _isTimeoutError( required numeric status_code ) {
      return status_code == 408;
    }

    private boolean function _isRateLimitError( required numeric status_code ){
      return status_code == variables.RATE_LIMIT_EXCEEDED_STATUS_CODE;
    }

    private boolean function _isRetryableError( required struct response ) {
      if( _isTimeoutError(response.statusCode) && variables.doNotRetryTimeouts ) {
        _debug( "ApifyApi request timeout: #response.statusCode# #response.statusText#. The setting doNotRetryTimeouts is set to true, so it will not be retried." );
        return false;
      }
      if( _isStatusCodeRetryable( response.statusCode ) ){
        return true;
      } else if( _isNetworkError( response ) ){
        return true;
      } else {
        _debug( "ApifyApi request error: #response.statusCode# #response.statusText#. This error cannot be retried." );
        return false;
      }
    }

    private boolean function _isStatusCodeRetryable( required numeric status_code ) {
      var isRateLimitError = _isRateLimitError(status_code);
      var isInternalError = status_code >= 500;
      return isRateLimitError || isInternalError;
    }

    private boolean function _isNetworkError( required struct response ) {
      return left(response.statusText, 18) == 'Connection Failure';
    }

    /**
    * @hint I'm not including this for now - I'll need to see how often it actually happens in the wild in order to determine if/when/where it should be included.
    */
    private boolean function _isResponseBodyInvalid( required struct response ) {
      var mimeType = response.mimetype ?: '';
      return mimeType == 'application/json' && !isJson( response.fileContent );
    }

    private void function _addRateLimitError( required numeric attempt ) {
      variables.stats.rateLimitErrors[attempt]++;
    }

    private void function _debug( required string message, any debug = {} ){
      if( variables.debug ){
        var enriched_message = "#dateTimeFormat( now(), "yyyy-mm-dd HH:NN:SS" )# DEBUG #message#";
        if( !isEmpty( debug ) ){
          var extraInfo = duplicate(debug);
          extraInfo.delete("apify_token");
          if( extraInfo.keyExists( "headers" ) ){
            extraInfo.headers.delete("Authorization");
          }
          enriched_message &= " ExtraInfo: #serializeJSON( extraInfo )#";
        }
        variables.stdout.println( enriched_message );
      }
    }

}
