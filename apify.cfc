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
        numeric minDelayBetweenRetriesMillis = 500,
        boolean doNotRetryTimeouts = false
    ) {

        structAppend( variables, arguments );

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
      var attempts = 0;
      var response = {};
      while (attempts < variables.maxRetries) {
        attempts++;

        // no try/catch here, for now... I don't think it's needed, since we should be able to handle everything with the response from the cfhttp request (which will include error information, if needed)
        response = makeHttpRequest( httpMethod = httpMethod, path = path, queryParams = queryParams, headers = headers, payload = payload );

        if( _isStatusOk(response.statusCode) ){
          break;
        }

        if( _isRateLimitError(response.statusCode) ) {
          _addRateLimitError(attempt);
        }

        _handleRequestError( response );

        // exponential back off! But not after the last failure
        if( attempts != variables.maxRetries ){
          sleep( attempts^2*1000 );
        }
      }
      // if we end up here with an empty response, we've failed
      if( response.isEmpty() ){
        throw( type="ApifyApiError", message="Retry limit reached: #variables.maxRetries# attempts failed." );
      }

      return response;
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

        cfhttp( url = fullPath, method = httpMethod,  result = 'result', timeout = variables.httpTimeout ) {

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
        return result;
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

}
