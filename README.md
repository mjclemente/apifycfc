# apifycfc

A CFML wrapper for the [Apify API](https://docs.apify.com/api/v2). Interact with Apify's automated web scraping and automation platform.

*Feel free to use the issue tracker to report bugs or suggest improvements!*

## Acknowledgements

This project borrows heavily from the API frameworks built by [jcberquist](https://github.com/jcberquist). Thanks to John for all the inspiration!

## Table of Contents

- [Quick Start](#quick-start)
- [Setup and Authentication](#setup-and-authentication)
- [`apifycfc` Reference Manual](#reference-manual)

### Quick Start

The following is a quick example of listing the actors in your account.

```cfc
apify = new path.to.apifycfc.apify( apify_token = 'xxx' );

actors = apify.listActors();

writeDump( var='#actors.data#' );
```

### Setup and Authentication

To get started with the Apify API, you'll need an [API token](https://docs.apify.com/api/v2#/introduction/authentication) .

Once you have this, you can provide them to this wrapper manually when creating the component, as in the Quick Start example above, or via an environment variable named `APIFY_TOKEN`, which will get picked up automatically. This latter approach is generally preferable, as it keeps hardcoded credentials out of your codebase.

### Reference Manual

---
