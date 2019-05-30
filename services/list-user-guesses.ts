import * as AWS from 'aws-sdk';

AWS.config.update({
  region: process.env.AWS_REGION,
});

exports.fetchGuessesByUser = async ({ pathParameters = {} }: { pathParameters: { guessor?: string } }, _context: any, callback: (Error, any) => void): Promise<void> => {
  try {
    const guessor = decodeURIComponent(pathParameters.guessor);
    const docClient = new AWS.DynamoDB.DocumentClient();

    const guessorDoc = (await docClient.get({
      TableName:  process.env.DYNAMO_TABLE_NAME,
      Key:        {
        Guessor:    guessor,
      },
    }).promise());

    if (!guessorDoc || !guessorDoc.Item) {
      callback(null, {
        statusCode: 404,
      });

      return;
    }

    callback(null, {
      statusCode: 200,
      headers:    {
        'Content-Type': 'application/json',
      },
      body:       JSON.stringify(guessorDoc.Item.Guesses),
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