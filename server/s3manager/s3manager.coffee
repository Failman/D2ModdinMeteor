AWS = Meteor.require 'aws-sdk'

AWS.config.update
  'accessKeyId'     : "AKIAJ4QROL3BSAMJTI7Q",
  'secretAccessKey' : "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",
  'region'          : "us-west-2"
s3 = new AWS.S3()
bucket = "d2mpclient"
Meteor.startup ->
  s3.listBuckets {}, (err, data)->
    console.log "=== buckets ==="
    if err?
      console.log "Error loading buckets: "+err
    else if data?
      bucketFound = false
      for bucket, i in data.Buckets
        console.log "  --> "+bucket.Name
        bucketFound = true if bucket.Name is bucket
      if not bucketFound
        console.log "Client bucket not found!"

generateModDownloadURL = (mod)->
  response = Async.runSync (done)->
    done null, s3.getSignedUrl 'getObject', {Bucket: bucket, Key: mod.bundlepath}
  response.result
