component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
    inspectTemplates();
    baseUrl = 'http://127.0.0.1:52558/testapi';
    apify = new apify( baseUrl = baseUrl, includeRaw = true );
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

      describe( "The actors", function(){

        it("can be listed", function(){
          var apify_request = apify.listActors( my = true, limit = 10 );
          expect( apify_request.statusCode ).toBe( 200 );
          var raw = apify_request.raw;
          expect( raw.path ).toBe( baseUrl & '/acts' );
          expect( raw.params ).toBe( 'limit=10&my=true' );
          expect( raw.method ).toBe( 'GET' );
        });

      });

      describe( "The actor tasks", function(){

        it("can be listed", function(){
          var apify_request = apify.listActorTasks( limit = 10 );
          expect( apify_request.statusCode ).toBe( 200 );
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
          expect( apify_request.statusCode ).toBe( 200 );
          var raw = apify_request.raw;
          expect( raw.path ).toBe( baseUrl & '/actor-tasks' );
          expect( raw.payload ).toBe( '{"options":{"memoryMbytes":128,"build":"latest","timeoutSecs":300},"input":{"startUrls":[{"url":"https://books.toscrape.com/"}]},"name":"books-toscrape-com","actId":"xxx"}' );
          expect( raw.method ).toBe( 'POST' );
        });

        it("can be retrieved by id", function(){
          var actorTaskId = 'example_actor_task_id';
          var apify_request = apify.getActorTaskById( actorTaskId );
          expect( apify_request.statusCode ).toBe( 200 );
          var raw = apify_request.raw;
          expect( raw.path ).toBe( baseUrl & '/actor-tasks/#actorTaskId#' );
          expect( raw.method ).toBe( 'GET' );
        });

      });

		});


	}

}
