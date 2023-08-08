const AWS = require('aws-sdk');
const dynamoDB = new AWS.DynamoDB.DocumentClient();
const ssm = new AWS.SSM();

exports.handler = async (event, context) => {
	    // Set the Parameter Store parameters
    const parameterName = event.userName;
    const parameterValue = event.request.userAttributes.name;
	let date = new Date();
  try {
    
        // Put the userName into Parameter Store
    await ssm
      .putParameter({
        Name: parameterName,
        Value: parameterValue,
        Type: 'String',
        Overwrite: true,
      }).promise();

    
    // Assuming you have an array of items to add to the DynamoDB table
    const itemsToAdd = [
      { 
        username: event.userName,
        name: event.request.userAttributes.name,
        email: event.request.userAttributes.email,
        createdAt: date.toISOString()
      }
    ];

    // Use a loop to add each item to the DynamoDB table
    for (const item of itemsToAdd) {
      const params = {
        TableName: 'users',
        Item: item,
      };
      await dynamoDB.put(params).promise();
    }
    console.log('User data added to DB and PS');
	context.done(null, event);
  } catch (error) {
    console.error('Error adding user:', error);
	context.done(null, event);
  }
};