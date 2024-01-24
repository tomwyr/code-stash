import { makeExecutableSchema } from '@graphql-tools/schema'
import { ApolloServerPluginDrainHttpServer } from 'apollo-server-core'
import { ApolloServer, ExpressContext } from 'apollo-server-express'
import { Server } from 'http'
import { WebSocketServer } from 'ws'
import { gqlConfig } from '../graphql/config'
import { cleanupServer } from './cleanupServer'
import { ServerInitializer } from './serverInitializer'

export function createApolloServer(
  options: CreateApolloServerOptions,
): ApolloServer<ExpressContext> {
  const { httpServer, wsServer, serverInitializer } = options

  const schema = makeExecutableSchema(gqlConfig)

  const serverCleanup = serverInitializer({
    schema,
    wsServer,
  })

  const server = new ApolloServer({
    schema,
    plugins: [
      ApolloServerPluginDrainHttpServer({ httpServer: httpServer }),
      cleanupServer({ serverCleanup }),
    ],
  })

  return server
}

export interface CreateApolloServerOptions {
  httpServer: Server
  wsServer: WebSocketServer
  serverInitializer: ServerInitializer
}
