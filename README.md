# kibana_cookbook

Chef cookbook for provisioning kibana cluster.

## Releasing New Version

We need to do these whenever we release a new version:

1. Run

```
bundle exec berks update
bundle exec berks vendor cookbooks
```

2. Commit and updated `cookbooks` directory
3. Tag the commit that we want to release with format `<APP-VERSION>-<REVISION>`
