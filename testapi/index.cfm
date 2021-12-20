<cfscript>
  route = cgi.PATH_INFO.replacenocase( '/testapi', '' ).lcase();
  method = cgi.request_method;
  res = {};

  cfheader( name="Content-Type", value="application/json" );

  if( route == '/acts' ){

    if( method == 'GET' ){
      res = {
        "data": {
          "count": 1,
          "desc": false,
          "items": [
            {
              "createdAt": "2021-12-06T16:18:32.192Z",
              "id": "xxx",
              "modifiedAt": "2021-12-16T19:23:27.247Z",
              "name": "apify-xxx-test",
              "username": "xxx"
            }
          ],
          "limit": 1000,
          "offset": 0,
          "total": 1
        }
      };

    }

  }

  if( route == '/actor-tasks' ){

    if( method == 'GET' ){
      res = {
        "data": {
          "count": 2,
          "desc": false,
          "items": [
            {
              "actId": "xxx",
              "actName": "apify-xxx-test",
              "actUsername": "xxx",
              "createdAt": "2021-12-16T18:52:30.737Z",
              "id": "xxx",
              "modifiedAt": "2021-12-16T19:09:09.039Z",
              "name": "www-example-com",
              "stats": {
                "totalRuns": 2
              },
              "userId": "xxx",
              "username": "xxx"
            },
            {
              "actId": "xxx",
              "actName": "apify-xxx-test",
              "actUsername": "xxx",
              "createdAt": "2021-12-16T19:31:11.845Z",
              "id": "xxx",
              "modifiedAt": "2021-12-16T19:31:54.976Z",
              "name": "also-com",
              "stats": {
                "totalRuns": 1
              },
              "userId": "xxx",
              "username": "xxx"
            }
          ],
          "limit": 1000,
          "offset": 0,
          "total": 2
        }
      };
    }

    if( method == 'POST' ){
      res = {
        "data": {
          "actId": "xxx",
          "createdAt": "2021-12-20T20:56:38.613Z",
          "id": "xxx",
          "input": {
            "startUrls": [
              {
                "url": "https://books.toscrape.com/"
              }
            ]
          },
          "modifiedAt": "2021-12-20T20:56:38.613Z",
          "name": "books-toscrape-com",
          "options": {
            "build": "latest",
            "memoryMbytes": 128,
            "timeoutSecs": 300
          },
          "stats": {
            "totalRuns": 0
          },
          "userId": "xxx",
          "username": "xxx"
        }
      };
    }

  }
  writeOutput( serializeJSON(res) );
</cfscript>
