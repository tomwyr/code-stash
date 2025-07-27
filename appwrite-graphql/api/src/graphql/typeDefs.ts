import { gql } from 'apollo-server-express'
import { readFileSync } from 'fs'

function readSchema(fileName: string): string {
  const path = `${schemaPath}/${fileName}.graphql`

  return readFileSync(path).toString('utf-8')
}

const schemaPath = './src/graphql/schema'
const schemas = ['objects', 'inputs', 'query', 'mutation', 'subscription']

const template = schemas.map(readSchema).join('\n')

export const typeDefs = gql(template)
