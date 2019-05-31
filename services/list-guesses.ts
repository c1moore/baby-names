import * as AWS from 'aws-sdk';

AWS.config.update({
  region: process.env.AWS_REGION,
});

exports.calculateResults = async (_event: any, _context: any, callback: (Error, any) => void): Promise<void> => {
  try {
    const docClient = new AWS.DynamoDB.DocumentClient();

    const docs: ({ Guess: string, Guessors: string[] })[] = (await docClient.scan({
      TableName:  process.env.DYNAMO_TABLE_NAME,
    }).promise()).Items as ({ Guess: string, Guessors: string[] })[];

    callback(null, {
      statusCode: 200,
      headers:    {
        'Content-Type': 'application/json',
      },
      body:       JSON.stringify(docs),
    });
  } catch (err) {
    callback(null, {
      statusCode: 500,
      headers:    {
        'Content-Type': 'application/json',
      },
      body:       JSON.stringify({
        msg:  err.toString(),
      }),
    });
  }
};