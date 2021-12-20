<cfscript>
  route = cgi.PATH_INFO.replacenocase( '/testapi', '' ).lcase();
  method = cgi.request_method;
  res = {};

  cfheader( name="Content-Type", value="application/json" );

  if( route == '/acts' ){

    if( method == 'GET' ){
      res = { "data": { "total": 1, "count": 1, "offset": 0, "limit": 1000, "desc": false, "items": [ { "id": "xxx", "createdAt": "2021-12-06T16:18:32.192Z", "modifiedAt": "2021-12-16T19:23:27.247Z", "name": "apify-xxx-test", "username": "xxx" } ] } };

    }

  }

  if( route == '/actor-tasks' ){

    if( method == 'GET' ){
      res = { "data": { "total": 2, "count": 2, "offset": 0, "limit": 1000, "desc": false, "items": [ { "id": "xxx", "userId": "xxx", "actId": "xxx", "actName": "apify-xxx-test", "name": "www-example-com", "username": "xxx", "actUsername": "xxx", "createdAt": "2021-12-16T18:52:30.737Z", "modifiedAt": "2021-12-16T19:09:09.039Z", "stats": { "totalRuns": 2 } }, { "id": "xxx", "userId": "xxx", "actId": "xxx", "actName": "apify-xxx-test", "name": "also-com", "username": "xxx", "actUsername": "xxx", "createdAt": "2021-12-16T19:31:11.845Z", "modifiedAt": "2021-12-16T19:31:54.976Z", "stats": { "totalRuns": 1 } } ] } };
    }

  }
  writeOutput( serializeJSON(res) );
</cfscript>
