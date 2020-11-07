const AWS = require("aws-sdk");
let s3 = new AWS.S3();

const parser = require('lambda-multipart-parser');

const docClient = new AWS.DynamoDB.DocumentClient({ region: process.env.AWS_REGION });

exports.handler = async (event, context, callback) => {
  const bucket = process.env.S3_BUCKET_NAME;
  const dynamoTable = process.env.DYNAMO_TABLE_NAME;

  // Parse image
  let image = await parser.parse(event);
  image = image.files[0].content;

  // Get filename
  let paramsDyn = {
    KeyConditionExpression: "id = :value", 
    ExpressionAttributeValues: {
     ":value": event.queryStringParameters.id
    }, 
    ProjectionExpression: "Filename",
    Limit : 1,
    TableName: dynamoTable
  };
  const resolveHeadObject = async()=> await docClient.query(paramsDyn).promise();
  let filename = await resolveHeadObject();
  filename = filename.Items[0].Filename;

  try {
    // Upload to S3
    let paramss3 = {
      Body: image,
      Bucket: bucket,
      Key: filename
    };
    let datas3 = await s3.putObject(paramss3).promise();
    console.log(`File is uploaded in - ${bucket} -> ${filename}`);
    console.log(datas3);
    // Update DynamoDB
    paramsDyn = {
      Item: {
        id: event.queryStringParameters.id,
        Date: Date.now(),
        Author: event.headers.author,
        Category: event.headers.category,
        Bucket: bucket,
        Filename: filename,
        Version: datas3.VersionId,
      },
      TableName: dynamoTable
    };
    await docClient.put(paramsDyn).promise();

    // Create response
    let body = {};
    body.id = event.queryStringParameters.id;
    body.location = `https://${bucket}.s3.amazonaws.com/${filename}`;
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
    console.log(err)
    callback(err, null);
  }
};
