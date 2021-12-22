component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
    inspectTemplates();
    baseUrl = 'http://127.0.0.1:52558/testapi';
    apify = new apify( baseUrl = baseUrl, includeRaw = true, debug = true );
	}

	function afterAll(){
	}

/*********************************** BDD SUITES ***********************************/

	function run(){
		describe( "The Apify API wrapper", function(){

			beforeEach(function(){
			});

			afterEach(function(){
			});

			it("can be init", function(){
				expect( apify ).toBeInstanceOf( 'apify' );
			});

      describe( "The retry logic", function(){

        it("will retry 500 errors", function(){
          apify_retry = new apify(
            baseUrl = "#baseUrl#/500",
            includeRaw = true,
            maxRetries = 2,
            debug = true
          );

          expect(
            function(){
              apify_retry.listActors( my = true, limit = 10 )
            }
          ).toThrow( "ApifyApiError" );
          var stats = apify_retry.retrieveCfcStats();
          expect( stats.calls ).toBe( 1 );
          expect( stats.requests ).toBe( 2 );

        });

        it("will retry network errors", function(){
          apify_retry = new apify(
            baseUrl = "http://notlocalhost",
            includeRaw = true,
            maxRetries = 2,
            debug = true
          );

          expect(
            function(){
              apify_retry.listActors( my = true, limit = 10 )
            }
          ).toThrow( "ApifyApiError" );
          var stats = apify_retry.retrieveCfcStats();
          expect( stats.calls ).toBe( 1 );
          expect( stats.requests ).toBe( 2 );
        });

        it("will retry rate limit errors", function(){
          apify_retry = new apify(
            baseUrl = "#baseUrl#/429",
            includeRaw = true,
            maxRetries = 2,
            debug = true
          );

          expect(
            function(){
              apify_retry.listActors( my = true, limit = 10 )
            }
          ).toThrow( "ApifyApiError" );
          var stats = apify_retry.retrieveCfcStats();
          expect( stats.calls ).toBe( 1 );
          expect( stats.requests ).toBe( 2 );
        });

        it("throws on timeout errors when set not to retry timeouts", function(){
          expect( apify ).toBeInstanceOf( 1 );
        });

        it("throws on 400 errors", function(){
          expect( apify ).toBeInstanceOf( 1 );
        });

      });

      describe( "The actors", function(){

        it("can be listed", function(){
          var apify_request = apify.listActors( my = true, limit = 10 );
          var raw = apify_request.raw;
          expect( raw.path ).toBe( baseUrl & '/acts' );
          expect( raw.params ).toBe( 'limit=10&my=true' );
          expect( raw.method ).toBe( 'GET' );
        });

      });

      describe( "The actor tasks", function(){

        it("can be listed", function(){
          var apify_request = apify.listActorTasks( limit = 10 );
          var raw = apify_request.raw;
          expect( raw.path ).toBe( baseUrl & '/actor-tasks' );
          expect( raw.params ).toBe( 'limit=10' );
          expect( raw.method ).toBe( 'GET' );
        });

        it("can be created", function(){
          var actorId = 'xxx';
          var name = "books-toscrape-com";
          var options = {
            "build": "latest",
            "timeoutSecs": 300,
            "memoryMbytes": 128
          };
          var input = {
            "startUrls": [
              {
                  "url": "https://books.toscrape.com/"
              }
            ]
          };
          var apify_request = apify.createActorTask( actorId, name, options, input );
          var raw = apify_request.raw;
          expect( raw.path ).toBe( baseUrl & '/actor-tasks' );
          expect( raw.payload ).toBe( '{"options":{"memoryMbytes":128,"build":"latest","timeoutSecs":300},"input":{"startUrls":[{"url":"https://books.toscrape.com/"}]},"name":"books-toscrape-com","actId":"xxx"}' );
          expect( raw.method ).toBe( 'POST' );
        });

        it("can be retrieved by id", function(){
          var actorTaskId = 'example_actor_task_id';
          var apify_request = apify.getActorTaskById( actorTaskId );
          var raw = apify_request.raw;
          expect( raw.path ).toBe( baseUrl & '/actor-tasks/#actorTaskId#' );
          expect( raw.method ).toBe( 'GET' );
        });

        it("can be updated", function(){
          var actorTaskId = 'example_actor_task_id';
          var actorId = 'xxx';
          var name = "books-toscrape2-com";
          var options = {
            "build": "latest",
            "timeoutSecs": 300,
            "memoryMbytes": 256
          };
          var input = {
            "startUrls": [
              {
                  "url": "https://books.toscrape2.com/"
              }
            ]
          };
          var apify_request = apify.updateActorTask( actorTaskId, actorId, name, options, input );
          var raw = apify_request.raw;
          expect( raw.path ).toBe( baseUrl & '/actor-tasks/#actorTaskId#' );
          expect( raw.payload ).toBe( '{"options":{"memoryMbytes":256,"build":"latest","timeoutSecs":300},"input":{"startUrls":[{"url":"https://books.toscrape2.com/"}]},"name":"books-toscrape2-com","actId":"xxx"}' );
          expect( raw.method ).toBe( 'PUT' );
        });

        it("can be deleted", function(){
          var actorTaskId = 'example_actor_task_id';
          var apify_request = apify.deleteActorTask( actorTaskId );
          var raw = apify_request.raw;
          expect( raw.path ).toBe( baseUrl & '/actor-tasks/#actorTaskId#' );
          expect( raw.method ).toBe( 'DELETE' );
        });

      });

		});


	}

}
