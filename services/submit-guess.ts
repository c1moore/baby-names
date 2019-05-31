import * as AWS from 'aws-sdk';
import axios, { AxiosResponse } from 'axios';

AWS.config.update({
  region: process.env.AWS_REGION,
});

function parseRequest(body: string = ''): { recaptchaToken: string, guessor: string, guesses: string[] } {
  const { recaptchaToken, guessor, guesses }: { recaptchaToken: string, guessor: string, guesses: string[] } = JSON.parse(body);
  
  if (!recaptchaToken) {
    throw new Error('Missing required param: recaptchaToken');
  }

  if (!guessor) {
    throw new Error('Missing required param: guessor');
  }

  if (!guesses || !Array.isArray(guesses) || !guesses.length) {
    throw new Error('Missing or invalid required param: guesses');
  }

  return { recaptchaToken, guessor, guesses };
};

async function loadRecaptchaSecret(): Promise<string> {
  const ssm = new AWS.SSM();

  return (await ssm.getParameter({
    Name:           `/BabyNames/${process.env.NODE_ENV}/RECAPTCHA_SECRET`,
    WithDecryption: true,
  }).promise()).Parameter.Value;
}

async function addGuess(docClient: AWS.DynamoDB.DocumentClient, guess: string, guessor: string): Promise<void> {
  try {
    return await docClient.update({
      TableName:                  process.env.DYNAMO_TABLE_NAME,
      Key:                        {
        Guess:                      guess,
      },
      ConditionExpression:        'not contains (Guessors, :guessor)',
      UpdateExpression:           'SET Guessors = list_append (Guessors, :guessor)',
      ExpressionAttributeValues:  {
        ':guessor':                 guessor,
      },
      ReturnValues:               'NONE',
    }).promise().then();
  } catch (err) {
    if (err.code !== 'ConditionalCheckFailedException') {
      throw err;
    }
  }
};

exports.submitGuess = async ({ body = '' }: { body: string }, _context: any, callback: (Error, any) => void): Promise<void> => {
  try {
    let recaptchaToken: string;
    let guessor: string;
    let guesses: string[];

    try {
      ({ recaptchaToken, guessor, guesses } = parseRequest(body));
    } catch (err) {
      callback(null, {
        statusCode: 400,
        headers:    {
          'Content-Type': 'application/json',
        },
        body:       JSON.stringify({
          msg: err.toString(),
        }),
      });
    }

    // Validate ReCAPTCHA
    const recaptchaRes: AxiosResponse<{success: boolean, challenge_ts: number, hostname: string, 'error-codes': string[]}> = await axios.post('https://www.google.com/recaptcha/api/siteverify', {
      secret:   await loadRecaptchaSecret(),
      response: recaptchaToken,
    });
  
    if (!recaptchaRes.data.success) {
      callback(null, {
        statusCode: 401,
        headers:    {
          'Content-Type': 'application/json',
        },
        body:       JSON.stringify({
          msg: `reCAPTCHA failed: ${(recaptchaRes['error-codes'] || []).join(', ')}`,
        }),
      });

      return;
    }
  
    // ReCAPTCHA was successful.  Add the answer.
    const docClient = new AWS.DynamoDB.DocumentClient();

    // Make sure there aren't any duplicate names since I pay per name.
    guesses = Array.from(new Set(guesses));

    try {
      await Promise.all(guesses.map((guess) => {
        return addGuess(docClient, guess, guessor);
      }));
    } catch (err) {
      if (err.code !== 'ConditionalCheckFailedException') {
        throw err;
      }
    }

    callback(null, {
      statusCode: 204,
    });
  } catch (err) {
    callback(null, {
      statusCode: 500,
      headers:    {
        'Content-Type': 'application/json',
      },
      body:       JSON.stringify({
        msg: err.toString(),
      }),
    });
  }
};
