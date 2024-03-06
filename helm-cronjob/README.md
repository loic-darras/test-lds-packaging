# helm-api

AAP Helm Chart for deploying API-like kubernetes components.

## User guide

You can find a user guide to use this chart [here](../docs/api/api.md)

## Developer guide

### Local usage

You can launch the helm manifest generation using the **values-example.yaml** file:

```bash
helm template -f values-example.yaml . --debug
```

### Testing chart

To test the chart you can refer to the [testing section](../docs/helm-testing.md)
