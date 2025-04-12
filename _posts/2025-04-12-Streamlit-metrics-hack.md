---
title: "Streamlit application metric endpoint hack"
date: 2025-04-12
categories: DEV
tags: streamlit python prometheus
---

## Intro

I have many **Streamlit** applications that require health checks for their data sources.  
The first attempt was to use the `streamlit_extras` library with the **Prometheus** module.  
Check example on the library
page <a target="_blank" href="https://arnaudmiribel.github.io/streamlit-extras/extras/prometheus/">https://arnaudmiribel.github.io/streamlit-extras/extras/prometheus/</a>  
The problem with this approach is that the metric functions are only executed when the application is actively used.  
So, this approach is not an effective solution for checking the health of the data source.

## Need

* metric checking data source health
* metric run every time Prometheus scraps standard Streamlit application metric endpoint `/_stcore/metrics`
* general metrics written in the library so they can be reused in different applications not only Streamlit apps.

## Solution

<a target="_blank" href="https://github.com/mysiar/streamlit_metrics_hack">All code</a>

basic counter metric example

```python
from prometheus_client import Counter
from streamlit_extras.prometheus import CollectorRegistry

from .registry import METRICS, METRIC_PREFIX, METRICS_REGISTRY


def metric_counter(
    metric_name: str = "counter",
    app_name: str = "not-set",
    metric_prefix: str = METRIC_PREFIX,
    metric_registry: CollectorRegistry = METRICS_REGISTRY,
) -> None:
    full_name = f"{metric_prefix}{metric_name}"
    if full_name not in METRICS:
        METRICS[full_name] = Counter(
            name=full_name,
            documentation=f"Counter for {full_name}",
            labelnames=["app"],
            registry=metric_registry,
        )
    METRICS[full_name].labels(app=app_name).inc()
```

This metric, by default, uses the REGISTRY from the `prometheus_client` module, making it suitable for any API
application that allows the creation of custom endpoints.  
But it can also utilize the Streamlit metrics registry from the `streamlit_extras.prometheus` module.

```python
    # for default Prometheus client registry
    metric_counter()
    
    # for Streamlit registry
    from streamlit_extras.prometheus import streamlit_registry
    metric_counter(metric_registry=streamlit_registry())
```

The solution presented involves patching the vendor Streamlit library file
`streamlit/web/server/stats_request_handler.py`
using <a target="_blank" href="https://github.com/mysiar/streamlit_metrics_hack/blob/master/patch_metrics.py">
patch_metrics.py</a> by adding the following code snippet to the beginning of the `get` method of the
`StatsRequestHandler` class.

```python
        try:
            from metrics.run_all_metrics import run_all_metrics
            run_all_metrics()
        except:
            pass
```

So, the metrics are now executed every time the metrics endpoint `/_stcore/metrics/` is called.

Result 
```
# HELP custom_test_hack_st_metrics_counter Counter for custom_test_hack_st_metrics_counter
# TYPE custom_test_hack_st_metrics_counter counter
custom_test_hack_st_metrics_counter_total{app="test_hack_st_metrics_app"} 1.0
custom_test_hack_st_metrics_counter_created{app="test_hack_st_metrics_app"} 1.7444541842915154e+09
```

```
# HELP custom_test_hack_st_metrics_counter Counter for custom_test_hack_st_metrics_counter
# TYPE custom_test_hack_st_metrics_counter counter
custom_test_hack_st_metrics_counter_total{app="test_hack_st_metrics_app"} 2.0
custom_test_hack_st_metrics_counter_created{app="test_hack_st_metrics_app"} 1.7444541842915154e+09
```
