# 		Rocksdb version check Resource

A specific [Concourse](http://concourse.ci) resource that get the last rocksdb sources. It fetches the sources for mongodb  compilation purpose

## Getting started
Add the following [Resource Type](http://concourse.ci/configuring-resource-types.html) to your Concourse pipeline
```yaml
resource_types:
  - name: rocksdb-version
    type: docker-image
    source:
      repository: jraverdyorange/concourse-rocks-check-resource
```

## Source Configuration

### `source`:

#### Parameters

* `version`: *Optional.* specific version to fetch (ex: "5.5.5") 

An example source configuration is below.
```yaml
resources:
- name: rocksdb-src
  type: rocksdb-version
  source:
    version: "5.5.5"
```

