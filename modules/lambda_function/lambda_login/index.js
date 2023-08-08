const AWS = require('aws-sdk');
const s3 = new AWS.S3();
const jwtDecode = require("jwt-decode");
const ssm = new AWS.SSM();

exports.handler = async (event, context) => {
  const decodedToken = jwtDecode(event.headers.Authorization);
  //console.log("************", decodedToken, "*****************");
  const currentTime = new Date().toISOString();
  const fileContent = `Current time: ${currentTime}`;
  const userName = decodedToken["name"];

  // Set the S3 bucket and file name
  const bucketName = 'iict-bucket-to-save-users-access';
  const fileName = `${userName}.txt`;
 // Set the parameter store object
 const parameterName = decodedToken["sub"]; 
  // Set the S3 parameters
  const params = {
    Bucket: bucketName,
    Key: fileName,
    Body: fileContent,
    ContentType: 'text/plain',
  };
  try {
    // Upload the file to S3
    await s3.putObject(params).promise();
        // Retrieve the parameter from Parameter Store
       const result = await ssm.getParameter({ Name: parameterName }).promise();
       const parameterValue = result.Parameter.Value;
    
        // Add the parameter value log to CloudWatch
       console.log('Parameter value:', parameterValue);
    // Return success message
    const response = {
      statusCode: 200, // Change the status code to 200 to indicate success
      body: JSON.stringify(`Hello  ${parameterValue}`),
    };
    return response;
  } catch (error) {
    // Return error message if file upload fails
    const response = {
      statusCode: 500,
      body: JSON.stringify('Error uploading file to S3: ' + error.message),
    };
    return response;
  }
};
