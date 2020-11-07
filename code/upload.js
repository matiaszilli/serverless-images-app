const AWS = require("aws-sdk");
let s3 = new AWS.S3();

const parser = require('lambda-multipart-parser');

const docClient = new AWS.DynamoDB.DocumentClient({ region: process.env.AWS_REGION });

exports.handler = async (event, context, callback) => {
  const bucket = process.env.S3_BUCKET_NAME;
  const dynamoTable = process.env.DYNAMO_TABLE_NAME;
  
  // Parse image
  let imageData = await parser.parse(event);
  let image = imageData.files[0].content;
  // Generate filename
  let filenameReq = imageData.files[0].filename;
  let ext = filenameReq.substr(filenameReq.lastIndexOf('.') + 1);
  let filePath = context.awsRequestId + "." + ext;

  try {
    // Upload to S3
    let paramss3 = {
      Body: image,
      Bucket: bucket,
      Key: filePath
    };
    let datas3 = await s3.upload(paramss3).promise();
    // Create DynamoDB item
    let paramsDyn = {
      Item: {
        id: context.awsRequestId,
        Version: datas3.VersionId,
        Date: Date.now(),
        Author: event.headers.author,
        Category: event.headers.category,
        Bucket: bucket,
        Filename: filePath,
      },
      TableName: dynamoTable
    };
    await docClient.put(paramsDyn).promise();
    console.log(`File is uploaded in - ${bucket} -> ${filePath}`);

    // Create response
    let body = {};
    body.id = context.awsRequestId;
    body.location = datas3.Location;
    body.version = datas3.VersionId;
    body = JSON.stringify(body);
    console.log(body);
    let response = {
      statusCode: 200,
      headers: {},
      body,
      isBase64Encoded: false
    };
    callback(null, response);

  } catch (err) {
    // In case of error
    console.log(err);
    callback(err, null);
  }
};
