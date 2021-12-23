# apifycfc

A CFML wrapper for the [Apify API](https://docs.apify.com/api/v2). Use it to interact with Apify's automated web scraping and automation platform.

This is an early stage API wrapper and does not yet cover the full Apify API. *Feel free to use the issue tracker to report bugs or suggest improvements!*

## Acknowledgements

This project borrows heavily from the API frameworks built by [jcberquist](https://github.com/jcberquist). Thanks to John for all the inspiration!

## Table of Contents

- [Quick Start](#quick-start)
- [Authentication](#authentication)
- [Setup](#setup)
- [`apifycfc` Reference Manual](#reference-manual)

### Quick Start

The following is a quick example of listing the actors in your account.

```cfc
apify = new path.to.apifycfc.apify( apify_token = 'xxx' );

actors = apify.listActors();

writeDump( var='#actors.data#' );
```

### Authentication

To get started with the Apify API, you'll need an [API token](https://docs.apify.com/api/v2#/introduction/authentication) .

Once you have this, you can provide them to this wrapper manually when creating the component, as in the Quick Start example above, or via an environment variable named `APIFY_TOKEN`, which will get picked up automatically. This latter approach is generally preferable, as it keeps hardcoded credentials out of your codebase.

### Setup

There are several options you can configure when initializing the CFC.

| Name               | Type    | Default                  | Description                                                                                                                                                                                                                                                                                                    |
| ------------------ | ------- | ------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| apify_token        | string  |                          | If you do not provide this via the init method, it must be provided as an environment variable, as explained in the authentication section.                                                                                                                                                                    |
| baseUrl            | string  | https://api.apify.com/v2 | The base endpoint for the API. You shouldn't need to change this, unless you're testing something.                                                                                                                                                                                                             |
| includeRaw         | boolean | false                    | When set to true, details of each request (HTTP Method, path, query params, payload) will be included in the response struct.                                                                                                                                                                                  |
| httpTimeout        | numeric | 360                      | Timeout for http requests, in seconds.                                                                                                                                                                                                                                                                         |
| maxRetries         | numeric | 8                        | Like Apify's official [JavaScript](https://docs.apify.com/apify-client-js) and [Python](https://docs.apify.com/apify-client-python) clients, this CFC provides automatic retries, with exponential backoff. This setting configures the number of retry attempts that should be made before throwing an error. |
| doNotRetryTimeouts | boolean | false                    | When set to true, requests that time out will not be automatically retried.                                                                                                                                                                                                                                    |
| debug              | boolean | false                    | When set to true, debugging information will be logged to the console.                                                                                                                                                                                                                                         |

### Reference Manual

A full reference manual for all public methods in `apify.cfc`  can be found in the `docs` directory, [here](https://github.com/mjclemente/apifycfc/blob/main/docs/apify.md).

---
