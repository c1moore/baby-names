import * as AWS from 'aws-sdk';

AWS.config.update({
  region: process.env.AWS_REGION,
});

exports.fetchGuessesByUser = async ({ pathParameters = {} }: { pathParameters: { guessor?: string } }, _context: any, callback: (Error, any) => void): Promise<void> => {
  try {
    const guessor = decodeURIComponent(pathParameters.guessor);
    const docClient = new AWS.DynamoDB.DocumentClient();

    const guessesDoc = (await docClient.scan({
      TableName:                  process.env.DYNAMO_TABLE_NAME,
      ProjectionExpression:       'Guess',
      FilterExpression:           'contains (Guessors, :guessor)',
      ExpressionAttributeValues:  {
        ':guessor':                 guessor,
      },
    }).promise());

    const guesses = guessesDoc.Items.map((doc: { Guess: string }) => {
      return doc.Guess;
    });

    callback(null, {
      statusCode: 200,
      headers:    {
        'Content-Type': 'application/json',
      },
      body:       JSON.stringify(guesses),
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