# Graph Automation Chunker Changelog

## Version 0.2.0

### New

- Added a new container port `health` on 8001
- Added `security.token` for providing a Secret reference containing a secure token for protecting the HTTP API

### Updated

- Updated the Document Chunker to version 1.1.0
- Updated all probes to use the new health port and to call `/healthz`

## Version 0.1.0

This is the initial release of the Graph Automation Document Chunker Helm chart.
