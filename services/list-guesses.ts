import AWS from 'aws-sdk';

AWS.config.update({
  region: process.env.AWS_REGION,
});

exports.calculateResults = async (_event: any, _context: any, callback: (Error, any) => void): Promise<void> => {
  try {
    const docClient = new AWS.DynamoDB.DocumentClient();

    const docs: ({ Guessor: string, Guesses: string[] })[] = (await docClient.scan({
      TableName:  process.env.DYNAMO_TABLE_NAME,
    }).promise()).Items as ({ Guessor: string, Guesses: string[] })[];

    const results: { [guess: string]: string[] } = {};

    docs.forEach((doc: { Guessor: string, Guesses: string[] }): void => {
      doc.Guesses.forEach((guess: string) => {
        if (!results[guess]) {
          results[guess] = [];
        }

        results[guess].push(doc.Guessor);
      });
    });

    callback(null, {
      statusCode: 200,
      headers:    {
        'Content-Type': 'application/json',
      },
      body:       JSON.stringify(results),
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