AWS = Meteor.require 'aws-sdk'
AWS.config.update
  'accessKeyId'     : "AKIAJ4QROL3BSAMJTI7Q",
  'secretAccessKey' : "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",
  'region'          : "us-west-2"
s3 = new AWS.S3()
###
Meteor.startup ->
  s3.listBuckets {}, (err, data)->
    console.log "=== buckets ==="
    if err?
      console.log "Error loading buckets: "+err
    else if data?
      bucketFound = false
      for bucket, i in data.Buckets
        console.log "  --> "+bucket.Name
###
@putObject = (file, data)->
  Async.runSync (done)->
    params =
      Bucket: 'd2mpclient'
      Key: file
      Body: data
      StorageClass: 'REDUCED_REDUNDANCY'
    s3.putObject params, done
@generateModDownloadURL = (mod)->
  s3.getSignedUrl 'getObject', {Bucket: "d2mpclient", Key: mod.bundlepath}
@getBundleDownloadURL = (file)->
  response = Async.runSync (done)->
    done null, s3.getSignedUrl 'getObject', {Bucket: "d2mpclient", Key: file}
  response.result
